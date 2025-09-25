







macro package std.unittest.testmacro

import std.ast.*









public macro Measure(attr: Tokens, input: Tokens): Tokens {
    topLevelMacroDriver(MEASURE_MACRO, input, attr, { it => insideParentContext(it.macroIdentifier) })
}
