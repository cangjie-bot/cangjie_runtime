






protected package std.deriving.impl

import std.deriving.api.*
import std.ast.Token

private let Core = QualifiedName("std.core")

func resolveInterface(name: Identifier): QualifiedName {

    let results = interfacesBySimpleName(name.value)
    if (results.size == 1) {
        let qualifiedName = results[0]
        return qualifiedName.replaceSimpleName(name.token)
    }

    Core + name
}

extend QualifiedName {
    func replaceSimpleName(name: Token) {
        let components = tokens.clone()
        let lastIndex = components.size - 1
        components[lastIndex] = name
        return QualifiedName(components)
    }
}
