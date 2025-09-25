






macro package std.unittest.testmacro

import std.ast.*


/*
 * @throws IllegalMemoryException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws MacroException
 */
public macro Fail(message: Tokens): Tokens {
    match (message.size == 0) {
        case true => throw MacroException("@Fail: Fail message should be specified.")
        case false where insideParentContext("CustomAssertion") => quote($MACRO_CTX_VAR_NAME.fail($message))
        case _ => quote(fail($message))
    }
}


/*
 * @throws IllegalMemoryException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws MacroException
 */
public macro FailExpect(message: Tokens): Tokens {
    match (message.size == 0) {
        case true => throw MacroException("@FailExpect: Fail message should be specified.")
        case false where insideParentContext("CustomAssertion") => quote($MACRO_CTX_VAR_NAME.failExpect($message))
        case _ => quote(failExpect($message))
    }
}
