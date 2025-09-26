






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
public macro Timeout(attrs: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TIMEOUT_MACRO, input, attrs, { it => insideParentContext(it.macroIdentifier) })
}
