









package std.unittest.common


protected enum JsonKind {
    JsNull | JsBool | JsInt | JsFloat | JsString | JsArray | JsObject
}


protected abstract class JsonValue <: ToString {








    public func toString(): String








    public func toJsonString(): String










    public static func fromStr(s: String): JsonValue {
        parseString(s)
    }






    public func kind(): JsonKind








    public func asNull(): JsonNull {
        match (this) {
            case jsonNull: JsonNull => jsonNull
            case _ => throw JsonException("Fail to convert to JsonNull")
        }
    }








    public func asBool(): JsonBool {
        match (this) {
            case jsonBool: JsonBool => jsonBool
            case _ => throw JsonException("Fail to convert to JsonBool")
        }
    }








    public func asInt(): JsonInt {
        match (this) {
            case jsonInt: JsonInt => jsonInt
            case _ => throw JsonException("Fail to convert to JsonInt")
        }
    }








    public func asFloat(): JsonFloat {
        match (this) {
            case jsonFloat: JsonFloat => jsonFloat
            case jsonInt: JsonInt => JsonFloat(jsonInt.getValue())
            case _ => throw JsonException("Fail to convert to JsonFloat")
        }
    }








    public func asString(): JsonString {
        match (this) {
            case jsonString: JsonString => jsonString
            case _ => throw JsonException("Fail to convert to JsonString")
        }
    }








    public func asArray(): JsonArray {
        match (this) {
            case jsonArray: JsonArray => jsonArray
            case _ => throw JsonException("Fail to convert to JsonArray")
        }
    }








    public func asObject(): JsonObject {
        match (this) {
            case jsonObject: JsonObject => jsonObject
            case _ => throw JsonException("Fail to convert to JsonObject")
        }
    }
}
