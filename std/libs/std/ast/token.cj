







package std.ast

public struct Token <: ToBytes {


    public let kind: TokenKind
    public let value: String
    public let pos: Position
    public var delimiterNum: UInt16 = 1
    protected var isSingleQuote = false

    public init() {
        kind = TokenKind.ILLEGAL
        value = ""
        pos = Position()
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public init(kind: TokenKind) {
        this.kind = kind
        value = getTokenLiteral(kind)
        pos = Position()
        if (kind == SINGLE_QUOTED_STRING_LITERAL) {
            this.isSingleQuote = true
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(kind: TokenKind, value: String) {
        if (!checkKindValue(kind, value)) {
            throw IllegalArgumentException(
                "TokenKind(" + getTokenKindValue(kind) + ") and Value(" + value + ") not matched.\n")
        }
        this.kind = kind
        this.value = value
        pos = Position()
        if (kind == SINGLE_QUOTED_STRING_LITERAL) {
            this.isSingleQuote = true
        }
    }
    init(k: TokenKind, v: String, f: UInt32, l: Int32, c: Int32) {
        kind = k
        value = v
        pos = Position(f, l, c)
    }

    public func addPosition(fileID: UInt32, line: Int32, colum: Int32): Token {
        return Token(this.kind, this.value, fileID, line, colum)
    }

    func addPosition(position: NodeFormat_Position) {
        return Token(this.kind, this.value, position.fileId, position.line, position.column)
    }

    func addPosition(position: Position) {
        return Token(this.kind, this.value, position.fileID, position.line, position.column)
    }
    public operator func ==(r: Token): Bool {
        return this.kind == r.kind && this.value == r.value && this.pos == r.pos
    }
    public operator func !=(r: Token): Bool {
        return !(this == r)
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func +(r: Tokens): Tokens {
        var l: Tokens = Tokens(Array<Token>(1, repeat: this))
        return l + r
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func +(r: Token): Tokens {
        var l: Tokens = Tokens(Array<Token>(1, repeat: this))
        return l + r
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    public func dump(): Unit {
        let kv: String = getTokenKindValue(kind)
        let id: UInt16 = getTokenID(kind)
        print("description: ${kv}, token_id: ${id}, ")
        if (this.kind == TokenKind.NL) {
            print("token_literal_value: \\n, ")
        } else {
            print("token_literal_value: ${value}, ")
        }
        pos.dump()
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toBytes(): Array<UInt8> {
        var kindId: UInt16 = getTokenID(this.kind)
        var b1: Array<UInt8> = castUInt16ToBytes(kindId)
        var b2: Array<UInt8> = castStringToBytes(this.value)
        var b12: Array<UInt8> = concatBytes(b1, b2)
        var b3: Array<UInt8> = this.pos.toBytes()
        var b23: Array<UInt8> = concatBytes(b12, b3)
        let isSingle: UInt16 = if (this.isSingleQuote) {
            1
        } else {
            0
        }
        var b4: Array<UInt8> = castUInt16ToBytes(isSingle)
        if (getTokenKind(kindId) == TokenKind.MULTILINE_RAW_STRING) {
            var b5: Array<UInt8> = castUInt16ToBytes(this.delimiterNum)
            var b45: Array<UInt8> = concatBytes(b4, b5)
            return concatBytes(b23, b45)
        }
        return concatBytes(b23, b4)
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func toBytes(arr: Array<UInt8>, start1: Int64) {
        var start = start1
        let kindId: UInt16 = getTokenID(this.kind)
        start = castUInt16ToBytes(arr, start, kindId)
        start = castStringToBytes(arr, start, this.value)
        start = this.pos.toBytes(arr, start)
        let isSingle: UInt16 = if (this.isSingleQuote) {
            1
        } else {
            0
        }
        start = castUInt16ToBytes(arr, start, isSingle)
        if (getTokenKind(kindId) == TokenKind.MULTILINE_RAW_STRING) {
            start = castUInt16ToBytes(arr, start, this.delimiterNum)
        }
        return start
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func getSize() {
        let kindId: UInt16 = getTokenID(this.kind)
        let size_kind = 2
        let size_len = 4
        let size_value = this.value.size
        let size_pos = this.pos.getSize()
        var size = size_kind + size_len + size_value + size_pos
        let size_is_single = 2
        size += size_is_single
        if (getTokenKind(kindId) == TokenKind.MULTILINE_RAW_STRING) {
            let size_delimiterNum = 2
            size += size_delimiterNum
        }
        return size
    }
}

/**
 * @throws IndexOutOfBoundsException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 */
func refreshPos(token: Token, f: UInt32, l: Int32, c: Int32): Token {
    var tk: Token
    if (let Some(macroObjPtr) <- MACRO_OBJECT.get()) {
        let pos = getMacroPosition(macroObjPtr)
        tk = Token(token.kind, token.value, pos[0], pos[1], pos[2])
        tk.delimiterNum = token.delimiterNum
        tk.isSingleQuote = token.isSingleQuote
        return tk
    }
    tk = Token(token.kind, token.value, f, l, c)
    tk.delimiterNum = token.delimiterNum
    tk.isSingleQuote = token.isSingleQuote
    return tk
}
