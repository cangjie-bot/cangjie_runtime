






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
public macro TestCase(input: Tokens): Tokens {
    return topLevelMacroDriver(TESTCASE_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro TestCase(args: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TESTCASE_MACRO, input, args, { it => insideParentContext(it.macroIdentifier) })
}
