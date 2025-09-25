







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
public macro Measure(attr: Tokens, input: Tokens): Tokens {
    topLevelMacroDriver(MEASURE_MACRO, input, attr, { it => insideParentContext(it.macroIdentifier) })
}
