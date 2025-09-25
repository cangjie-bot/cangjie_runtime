






macro package std.unittest.testmacro

import std.ast.*
import std.collection.ArrayList

extend Array<TokenKind> {
    func containsKind(target: TokenKind): Bool {
        for (kind in this where kind == target) {
            return true
        }
        false
    }
}

extend<T> ArrayList<T> {
    func find(predicate: (T) -> Bool): ?T {
        for (x in this where predicate(x)) {
            return x
        }
        None
    }

    func contains(predicate: (T) -> Bool): Bool {
        this.find(predicate).isSome()
    }
}

extend Tokens {
    func contains(predicate: (Token) -> Bool): Bool {
        for (token in this where predicate(token)) {
            return true
        }
        false
    }
}

extend FuncDecl {
    func isAbstract(): Bool {
        this.block.lBrace == this.block.rBrace
    }
}
