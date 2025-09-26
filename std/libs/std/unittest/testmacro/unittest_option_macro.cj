






macro package std.unittest.testmacro

import std.ast.*
import std.collection.map

let MACRO_NAME = "UnittestOption"

/**
 * @throws OutOfMemoryError
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws MacroException
 */
public macro UnittestOption(_: Tokens): Tokens {
    expandValidatorMacro(Tokens(), Tokens())
}

/**
 * @throws OutOfMemoryError
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws MacroException
 */
public macro UnittestOption(types: Tokens, params: Tokens): Tokens {
    expandValidatorMacro(types, params)
}

class OptionInfo {
    let types: Array<TypeNode>
    let name: RefExpr
    var validator: ?Expr = None
    var description: ?LitConstExpr = None
    var isPublic = false

    private prop nameStr: String {
        get() {
            name.identifier.value
        }
    }

        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
    prop nameLiteral: Token {
        get() {
            Token(TokenKind.STRING_LITERAL, nameStr)
        }
    }

        /**
         * @throws Error
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         */
    prop descriptionString: Tokens {
        get() {
            description?.toTokens() ?? quote(None<String>)
        }
    }
        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
    prop typeToken: Token {
        get() {
            let typeName = "Key" + nameStr[0..1].toAsciiUpper() + nameStr[1..]
            return Token(TokenKind.IDENTIFIER, typeName)
        }
    }

        /**
         * @throws IllegalMemoryException
         * @throws OutOfMemoryError
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
    prop validTypesAsStringArray: Tokens {
        get() {
            let typesTokens = types |> map { tn: TypeNode =>
                    let typeStr = tn.toTokens().toString().replace(" ", "")
                    Token(TokenKind.STRING_LITERAL, typeStr).toTokens()
                }

            return Token(TokenKind.LSQUARE) + commaSeparated(typesTokens) + Token(TokenKind.RSQUARE)
        }
    }

        /**
         * @throws ConcurrentModificationException
         * @throws Error
         * @throws IllegalMemoryException
         * @throws NoneValueException
         * @throws Exception
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ParseASTException
         * @throws ASTException
         */
    private prop expectedValidatorParameterType: TypeNode {
        get() {
            if (types.size == 1) {
                types[0]
            } else {
                FuncParam(quote(Any)).paramType
            }
        }
    }

    /**
     * @throws ConcurrentModificationException
     * @throws ASTException
     * @throws ParseASTException
     * @throws Error
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MacroException
     */
    init(types: Array<TypeNode>, rawArgs: Tokens) {
        this.types = types
        if (rawArgs.size == 0) {
            throw MacroException("Expected option name in @${MACRO_NAME} macro.")
        }

        let args = if (rawArgs.get(0).value == "public") {
            isPublic = true
            parseCommaSeparatedExpressions(rawArgs[1..])
        } else {
            parseCommaSeparatedExpressions(rawArgs)
        }

        match (args[0]) {
            case re: RefExpr => name = re
            case _ => throw MacroException("Expected option identifier as first param in @${MACRO_NAME}.")
        }

        for (arg in args[1..]) {
            match (arg) {
                case lambda: LambdaExpr =>
                    if (validator.isSome()) {
                        throw MacroException("Option validator can not be duplicated in @${MACRO_NAME}.")
                    }
                    checkUserValidatorParameter(lambda)
                    validator = lambda
                case ref: RefExpr =>
                    validator = ref
                case lce: LitConstExpr =>
                    if (description.isSome()) {
                        throw MacroException("Option description can not be duplicated in @${MACRO_NAME}.")
                    }
                    if (lce.literal.kind != TokenKind.STRING_LITERAL) {
                        throw MacroException("Option description in @${MACRO_NAME} must be string literal.")
                    }
                    description = lce
                case _ => throw MacroException("Unexpected argument in @${MACRO_NAME} (${arg.toTokens()}).")
            }
        }
    }

    /**
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws IllegalMemoryException
     * @throws NoneValueException
     * @throws Exception
     * @throws ParseASTException
     * @throws ASTException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MacroException
     */
    private func checkUserValidatorParameter(validator: LambdaExpr): Unit {
        let params = validator.funcParams

        if (params.size > 1) {
            throw MacroException("Validator callback of ${MACRO_NAME} must have only one parameter.")
        }

        let realParameterName = params[0].paramType.typeParameterName.value
        if (realParameterName == "") {
            return
        }

        let expectedParameterName = expectedValidatorParameterType.typeParameterName.value
        if (realParameterName != expectedParameterName) {
            throw MacroException("${MACRO_NAME} validator parameter type must be ${expectedValidatorParameterType.dump(0)}.")
        }
    }
}

struct OptionRegistratorBuilder {
    OptionRegistratorBuilder(private let opt: OptionInfo) {}

    /**
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func buildUserValidatorCall(validator: Expr): Tokens {
        quote(
            let status = $validator(value)
            match (status) {
                case b: Bool => if (!b) {
                        return OptionValidity.InvalidOption("")
                    }
                case s: ?String => if (let Some(errorMsg) <- s) {
                        return OptionValidity.InvalidOption(errorMsg)
                    }
                case _ => throw Exception("Unknown return type of validator callback. 'Bool' or '?String' is expected.")
            }
        )
    }

    /**
     * @throws OutOfMemoryError
     * @throws IllegalMemoryException
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func build(): Tokens {
        var userValidatorCall = Tokens()
        if (let Some(validator) <- opt.validator) {
            userValidatorCall = buildUserValidatorCall(validator)
        }

        let validatorBody = match (opt.types.size) {
            case 1 => oneTypeCheck(userValidatorCall)
            case _ => severalTypesCheck(userValidatorCall)
        }

        let registerOptionValidator = quote(let _ = registerOptionValidator($(opt.nameLiteral), {value: Any => $validatorBody}))
        let setOptionInfo = quote(
            let _ = setOptionInfo($(opt.nameLiteral), $(opt.validTypesAsStringArray), description: $(opt.descriptionString)))

        return registerOptionValidator + setOptionInfo
    }

    /**
     * @throws Error
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func key(ty: TypeNode): Tokens {
        quote(ConfigurationKey.create<$ty>($(opt.nameLiteral)))
    }

    /**
     * @throws Error
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func severalTypesCheck(userValidatorCall: Tokens): Tokens {
        var typeCases = Tokens()
        for (ty in opt.types) {
            typeCases += quote(case _: $ty => return OptionValidity.ValidOption($(key(ty))))
        }

        return quote($userValidatorCall
            match (value) {
                $typeCases
                case _ => return OptionValidity.UnknownOptionType
            })
    }

    /**
     * @throws Error
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func oneTypeCheck(userValidatorCall: Tokens): Tokens {
        quote(if(let Some(value) <- (value as $(opt.types[0]))) {
            $userValidatorCall
            return OptionValidity.ValidOption($(key(opt.types[0])))
        } else {
            return OptionValidity.UnknownOptionType
        })
    }
}

/**
 * @throws Error
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func generateKeyType(opt: OptionInfo): Tokens {
    var superTypes = Tokens()
    for (i in 0..opt.types.size) {
        let ty = opt.types[i]
        if (i == 0) {
            superTypes += quote(KeyFor<$ty>)
        } else {
            superTypes += quote(& KeyFor<$ty>)
        }
    }

    let accessLevel = if (opt.isPublic) { quote(public) } else { Tokens() }

    quote(
        $accessLevel struct $(opt.typeToken) <: $superTypes {
            public static prop $(opt.name): $(opt.typeToken) {
                get() {
                    $(opt.typeToken)()
                }
            }

            public prop name: String {
                get() {
                    $(opt.nameLiteral)
                }
            }
        }
    )
}

/**
 * @throws OutOfMemoryError
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws MacroException
 */
func expandValidatorMacro(rawTypes: Tokens, rawArgs: Tokens): Tokens {
    if (rawTypes.size == 0) {
        throw MacroException("@${MACRO_NAME} macro require types to be specified in [].")
    }
    let types = parseTypes(rawTypes).toArray()
    if (types.isEmpty()) {
        throw MacroException("@${MACRO_NAME} macro require types to be specified in [].")
    }

    let optInfo = OptionInfo(types, rawArgs)
    let keyType = generateKeyType(optInfo)
    let registratorOfValidator = OptionRegistratorBuilder(optInfo).build()

    return quote(
        $keyType

        $registratorOfValidator
    )
}
