






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
public macro Configure(args: Tokens, input: Tokens) {
    return topLevelMacroDriver(CONFIGURE_MACRO, input, args, { it => insideParentContext(it.macroIdentifier) })
}
