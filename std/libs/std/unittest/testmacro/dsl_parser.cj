






macro package std.unittest.testmacro

import std.ast.*
import std.collection.ArrayList
extend<T> ArrayList<T> {
    func push(value: T): Unit {
        add(value)
    }

    func pop(): ?T {
        if (size == 0) {
            None
        } else {
            remove(at: size - 1)
        }
    }

    prop top: ?T {
        get() {
            if (size == 0) { None } else { get(size - 1) }
        }
    }
}


class DSLParser {
    var inputIndex: Int64 = 0

    DSLParser(let input: Tokens) {
        skipIgnored()
    }
    prop currentToken: Token {
        get() { if (inputIndex < input.size) { input[inputIndex] } else { Token(END) } }
    }
    func nextToken() {
        if (completed()) {
            return
        }
        inputIndex++
        skipIgnored()
    }
    func skipIgnored() {
        while (!completed()) {
            match (currentToken.kind) {
                case NL | COMMENT | END => inputIndex++
                case _ => break
            }
        }
    }
    func expectToken(kind: TokenKind): Token {
        if (currentToken.kind != kind) {
            throw MacroException(
                "Expected ${kind} at index ${inputIndex}, got `${currentToken.value}` of kind ${currentToken.kind}"
            )
        } else {
            let result = currentToken
            nextToken()
            return result
        }
    }
    func parseBalancedDelimited(delimiter!: TokenKind, terminator!: TokenKind): Array<Tokens> {
        let result = ArrayList<Tokens>()
        var current = TokensBuilder()
        while (true) {
            let once = parseBalanced(terminator: delimiter)
            current.append(once)
            if (currentToken.kind == delimiter) {
                nextToken()
                result.add(current.toTokens())
                current = TokensBuilder()
                continue
            } else if (currentToken.kind == terminator) {
                result.add(current.toTokens())
                break
            }
        }
        return result.toArray()
    }
    func parseBalanced(terminator!: TokenKind = TokenKind.END): Tokens {
        let stack = ArrayList<TokenKind>()
        let tb = TokensBuilder()
        func opposite(tk: TokenKind): ?TokenKind {
            match (tk) {
                case LPAREN => RPAREN
                case LSQUARE => RSQUARE
                case LT => GT
                case RPAREN => LPAREN
                case RSQUARE => LSQUARE
                case GT => LT
                case _ => None
            }
        }

        while (!completed()) {
            match (currentToken.kind) {
                case LPAREN | LSQUARE | LT =>
                    stack.push(currentToken.kind)
                case RPAREN | RSQUARE | GT =>
                    if (stack.size == 0) {
                        return tb.toTokens()
                    }
                    let top = stack.pop()
                    match ((top, opposite(currentToken.kind))) {
                        case (Some(a), Some(b)) where a == b => ()
                        case _ =>
                            throw MacroException("Incorrect token sequence: ${tb.toTokens()} ${currentToken.value}")
                    }
                    if (stack.size == 0) {
                        tb.append(currentToken)
                        nextToken()
                        return tb.toTokens()
                    }
                case tk where tk == terminator =>
                    if (stack.size == 0) {
                        return tb.toTokens()
                    }
                case _ => ()
            }
            tb.append(currentToken)
            nextToken()
        }
        if (stack.size != 0) {
            throw MacroException("Incorrect token sequence: ${tb.toTokens()}")
        }
        return tb.toTokens()
    }
    func completed(): Bool {
        return inputIndex >= input.size
    }
}
