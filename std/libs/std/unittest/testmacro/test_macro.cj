







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
public macro Test(input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

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
public macro Test(dsl: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_MACRO, input, dsl, { it => insideParentContext(it.macroIdentifier) })
}
