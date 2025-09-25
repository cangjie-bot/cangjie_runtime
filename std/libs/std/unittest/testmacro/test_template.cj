






macro package std.unittest.testmacro

import std.ast.*

public macro TestTemplate(input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_TEMPLATE_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

public macro TestTemplate(dsl: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_TEMPLATE_MACRO, input, dsl, { it => insideParentContext(it.macroIdentifier) })
}
