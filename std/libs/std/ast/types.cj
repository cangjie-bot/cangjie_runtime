







package std.ast

import std.collection.ArrayList

public open class TypeNode <: Node {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token) {
        super()
        typeParameterName_ = typeParameterName
        colon_ = colon
    }
    /*
     * @noThrow
     */
    init() {
        super()
    }
    private var typeParameterName_: Token = Token(TokenKind.IDENTIFIER, "")
    private var colon_: Token = Token(TokenKind.COLON)
    public mut prop typeParameterName: Token {
        /*
         * @noThrow
         */
        get() {
            typeParameterName_
        }
        /*
         * @noThrow
         */
        set(v) {
            typeParameterName_ = v
        }
    }
    public mut prop colon: Token {
        /*
         * @noThrow
         */
        get() {
            colon_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, COLON)
            colon_ = v
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func toTokens(): Tokens {
        if (typeParameterName_.value.isEmpty()) {
            return Tokens()
        }
        return Tokens().append(typeParameterName_).append(colon_)
    }
    /*
     * @noThrow
     */
    public open func traverse(v: Visitor): Unit {
        v.visit(this)
        return
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected open func dump(indent: UInt16): String {
        var ret: String = ""
        if (!typeParameterName_.value.isEmpty()) {
            ret += getTokenIndent("-typeParameterName", typeParameterName_, indent)
            ret += getTokenIndent("-COLON", colon_, indent)
        }
        ret
    }
}

public class PrimitiveType <: TypeNode {
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseType(inputs) as PrimitiveType) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.typeParameterName = v.typeParameterName
                    this.keyword_ = v.keyword_
                case None => throw ASTException("Cannot construct the 'PrimitiveType' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'PrimitiveType' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {}
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, keyword: Token) {
        super(typeParameterName, colon)
        this.keyword_ = keyword
    }
    private var keyword_: Token = Token()
    public mut prop keyword: Token {
        /*
         * @noThrow
         */
        get() {
            keyword_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkPrimitiveType(v)
            keyword_ = v
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        return super.toTokens().append(keyword_)
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        return
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "PrimitiveType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getTokenIndent("-keyword", keyword_, currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class RefType <: TypeNode {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, identifier: Token, lAngle: Token, typeArguments: ArrayList<TypeNode>,
        commas: Tokens, rAngle: Token) {
        super(typeParameterName, colon)
        identifier_ = identifier
        lAngle_ = lAngle
        typeArguments_ = typeArguments
        commas_ = commas
        rAngle_ = rAngle
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseType(inputs) as RefType) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.typeParameterName = v.typeParameterName
                    this.identifier_ = v.identifier_
                    this.lAngle_ = checkValid(v.lAngle_)
                    this.typeArguments_ = v.typeArguments_
                    this.commas_ = v.commas_
                    this.rAngle_ = checkValid(v.rAngle_)
                case None => throw ASTException("Cannot construct the 'RefType' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'RefType' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {}

    private var identifier_: Token = Token()
    private var lAngle_: Token = Token()
    private var typeArguments_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var commas_: Tokens = Tokens()
    private var rAngle_: Token = Token()
    public mut prop identifier: Token {
        /*
         * @noThrow
         */
        get() {
            identifier_
        }
        /*
         * @noThrow
         */
        set(v) {
            identifier_ = v
        }
    }
    public mut prop lAngle: Token {
        /*
         * @noThrow
         */
        get() {
            lAngle_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LT)
            lAngle_ = v
        }
    }
    public mut prop typeArguments: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            typeArguments_
        }
        /*
         * @noThrow
         */
        set(v) {
            typeArguments_ = v
        }
    }
    public mut prop commas: Tokens {
        /*
         * @noThrow
         */
        get() {
            commas_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, COMMA)
            commas_ = v
        }
    }
    public mut prop rAngle: Token {
        /*
         * @noThrow
         */
        get() {
            rAngle_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, GT)
            rAngle_ = v
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret = super.toTokens().append(identifier_)
        if (!typeArguments_.isEmpty()) {
            ret.append(lAngle_.tryGet() ?? Token(TokenKind.LT))
            for (i in 0..typeArguments_.size - 1) {
                let comma = commas.tryGet(i) ?? Token(TokenKind.COMMA)
                ret.append(typeArguments_[i].toTokens()).append(comma)
            }
            ret.append(typeArguments_[typeArguments_.size - 1].toTokens())
            ret.append(rAngle_.tryGet() ?? Token(TokenKind.GT))
        }
        ret
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        for (ty in typeArguments_) {
            ty.traverse(v)
        }
        return
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "RefType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getTokenIndent("-identifier", identifier_, currentIndent)
        for (i in 0..typeArguments_.size) {
            ret += getIndent(currentIndent) + "-typeArguments: ${i}, "
            ret += typeArguments_[i].dump(currentIndent)
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class QualifiedType <: TypeNode {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, baseType: TypeNode, dot: Token, identifier: Token, lAngle: Token,
        typeArguments: ArrayList<TypeNode>, commas: Tokens, rAngle: Token) {
        super(typeParameterName, colon)
        baseType_ = baseType
        dot_ = dot
        identifier_ = identifier
        lAngle_ = lAngle
        typeArguments_ = typeArguments
        commas_ = commas
        rAngle_ = rAngle
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseType(inputs) as QualifiedType) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.typeParameterName = v.typeParameterName
                    this.baseType_ = v.baseType_
                    this.dot_ = v.dot_
                    this.identifier_ = v.identifier_
                    this.lAngle_ = checkValid(v.lAngle_)
                    this.typeArguments_ = v.typeArguments_
                    this.commas_ = v.commas_
                    this.rAngle_ = checkValid(v.rAngle_)
                case None => throw ASTException("Cannot construct the 'QualifiedType' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'QualifiedType' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {}
    private var baseType_: TypeNode = TypeNode()
    private var dot_: Token = Token(TokenKind.DOT)
    private var identifier_: Token = Token(TokenKind.IDENTIFIER, "")
    private var lAngle_: Token = Token()
    private var typeArguments_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var commas_: Tokens = Tokens()
    private var rAngle_: Token = Token()

    public mut prop baseType: TypeNode {
        /*
         * @noThrow
         */
        get() {
            baseType_
        }
        /*
         * @noThrow
         */
        set(v) {
            baseType_ = v
        }
    }
    public mut prop dot: Token {
        /*
         * @noThrow
         */
        get() {
            dot_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, DOT)
            dot_ = v
        }
    }
    public mut prop identifier: Token {
        /*
         * @noThrow
         */
        get() {
            identifier_
        }
        /*
         * @noThrow
         */
        set(v) {
            identifier_ = v
        }
    }
    public mut prop lAngle: Token {
        /*
         * @noThrow
         */
        get() {
            lAngle_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LT)
            lAngle_ = v
        }
    }
    public mut prop typeArguments: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            typeArguments_
        }
        /*
         * @noThrow
         */
        set(v) {
            typeArguments_ = v
        }
    }
    public mut prop commas: Tokens {
        /*
         * @noThrow
         */
        get() {
            commas_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, COMMA)
            commas_ = v
        }
    }
    public mut prop rAngle: Token {
        /*
         * @noThrow
         */
        get() {
            rAngle_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, GT)
            rAngle_ = v
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret = super.toTokens().append(baseType_.toTokens()).append(dot_).append(identifier_)
        if (!typeArguments_.isEmpty()) {
            ret.append(lAngle_)
            for (i in 0..typeArguments_.size - 1) {
                let comma = commas.tryGet(i) ?? Token(TokenKind.COMMA)
                ret.append(typeArguments_[i].toTokens()).append(comma)
            }
            ret.append(typeArguments_[typeArguments_.size - 1].toTokens())
            ret.append(rAngle_)
        }
        ret
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        baseType_.traverse(v)
        for (ty in typeArguments_) {
            ty.traverse(v)
        }
        return
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "QualifiedType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getIndent(currentIndent) + "-baseType: "
        ret += baseType_.dump(currentIndent)
        ret += getTokenIndent("identifier", identifier_, currentIndent)
        for (i in 0..typeArguments_.size) {
            ret += getIndent(currentIndent) + "typeArguments: ${i}, "
            ret += typeArguments_[i].dump(currentIndent)
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class ParenType <: TypeNode {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, lParen: Token, parenthesizedType: TypeNode, rParen: Token) {
        super(typeParameterName, colon)
        lParen_ = lParen
        this.ty_ = parenthesizedType
        rParen_ = rParen
    }
    /*
     * @noThrow
     */
    public init() {}
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseType(inputs) as ParenType) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.typeParameterName = v.typeParameterName
                    this.lParen_ = v.lParen_
                    this.ty_ = v.ty_
                    this.rParen_ = v.rParen_
                case None => throw ASTException("Cannot construct the 'ParenType' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'ParenType' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    private var lParen_: Token = Token(TokenKind.LPAREN)
    private var ty_: TypeNode = TypeNode()
    private var rParen_: Token = Token(TokenKind.RPAREN)
    public mut prop lParen: Token {
        /*
         * @noThrow
         */
        get() {
            lParen_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LPAREN)
            lParen_ = v
        }
    }
    public mut prop parenthesizedType: TypeNode {
        /*
         * @noThrow
         */
        get() {
            ty_
        }
        /*
         * @noThrow
         */
        set(v) {
            ty_ = v
        }
    }
    public mut prop rParen: Token {
        /*
         * @noThrow
         */
        get() {
            rParen_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, RPAREN)
            rParen_ = v
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        super.toTokens().append(lParen_).append(ty_.toTokens()).append(rParen_)
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        ty_.traverse(v)
        return
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "ParenType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getIndent(currentIndent) + "-parenthesizedType: "
        ret += ty_.dump(currentIndent + 1)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class TupleType <: TypeNode {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, lParen: Token, types: ArrayList<TypeNode>, commas: Tokens,
        rParen: Token) {
        super(typeParameterName, colon)
        lParen_ = lParen
        this.types_ = types
        commas_ = commas
        rParen_ = rParen
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseType(inputs) as TupleType) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.typeParameterName = v.typeParameterName
                    this.lParen_ = v.lParen_
                    this.commas_ = v.commas_
                    this.types_ = v.types_
                    this.rParen_ = v.rParen_
                case None => throw ASTException("Cannot construct the 'TupleType' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'TupleType' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {}
    private var lParen_: Token = Token(TokenKind.LPAREN)
    private var types_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var commas_: Tokens = Tokens()
    private var rParen_: Token = Token(TokenKind.RPAREN)
    public mut prop lParen: Token {
        /*
         * @noThrow
         */
        get() {
            lParen_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LPAREN)
            lParen_ = v
        }
    }
    public mut prop types: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            types_
        }
        /*
         * @noThrow
         */
        set(v) {
            types_ = v
        }
    }
    public mut prop rParen: Token {
        /*
         * @noThrow
         */
        get() {
            rParen_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, RPAREN)
            rParen_ = v
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret = super.toTokens().append(lParen_)
        if (commas_.size == 0) {
            commas_ = Tokens(Array(types_.size - 1, repeat: Token(TokenKind.COMMA)))
        }
        if (!types_.isEmpty()) {
            for (i in 0..types_.size - 1) {
                ret.append(types_[i].toTokens()).append(commas_[i])
            }
            ret.append(types_[types_.size - 1].toTokens())
        }
        ret.append(rParen_)
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        for (ty in types_) {
            ty.traverse(v)
        }
        return
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "TupleType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        for (i in 0..types_.size) {
            ret += getIndent(currentIndent) + "-types: ${i}, "
            ret += types_[i].dump(currentIndent)
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class ThisType <: TypeNode {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, keyword: Token) {
        super(typeParameterName, colon)
        keyword_ = keyword
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        let tokens = Tokens()
        tokens.append(quote(class tmp)).append(Token(LCURL)).append(quote(func f():)).append(inputs).append(quote({}}))
        let classDecl = (parseDecl(tokens) as ClassDecl).getOrThrow()
        let funcDecl = (classDecl.body.decls[0] as FuncDecl).getOrThrow()
        match (funcDecl.declType as ThisType) {
            case Some(v) =>
                this.begin_ = v.beginPos
                this.end_ = v.endPos
                super.typeParameterName = v.typeParameterName
                this.keyword_ = v.keyword_
            case None => throw ASTException("Cannot construct the 'ThisType' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
    }
    private var keyword_: Token = Token(TokenKind.THISTYPE)
    public mut prop keyword: Token {
        /*
         * @noThrow
         */
        get() {
            keyword_
        }
        /*
         * @noThrow
         */
        set(v) {
            keyword_ = v
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        super.toTokens().append(keyword_)
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        return
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "ThisType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getTokenIndent("-keyword", keyword_, currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class PrefixType <: TypeNode {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, prefixOps: Tokens, baseType: TypeNode) {
        super(typeParameterName, colon)
        prefixOps_ = prefixOps
        baseType_ = baseType
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseType(inputs) as PrefixType) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.typeParameterName = v.typeParameterName
                    this.prefixOps_ = v.prefixOps_
                    this.baseType_ = v.baseType_
                case None => throw ASTException("Cannot construct the 'PrefixType' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'PrefixType' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {}
    private var prefixOps_: Tokens = Tokens()
    private var baseType_: TypeNode = TypeNode()
    public mut prop prefixOps: Tokens {
        /*
         * @noThrow
         */
        get() {
            prefixOps_
        }
        /*
         * @noThrow
         */
        set(v) {
            prefixOps_ = v
        }
    }
    public mut prop baseType: TypeNode {
        /*
         * @noThrow
         */
        get() {
            baseType_
        }
        /*
         * @noThrow
         */
        set(v) {
            baseType_ = v
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        super.toTokens().append(prefixOps).append(baseType_)
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        baseType_.traverse(v)
        return
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "PrefixType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        for (i in 0..prefixOps_.size) {
            ret += getTokenIndent("-prefixOps: ${i}", prefixOps_[i], currentIndent)
        }
        ret += getIndent(currentIndent) + "-baseType: "
        ret += baseType_.dump(currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class FuncType <: TypeNode {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, keyword: Token, lParen: Token, types: ArrayList<TypeNode>,
        commas: Tokens, rParen: Token, arrow: Token, returnType: TypeNode) {
        super(typeParameterName, colon)
        this.keyword_ = keyword
        this.lParen_ = lParen
        this.types_ = types
        this.commas_ = commas
        this.rParen_ = rParen
        this.arrow_ = arrow
        this.retTy_ = returnType
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseType(inputs) as FuncType) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.typeParameterName = v.typeParameterName
                    this.keyword_ = checkValid(v.keyword_)
                    this.lParen_ = v.lParen_
                    this.types_ = v.types_
                    this.commas_ = v.commas_
                    this.rParen_ = v.rParen_
                    this.arrow_ = v.arrow_
                    this.retTy_ = v.retTy_
                case None => throw ASTException("Cannot construct the 'FuncType' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'FuncType' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {}
    private var keyword_: Token = Token()
    private var lParen_: Token = Token(TokenKind.LPAREN)
    private var types_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var commas_: Tokens = Tokens()
    private var rParen_: Token = Token(TokenKind.RPAREN)
    private var arrow_: Token = Token(TokenKind.ARROW)
    private var retTy_: TypeNode = TypeNode()
    public mut prop keyword: Token {
        /*
         * @noThrow
         */
        get() {
            keyword_
        }
        /*
         * @noThrow
         */
        set(v) {
            keyword_ = v
        }
    }
    public mut prop lParen: Token {
        /*
         * @noThrow
         */
        get() {
            lParen_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LPAREN)
            lParen_ = v
        }
    }
    public mut prop types: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            types_
        }
        /*
         * @noThrow
         */
        set(v) {
            types_ = v
        }
    }
    public mut prop commas: Tokens {
        /*
         * @noThrow
         */
        get() {
            commas_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, COMMA)
            commas_ = v
        }
    }
    public mut prop rParen: Token {
        /*
         * @noThrow
         */
        get() {
            rParen_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, RPAREN)
            rParen_ = v
        }
    }
    public mut prop arrow: Token {
        /*
         * @noThrow
         */
        get() {
            arrow_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, ARROW)
            arrow_ = v
        }
    }
    public mut prop returnType: TypeNode {
        /*
         * @noThrow
         */
        get() {
            retTy_
        }
        /*
         * @noThrow
         */
        set(v) {
            retTy_ = v
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret = super.toTokens()

        if (isValidToken(keyword_)) {
            ret.append(keyword_)
        }

        ret.append(lParen_)
        if (!types_.isEmpty()) {
            for (i in 0..types_.size - 1) {
                let comma = commas.tryGet(i) ?? Token(TokenKind.COMMA)
                ret.append(types_[i].toTokens()).append(comma)
            }
            ret.append(types_[types_.size - 1].toTokens())
        }
        ret.append(rParen_).append(arrow_).append(retTy_.toTokens())

        ret
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        for (ty in types_) {
            ty.traverse(v)
        }
        retTy_.traverse(v)
        return
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "FuncType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getTokenIndent("-keyword", keyword_, currentIndent)
        for (i in 0..types_.size) {
            ret += getIndent(currentIndent) + "-types: ${i}, "
            ret += types_[i].dump(currentIndent)
        }
        ret += getTokenIndent("-ARROW", arrow_, currentIndent)
        ret += getIndent(currentIndent) + "-returnType: "
        ret += retTy_.dump(currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class VArrayType <: TypeNode {
    /*
     * @noThrow
     */
    init(typeParameterName: Token, colon: Token, keyword: Token, lAngle: Token, elementTy: TypeNode, dollar: Token,
        size: Token, rAngle: Token) {
        super(typeParameterName, colon)
        keyword_ = keyword
        lAngle_ = lAngle
        elementTy_ = elementTy
        dollar_ = dollar
        constant_ = size
        rAngle_ = rAngle
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseType(inputs) as VArrayType) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.typeParameterName = v.typeParameterName
                    this.keyword_ = v.keyword_
                    this.lAngle_ = v.lAngle_
                    this.elementTy_ = v.elementTy_
                    this.dollar_ = v.dollar_
                    this.constant_ = v.constant_
                    this.rAngle_ = v.rAngle_
                case None => throw ASTException("Cannot construct the 'VArrayType' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'VArrayType' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {}
    private var keyword_: Token = Token(TokenKind.VARRAY)
    private var lAngle_: Token = Token(TokenKind.LT)
    private var elementTy_: TypeNode = TypeNode()
    private var dollar_: Token = Token(TokenKind.DOLLAR)
    private var constant_: Token = Token()
    private var rAngle_: Token = Token(TokenKind.GT)
    public mut prop keyword: Token {
        /*
         * @noThrow
         */
        get() {
            keyword_
        }
        /*
         * @noThrow
         */
        set(v) {
            keyword_ = v
        }
    }
    public mut prop lAngle: Token {
        /*
         * @noThrow
         */
        get() {
            lAngle_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LT)
            lAngle_ = v
        }
    }
    public mut prop elementTy: TypeNode {
        /*
         * @noThrow
         */
        get() {
            elementTy_
        }
        /*
         * @noThrow
         */
        set(v) {
            elementTy_ = v
        }
    }
    public mut prop dollar: Token {
        /*
         * @noThrow
         */
        get() {
            dollar_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, DOLLAR)
            dollar_ = v
        }
    }
    public mut prop size: Token {
        /*
         * @noThrow
         */
        get() {
            constant_
        }
        /*
         * @noThrow
         */
        set(v) {
            constant_ = v
        }
    }
    public mut prop rAngle: Token {
        /*
         * @noThrow
         */
        get() {
            rAngle_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, GT)
            rAngle_ = v
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var comma = Token(TokenKind.COMMA).addPosition(elementTy_.endPos.fileID, elementTy_.endPos.line,
            elementTy_.endPos.column + 1)
        super
            .toTokens()
            .append(keyword_)
            .append(lAngle_)
            .append(elementTy_)
            .append(comma)
            .append(dollar_)
            .append(size)
            .append(rAngle_)
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        elementTy_.traverse(v)
        return
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "VArrayType {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getTokenIndent("-VARRAY", keyword_, currentIndent)
        ret += getIndent(currentIndent) + "-elementTy: "
        ret += elementTy_.dump(currentIndent)
        ret += getTokenIndent("-dollar", dollar_, currentIndent)
        ret += getTokenIndent("-size", constant_, currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}
