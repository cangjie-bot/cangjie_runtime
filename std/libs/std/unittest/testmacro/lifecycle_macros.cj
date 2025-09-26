







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
public macro BeforeAll(input: Tokens) {
    return topLevelMacroDriver(BEFORE_ALL_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro AfterAll(input: Tokens) {
    return topLevelMacroDriver(AFTER_ALL_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro BeforeEach(input: Tokens) {
    return topLevelMacroDriver(BEFORE_EACH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro AfterEach(input: Tokens) {
    return topLevelMacroDriver(AFTER_EACH_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}
