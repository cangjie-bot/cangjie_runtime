







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
public macro BeforeAll(input: Tokens) {
    return topLevelMacroDriver(BEFORE_ALL_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro AfterAll(input: Tokens) {
    return topLevelMacroDriver(AFTER_ALL_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro BeforeEach(input: Tokens) {
    return topLevelMacroDriver(BEFORE_EACH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro AfterEach(input: Tokens) {
    return topLevelMacroDriver(AFTER_EACH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}
