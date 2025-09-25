






macro package std.unittest.mock.mockmacro

import std.ast.*

let tks = quote(any())

func preprocess(userInput: Tokens): Tokens {
    var result = Tokens()
    for (tok in userInput) {
        match (tok.kind) {
            case WILDCARD => result.append(quote($tks))
            case _ => result.append(tok)
        }
    }
    return result
}
