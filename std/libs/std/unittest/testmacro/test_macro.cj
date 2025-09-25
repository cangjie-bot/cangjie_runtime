







macro package std.unittest.testmacro

import std.ast.*













public macro Test(input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

public macro Test(dsl: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_MACRO, input, dsl, { it => insideParentContext(it.macroIdentifier) })
}
