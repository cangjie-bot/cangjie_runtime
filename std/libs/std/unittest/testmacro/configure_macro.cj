






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
public macro Configure(args: Tokens, input: Tokens) {
    return topLevelMacroDriver(CONFIGURE_MACRO, input, args, { it => insideParentContext(it.macroIdentifier) })
}
