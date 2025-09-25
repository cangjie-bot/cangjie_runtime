






macro package std.unittest.testmacro

import std.ast.*















public macro Timeout(attrs: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TIMEOUT_MACRO, input, attrs, { it => insideParentContext(it.macroIdentifier) })
}
