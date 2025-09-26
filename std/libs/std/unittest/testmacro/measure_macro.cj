







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
public macro Measure(attr: Tokens, input: Tokens): Tokens {
    topLevelMacroDriver(MEASURE_MACRO, input, attr, { it => insideParentContext(it.macroIdentifier) })
}
