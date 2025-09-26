






macro package std.unittest.testmacro

import std.ast.*
import std.collection.*
class TokensBuilder  {
    TokensBuilder(let data: ArrayList<Tokens>) {}
    init() { data = ArrayList() }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func append(tokens: TokensBuilder): TokensBuilder {
        data.add(all: tokens.data)
        return this
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func append(kind: TokenKind): TokensBuilder {
        data.add(Tokens(Token(kind)))
        return this
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func append<TT>(tokens: TT): TokensBuilder where TT <: ToTokens {
        match (tokens) {
            case tb: TokensBuilder => return append(tb)
            case _ => ()
        }

        let raw = tokens.toTokens()
        data.add(raw)
        return this
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func curlyBraces(body: (TokensBuilder) -> Unit): TokensBuilder {
        append(LCURL).append(NL)
        body(this)
        append(RCURL).append(NL)
    }

    /**
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func scope(body: (TokensBuilder) -> Unit) {
        append(NL).append(quote({ => ))
        body(this)
        append(NL).append(quote(}())).append(NL)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toTokens(): Tokens {
        let bigList = ArrayList<Token>()
        for (tt in data) {
            for (t in tt) {
                bigList.add(t)
            }
        }
        Tokens(bigList)
    }
}

extend Tokens {
    /**
     * @throws IndexOutOfBoundsException
     */
    func startsWith(prefix: Tokens): Bool {
        let thisIt = this.iterator()
        let thatIt = prefix.iterator()
        while (true) {
            match ((thisIt.next(), thatIt.next())) {
                case (Some(t0), Some(t1)) where t0.kind == t1.kind && t0.value == t1.value =>
                    continue
                case (_, None) => return true
                case (None, _) => return false
                case _ => break
            }
        }
        return false
    }
}

extend<T> Option<T> where T <: ToTokens {
    /**
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func toTokens(): Tokens {
        match (this) {
            case None => quote(None)
            case Some(tokens) => quote($tokens)
        }
    }
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func nestedTuple<T>(things: Array<T>): Tokens where T <: ToTokens {
    if (things.size == 0) {
        return Tokens()
    }
    if (things.size == 1) {
        return things[0].toTokens()
    }

    func buildTuple(tb: TokensBuilder, i: Int64): Unit {
        let item = things[i]
        if (i == 0) {
            tb.append(things[i])
            return
        }

        tb.append(TokenKind.LPAREN)
        buildTuple(tb, i - 1)
        tb.append(TokenKind.COMMA)
        tb.append(things[i])
        tb.append(TokenKind.RPAREN)
    }

    let tb = TokensBuilder()

    buildTuple(tb, things.size - 1)

    return tb.toTokens()
}

/**
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func commaSeparated<T>(things: Iterable<T>): Tokens where T <: ToTokens {
    let tb = TokensBuilder()
    let it = things.iterator()
    let first = it.next()
    match (first) {
        case None => return tb.toTokens()
        case Some(t) => tb.append(t)
    }
    for (e in it) {
        tb.append(COMMA).append(e)
    }
    return tb.toTokens()
}

/**
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func arrayLiteral<T>(array: Iterable<T>): Tokens where T <: ToTokens {
    return quote([$(commaSeparated(array))])
}

/**
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func tupleLiteral<T>(array: Iterable<T>): Tokens where T <: ToTokens {
    return quote(($(commaSeparated(array))))
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
 */
func parseCommaSeparatedExpressions(input: Tokens): Array<Expr> {
    let parsedFakeCall = (parseExpr(quote(dummy($input))) as CallExpr).getOrThrow()
    return parsedFakeCall.arguments |> map { arg: Argument => arg.expr } |> collectArray
}

/**
 * @throws ASTException
 */
func getGenericParams(decl: Decl): Tokens {
    return try {
        decl.genericParam.parameters
    } catch (e: Exception) {
        Tokens()
    }
}

/**
 * @throws ConcurrentModificationException
 * @throws ASTException
 * @throws ParseASTException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 * @throws Exception
 */
func parseTypes(tokens: Tokens): ArrayList<TypeNode> {
    let types = ArrayList<TypeNode>()

    var start = 0
    while (start <= tokens.size) {
        try {
            let (ty, end) = parseTypeFragment(tokens, startFrom: start)
            types.add(ty)
            start = end + 1

            if (start > tokens.size) {
                break
            }
            if (tokens.get(end).kind != TokenKind.COMMA) {
                throw Exception("Types should be separated with comma [${tokens}].")
            }
        } catch (e: ParseASTException) {
            throw IllegalArgumentException("List of types can not be parsed [${tokens}].")
        }
    }

    return types
}
