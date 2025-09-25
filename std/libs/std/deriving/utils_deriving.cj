






macro package std.deriving

import std.deriving.api.*
import std.ast.*

interface DerivingMacroMessage<T> {
    static prop Key: String

    func sendMessage(): Unit
    static func fromMessage(msg: MacroMessage): ?T
}



func parseDeclUnwrapSafe(input: Tokens): Result<Decl> {
    try {
        Ok(parseDecl(input).unwrap())
    } catch (cause: Exception) {
        Err(cause)
    }
}

enum Result<T> {
    | Ok(T)
    | Err(Exception)
}
