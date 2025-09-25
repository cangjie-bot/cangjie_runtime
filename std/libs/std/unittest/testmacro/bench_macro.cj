







macro package std.unittest.testmacro

import std.ast.*

public macro Bench(input: Tokens): Tokens {
    return topLevelMacroDriver(BENCH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}









public macro Bench(attr: Tokens, input: Tokens): Tokens {
    
    if (attr.size == 1 && attr.get(0).kind == TokenKind.INTEGER_LITERAL) {
        return topLevelMacroDriver(BENCH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
    } else {
        return topLevelMacroDriver(BENCH_MACRO, input, attr, { it => insideParentContext(it.macroIdentifier) })
    }
}
