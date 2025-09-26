






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
func topLevelMacroDriver(key: MacroKey, input: Tokens,
        args: Tokens, parentCheck: (key: MacroKey) -> Bool): Tokens {
    let tokens = key.write(input, args: args)
    for (pkey in MacroKey.allSupportedMacros()) {
        if (parentCheck(pkey)) {
            return tokens
        }
    }

    let decl = parseDecl(tokens)
    key.verifyDecl(decl)

    if (let Some(_) <- decl.loadSingle(TEST_MACRO)) {
        return InstrumentedClass.fromDecl(TEST_MACRO, decl, input).toTokens()
    }
    if (let Some(_) <- decl.loadSingle(TEST_BUILDER_MACRO)) {
        return emitTestBuilder(decl, input)
    }
    if (let Some(_) <- decl.loadSingle(TEST_TEMPLATE_MACRO)) {
        return InstrumentedClass.fromDecl(TEST_TEMPLATE_MACRO, decl, input).toTokens()
    }
    if (let Some(_) <- decl.loadSingle(ASSERTION_MACRO)) {
        return emitCustomAssertionBuilder(decl)
    }

    let additionalErrors = MacroErrors()
    additionalErrors.add(
        "${key} macro on top level must be used together with ${TEST_MACRO}, ${TEST_TEMPLATE_MACRO} or ${TEST_BUILDER_MACRO}.")
    additionalErrors.report()

    return tokens
}
