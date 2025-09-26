






protected package std.deriving.resolve

import std.ast.*

func myReduce<T>(combine: (T, T) -> T): (Iterable<T>) -> ?T {{ items =>
    let iterator = items.iterator()
    var current = iterator.next() ?? return None
    while (let Some(next) <- iterator.next()) {
        current = combine(next, current)
    }
    return current
}}

func unopt<T>(opt: Option<Option<T>>): Option<T> {
    opt ?? None
}

/**
 * @throws ConcurrentModificationException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws ParseASTException
 * @throws ASTException
 * @throws Error
 * @throws IllegalMemoryException
 * @throws NoneValueException
 * @throws Exception
 */
func myParseType(tokens: Tokens): TypeNode {
    let v = match (parseDecl(quote(let x: $tokens))) {
        case v: VarDecl => v
        case _ => throw Exception()
    }

    return v.declType
}
