







macro package std.unittest.testmacro

import std.ast.*

public macro BeforeAll(input: Tokens) {
    return topLevelMacroDriver(BEFORE_ALL_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

public macro AfterAll(input: Tokens) {
    return topLevelMacroDriver(AFTER_ALL_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

public macro BeforeEach(input: Tokens) {
    return topLevelMacroDriver(BEFORE_EACH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

public macro AfterEach(input: Tokens) {
    return topLevelMacroDriver(AFTER_EACH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}
