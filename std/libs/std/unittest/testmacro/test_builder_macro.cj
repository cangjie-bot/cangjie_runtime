






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
public macro TestBuilder(input: Tokens): Tokens {
    return topLevelMacroDriver(TEST_BUILDER_MACRO, input, Tokens(), { it => insideParentContext(it.macroIdentifier) })
}

/**
 * @throws MacroException
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func emitTestBuilder(decl: Decl, originalTokens: Tokens): Tokens {
    let funcDecl = verifyDeclShape(decl)
    let tb = TokensBuilder()
    tb.append(originalTokens).append(NL)
    tb.append(buildRegistrationFunction(funcDecl)).append(NL)
    return tb.toTokens()
}

/**
 * @throws MacroException
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
private func buildRegistrationFunction(funcDecl: FuncDecl): Tokens {
    let registerFuncName = Token(IDENTIFIER, "register_${funcDecl.identifier.value}")
    let extensionInterface = Token(IDENTIFIER, "TestPackageExtension_" + funcDecl.identifier.value)
    let suiteBuilder = generateBuildSuite(funcDecl)
    quote(
        interface $extensionInterface {
            func $registerFuncName(): Unit
        }
        extend TestPackage <: $extensionInterface {
            @Attribute[TEST_REGISTER]
            public func $registerFuncName() {
                registerSuite({ =>
                    $suiteBuilder
                })
            }
        }
    )
}

/**
 * @throws MacroException
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
private func generateBuildSuite(funcDecl: FuncDecl): Tokens {
    let rawConfiguration = loadFuncConfiguration(funcDecl)
    let funcIdent = funcDecl.identifier
    if (rawConfiguration.isEmpty()) {
        return quote($funcIdent())
    }
    let tb = TokensBuilder()
    let configurationVariableName = Token(IDENTIFIER, "__configuration")
    buildConfiguration(rawConfiguration, configurationVariableName, tb)
    tb.append(quote(TestSuite.builder($funcIdent()).configure($configurationVariableName).build()))
    tb.toTokens()
}

private let WRONG_TARGET_MESSAGE = "@TestBuilder macro must be put on a function without parameters."
/**
 * @throws IllegalArgumentException
 * @throws ASTException
 * @throws MacroException
 */
private func verifyDeclShape(decl: Decl): FuncDecl {
    let funcDecl = (decl as FuncDecl) ?? throw MacroException(WRONG_TARGET_MESSAGE)
    if (!funcDecl.funcParams.isEmpty()) {
        throw MacroException(WRONG_TARGET_MESSAGE)
    }
    let returnType = try {
        funcDecl.declType
    } catch (e: ASTException) {
        throw MacroException("@TestBuilder function must have return type explicitly specified.")
    }
    if ((returnType as RefType)?.identifier.value != "TestSuite") {
        throw MacroException("@TestBuilder function must return 'TestSuite'.")
    }
    return funcDecl
}
