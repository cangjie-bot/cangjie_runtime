






macro package std.unittest.testmacro

import std.ast.*










public macro Configure(args: Tokens, input: Tokens) {
    return topLevelMacroDriver(CONFIGURE_MACRO, input, args, { it => insideParentContext(it.macroIdentifier) })
}
