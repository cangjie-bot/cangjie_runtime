







package std.ast

import std.collection.ArrayList

const NUM_SPACES: UInt16 = 2

func isValidPosition(pos: NodeFormat_Position): Bool {
    if (pos.line == 0 && pos.column == 0) {
        return false
    }
    return true
}

func isValidPosition(tk: Token): Bool {
    if (tk.pos.line == 0 && tk.pos.column == 0) {
        return false
    }
    return true
}

func isValidToken(tk: Token): Bool {
    return tk.kind != TokenKind.ILLEGAL
}

/**
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws ParseASTException
 */
func getNodeBeginPos(nodeBase: Option<NodeFormat_NodeBase>): NodeFormat_Position {
    return match (nodeBase) {
        case Some(v) => v.GetBegin()
        case None => throw ParseASTException()
    }
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func getOperaterKindOrIdentTokens(opKind: Int32, pos: NodeFormat_Position, ident: Tokens): Tokens {
    let identifierTokens: Tokens = match (getTokenKind(UInt16(opKind))) {
        case NOT => Tokens().append(Token(TokenKind.NOT).addPosition(pos))
        case ADD => Tokens().append(Token(TokenKind.ADD).addPosition(pos))
        case SUB => Tokens().append(Token(TokenKind.SUB).addPosition(pos))
        case EXP => Tokens().append(Token(TokenKind.EXP).addPosition(pos))
        case MUL => Tokens().append(Token(TokenKind.MUL).addPosition(pos))
        case DIV => Tokens().append(Token(TokenKind.DIV).addPosition(pos))
        case MOD => Tokens().append(Token(TokenKind.MOD).addPosition(pos))
        case LT => Tokens().append(Token(TokenKind.LT).addPosition(pos))
        case LE => Tokens().append(Token(TokenKind.LE).addPosition(pos))
        case GT => Tokens().append(Token(TokenKind.GT).addPosition(pos))
        case BITAND => Tokens().append(Token(TokenKind.BITAND).addPosition(pos))
        case BITOR => Tokens().append(Token(TokenKind.BITOR).addPosition(pos))
        case BITXOR => Tokens().append(Token(TokenKind.BITXOR).addPosition(pos))
        case LSHIFT => Tokens().append(Token(TokenKind.LSHIFT).addPosition(pos))
        case EQUAL => Tokens().append(Token(TokenKind.EQUAL).addPosition(pos))
        case NOTEQ => Tokens().append(Token(TokenKind.NOTEQ).addPosition(pos))
        case RSHIFT => Tokens().append(Token(TokenKind.RSHIFT).addPosition(pos))
        case GE => Tokens().append(Token(TokenKind.GE).addPosition(pos))
        case LSQUARE => Token(TokenKind.LSQUARE).addPosition(pos) + Token(TokenKind.RSQUARE).addPosition(pos.fileId,
            pos.line, pos.column + 1)
        case LPAREN => Token(TokenKind.LPAREN).addPosition(pos) + Token(TokenKind.RPAREN).addPosition(pos.fileId,
            pos.line, pos.column + 1)
        case _ => ident
    }
    return identifierTokens
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func getIndent(indent: UInt16): String {
    return String(Array<Rune>(Int64(indent * NUM_SPACES), repeat: r' '))
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func getTokenIndent(name: String, tk: Token, indent: UInt16, noNameIndent!: Bool = false, index!: Option<Int64> = None): String {
    var ret: String = ""
    if (!isValidToken(tk) || (tk.value.isEmpty() && tk.pos.fileID != 1)) {
        return ret
    }
    var nameIndent = indent
    if (noNameIndent) {
        nameIndent = 0
    }
    match (index) {
        case Some(v) => ret += getIndent(nameIndent) + "${name}: ${v}, Token {\n"
        case None => ret += getIndent(nameIndent) + "${name}: Token {\n"
    }
    var value = tk.value
    if (value == "\n") {
        value = "\\n"
    }
    ret += getIndent(indent + 1) + "value: \"${value}\"\n"
    ret += getIndent(indent + 1) + "kind: ${tk.kind.toString()}\n"
    if (!isValidPosition(tk) || tk.pos.fileID != 1) {
        ret += getIndent(indent) + "}\n"
        return ret
    }
    ret += getIndent(indent + 1) + "pos: ${tk.pos.line}: ${tk.pos.column}\n"
    ret += getIndent(indent) + "}\n"
    return ret
}

/**
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func dumpNodes<N>(name: String, contents: ArrayList<N>, indent: UInt16): String where N <: Node {
    var ret = ""
    for (i in 0..contents.size) {
        ret += getIndent(indent) + "${name}: ${i}, "
        ret += contents[i].dump(indent)
    }
    return ret
}


/**
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
public func compareTokens(tokens1: Tokens, tokens2: Tokens): Bool {
    
    func rmNewlineEnd(input: Tokens): Tokens {
        var tokenArr: Tokens = Tokens()
        var iterator = input.iterator()
        while (true) {
            match (iterator.next()) {
                case None => break
                case Some(obj) where obj.kind != TokenKind.NL && obj.kind != TokenKind.END => tokenArr.append(obj);
                case _ => ()
            }
        }
        return tokenArr
    }
    var tokens1_: Tokens = rmNewlineEnd(tokens1)
    var tokens2_: Tokens = rmNewlineEnd(tokens2)

    
    var size1: Int64 = tokens1_.size
    var size2: Int64 = tokens2_.size
    if (size1 != size2) {
        return false
    }
    for (i in 0..size1) {
        var token1 = tokens1_[i]
        var token2 = tokens2_[i]
        
        if (token1.kind != token2.kind || token1.value != token2.value) {
            return false
        }
    }
    return true
}

/**
 * @throws IndexOutOfBoundsException
 */
func checkKindValue(k: TokenKind, v: String): Bool {
    let kv: String = getTokenLiteral(k)
    if (kv == "" || k == TokenKind.UNIT_LITERAL) {
        return true
    }
    if (k == TokenKind.NL && (v == "\n" || v == "\r\n")) {
        return true
    }
    return kv == v
}

/**
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func getImportSpecTokens(imports: ArrayList<ImportList>): Tokens {
    var r: Tokens = Tokens()
    for (i in 0..imports.size) {
        r.append(imports[i].toTokens())
    }
    return r
}

/**
 * @throws ASTException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func dumpCommonContent(currentIndent: UInt16, upperBound: Token, superTypes: ArrayList<TypeNode>,
    constraint: ArrayList<GenericConstraint>, body: Body) {
    var ret: String = ""
    if (isValidToken(upperBound)) {
        ret += getTokenIndent("-upperBound", upperBound, currentIndent)
    }

    for (i in 0..superTypes.size) {
        ret += getIndent(currentIndent) + "-superTypes: ${i}, "
        ret += superTypes[i].dump(currentIndent)
    }
    for (i in 0..constraint.size) {
        ret += getIndent(currentIndent) + "-genericConstraint: ${i}, "
        ret += constraint[i].dump(currentIndent)
    }
    ret += getIndent(currentIndent) + "-body: "
    ret += body.dump(currentIndent)
    return ret
}

/**
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func referenceType2Tokens(upperBound: Token, superTypes: ArrayList<TypeNode>, superTypeBitAnds: Tokens,
    constraint: ArrayList<GenericConstraint>, constraintCommas: Tokens): Tokens {
    let ret = Tokens()
    if (!superTypes.isEmpty()) {
        if (upperBound.kind != ILLEGAL) {
            ret.append(upperBound)
        } else {
            ret.append(Token(TokenKind.UPPERBOUND))
        }
        for (i in 0..superTypes.size - 1) {
            let bitAnd = superTypeBitAnds.tryGet(i) ?? Token(TokenKind.BITAND)
            ret.append(superTypes[i].toTokens()).append(bitAnd)
        }
        ret.append(superTypes[superTypes.size - 1].toTokens())
    }
    if (!constraint.isEmpty()) {
        var index = constraint.size - 1
        for (i in 0..index) {
            let comma = constraintCommas.tryGet(i) ?? Token(TokenKind.COMMA)
            ret.append(constraint[i].toTokens()).append(comma)
        }
        ret.append(constraint[index].toTokens())
    }
    return ret
}

extend Tokens {
    /**
     * @throws IndexOutOfBoundsException
     */
    func tryGet(index: Int64): ?Token {
        if (index >= size) {
            Option<Token>.None
        } else {
            Some(this[index])
        }
    }
}

extend Token {
    func tryGet(): ?Token {
        if (kind == TokenKind.ILLEGAL) {
            Option<Token>.None
        } else {
            Some(this)
        }
    }
}

/**
 * @throws ASTException
 */
func checkTokenType(tk: Token, kind: TokenKind) {
    if (tk.kind != kind) {
        throw ASTException("Illegal TokenKind, TokenKind should be ${kind}")
    }
}

/**
 * @throws ASTException
 */
func checkTokensType(tks: Tokens, kind: TokenKind) {
    for (tk in tks) {
        checkTokenType(tk, kind)
    }
}

/**
 * @throws ASTException
 */
func checkTokenTypeAssign(tk: Token) {
    let arr = [ASSIGN, ADD_ASSIGN, SUB_ASSIGN, MUL_ASSIGN, EXP_ASSIGN, DIV_ASSIGN, MOD_ASSIGN, AND_ASSIGN, OR_ASSIGN,
        BITAND_ASSIGN, BITOR_ASSIGN, BITXOR_ASSIGN, LSHIFT_ASSIGN, RSHIFT_ASSIGN]
    for (t in arr) {
        if (tk.kind == t) {
            return
        }
    }
    throw ASTException("Illegal TokenKind, TokenKind should be assign")
}

/**
 * @throws ASTException
 */
func checkPrimitiveType(tk: Token) {
    let arr = [INT8, INT16, INT32, INT64, INTNATIVE, UINT8, UINT16, UINT32, UINT64, UINTNATIVE, FLOAT16, FLOAT32,
        FLOAT64, RUNE, BOOLEAN, NOTHING, UNIT]
    for (t in arr) {
        if (tk.kind == t) {
            return
        }
    }
    throw ASTException("Illegal TokenKind, TokenKind should be a primitive type.")
}

func checkValid(input: Token) {
    if (isValidPosition(input)) {
        return input
    } else {
        return Token()
    }
}
