






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
public macro TestCase(input: Tokens): Tokens {
    return topLevelMacroDriver(TESTCASE_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro TestCase(args: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TESTCASE_MACRO, input, args, { it => insideParentContext(it.macroIdentifier) })
}
