






package std.unittest

import std.collection.*
import std.regex.Regex
import std.unittest.common.*

func substituteTemplate(template: String, values: JsonValue): String {
    Root(template).substitute(values)
}






class Root {
    var templates = HashMap<String, Template>()
    var rootTemplate: Template
    Root(t: String) {
        var template = t

        var idx = 0
        let builder = StringBuilder()
        while (let Some(start) <- template.indexOf("{{", idx)) {
            let end = template.indexOf("}}", idx).getOrThrow()
            let t = Template.fromString(template[start + 2..end])
            templates.add(t.name, t)
            builder.append(template[idx..start])
            idx = end + 2
        }
        builder.append(template[idx..])

        rootTemplate = Template("Root", builder.toString())
        Template.REPEATABLES_MATCHER = Regex("\\{\\!(([^!]|\\![^}])+)\\!\\}")
        Template.VARIABLES_MATCHER = Regex("\\$([a-zA-Z0-9_]+)\\:?([a-zA-Z0-9_]+)?")
    }

    func substitute(values: JsonValue): String {
        rootTemplate.substitute(values, templates, 0).getOrThrow()
    }
}

class Template {
    Template(let name: String, let baseText: String) {}
    static func fromString(text: String): Template {
        let parts = text.split("\n", 2)
        Template(parts[0].trimEnd(" \r\n"), parts[1])
    }

    static var REPEATABLES_MATCHER: Regex = Regex("temp")
    static var VARIABLES_MATCHER: Regex = Regex("temp")
    static let REPETITIONS_SANITY_CHECK: Int64 = 1000;

    func substitute(values: JsonValue, templates: HashMap<String, Template>, index: Int64): ?String {
        if (values is JsonNull) {
            return ""
        }

        var baseText = this.baseText

        while (let Some(repeated) <- REPEATABLES_MATCHER.matcher(baseText).find()) {
            let data = StringBuilder()
            data.append(baseText[0..repeated.matchPosition().start])

            let inner = repeated.matchString(1)

            var repIndex = 0
            while (repIndex < REPETITIONS_SANITY_CHECK) {
                data.append(Template("Dummy", inner).substitute(values, templates, repIndex) ?? break)
                repIndex += 1
            }

            data.append(baseText[repeated.matchPosition().end..])
            baseText = data.toString()
        }

        while (let Some(variable) <- VARIABLES_MATCHER.matcher(baseText).find()) {
            let data = StringBuilder()
            data.append(baseText[0..variable.matchPosition().start])

            let field = variable.matchString(1)
            let values = values.getIndexed(field, index) ?? return None
            if (variable.groupNumber() == 1) {
                data.append(values.render())
            } else {
                let substitutionName = variable.matchString(2)
                if (!templates.contains(substitutionName)) {
                    data.append("<Error: subtemplate \"${substitutionName}\" not found.>")
                } else {
                    let result = templates[substitutionName].substitute(values, templates, 0) ??
                        "<Error while substituting subtemplate \"${substitutionName}\">"
                    data.append(result)
                }
            }
            data.append(baseText[variable.matchPosition().end..])
            baseText = data.toString()
        }
        baseText
    }
}

func object(data: Array<(String, IntoJson)>): JsonObject {
    JsonObject(HashMap<String, JsonValue>(data.size) { i => (data[i][0], data[i][1].json()) })
}

interface IntoJson {
    func json(): JsonValue
}

extend JsonValue <: IntoJson {
    public func json(): JsonValue {
        this
    }
}

extend String <: IntoJson {
    public func json(): JsonValue {
        JsonString(this)
    }
}

extend Int64 <: IntoJson {
    public func json(): JsonValue {
        JsonInt(this)
    }
}

extend<T> Option<T> <: IntoJson where T <: IntoJson {
    public func json(): JsonValue {
        match (this) {
            case None => JsonNull()
            case Some(x) => x.json()
        }
    }
}

extend<T> Array<T> <: IntoJson where T <: IntoJson {
    public func json(): JsonValue {
        JsonArray(ArrayList(this.size) {i => this[i].json()})
    }
}

extend<T> ArrayList<T> <: IntoJson where T <: IntoJson {
    public func json(): JsonValue {
        JsonArray(ArrayList(this.size) {i => this[i].json()})
    }
}

extend JsonValue {
    func render(): String {
        match (this) {
            case x: JsonString => x.getValue()
            case _: JsonNull => "<none>"
            case _ => this.toString()
        }
    }
}

extend JsonValue {
    func getIndexed(field: String, index: Int64): ?JsonValue {
        if (let Some(arr) <- (this as JsonArray)) {
            return (arr.get(index) as JsonObject)?.get(field) ?? None
        }

        if (!(this is JsonObject)) {
            return None
        }

        match (this.asObject().get(field)) {
            case Some(arr) where arr is JsonArray => arr.asArray().get(index)
            case Some(arr) where arr is JsonNull => None
            case Some(other) => other
            case None =>
                JsonNull()
        }
    }

}
