






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
public macro Timeout(attrs: Tokens, input: Tokens): Tokens {
    return topLevelMacroDriver(TIMEOUT_MACRO, input, attrs, { it => insideParentContext(it.macroIdentifier) })
}
