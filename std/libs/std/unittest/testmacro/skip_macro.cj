







macro package std.unittest.testmacro

import std.ast.*








public macro Skip(input: Tokens): Tokens {
    return topLevelMacroDriver(SKIP_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}










public macro Skip(attr: Tokens, input: Tokens): Tokens {
    let tokens = match {
        case compareTokens(attr, true.toTokens()) => ()
        case compareTokens(attr, false.toTokens()) =>
            return input
        case _ => throw MacroException("@Skip can only be used with true or false")
    }
    return topLevelMacroDriver(SKIP_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}
