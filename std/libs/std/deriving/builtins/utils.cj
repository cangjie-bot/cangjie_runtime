






protected package std.deriving.builtins

import std.deriving.api.*
import std.ast.*
import std.collection.*

/**
 * @throws Error
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func destructEnumCase(enumCase: TargetEnumCase, prefix: String): Tokens {
    let constructorId = enumCase.constructor.identifier
    let presentPositions = enumCase.fields |> map<TargetEnumField, Int64> { f => f.position } |> collectHashSet

    if (enumCase.totalArgumentsCount == 0) {
        return quote($constructorId)
    }

    return (0..enumCase.totalArgumentsCount) |> map<Int64, Tokens> { f =>
        match (presentPositions.contains(f)) {
            case true => Tokens(Token(TokenKind.IDENTIFIER, "${prefix}${f}"))
            case _ => Tokens(Token(TokenKind.WILDCARD, "_"))
        }
    } |> joinTokens(prefix: quote($constructorId\(), delimiter: quote(,), postfix: quote(\)))
}

/**
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func enumFallback(target: DerivingTarget): Tokens {
    match (isEnumHasEllipsis(target)) {
        case true => quote(
            case _ => throw Exception("Should never happen")
        )
        case _ => quote()
    }
}

func isEnumHasEllipsis(target: DerivingTarget): Bool {
    match (target.declaration) {
        case en: EnumDecl => en.ellipsis.kind == TokenKind.ELLIPSIS
        case _ => false
    }
}
