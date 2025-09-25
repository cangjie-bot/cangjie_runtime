







package std.ast

import std.collection.ArrayList

public class TokensIterator <: Iterator<Token> {
    
    private var position: Int64 = -1
    private let data: Tokens

    

    /*
     * @noThrow
     */
    public init(tokens: Tokens) {
        data = tokens
    }

    

    
    /*
     * @throws IndexOutOfBoundsException
     */
    public func peek(): Option<Token> {
        if (position >= data.size || position < 0) {
            return None<Token>
        }
        return Some(data[position])
    }

    
    /*
     * @throws IndexOutOfBoundsException
     */
    public func seeing(kind: TokenKind): Bool {
        return match (this.peek()) {
            case Some(obj) => obj.kind == kind
            case None => false
        }
    }

    
    /*
     * @throws IndexOutOfBoundsException
     */
    public func next(): Option<Token> {
        if (position < data.size) {
            position = position + 1
        }
        return peek()
    }
}

/*
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func refreshTokensPosition(tks: Tokens) {
    return tks.refreshPosition()
}

public open class Tokens <: ToString & Iterable<Token> & ToBytes {
    

    
    protected var tokens: ArrayList<Token> = ArrayList<Token>(0)

    /*
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func refreshPosition() {
        var newTokens: ArrayList<Token> = ArrayList<Token>(0)
        for (tk in tokens) {
            newTokens.add(refreshPos(tk, tk.pos.fileID, tk.pos.line, tk.pos.column))
        }
        tokens = newTokens
        return this
    }

    

    
    /*
     * @noThrow
     */
    public init() {
    }

    
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    init(buf: Array<UInt8>) {
        if (buf.size == 0) {
            return
        }
        var off: Int64 = 0
        let sizeOfTokens: UInt32 = getUInt32(buf[off..off + 4])
        off = off + 4
        for (_ in 0..Int64(sizeOfTokens)) {
            let tokenId: UInt16 = getUInt16(buf[off..off + 2])
            off = off + 2
            let strLen = getUInt32(buf[off..off + 4])
            off = off + 4
            let value: String = getString(buf, off, strLen)
            off = off + value.size
            let fileID: UInt32 = getUInt32(buf[off..off + 4])
            off = off + 4
            let line: Int32 = getInt32(buf[off..off + 4])
            off = off + 4
            let column: Int32 = getInt32(buf[off..off + 4])
            off = off + 4
            var tokenKind = getTokenKind(tokenId)
            let isSingle: UInt16 = getUInt16(buf[off..off + 2])
            if (tokenKind == STRING_LITERAL && isSingle == 1) {
                tokenKind = SINGLE_QUOTED_STRING_LITERAL
            }
            off = off + 2
            var token: Token = Token(tokenKind, value, fileID, line, column)
            if (isSingle == 1) {
                token.isSingleQuote = true
            }
            if (tokenKind == TokenKind.MULTILINE_RAW_STRING) {
                token.delimiterNum = getUInt16(buf[off..off + 2])
                off = off + 2
            }
            tokens.add(token)
        }
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(tokArray: Array<Token>) {
        tokens.add(all: tokArray)
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(tokArrayList: ArrayList<Token>) {
        tokens.add(all: tokArrayList)
    }

    

    
    public open prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            return tokens.size
        }
    }

    
    /*
     * @throws IndexOutOfBoundsException
     */
    public open func get(index: Int64): Token {
        if (index < 0 || index >= tokens.size) {
            throw IndexOutOfBoundsException("index is ${index} but the size of tokens is ${tokens.size}")
        }
        return tokens[index]
    }

    
    /*
     * @noThrow
     */
    public func iterator(): TokensIterator {
        return TokensIterator(this)
    }

    
    /*
     * @noThrow
     */
    public func concat(tokens: Tokens): Tokens {
        return ConcatTokens(this, tokens)
    }

    

    
    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func [](index: Int64): Token {
        return this.get(index)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public open operator func [](range: Range<Int64>): Tokens {
        return Tokens(tokens[range])
    }

    
    /*
     * @noThrow
     */
    public operator func +(r: Tokens): Tokens {
        return this.concat(r)
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func +(r: Token): Tokens {
        var rts: Tokens = Tokens(Array<Token>(1, repeat: r))
        return this.concat(rts)
    }

    
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func append(tokens: Tokens): Tokens {
        for (tk in tokens) {
            this.tokens.add(tk)
        }
        return this
    }

    
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func append(token: Token): Tokens {
        tokens.add(token)
        return this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func append(node: Node): Tokens {
        this.append(node.toTokens())
        return this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func remove(index: Int64): Tokens {
        tokens.remove(at: index)
        return this
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    public func dump(): Unit {
        for (tk in this) {
            tk.dump()
        }
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     */
    public func toString(): String {
        if (size == 0) {
            return ""
        } else if (size == 1) {
            return tokenToString(this[0])
        }
        var tokBytes: CPointer<UInt8> = unsafePointerCastFromUint8Array((this).toBytes())
        var spaceFlag: CPointer<Bool> = unsafe { LibC.malloc<Bool>(count: size) }
        if (spaceFlag.isNull()) {
            unsafe { LibC.free(tokBytes) }
            throw IllegalMemoryException("malloc failed!")
        }
        unsafe { CJ_CheckAddSpace(tokBytes, spaceFlag) }
        var toStr: String = ""
        var indentStr = "    "
        try {
            var indent = 0;
            for (loop in 0..this.size) {
                if (this[loop].kind == TokenKind.RCURL && indent > 0) {
                    indent = indent - 1
                }
                if (loop != 0 && this[loop - 1].kind == TokenKind.NL) {
                    toStr = toStr + indentStr * indent
                }
                if (this[loop].kind == TokenKind.LCURL) {
                    indent = indent + 1
                }
                toStr = toStr + tokenToString(this[loop])
                if (unsafe { spaceFlag.read(loop) }) {
                    toStr = toStr + " "
                }
            }
        } finally {
            unsafe { LibC.free(tokBytes) }
            unsafe { LibC.free(spaceFlag) }
        }
        return toStr
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func toBytes(): Array<UInt8> {
        let numberOfTokens: Int64 = this.size
        if (numberOfTokens == 0) {
            return Array<UInt8>(0, {_ => 0})
        }

        let size = getSize()
        let arr = Array<UInt8>(size, repeat: 0)
        var start = 0

        start = castUInt32ToBytes(arr, start, UInt32(numberOfTokens))

        for (i in 0..numberOfTokens) {
            start = this[i].toBytes(arr, start)
        }

        return arr
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func toBytes(startFrom: Int64): Array<UInt8> {
        let numberOfTokens: Int64 = this.size - startFrom
        if (numberOfTokens <= 0) {
            return Array<UInt8>(0, {_ => 0})
        }

        let size = getSize(startFrom: startFrom)
        let arr = Array<UInt8>(size, repeat: 0)
        var start = 0

        start = castUInt32ToBytes(arr, start, UInt32(numberOfTokens))

        for (i in startFrom..this.size) {
            start = this[i].toBytes(arr, start)
        }

        return arr
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func getSize(startFrom!: Int64 = 0) {
        let numberOfTokens: Int64 = this.size
        var size = 0;
        for (i in startFrom..numberOfTokens) {
            size += this[i].getSize()
        }
        let size_numberOfTokens = 4
        return size + size_numberOfTokens
    }
}

/*
 * @throws IllegalArgumentException
 */
func tokenToString(tk: Token): String {
    var ret: String = " "
    let quoteMark: String = if (tk.isSingleQuote) {
        "\'"
    } else {
        "\""
    }
    if (tk.kind == TokenKind.MULTILINE_RAW_STRING) {
        var delimiter: String = ""
        var cnt = tk.delimiterNum
        while (cnt > 0) {
            delimiter += "#"
            cnt--
        }
        if (tk.value.endsWith("\\")) {
            ret = delimiter + "\\" + quoteMark + tk.value + "\\" + quoteMark + delimiter
        } else {
            ret = delimiter + quoteMark + tk.value + quoteMark + delimiter
        }
    } else if (tk.kind == TokenKind.MULTILINE_STRING) {
        ret = quoteMark + quoteMark + quoteMark + "\n" + tk.value + quoteMark + quoteMark + quoteMark
    } else if (tk.kind == TokenKind.STRING_LITERAL || tk.kind == TokenKind.SINGLE_QUOTED_STRING_LITERAL) {
        ret = quoteMark + tk.value + quoteMark
    } else if (tk.kind == TokenKind.JSTRING_LITERAL) {
        if (tk.value.endsWith("\\")) {
            ret = "J\\" + quoteMark + tk.value + "\\" + quoteMark
        } else {
            ret = "J" + quoteMark + tk.value + quoteMark
        }
    } else if (tk.kind == TokenKind.RUNE_LITERAL) {
        ret = "r" + quoteMark + tk.value + quoteMark
    } else {
        ret = tk.value
    }
    return ret
}

class ConcatTokens <: Tokens {
    
    

    
    private let leftChild: Tokens
    private var rightChild: Tokens
    private var cachedSize: Int64

    

    
    /*
     * @noThrow
     */
    init(lc: Tokens, rc: Tokens) {

        leftChild = lc
        rightChild = rc
        cachedSize = leftChild.size + rightChild.size
    }

    

    
    public override prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            return cachedSize
        }
    }

    
    /*
     * @throws IndexOutOfBoundsException
     */
    public override func get(index: Int64): Token {
        if (index < 0 || index >= size) {
            throw IndexOutOfBoundsException("index is ${index} but the size of tokens is ${size}")
        }
        let leftChildSize = leftChild.size
        if (index < leftChildSize) {
            return leftChild[index]
        } else {
            return rightChild[index - leftChildSize]
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func [](range: Range<Int64>): Tokens {
        if (range.step != 1) {
            throw IllegalArgumentException("Illegal step ${range.step}, step should be 1")
        }

        if (range.start < 0 || range.end < range.start || range.end > size) {
            throw IndexOutOfBoundsException("the range is illegal or out of bound of index of the tokens")
        }

        let leftChildSize = leftChild.size
        if (range.end <= leftChildSize) {
            return leftChild[range]
        } else if (range.start >= leftChildSize) {
            return rightChild[(range.start - leftChildSize)..(range.end - leftChildSize)]
        } else {
            return leftChild[range.start..leftChildSize] + rightChild[0..(range.end - leftChildSize)]
        }
    }

    
    /*
     * @noThrow
     */
    public override func append(tks: Tokens): Tokens {
        rightChild = rightChild + tks
        cachedSize += tks.size
        return this
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public override func append(tk: Token): Tokens {
        rightChild = rightChild + tk
        cachedSize += 1
        return this
    }
}
