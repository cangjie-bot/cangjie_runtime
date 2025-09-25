






macro package std.unittest.testmacro

import std.ast.*
import std.collection.*

public macro Tag(tags: Tokens, input: Tokens): Tokens {
    verifyTagMacro(tags)
    return topLevelMacroDriver(TAG_MACRO, input, tags, { it => insideParentContext(it.macroIdentifier) })
}


func verifyTagMacro(tokens: Tokens): Unit {
    let parser = DSLParser(Tokens(collectArray(tokens)))
    try {
        let tags = parser.parseBalancedDelimited(delimiter: TokenKind.COMMA, terminator: TokenKind.END)
        if (tags |> any { it: Tokens => (it.size != 1 || it[0].kind != TokenKind.IDENTIFIER) }) {
            throw Exception("@Tag macro has no passed arguments or one of the tags is not valid identifier")
        }
    } catch (ex: Exception) {
        throw MacroException(
            "Illegal parameters for @Tag[${tokens}]," +
            "parameters should use the form @Tag[Tag1, Tag2, Tag3], nested error: " +
            ex.message
        )
    }
}
