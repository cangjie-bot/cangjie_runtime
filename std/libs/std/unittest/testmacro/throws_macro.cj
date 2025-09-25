






macro package std.unittest.testmacro

import std.ast.*


public macro AssertThrows(body: Tokens): Tokens {
    if (insideParentContext("CustomAssertion")) {
        return expandAssertThrowsMacro(body, quote(Exception), insideCustom: true)
    }
    return expandAssertThrowsMacro(body, quote(Exception), insideCustom: false)
}


public macro AssertThrows(exceptions: Tokens, body: Tokens): Tokens {
    if (insideParentContext("CustomAssertion")) {
        return expandAssertThrowsMacro(body, exceptions, insideCustom: true)
    }
    return expandAssertThrowsMacro(body, exceptions, insideCustom: false)
}


public macro ExpectThrows(body: Tokens): Tokens {
    if (insideParentContext("CustomAssertion")) {
        return expandAssertThrowsMacro(body, quote(Exception), insideCustom: true, isExpect: true)
    }
    return expandAssertThrowsMacro(body, quote(Exception), insideCustom: false, isExpect: true)
}


public macro ExpectThrows(exceptions: Tokens, body: Tokens): Tokens {
    if (insideParentContext("CustomAssertion")) {
        return expandAssertThrowsMacro(body, exceptions, insideCustom: true, isExpect: true)
    }
    return expandAssertThrowsMacro(body, exceptions, insideCustom: false, isExpect: true)
}

func processAssertThrowBody(body: Tokens, isExpect: Bool): Tokens {
    let macroName = if (isExpect) { "@ExpectThrows" } else { "@AssertThrows" }
    if (body.size == 0) {
        throw MacroException("${macroName}: Empty body, expected expression or block.")
    }

    if (body[0].kind == TokenKind.LCURL &&
        body[body.size - 1].kind == TokenKind.RCURL) {

        let ifExpr = IfExpr(quote(if(true) $body))

        var result = Tokens()
        for (node in ifExpr.ifBlock.nodes) {
            let t = node.toTokens()
            result += quote(
                $t
            )
        }

        return result
    }

    try {
        let (expr, exprEnd) = parseExprFragment(body)

        if (body.size != exprEnd) {
            throw MacroException("${macroName}: " +
                "Body is not valid expression, there are extra tokens after `${expr.toTokens()}`.")
        }
    } catch (e: ParseASTException) {
        throw MacroException("${macroName}: Invalid body, expected expression or block.")
    }

    return body
}

func typeNodeToString(ty: TypeNode): String {
    let res = StringBuilder()
    for (c in ty.toTokens().toString().runes()) {
        if (!c.isAsciiWhiteSpace()) {
            res.append(c)
        }
    }

    res.toString()
}

private func obtainMacroSpecificTokens(isExpect: Bool, insideCustom: Bool) {
    let (prefix, callArgs) = if (insideCustom) {
        (quote($MACRO_CTX_VAR_NAME.), { errmesg: String, tokens: String =>
            quote($errmesg, $tokens, e.toString(), optParentCtx: $MACRO_CTX_VAR_NAME)
        })
    } else {
        (quote(), { errmesg: String, tokens: String =>
            quote($errmesg, $tokens, e.toString())
        })
    }
    let (macroName, unexpectedECall, failFunctionTokens) = if (isExpect) {
        ("@ExpectThrows", Token(IDENTIFIER, "expectCaughtUnexpectedE"), quote($prefix failExpect))
    } else {
        ("@AssertThrows", Token(IDENTIFIER, "assertCaughtUnexpectedE"), quote($prefix fail))
    }

    return (macroName, unexpectedECall, failFunctionTokens, callArgs)
}






private func handleExpectedErrorTypes(iter: Iterable<TypeNode>) {
    let sb = StringBuilder()
    var shouldThrowAssert: Bool = true
    var shouldThrowIntermediate: Bool = true

    let typesIt = iter.iterator()
    var curr = typesIt.next()
    while (let Some(ty) <- curr) {
        let it = typeNodeToString(ty)
        sb.append(it)
        shouldThrowAssert &&= it != "AssertException"
        shouldThrowIntermediate &&= it != "AssertIntermediateException"
        curr = typesIt.next()
        if (!curr.isNone()) {
            sb.append(" | ")
        }
    }

    let tb = TokensBuilder()
    if (shouldThrowAssert) {
        tb.append(quote(
            if (e is AssertException) {
                throw e
            }
        ))
    }
    if (shouldThrowIntermediate) {
        tb.append(quote(
            if (e is AssertIntermediateException) {
                throw e
            }
        ))
    }
    tb.append(quote(
        if (e is UnittestTimeoutException) {
            throw e
        }
    ))

    return (sb.toString(), tb.toTokens())
}

private func expandAssertThrowsMacro(
    body_: Tokens, exceptions: Tokens,
    isExpect!: Bool = false,
    insideCustom!: Bool = false
): Tokens {
    let (macroName, unexpectedECall, failFunctionTokens, callArgs) = obtainMacroSpecificTokens(isExpect, insideCustom)

    if (exceptions.size == 0) {
        throw MacroException("${macroName}: " +
            "Invalid syntax, exception types are expected inside []. Or use macro without [].")
    }

    let body = processAssertThrowBody(body_, isExpect)

    let tryExpession = quote(try {} catch (e: $exceptions) {})
    let catchPatterns = try {
        TryExpr(tryExpession).catchPatterns
    } catch (e: ASTException) {
        throw MacroException("${macroName}: Invalid list of exception types inside [].")
    }
    let expectedExceptions = catchPatterns[0]
    let etp = (expectedExceptions as ExceptTypePattern).getOrThrow()
    var returnTypeTokens = if (etp.types.size == 1) {
        etp.types[0].toTokens()
    } else {
        quote(Exception)
    }
    returnTypeTokens = if (isExpect) { quote(None<$returnTypeTokens>) } else { quote() }

    let (exceptionsStringTokens, throwAssertTokens) = handleExpectedErrorTypes(etp.types.iterator())

    let noExceptionErrmesg = "${macroName}: Expected '${exceptionsStringTokens}' was not caught."
    let unexpectedErrmesg = "${macroName}(${exceptionsStringTokens})"
    return quote(
        try {
            try {
                assertEqual("true", "true", true, true)

                $body

                $failFunctionTokens($noExceptionErrmesg)
                $returnTypeTokens
            } catch ($expectedExceptions) {
                $throwAssertTokens
                e
            }
        } catch (e: Exception) {
            if (e is AssertException || e is AssertIntermediateException || e is UnittestTimeoutException) {
                throw e
            }

            $unexpectedECall($(callArgs(unexpectedErrmesg, exceptionsStringTokens)))
            $returnTypeTokens
        }
    )
}
