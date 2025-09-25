







macro package std.unittest.testmacro

import std.ast.*
import std.collection.*

/*
 * @throws ConcurrentModificationException
 * @throws ParseASTException
 * @throws ASTException
 * @throws Error
 * @throws Exception
 * @throws IllegalMemoryException
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws MacroException
 */
public macro Strategy(input: Tokens): Tokens {
    expandStrategy(Tokens(), input)
}






/*
 * @throws ConcurrentModificationException
 * @throws ParseASTException
 * @throws ASTException
 * @throws Error
 * @throws Exception
 * @throws IllegalMemoryException
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws MacroException
 */
public macro Strategy(attr: Tokens, input: Tokens): Tokens {
    expandStrategy(attr, input)
}

/*
 * @throws ConcurrentModificationException
 * @throws ParseASTException
 * @throws ASTException
 * @throws Error
 * @throws Exception
 * @throws IllegalMemoryException
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws MacroException
 */
func expandStrategy(attr: Tokens, input: Tokens): Tokens {
    let strategies = ArrayList(parseDSLMacro(attr))
    let builder = TokensBuilder()

    let funcItem = parseDecl(input) as FuncDecl ?? throw MacroException("@Strategy macro must be placed on a function")
    checkFunc(funcItem)

    let modifiers = funcItem.modifiers
    funcItem.modifiers = ArrayList()
    let paramTypes = funcItem.funcParams |>
        map {x: FuncParam => x.paramType.toTokens() } |>
        collectArray<Tokens>
    let paramNames = funcItem.funcParams |>
        map {x: FuncParam => x.identifier.value } |>
        collectArray<String>
    let funcName = funcItem.identifier
    let returnType = funcItem.declType

    let isStatic = modifiers |> any<Modifier>{ t => t.keyword.kind == TokenKind.STATIC }

    buildDataStrategy(
        strategies,
        paramNames,
        paramTypes,
        funcName,
        resultingType: quote(DataStrategyProcessor<$returnType>),
        builder: builder
    )

    let namesTokens = paramNames |> map {x => Token(IDENTIFIER, x)} |> collectArray<Token>
    let destructuring = nestedTuple(namesTokens).ifEmpty(quote(_))
    builder.append(
        quote(.map<$returnType> { x___ =>
            $funcItem
            let $destructuring = x___
            $funcName($(commaSeparated(namesTokens)))
        })
    )

    if (isStatic) {
        return quote($modifiers $(builder.toTokens()))
    } else {
        return quote( @Attribute[Strategy] $modifiers $(builder.toTokens()))
    }
}

/*
 * @throws IndexOutOfBoundsException
 * @throws ASTException
 * @throws IllegalArgumentException
 * @throws MacroException
 */
private func checkFunc(funcItem: FuncDecl) {
    if (let Some(key) <- MacroStorage.loadAllAttrs(funcItem).keys().iterator().next()) {
        throw MacroException("@Strategy macro can't be used together with ${key}")
    }

    try {
        funcItem.declType
    } catch (e: ASTException) {
        throw MacroException("@Strategy annotated function must have return type explicitly specified.")
    }

    for (modifier in funcItem.modifiers) {
        let kind = modifier.keyword.kind
        if (MacroKey.FORBIDDEN_MODIFIERS |> any<TokenKind> {t => t == kind}) {
            throw MacroException(
                "Function modifier `${modifier.keyword.value}` is not allowed on @Strategy annotated function")
        }
    }
}
