






macro package std.unittest.testmacro

import std.ast.*
import std.collection.*








public macro Types(dsl: Tokens, input: Tokens) {
    return topLevelMacroDriver(TYPES_MACRO, input, dsl, {it => insideParentContext(it.macroIdentifier)})
}


func parseTypesMacro(params: Tokens): Array<(String, Array<Tokens>)> {
    let parser = DSLParser(Tokens(collectArray(params)))
    let result = ArrayList<(String, Array<Tokens>)>()

    try {
        while (true) {
            let id = parser.expectToken(IDENTIFIER)
            parser.expectToken(IN)
            parser.expectToken(TokenKind.LT)
            let toks = parser.parseBalancedDelimited(delimiter: TokenKind.COMMA, terminator: TokenKind.GT)
            result.add((id.value, toks))
            parser.expectToken(TokenKind.GT)
            if (!parser.completed() && parser.currentToken.kind == COMMA) {
                parser.nextToken()
                continue
            } else {
                break
            }
        }
    } catch (ex: Exception) {
        throw MacroException(
            "Illegal parameters for @Types: ${params}," +
                "parameters should use the form @Types[T in <A, B, C>, U in <D, E>], nested error:" + ex.message)
    }
    return result.toArray()
}








func walkTypeParameters(
    left: Array<Token>,
    typeSubst: HashMap<String, Array<Tokens>>,
    acc: ArrayList<Tokens>,
    body: (ArrayList<Tokens>) -> Unit
): Unit {
    if (left.isEmpty()) {
        body(acc)
        return
    }

    let vars = typeSubst.get(left[0].value) ?? throw MacroException(
        "Generic type parameter ${left[0].value} is not provided, did you forget to put a @Types macro?")
    for (v in vars) {
        if (v.size == 0) {
            throw MacroException("Empty type in @Types macro for parameter ${left[0].value}")
        }
        acc.push(v)
        walkTypeParameters(left[1..], typeSubst, acc, body)
        acc.pop()
    }
}





func checkTypeSubstitution(
    genericArgs: Array<Token>,
    typeSubst: HashMap<String, Array<Tokens>>
) {
    for ((_, v) in typeSubst) {
        for (vts in v) {
            for (vt in vts) {
                if (vt.kind == IDENTIFIER && typeSubst.contains(vt.value)) {
                    throw MacroException(
                        "@Types macro does not support recursive types: " +
                        "type ${typesToString(vts)} is not allowed to use type parameter ${vt.value}")
                }
            }
        }
    }
    if (genericArgs.size == typeSubst.size) {
        return
    }
    let mutableTypeSubst = typeSubst.clone()
    for (arg in genericArgs) {
        mutableTypeSubst.remove(arg.value)
    }
    if (mutableTypeSubst.size > 0) {
        let leftoverVars = mutableTypeSubst.keys() |> collectString<String>(delimiter: ", ")
        throw MacroException("@Types macro provides unknown type variables: ${leftoverVars}")
    }
}



func typesToString(types: Tokens) {
    let result = StringBuilder()
    for (token in types) {
        match (token.kind) {
            case TokenKind.COMMA => result.append(", ")
            case TokenKind.ARROW => result.append(" -> ")
            case _ => result.append(token.value)
        }
    }
    return result.toString()
}
