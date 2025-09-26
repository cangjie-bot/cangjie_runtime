







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
public macro Skip(input: Tokens): Tokens {
    return topLevelMacroDriver(SKIP_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
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
public macro Skip(attr: Tokens, input: Tokens): Tokens {
    let tokens = match {
        case compareTokens(attr, true.toTokens()) => ()
        case compareTokens(attr, false.toTokens()) =>
            return input
        case _ => throw MacroException("@Skip can only be used with true or false")
    }
    return topLevelMacroDriver(SKIP_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}
