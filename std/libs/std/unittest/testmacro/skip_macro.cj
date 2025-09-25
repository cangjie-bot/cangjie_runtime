







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
public macro Skip(input: Tokens): Tokens {
    return topLevelMacroDriver(SKIP_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}










/*
 * @throws OutOfMemoryError
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
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
