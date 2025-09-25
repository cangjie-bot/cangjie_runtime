






macro package std.unittest.testmacro

import std.ast.*











public macro Parallel(input: Tokens): Tokens {
    return topLevelMacroDriver(PARALLEL_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}
