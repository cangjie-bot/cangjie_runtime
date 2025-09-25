






macro package std.unittest.testmacro

import std.ast.*









public macro TestCase(input: Tokens): Tokens {
    return topLevelMacroDriver(TESTCASE_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

public macro TestCase(args: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TESTCASE_MACRO, input, args, { it => insideParentContext(it.macroIdentifier) })
}
