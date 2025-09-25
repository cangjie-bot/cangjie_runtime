







macro package std.unittest.testmacro

import std.ast.*













/*
 * @throws OutOfMemoryError
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IllegalSynchronizationStateException
 * @throws MacroException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public macro Test(input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

/*
 * @throws OutOfMemoryError
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IllegalSynchronizationStateException
 * @throws MacroException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public macro Test(dsl: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_MACRO, input, dsl, { it => insideParentContext(it.macroIdentifier) })
}
