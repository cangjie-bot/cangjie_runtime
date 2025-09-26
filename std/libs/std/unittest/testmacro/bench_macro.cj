







macro package std.unittest.testmacro

import std.ast.*

/**
 * @throws ConcurrentModificationException
 * @throws ParseASTException
 * @throws ASTException
 * @throws OutOfMemoryError
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws IllegalSynchronizationStateException
 * @throws MacroException
 */
public macro Bench(input: Tokens): Tokens {
    return topLevelMacroDriver(BENCH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}









/**
 * @throws ConcurrentModificationException
 * @throws ParseASTException
 * @throws ASTException
 * @throws OutOfMemoryError
 * @throws IllegalSynchronizationStateException
 * @throws MacroException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public macro Bench(attr: Tokens, input: Tokens): Tokens {
    
    if (attr.size == 1 && attr.get(0).kind == TokenKind.INTEGER_LITERAL) {
        return topLevelMacroDriver(BENCH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
    } else {
        return topLevelMacroDriver(BENCH_MACRO, input, attr, { it => insideParentContext(it.macroIdentifier) })
    }
}
