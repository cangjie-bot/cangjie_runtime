







package std.ast

import std.collection.ArrayList

public open class Decl <: Node {
    /*
     * @noThrow
     */
    init(annotations: ArrayList<Annotation>, modifiers: ArrayList<Modifier>, keyword: Token, identifier: Token,
        genericParam: Option<GenericParam>, constraint: ArrayList<GenericConstraint>, constraintCommas: Tokens,
        isGenericDecl: Bool) {
        super()
        this.annotations_ = annotations
        this.modifiers_ = modifiers
        this.identifier_ = identifier
        this.keyword_ = keyword
        this.genericParam_ = genericParam
        this.constraint_ = constraint
        this.constraintCommas_ = constraintCommas
        this.isGenericDecl_ = isGenericDecl
    }

    /*
     * @noThrow
     */
    init(keyword: Token, identifier: Token) {
        super()
        this.identifier_ = identifier
        this.keyword_ = keyword
    }

    /*
     * @noThrow
     */
    init(decl: Decl) {
        super()
        this.annotations_ = decl.annotations
        this.modifiers_ = decl.modifiers
        this.identifier_ = decl.identifier
        this.keyword_ = decl.keyword
        this.genericParam_ = decl.genericParam_
        this.constraint_ = decl.genericConstraint
        this.constraintCommas_ = decl.constraintCommas_
        this.isGenericDecl_ = decl.isGenericDecl
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ASTException
     * @throws ParseASTException
     */
    init(input: Tokens) {
        try {
            var decl = parseDecl(input)
            this.begin_ = decl.beginPos
            this.end_ = decl.endPos
            this.annotations_ = decl.annotations
            this.modifiers_ = decl.modifiers
            this.identifier_ = match (decl) {
                case extDecl: ExtendDecl => Token()
                case _ => decl.identifier
            }
            this.keyword_ = decl.keyword
            this.genericParam_ = decl.genericParam_
            this.constraint_ = decl.genericConstraint
            this.constraintCommas_ = decl.constraintCommas
            this.node = decl
            this.isGenericDecl_ = decl.isGenericDecl
        } catch (e: Exception) {
            ()
        }
    }
    /*
     * @noThrow
     */
    init() {
        super()
    }
    private var annotations_: ArrayList<Annotation> = ArrayList<Annotation>()
    protected var modifiers_: ArrayList<Modifier> = ArrayList<Modifier>()
    protected var keyword_: Token = Token()
    protected var identifier_: Token = Token()
    private var genericParam_: Option<GenericParam> = None<GenericParam>
    private var constraint_: ArrayList<GenericConstraint> = ArrayList<GenericConstraint>()
    private var constraintCommas_: Tokens = Tokens()
    private var isGenericDecl_: Bool = false
    protected var node: Node = Expr()
    public mut open prop identifier: Token {
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
    public mut prop annotations: ArrayList<Annotation> {
        /*
         * @noThrow
         */
        get() {
            annotations_
        }
        /*
         * @noThrow
         */
        set(v) {
            annotations_ = v
        }
    }
    public mut prop modifiers: ArrayList<Modifier> {
        /*
         * @noThrow
         */
        get() {
            modifiers_
        }
        /*
         * @noThrow
         */
        set(v) {
            modifiers_ = v
        }
    }
    public mut prop genericParam: GenericParam {
        /*
         * @throws ASTException
         */
        get() {
            match (genericParam_) {
                case Some(v) => v
                case None => throw ASTException("Get Generic parameters failed")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            genericParam_ = Some(v)
        }
    }
    public mut prop genericConstraint: ArrayList<GenericConstraint> {
        /*
         * @noThrow
         */
        get() {
            constraint_
        }
        /*
         * @noThrow
         */
        set(v) {
            constraint_ = v
        }
    }
    public mut prop constraintCommas: Tokens {
        /*
         * @noThrow
         */
        get() {
            constraintCommas_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, COMMA)
            constraintCommas_ = v
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func hasAttr(attr: String): Bool {
        for (i in 0..annotations_.size) {
            for (attribute in annotations_[i].attributes) {
                if (attribute.value == attr) {
                    return true
                }
            }
        }
        return false
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func getAttrs(): Tokens {
        var ret = Tokens()
        for (i in 0..annotations_.size) {
            for (attribute in annotations_[i].attributes) {
                ret.append(attribute)
            }
        }
        return ret
    }

    public mut prop isGenericDecl: Bool {
        /*
         * @noThrow
         */
        get() {
            isGenericDecl_
        }
        /*
         * @noThrow
         */
        set(v) {
            isGenericDecl_ = v
        }
    }

    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func toTokens(): Tokens {
        var ret = Tokens()
        for (i in 0..annotations_.size) {
            ret.append(annotations_[i].toTokens())
        }
        for (i in 0..modifiers_.size) {
            ret.append(modifiers_[i].toTokens())
        }
        if (isValidToken(keyword_)) {
            ret.append(keyword_)
        }
        if (isValidToken(identifier_) && !identifier_.value.isEmpty() && keyword_.value != identifier_.value) {
            ret.append(identifier_)
        }
        match (genericParam_) {
            case Some(v) => ret.append(v.toTokens())
            case None => ()
        }
        return ret
    }

    /*
     * @noThrow
     */
    public open func traverse(v: Visitor): Unit {
        if (v.needBreakTraverse()) {
            return
        }
        for (anno in annotations_) {
            anno.traverse(v)
        }
        for (modifier in modifiers_) {
            modifier.traverse(v)
        }
        match (this.genericParam_) {
            case Some(node) => node.traverse(v)
            case _ => ()
        }
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected open func dump(indent: UInt16): String {
        var ret: String = ""
        for (i in 0..annotations_.size) {
            ret += getIndent(indent) + "-annotations: ${i}, "
            ret += annotations_[i].dump(indent)
        }
        for (i in 0..modifiers_.size) {
            ret += getIndent(indent) + "-modifiers: ${i}, "
            ret += modifiers_[i].dump(indent)
        }
        if (!keyword_.value.isEmpty()) {
            ret += getTokenIndent("-keyword", keyword_, indent)
        }
        if (!identifier_.value.isEmpty()) {
            ret += getTokenIndent("-identifier", identifier_, indent)
        }
        match (this.genericParam_) {
            case Some(node) =>
                if (genericParam.parameters.size != 0) {
                    ret += getIndent(indent) + "-genericParam: "
                    ret += node.dump(indent)
                }
            case _ => ()
        }
        ret
    }
}

public class ClassDecl <: Decl {
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as ClassDecl) {
            case Some(v) =>
                this.upBound_ = checkValid(v.upBound_)
                this.superTypes_ = v.superTypes_
                this.superTypeBitAnds_ = v.superTypeBitAnds_
                this.classbody_ = v.classbody_
            case None => throw ASTException("Cannot construct the 'ClassDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    init(decl: Decl, upBound: Token, superTypes: ArrayList<TypeNode>, superTypeBitAnds: Tokens, body: Body) {
        super(decl)
        this.upBound_ = upBound
        this.classbody_ = body
        this.superTypes_ = superTypes
        this.superTypeBitAnds_ = superTypeBitAnds
    }
    /*
     * @noThrow
     */
    public init() {
    }
    private var upBound_: Token = Token()
    private var superTypes_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var superTypeBitAnds_: Tokens = Tokens()
    private var classbody_: Body = Body()
    public mut prop upperBound: Token {
        /*
         * @noThrow
         */
        get() {
            upBound_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, UPPERBOUND)
            upBound_ = v
        }
    }
    public mut prop superTypes: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            superTypes_
        }
        /*
         * @noThrow
         */
        set(v) {
            superTypes_ = v
        }
    }
    public mut prop superTypeBitAnds: Tokens {
        /*
         * @noThrow
         */
        get() {
            superTypeBitAnds_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, BITAND)
            superTypeBitAnds_ = v
        }
    }
    public mut prop body: Body {
        /*
         * @noThrow
         */
        get() {
            classbody_
        }
        /*
         * @noThrow
         */
        set(v) {
            classbody_ = v
        }
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = super.toTokens()
        return ret
            .append(referenceType2Tokens(upBound_, superTypes_, superTypeBitAnds_, genericConstraint, constraintCommas))
            .append(classbody_.toTokens())
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        for (ty in superTypes_) {
            ty.traverse(v)
        }
        for (constraint in genericConstraint) {
            constraint.traverse(v)
        }
        classbody_.traverse(v)
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "ClassDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += dumpCommonContent(currentIndent, upBound_, superTypes_, genericConstraint, classbody_)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class StructDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, upBound: Token, superTypes: ArrayList<TypeNode>, superTypeBitAnds: Tokens, body: Body) {
        super(decl)
        this.upBound_ = upBound
        this.structbody_ = body
        this.superTypes_ = superTypes
        this.superTypeBitAnds_ = superTypeBitAnds
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as StructDecl) {
            case Some(v) =>
                this.upBound_ = checkValid(v.upBound_)
                this.superTypes_ = v.superTypes_
                this.structbody_ = v.structbody_
                this.superTypeBitAnds_ = v.superTypeBitAnds_
            case None => throw ASTException("Cannot construct the 'StructDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
    }
    private var upBound_: Token = Token()
    private var superTypes_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var superTypeBitAnds_: Tokens = Tokens()
    private var structbody_: Body = Body()
    public mut prop upperBound: Token {
        /*
         * @noThrow
         */
        get() {
            upBound_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, UPPERBOUND)
            upBound_ = v
        }
    }
    public mut prop superTypes: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            superTypes_
        }
        /*
         * @noThrow
         */
        set(v) {
            superTypes_ = v
        }
    }
    public mut prop superTypeBitAnds: Tokens {
        /*
         * @noThrow
         */
        get() {
            superTypeBitAnds_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, BITAND)
            superTypeBitAnds_ = v
        }
    }
    public mut prop body: Body {
        /*
         * @noThrow
         */
        get() {
            structbody_
        }
        /*
         * @noThrow
         */
        set(v) {
            structbody_ = v
        }
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = super.toTokens()
        return ret
            .append(referenceType2Tokens(upBound_, superTypes_, superTypeBitAnds_, genericConstraint, constraintCommas))
            .append(structbody_.toTokens())
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        for (ty in superTypes_) {
            ty.traverse(v)
        }
        for (constraint in genericConstraint) {
            constraint.traverse(v)
        }
        structbody_.traverse(v)
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "StructDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += dumpCommonContent(currentIndent, upBound_, superTypes_, genericConstraint, structbody_)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class InterfaceDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, upBound: Token, superTypes: ArrayList<TypeNode>, superTypeBitAnds: Tokens, body: Body) {
        super(decl)
        this.upBound_ = upBound
        this.interfacetbody_ = body
        this.superTypes_ = superTypes
        this.superTypeBitAnds_ = superTypeBitAnds
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as InterfaceDecl) {
            case Some(v) =>
                this.upBound_ = checkValid(v.upBound_)
                this.superTypes_ = v.superTypes_
                this.interfacetbody_ = v.interfacetbody_
                this.superTypeBitAnds_ = v.superTypeBitAnds_
            case None => throw ASTException("Cannot construct the 'InterfaceDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
    }
    private var upBound_: Token = Token()
    private var superTypes_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var superTypeBitAnds_: Tokens = Tokens()
    private var interfacetbody_: Body = Body()
    public mut prop upperBound: Token {
        /*
         * @noThrow
         */
        get() {
            upBound_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, UPPERBOUND)
            upBound_ = v
        }
    }
    public mut prop superTypes: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            superTypes_
        }
        /*
         * @noThrow
         */
        set(v) {
            superTypes_ = v
        }
    }
    public mut prop superTypeBitAnds: Tokens {
        /*
         * @noThrow
         */
        get() {
            superTypeBitAnds_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, BITAND)
            superTypeBitAnds_ = v
        }
    }
    public mut prop body: Body {
        /*
         * @noThrow
         */
        get() {
            interfacetbody_
        }
        /*
         * @noThrow
         */
        set(v) {
            interfacetbody_ = v
        }
    }

    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = super.toTokens()
        return ret
            .append(referenceType2Tokens(upBound_, superTypes_, superTypeBitAnds_, genericConstraint, constraintCommas))
            .append(interfacetbody_.toTokens())
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        for (ty in superTypes_) {
            ty.traverse(v)
        }
        for (constraint in genericConstraint) {
            constraint.traverse(v)
        }
        interfacetbody_.traverse(v)
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "InterfaceDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += dumpCommonContent(currentIndent, upBound_, superTypes_, genericConstraint, interfacetbody_)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class EnumDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, upBound: Token, superTypes: ArrayList<TypeNode>, superTypeBitAnds: Tokens, lBrace: Token,
        bitor: Tokens, constructors: ArrayList<Constructor>, decls: ArrayList<Decl>, rBrace: Token, ellipsis: Token) {
        super(decl)
        upBound_ = upBound
        superTypes_ = superTypes
        superTypeBitAnds_ = superTypeBitAnds
        lBrace_ = lBrace
        bitor_ = bitor
        constructors_ = constructors
        decls_ = decls
        rBrace_ = rBrace
        ellipsis_ = ellipsis
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as EnumDecl) {
            case Some(v) =>
                this.upBound_ = checkValid(v.upBound_)
                this.superTypes_ = v.superTypes_
                this.superTypeBitAnds_ = v.superTypeBitAnds_
                this.lBrace_ = v.lBrace_
                this.bitor_ = v.bitor_
                this.constructors_ = v.constructors_
                this.decls_ = v.decls_
                this.rBrace_ = v.rBrace_
                this.ellipsis_ = checkValid(v.ellipsis_)
            case None => throw ASTException("Cannot construct the 'EnumDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
    }
    private var upBound_: Token = Token()
    private var superTypes_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var superTypeBitAnds_: Tokens = Tokens()
    private var lBrace_: Token = Token(TokenKind.LCURL)
    private var bitor_: Tokens = Tokens()
    private var constructors_ = ArrayList<Constructor>()
    private var decls_ = ArrayList<Decl>()
    private var rBrace_: Token = Token(TokenKind.RCURL)
    private var ellipsis_: Token = Token()

    public mut prop upperBound: Token {
        /*
         * @noThrow
         */
        get() {
            upBound_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, UPPERBOUND)
            upBound_ = v
        }
    }
    public mut prop superTypes: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            superTypes_
        }
        /*
         * @noThrow
         */
        set(v) {
            superTypes_ = v
        }
    }
    public mut prop superTypeBitAnds: Tokens {
        /*
         * @noThrow
         */
        get() {
            superTypeBitAnds_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, BITAND)
            superTypeBitAnds_ = v
        }
    }
    public mut prop lBrace: Token {
        /*
         * @noThrow
         */
        get() {
            lBrace_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LCURL)
            lBrace_ = v
        }
    }
    public mut prop constructors: ArrayList<Constructor> {
        /*
         * @noThrow
         */
        get() {
            constructors_
        }
        /*
         * @noThrow
         */
        set(v) {
            constructors_ = v
        }
    }
    public mut prop decls: ArrayList<Decl> {
        /*
         * @noThrow
         */
        get() {
            decls_
        }
        /*
         * @noThrow
         */
        set(v) {
            decls_ = v
        }
    }
    public mut prop rBrace: Token {
        /*
         * @noThrow
         */
        get() {
            rBrace_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, RCURL)
            rBrace_ = v
        }
    }
    public mut prop ellipsis: Token {
        /*
         * @noThrow
         */
        get() {
            ellipsis_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, ELLIPSIS)
            ellipsis_ = v
        }
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = super.toTokens()
        if (!superTypes_.isEmpty()) {
            if (upBound_.kind != ILLEGAL) {
                ret.append(upBound_)
            } else {
                ret.append(Token(TokenKind.UPPERBOUND))
            }
            for (i in 0..superTypes_.size - 1) {
                let bitAnd = superTypeBitAnds_.tryGet(i) ?? Token(BITAND)
                ret.append(superTypes_[i].toTokens()).append(bitAnd)
            }
            ret.append(superTypes_[superTypes_.size - 1].toTokens())
        }
        if (!super.genericConstraint.isEmpty()) {
            var index = super.genericConstraint.size - 1
            for (i in 0..index) {
                let comma = super.constraintCommas.tryGet(i) ?? Token(TokenKind.COMMA)
                ret.append(super.genericConstraint[i].toTokens()).append(comma)
            }
            ret.append(super.genericConstraint[index].toTokens())
        }
        ret.append(lBrace_).append(Token(NL))
        let bitOrIterator = bitor_.iterator()
        if (!constructors_.isEmpty()) {
            if (bitor_.size != 0 && bitor_[0].pos.line <= constructors_[0].identifier.pos.line &&
                bitor_[0].pos.column <= constructors_[0].identifier.pos.column) {
                if (let Some(or) <- bitOrIterator.next()) {
                    ret.append(or)
                }
            }
            ret.append(constructors_[0].toTokens()).append(Token(NL))
            for (i in 1..constructors_.size) {
                let bitOr = bitOrIterator.next() ?? Token(BITOR)
                ret.append(bitOr).append(constructors_[i].toTokens()).append(Token(NL))
            }
        }
        if (isValidToken(ellipsis_)) {
            let bitOr = bitOrIterator.next() ?? Token(BITOR)
            ret.append(bitOr).append(ellipsis_).append(Token(NL))
        }
        for (decl in decls_) {
            ret.append(decl.toTokens())
        }
        ret.append(rBrace_).append(Token(NL))
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        for (ty in superTypes_) {
            ty.traverse(v)
        }
        for (constraint in genericConstraint) {
            constraint.traverse(v)
        }
        for (constructor in constructors_) {
            constructor.traverse(v)
        }
        for (decl in decls_) {
            decl.traverse(v)
        }
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "EnumDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        if (isValidToken(upBound_)) {
            ret += getTokenIndent("-upperBound", upBound_, currentIndent)
        }

        ret += dumpNodes("-superTypes", superTypes_, currentIndent)
        ret += dumpNodes("-genericConstraint", genericConstraint, currentIndent)
        for (i in 0..constructors_.size) {
            ret += getIndent(currentIndent) + "-constructors: ${i}, "
            ret += constructors_[i].dump(currentIndent)
        }
        if (isValidToken(ellipsis_)) {
            ret += getTokenIndent("-ellipsis", ellipsis_, currentIndent)
        }
        for (i in 0..decls_.size) {
            ret += getIndent(currentIndent) + "-decls: ${i}, "
            ret += decls_[i].dump(currentIndent)
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class ExtendDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, extendType: TypeNode, upBound: Token, superTypes: ArrayList<TypeNode>, superTypeBitAnds: Tokens,
        body: Body) {
        super(decl)
        this.extendType_ = extendType
        this.upBound_ = checkValid(upBound)
        this.superTypes_ = superTypes
        this.superTypeBitAnds_ = superTypeBitAnds
        this.body_ = body
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as ExtendDecl) {
            case Some(v) =>
                this.extendType_ = v.extendType_
                this.upBound_ = checkValid(v.upBound_)
                this.superTypes_ = v.superTypes_
                this.superTypeBitAnds_ = v.superTypeBitAnds_
                this.body_ = v.body_
            case None => throw ASTException("Cannot construct the 'ExtendDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
    }
    private var extendType_: TypeNode = TypeNode()
    private var upBound_: Token = Token()
    private var superTypes_: ArrayList<TypeNode> = ArrayList<TypeNode>()
    private var superTypeBitAnds_: Tokens = Tokens()
    private var body_ = Body()
    public mut override prop identifier: Token {
        /*
         * @throws ASTException
         */
        get() {
            throw ASTException("Current ExtendDecl don't have identifier")
        }
        /*
         * @throws ASTException
         */
        set(_) {
            throw ASTException("Current ExtendDecl don't have identifier")
        }
    }
    public mut prop extendType: TypeNode {
        /*
         * @noThrow
         */
        get() {
            extendType_
        }
        /*
         * @noThrow
         */
        set(v) {
            extendType_ = v
        }
    }
    public mut prop upperBound: Token {
        /*
         * @noThrow
         */
        get() {
            upBound_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, UPPERBOUND)
            upBound_ = v
        }
    }
    public mut prop superTypes: ArrayList<TypeNode> {
        /*
         * @noThrow
         */
        get() {
            superTypes_
        }
        /*
         * @noThrow
         */
        set(v) {
            superTypes_ = v
        }
    }
    public mut prop superTypeBitAnds: Tokens {
        /*
         * @noThrow
         */
        get() {
            superTypeBitAnds_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokensType(v, BITAND)
            superTypeBitAnds_ = v
        }
    }
    public mut prop body: Body {
        /*
         * @noThrow
         */
        get() {
            body_
        }
        /*
         * @noThrow
         */
        set(v) {
            body_ = v
        }
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = super.toTokens().append(extendType_)
        return ret
            .append(referenceType2Tokens(upBound_, superTypes_, superTypeBitAnds_, genericConstraint, constraintCommas))
            .append(body_.toTokens())
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        extendType_.traverse(v)
        for (ty in superTypes_) {
            ty.traverse(v)
        }
        for (constraint in genericConstraint) {
            constraint.traverse(v)
        }
        body_.traverse(v)
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "ExtendDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getIndent(currentIndent) + "-extendType: "
        ret += extendType_.dump(currentIndent)
        ret += dumpCommonContent(currentIndent, upBound_, superTypes_, genericConstraint, body_)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class FuncDecl <: Decl {
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as FuncDecl) {
            case Some(v) =>
                this.lParen_ = v.lParen_
                this.rParen_ = v.rParen_
                this.params_ = v.params_
                this.colon_ = checkValid(v.colon_)
                this.retTy_ = v.retTy_
                this.block_ = v.block_
                this.overloadedOperators_ = v.overloadedOperators_
                this.isEnumConstruct = v.isEnumConstruct
            case None => throw ASTException("Cannot construct the 'FuncDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    init(decl: Decl, lParen: Token, funcParams: ArrayList<FuncParam>, rParen: Token, colon: Token, ty: Option<TypeNode>,
        block: Block) {
        super(decl)
        this.lParen_ = lParen
        this.params_ = funcParams
        this.rParen_ = rParen
        this.colon_ = colon
        this.retTy_ = ty
        this.block_ = block
    }
    /*
     * @noThrow
     */
    public init() {
    }
    private var overloadedOperators_: Tokens = Tokens()
    private var lParen_: Token = Token(TokenKind.LPAREN)
    private var params_: ArrayList<FuncParam> = ArrayList<FuncParam>()
    private var rParen_: Token = Token(TokenKind.RPAREN)
    private var colon_ = Token()
    private var retTy_: Option<TypeNode> = None<TypeNode>
    private var block_: Block = Block()
    var isEnumConstruct: Bool = false
    public mut prop overloadOp: Tokens {
        /*
         * @noThrow
         */
        get() {
            overloadedOperators_
        }
        /*
         * @noThrow
         */
        set(v) {
            overloadedOperators_ = v
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
    public mut prop funcParams: ArrayList<FuncParam> {
        /*
         * @noThrow
         */
        get() {
            params_
        }
        /*
         * @noThrow
         */
        set(v) {
            params_ = v
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
    public mut prop declType: TypeNode {
        /*
         * @throws ASTException
         */
        get() {
            match (retTy_) {
                case Some(v) => v
                case None => throw ASTException("Current FuncDecl has empty return type")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            retTy_ = Some(v)
        }
    }
    public mut prop block: Block {
        /*
         * @noThrow
         */
        get() {
            block_
        }
        /*
         * @noThrow
         */
        set(v) {
            block_ = v
        }
    }

    /*
     * @noThrow
     */
    public func isConst(): Bool {
        for (modifier in modifiers) {
            if (modifier.keyword.value == "const") {
                return true
            }
        }
        return false
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = Tokens()
        for (i in 0..annotations.size) {
            ret.append(annotations[i].toTokens())
        }
        for (i in 0..modifiers.size) {
            ret.append(modifiers[i].toTokens())
        }
        if (isValidToken(keyword)) {
            ret.append(keyword)
        }
        if (overloadOp.size != 0) {
            ret.append(overloadOp)
        } else if (isValidToken(identifier) && !identifier.value.isEmpty() && keyword.value != identifier.value) {
            if (identifier.value == "~init") {
                let identPos = identifier.pos
                ret.append(Token(TokenKind.BITNOT).addPosition(identPos))
                ret.append(Token(TokenKind.INIT).addPosition(identPos.fileID, identPos.line, identPos.column + 1))
            } else {
                ret.append(identifier)
            }
        }
        var paramTokens = try {
            genericParam.toTokens()
        } catch (e: Exception) {
            Tokens()
        }
        ret.append(paramTokens).append(lParen_)
        ret.append(funcParams.toTokens())
        ret.append(rParen_)
        match (retTy_) {
            case Some(v) => ret.append(colon_).append(v.toTokens())
            case None => ()
        }
        if (!super.genericConstraint.isEmpty()) {
            var index = super.genericConstraint.size - 1
            for (i in 0..index) {
                let comma = super.constraintCommas.tryGet(i) ?? Token(TokenKind.COMMA)
                ret.append(super.genericConstraint[i].toTokens()).append(comma)
            }
            ret.append(super.genericConstraint[index].toTokens())
        }
        ret.append(block.toTokens())
        return ret
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        for (param in params_) {
            param.traverse(v)
        }
        match (retTy_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        for (constraint in genericConstraint) {
            constraint.traverse(v)
        }
        for (node in block.nodes) {
            node.traverse(v)
        }
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "FuncDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        if (overloadedOperators_.size != 0) {
            if (overloadedOperators_.size == 1) {
                ret += getTokenIndent("overloadOp", overloadedOperators_[0], currentIndent, noNameIndent: true)
            } else {
                ret += getIndent(currentIndent) +
                    "overloadOp: ${overloadedOperators_[0].value + overloadedOperators_[1].value}"
            }
        }
        for (i in 0..funcParams.size) {
            ret += getIndent(currentIndent) + "-funcParams: ${i}, "
            ret += funcParams[i].dump(currentIndent)
        }

        match (retTy_) {
            case Some(v) =>
                ret += getIndent(currentIndent) + "-declType: "
                ret += v.dump(currentIndent)
            case None => ()
        }
        for (i in 0..genericConstraint.size) {
            ret += getIndent(currentIndent) + "-genericConstraint: ${i}, "
            ret += genericConstraint[i].dump(currentIndent)
        }
        ret += getIndent(currentIndent) + "-block: "
        ret += block_.dump(currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class MainDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, lParen: Token, funcParams: ArrayList<FuncParam>, rParen: Token, colon: Token, ty: Option<TypeNode>,
        block: Block) {
        super(decl)
        this.lParen_ = lParen
        this.params_ = funcParams
        this.rParen_ = rParen
        this.colon_ = colon
        this.retTy_ = ty
        this.block_ = block
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as MainDecl) {
            case Some(v) =>
                this.lParen_ = v.lParen_
                this.rParen_ = v.rParen_
                this.params_ = v.params_
                this.colon_ = checkValid(v.colon_)
                this.retTy_ = v.retTy_
                this.block_ = v.block_
            case None => throw ASTException("Cannot construct the 'MainDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
        super()
    }
    private var lParen_: Token = Token(TokenKind.LPAREN)
    private var rParen_: Token = Token(TokenKind.RPAREN)
    private var colon_ = Token()
    private var params_: ArrayList<FuncParam> = ArrayList<FuncParam>()
    private var retTy_: Option<TypeNode> = None<TypeNode>
    private var block_: Block = Block()

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
    public mut prop funcParams: ArrayList<FuncParam> {
        /*
         * @noThrow
         */
        get() {
            params_
        }
        /*
         * @noThrow
         */
        set(v) {
            params_ = v
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
    public mut prop declType: TypeNode {
        /*
         * @throws ASTException
         */
        get() {
            match (retTy_) {
                case Some(v) => v
                case None => throw ASTException("Current MainDecl has empty return type")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            retTy_ = Some(v)
        }
    }
    public mut prop block: Block {
        /*
         * @noThrow
         */
        get() {
            block_
        }
        /*
         * @noThrow
         */
        set(v) {
            block_ = v
        }
    }

    /*
     * @throws ASTException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = Tokens().append(super.toTokens())
        ret.append(lParen_)
        ret.append(funcParams.toTokens())
        ret.append(rParen_)
        match (retTy_) {
            case Some(v) => ret.append(colon_).append(v.toTokens())
            case None => ()
        }
        ret.append(block.toTokens())
        return ret
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        for (param in params_) {
            param.traverse(v)
        }
        match (retTy_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        block_.traverse(v)
        return
    }

    /*
     * @throws ASTException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "MainDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        for (i in 0..funcParams.size) {
            ret += getIndent(currentIndent) + "-funcParams: ${i}, "
            ret += funcParams[i].dump(currentIndent)
        }
        match (retTy_) {
            case Some(v) =>
                ret += getIndent(currentIndent) + "-declType: "
                ret += v.dump(currentIndent)
            case None => ()
        }
        ret += getIndent(currentIndent) + "-block: "
        ret += block_.dump(currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class MacroDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, lParen: Token, params: ArrayList<FuncParam>, rParen: Token, colon: Token, ty: Option<TypeNode>,
        block: Block) {
        super(decl)
        lParen_ = lParen
        this.params_ = params
        rParen_ = rParen
        this.colon_ = colon
        this.retTy_ = ty
        this.block_ = block
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as MacroDecl) {
            case Some(v) =>
                this.lParen_ = v.lParen_
                this.rParen_ = v.rParen_
                this.params_ = v.params_
                this.colon_ = checkValid(v.colon_)
                this.retTy_ = v.retTy_
                this.block_ = v.block_
            case None => throw ASTException("Cannot construct the 'MacroDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
        super()
    }
    private var lParen_: Token = Token(TokenKind.LPAREN)
    private var rParen_: Token = Token(TokenKind.RPAREN)
    private var params_: ArrayList<FuncParam> = ArrayList<FuncParam>()
    private var colon_ = Token()
    private var retTy_: Option<TypeNode> = None<TypeNode>
    private var block_: Block = Block()

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
    public mut prop funcParams: ArrayList<FuncParam> {
        /*
         * @noThrow
         */
        get() {
            params_
        }
        /*
         * @noThrow
         */
        set(v) {
            params_ = v
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
    public mut prop declType: TypeNode {
        /*
         * @throws ASTException
         */
        get() {
            match (retTy_) {
                case Some(v) => v
                case None => throw ASTException("Current MacroDecl has empty return type")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            retTy_ = Some(v)
        }
    }
    public mut prop block: Block {
        /*
         * @noThrow
         */
        get() {
            block_
        }
        /*
         * @noThrow
         */
        set(v) {
            block_ = v
        }
    }

    /*
     * @throws ASTException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = Tokens().append(super.toTokens())
        ret.append(lParen_)
        ret.append(funcParams.toTokens())
        ret.append(rParen_)
        if (!isValidPosition(colon_)) {
            return ret.append(block.toTokens())
        }
        match (retTy_) {
            case Some(v) => ret.append(colon_).append(v)
            case None => ()
        }
        return ret.append(block.toTokens())
    }

    /*
     * @throws ASTException
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        for (param in params_) {
            param.traverse(v)
        }
        declType.traverse(v)
        for (constraint in genericConstraint) {
            constraint.traverse(v)
        }
        block_.traverse(v)
        return
    }

    /*
     * @throws ASTException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "MacroDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        for (i in 0..funcParams.size) {
            ret += getIndent(currentIndent) + "-funcParams: ${i}, "
            ret += funcParams[i].dump(currentIndent)
        }
        if (isValidPosition(colon_)) {
            match (retTy_) {
                case Some(v) =>
                    ret += getIndent(currentIndent) + "-declType: "
                    ret += v.dump(currentIndent)
                case None => ()
            }
        }
        ret += getIndent(currentIndent) + "-block: "
        ret += block_.dump(currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class PrimaryCtorDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, lParen: Token, params: ArrayList<FuncParam>, rParen: Token, block: Block) {
        super(decl)
        this.lParen_ = lParen
        this.params_ = params
        this.rParen_ = rParen
        this.block_ = block
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseDecl(inputs, astKind: "PrimaryCtorDecl") as PrimaryCtorDecl) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    this.annotations = v.annotations
                    this.modifiers = v.modifiers
                    this.identifier_ = v.identifier_
                    this.lParen_ = v.lParen_
                    this.rParen_ = v.rParen_
                    this.params_ = v.params_
                    this.block_ = v.block_
                case None => throw ASTException("Cannot construct the 'PrimaryCtorDecl' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'PrimaryCtorDecl' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {
        super()
    }
    private var lParen_: Token = Token(TokenKind.LPAREN)
    private var rParen_: Token = Token(TokenKind.RPAREN)
    private var params_: ArrayList<FuncParam> = ArrayList<FuncParam>()
    private var block_: Block = Block()

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
    public mut prop funcParams: ArrayList<FuncParam> {
        /*
         * @noThrow
         */
        get() {
            params_
        }
        /*
         * @noThrow
         */
        set(v) {
            params_ = v
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
    public mut prop block: Block {
        /*
         * @noThrow
         */
        get() {
            block_
        }
        /*
         * @noThrow
         */
        set(v) {
            block_ = v
        }
    }

    /*
     * @noThrow
     */
    public func isConst(): Bool {
        for (modifier in modifiers) {
            if (modifier.keyword.value == "const") {
                return true
            }
        }
        return false
    }

    /*
     * @throws ASTException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = Tokens().append(super.toTokens()).append(lParen_)
        ret.append(funcParams.toTokens())
        ret.append(rParen_).append(block.toTokens())
        return ret
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        for (param in params_) {
            param.traverse(v)
        }
        for (constraint in genericConstraint) {
            constraint.traverse(v)
        }
        block_.traverse(v)
        return
    }

    /*
     * @throws ASTException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "PrimaryCtorDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        for (i in 0..funcParams.size) {
            ret += getIndent(currentIndent) + "-funcParams: ${i}, "
            ret += funcParams[i].dump(currentIndent)
        }
        ret += getIndent(currentIndent) + "-block: "
        ret += block_.dump(currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class VarDecl <: Decl {


    /*
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    init(decl: Decl, colon: Token, declType: Option<TypeNode>, assign: Token, expr: Option<Expr>) {
        super(decl)
        this.declType_ = declType
        this.expr_ = expr
        this.colon_ = colon
        this.assign_ = assign
        if (this.keyword.kind == TokenKind.CONST) {
            modifiers.removeIf {mod => mod.keyword.kind == TokenKind.CONST}
        }
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    init(decl: Decl, pattern: Option<Pattern>, colon: Token, declType: Option<TypeNode>, assign: Token,
        expr: Option<Expr>) {
        super(decl)
        this.pattern_ = pattern
        this.declType_ = declType
        this.expr_ = expr
        this.colon_ = colon
        this.assign_ = assign
        if (this.keyword.kind == TokenKind.CONST) {
            modifiers.removeIf {mod => mod.keyword.kind == TokenKind.CONST}
        }
    }
    /*
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as VarDecl) {
            case Some(v) =>
                this.declType_ = v.declType_
                this.expr_ = v.expr_
                this.colon_ = checkValid(v.colon_)
                this.assign_ = v.assign_
                this.isEnumConstruct = v.isEnumConstruct
            case None => throw ASTException("Cannot construct the 'VarDecl' node.")
        }
        if (this.keyword.kind == TokenKind.CONST) {
            modifiers.removeIf {mod => mod.keyword.kind == TokenKind.CONST}
        }
    }
    /*
     * @noThrow
     */
    public init() {
        super()
    }
    private var pattern_: Option<Pattern> = None<Pattern>
    private var colon_ = Token()
    private var declType_: Option<TypeNode> = None<TypeNode>
    private var assign_: Token = Token()
    private var expr_: Option<Expr> = None<Expr>
    var isEnumConstruct: Bool = false

    public mut prop pattern: Pattern {
        /*
         * @throws ASTException
         */
        get() {
            match (pattern_) {
                case Some(v) => v
                case None => throw ASTException("Current VarDecl is with an empty pattern")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            pattern_ = v
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
    public mut prop declType: TypeNode {
        /*
         * @throws ASTException
         */
        get() {
            match (declType_) {
                case Some(v) => v
                case None => throw ASTException("Current VarDecl has an implicit type")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            declType_ = Some(v)
        }
    }
    public mut prop assign: Token {
        /*
         * @noThrow
         */
        get() {
            assign_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, ASSIGN)
            assign_ = v
        }
    }
    public mut prop expr: Expr {
        /*
         * @throws ASTException
         */
        get() {
            match (expr_) {
                case Some(v) => v
                case None => throw ASTException("Current VarDecl has not be initialized")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            expr_ = Some(v)
        }
    }

    /*
     * @noThrow
     */
    public func isConst(): Bool {
        if (keyword.kind == TokenKind.CONST) {
            return true
        }
        return false
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = super.toTokens()
        var endPos = Position(identifier.pos.fileID, identifier.pos.line,
            identifier.pos.column + Int32(identifier.value.size))
        match (pattern_) {
            case Some(v) => ret.append(v.toTokens())
            case None => ()
        }
        match (declType_) {
            case Some(v) =>
                ret.append(colon_).append(v.toTokens())
                endPos = v.endPos
            case None => ()
        }
        match (expr_) {
            case Some(v) =>
                ret.append(assign_).append(v.toTokens())
                endPos = v.endPos
            case None => ()
        }
        ret.append(Token(NL).addPosition(endPos))
        return ret
    }
    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        match (pattern_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        match (declType_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        match (expr_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        return
    }

    /*
     * @throws ASTException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "VarDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        match (pattern_) {
            case Some(node) =>
                ret += getIndent(currentIndent) + "-pattern: "
                ret += node.dump(currentIndent)
            case None => ()
        }
        match (declType_) {
            case Some(node) =>
                ret += getIndent(currentIndent) + "-declType: "
                ret += node.dump(currentIndent)
            case None => ()
        }
        ret += getTokenIndent("-assign", assign_, currentIndent)
        match (expr_) {
            case Some(node) =>
                ret += getIndent(currentIndent) + "-expr: "
                ret += node.dump(currentIndent)
            case None => ()
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public open class FuncParam <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, notMark: Token, colon: Token, paramType: TypeNode, assign: Token, expr: Option<Expr>, comma: Token,
        isMemberParam: Bool) {
        super(decl)
        not_ = notMark
        colon_ = colon
        paramType_ = paramType
        assign_ = assign
        expr_ = expr
        comma_ = comma
        isMemberParam_ = isMemberParam
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super()
        var params = ArrayList<FuncParam>()
        try {
            let tokens = Tokens()
            tokens
                .append(Token(IDENTIFIER))
                .append(Token(LPAREN))
                .append(inputs)
                .append(Token(RPAREN))
                .append(Token(LCURL))
                .append(Token(RCURL))
            params = PrimaryCtorDecl(tokens).funcParams
        } catch (e: ASTException) {
            throw ASTException("Cannot construct the 'FuncParam' node.")
        }
        if (params.size == 0) {
            throw ASTException("Cannot construct the 'FuncParam' node.")
        }
        let v = params[0]
        this.not_ = checkValid(v.not_)
        this.colon_ = v.colon_
        this.paramType_ = v.paramType_
        this.assign_ = checkValid(v.assign_)
        this.expr_ = v.expr_
        this.comma_ = v.comma_
        this.identifier_ = v.identifier_
        this.isMemberParam_ = v.isMemberParam_
        this.modifiers_ = v.modifiers
        this.keyword_ = v.keyword_
    }
    /*
     * @noThrow
     */
    public init() {
    }
    /*
     * @noThrow
     */
    init(key: Token, identifier: Token) {
        super(key, identifier)
    }
    private var not_ = Token()
    private var colon_ = Token()
    private var paramType_: TypeNode = TypeNode()
    private var assign_ = Token()
    private var expr_: Option<Expr> = None<Expr>
    private var comma_ = Token()
    private var isMemberParam_ = false
    public mut prop not: Token {
        /*
         * @noThrow
         */
        get() {
            not_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, NOT)
            not_ = v
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
    public mut prop paramType: TypeNode {
        /*
         * @noThrow
         */
        get() {
            paramType_
        }
        /*
         * @noThrow
         */
        set(v) {
            paramType_ = v
        }
    }
    public mut prop assign: Token {
        /*
         * @noThrow
         */
        get() {
            assign_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, ASSIGN)
            assign_ = v
        }
    }
    public mut prop expr: Expr {
        /*
         * @throws ASTException
         */
        get() {
            match (expr_) {
                case Some(v) => v
                case None => throw ASTException("The expression of FuncParam is None")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            expr_ = Some(v)
        }
    }
    /*
     * @noThrow
     */
    public func isMemberParam(): Bool {
        return isMemberParam_
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func toTokens(): Tokens {
        var ret = super.toTokens()
        if (isValidToken(not_)) {
            ret.append(not_)
        }
        if (paramType_.toTokens().size != 0) {
            if (isValidToken(colon_)) {
                ret.append(colon_)
            } else {
                ret.append(Token(TokenKind.COLON))
            }
            ret.append(paramType_.toTokens())
        }
        match (expr_) {
            case Some(v) => ret.append(assign_).append(v.toTokens())
            case None => ()
        }
        if (isValidToken(comma_)) {
            ret.append(comma_)
        }
        ret
    }

    /*
     * @noThrow
     */
    public open func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        paramType_.traverse(v)
        match (expr_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        return
    }

    /*
     * @throws ASTException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected open func dump(indent: UInt16): String {
        var ret: String = "FuncParam {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        if (isValidToken(not_)) {
            ret += getTokenIndent("-not", not_, currentIndent)
        }
        if (isValidToken(colon_)) {
            ret += getTokenIndent("-colon", colon_, currentIndent)
        }
        ret += getIndent(currentIndent) + "-paramType: "
        ret += paramType_.dump(currentIndent)
        if (isValidToken(assign_)) {
            ret += getTokenIndent("-assign", assign_, currentIndent)
        }
        match (expr_) {
            case Some(v) =>
                ret += getIndent(currentIndent) + "-expr: "
                ret += v.dump(currentIndent)
            case None => ()
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class PropDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, colon: Token, declType: TypeNode, lCurl: Token, getter: Option<FuncDecl>, setter: Option<FuncDecl>,
        rCurl: Token) {
        super(decl)
        this.colon_ = colon
        this.declType_ = declType
        this.lCurl_ = lCurl
        this.getter_ = getter
        this.setter_ = setter
        this.rCurl_ = rCurl
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as PropDecl) {
            case Some(v) =>
                this.colon_ = checkValid(v.colon_)
                this.declType_ = v.declType_
                this.lCurl_ = v.lCurl_
                this.getter_ = v.getter_
                this.setter_ = v.setter_
                this.rCurl_ = v.rCurl_
            case None => throw ASTException("Cannot construct the 'PropDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
        super()
    }
    private var colon_ = Token(TokenKind.COLON)
    private var declType_: TypeNode = TypeNode()
    private var lCurl_ = Token(TokenKind.LCURL)
    private var getter_: Option<FuncDecl> = None<FuncDecl>
    private var setter_: Option<FuncDecl> = None<FuncDecl>
    private var rCurl_ = Token(TokenKind.RCURL)
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
    public mut prop declType: TypeNode {
        /*
         * @noThrow
         */
        get() {
            declType_
        }
        /*
         * @noThrow
         */
        set(v) {
            declType_ = v
        }
    }
    public mut prop lBrace: Token {
        /*
         * @noThrow
         */
        get() {
            lCurl_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LCURL)
            lCurl_ = v
        }
    }
    public mut prop getter: FuncDecl {
        /*
         * @throws ASTException
         */
        get() {
            match (getter_) {
                case Some(v) => v
                case None => throw ASTException("The PropDecl have empty 'get()' function")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            getter_ = Some(v)
        }
    }
    public mut prop setter: FuncDecl {
        /*
         * @throws ASTException
         */
        get() {
            match (setter_) {
                case Some(v) => v
                case None => throw ASTException("The PropDecl have empty 'set()' function")
            }
        }
        /*
         * @noThrow
         */
        set(v) {
            setter_ = Some(v)
        }
    }
    public mut prop rBrace: Token {
        /*
         * @noThrow
         */
        get() {
            rCurl_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, RCURL)
            rCurl_ = v
        }
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = super.toTokens()
        ret.append(colon_).append(declType_.toTokens())
        if (!isValidPosition(lCurl_) || !isValidPosition(rCurl_)) {
            return ret
        }
        ret.append(lCurl_).append(Token(NL))
        match (getter_) {
            case Some(v) => ret.append(v.toTokens())
            case None => ()
        }
        match (setter_) {
            case Some(v) => ret.append(v.toTokens())
            case None => ()
        }
        ret.append(rCurl_).append(Token(NL))
        return ret
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        declType_.traverse(v)
        match (getter_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        match (setter_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        return
    }

    /*
     * @throws ASTException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "PropDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getIndent(currentIndent) + "-declType: "
        ret += declType_.dump(currentIndent)
        match (getter_) {
            case Some(v) =>
                ret += getIndent(currentIndent) + "-getter: "
                ret += v.dump(currentIndent)
            case None => ()
        }
        match (setter_) {
            case Some(v) =>
                ret += getIndent(currentIndent) + "-setter: "
                ret += v.dump(currentIndent)
            case None => ()
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class TypeAliasDecl <: Decl {
    /*
     * @noThrow
     */
    init(decl: Decl, assign: Token, aliasType: TypeNode) {
        super(decl)
        assign_ = assign
        aliasType_ = aliasType
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        super(inputs)
        match (super.node as TypeAliasDecl) {
            case Some(v) =>
                this.assign_ = v.assign_
                this.aliasType_ = v.aliasType_
            case None => throw ASTException("Cannot construct the 'TypeAliasDecl' node.")
        }
    }
    /*
     * @noThrow
     */
    public init() {
        super()
    }
    private var assign_: Token = Token()
    private var aliasType_: TypeNode = TypeNode()
    public mut prop assign: Token {
        /*
         * @noThrow
         */
        get() {
            assign_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, ASSIGN)
            assign_ = v
        }
    }
    public mut prop aliasType: TypeNode {
        /*
         * @noThrow
         */
        get() {
            aliasType_
        }
        /*
         * @noThrow
         */
        set(v) {
            aliasType_ = v
        }
    }

    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toTokens(): Tokens {
        var ret: Tokens = super.toTokens()
        ret.append(assign).append(aliasType_.toTokens()).append(Token(NL))
    }

    /*
     * @noThrow
     */
    public func traverse(v: Visitor): Unit {
        v.visit(this)
        if (v.needBreakTraverse()) {
            return
        }
        super.traverse(v)
        aliasType_.traverse(v)
        return
    }

    /*
     * @throws ASTException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "TypeAliasDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += super.dump(currentIndent)
        ret += getTokenIndent("-assign", assign_, currentIndent)
        ret += getIndent(currentIndent) + "-aliasType: "
        ret += aliasType_.dump(currentIndent)
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class MacroExpandDecl <: Decl {
    /*
     * @noThrow
     */
    init(at: Token, fullIdentifier: Token, identifier: Token, lSquare: Token, macroAttrs: Tokens, rSquare: Token,
        lParen: Token, macroInputs: Tokens, rParen: Token, macroInputDecl: Option<Decl>, hasParenthesis: Bool,
        isCompileTimeVisible: Bool) {
        super(at, identifier)
        pkgIdentifier_ = fullIdentifier
        lSquare_ = lSquare
        macroAttrs_ = macroAttrs
        rSquare_ = rSquare
        lParen_ = lParen
        macroInputs_ = macroInputs
        rParen_ = rParen
        macroInputDecl_ = macroInputDecl
        hasParenthesis_ = hasParenthesis
        isCompileTimeVisible_ = isCompileTimeVisible
    }
    /*
     * @throws ConcurrentModificationException
     * @throws Error
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ParseASTException
     * @throws ASTException
     */
    public init(inputs: Tokens) {
        try {
            match (parseDecl(inputs) as MacroExpandDecl) {
                case Some(v) =>
                    this.begin_ = v.beginPos
                    this.end_ = v.endPos
                    super.keyword = v.keyword
                    this.pkgIdentifier_ = v.pkgIdentifier_
                    super.identifier = v.identifier
                    this.lSquare_ = checkValid(v.lSquare_)
                    this.macroAttrs_ = v.macroAttrs_
                    this.rSquare_ = checkValid(v.rSquare_)
                    this.lParen_ = checkValid(v.lParen_)
                    this.macroInputs_ = v.macroInputs_
                    this.rParen_ = checkValid(v.rParen_)
                    this.macroInputDecl_ = v.macroInputDecl_
                    this.hasParenthesis_ = v.hasParenthesis_
                    this.isCompileTimeVisible_ = v.isCompileTimeVisible_
                    this.annotations = v.annotations
                case None => throw ASTException("Cannot construct the 'MacroExpandDecl' node.")
            }
        } catch (e: ParseASTException) {
            if (e.message == String.empty) {
                throw ASTException("Cannot construct the 'MacroExpandDecl' node.")
            } else {
                throw ASTException(e.message)
            }
        }
    }
    /*
     * @noThrow
     */
    public init() {}
    private var pkgIdentifier_: Token = Token()
    private var lSquare_: Token = Token()
    private var macroAttrs_: Tokens = Tokens()
    private var rSquare_: Token = Token()
    private var lParen_: Token = Token()
    private var macroInputs_: Tokens = Tokens()
    private var rParen_: Token = Token()
    private var macroInputDecl_: Option<Decl> = None<Decl>
    private var hasParenthesis_: Bool = false
    var isCompileTimeVisible_ = false
    public mut prop fullIdentifier: Token {
        /*
         * @noThrow
         */
        get() {
            pkgIdentifier_
        }
        /*
         * @noThrow
         */
        set(v) {
            pkgIdentifier_ = v
        }
    }

    public mut prop lSquare: Token {
        /*
         * @noThrow
         */
        get() {
            lSquare_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LSQUARE)
            lSquare_ = v
        }
    }
    public mut prop macroAttrs: Tokens {
        /*
         * @noThrow
         */
        get() {
            macroAttrs_
        }
        /*
         * @noThrow
         */
        set(v) {
            macroAttrs_ = v
        }
    }
    public mut prop rSquare: Token {
        /*
         * @noThrow
         */
        get() {
            rSquare_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, RSQUARE)
            rSquare_ = v
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
    public mut prop macroInputs: Tokens {
        /*
         * @noThrow
         */
        get() {
            macroInputs_
        }
        /*
         * @throws ConcurrentModificationException
         * @throws Error
         * @throws NoneValueException
         * @throws Exception
         * @throws IllegalMemoryException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ASTException
         * @throws ParseASTException
         */
        set(v) {
            macroInputs_ = v
            macroInputDecl_ = try {
                Some(parseDecl(v))
            } catch (e: ParseASTException | ASTException) {
                None
            }
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
    public mut prop macroInputDecl: Decl {
        /*
         * @throws ASTException
         */
        get() {
            match (macroInputDecl_) {
                case Some(v) => v
                case None => throw ASTException()
            }
        }
        /*
         * @throws NoneValueException
         * @throws ASTException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         */
        set(v) {
            macroInputDecl_ = Some(v)
            macroInputs_ = v.toTokens()
        }
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toTokens(): Tokens {
        var ret = Tokens()
        for (i in 0..annotations.size) {
            ret.append(annotations[i].toTokens())
        }
        ret.append(keyword)
        let identArray = pkgIdentifier_.value.split(".")
        let identPos = pkgIdentifier_.pos
        var identColumn = identPos.column
        for (i in 0..identArray.size - 1) {
            let identifier = identArray[i]
            ret = ret.append(Token(TokenKind.IDENTIFIER, identifier).addPosition(identPos))
            identColumn = identColumn + Int32(identifier.size)
            ret = ret.append(Token(TokenKind.DOT).addPosition(identPos.fileID, identPos.line, identColumn))
            identColumn++
        }
        if (identArray.size > 0) {
            let identifier = identArray[identArray.size - 1]
            ret = ret + Token(TokenKind.IDENTIFIER, identifier).addPosition(identPos.fileID, identPos.line, identColumn)
        }
        if (isValidToken(lSquare_)) {
            ret.append(lSquare_).append(macroAttrs_).append(rSquare_)
        }
        if (isValidToken(lParen_)) {
            ret.append(lParen_).append(macroInputs_).append(rParen_).append(Token(NL))
        } else {
            match (macroInputDecl_) {
                case Some(v) => ret.append(Token(NL)).append(v)
                case None => ()
            }
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
        for (anno in annotations) {
            anno.traverse(v)
        }
        match (macroInputDecl_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "MacroExpandDecl {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += getTokenIndent("-identifier", identifier, currentIndent)

        for (i in 0..annotations.size) {
            ret += getIndent(currentIndent) + "-annotations: ${i}, "
            ret += annotations[i].dump(currentIndent)
        }
        for (i in 0..macroAttrs_.size) {
            ret += getTokenIndent("-macroAttrs ${i}", macroAttrs[i], currentIndent)
        }
        for (i in 0..macroInputs_.size) {
            ret += getTokenIndent("-macroInputs ${i}", macroInputs[i], currentIndent)
        }
        match (macroInputDecl_) {
            case Some(node) =>
                ret += getIndent(currentIndent) + "-macroInputDecl: "
                ret += node.dump(currentIndent)
            case None => ()
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}

public class MacroExpandParam <: FuncParam {
    /*
     * @noThrow
     */
    init(at: Token, fullIdentifier: Token, identifier: Token, lSquare: Token, macroAttrs: Tokens, rSquare: Token,
        lParen: Token, macroInputs: Tokens, rParen: Token, macroInputDecl: Option<Decl>, hasParenthesis: Bool,
        isCompileTimeVisible: Bool) {
        super(at, identifier)
        pkgIdentifier_ = fullIdentifier
        lSquare_ = lSquare
        macroAttrs_ = macroAttrs
        rSquare_ = rSquare
        lParen_ = lParen
        macroInputs_ = macroInputs
        rParen_ = rParen
        macroInputDecl_ = macroInputDecl
        hasParenthesis_ = hasParenthesis
        isCompileTimeVisible_ = isCompileTimeVisible
    }

    /*
     * @noThrow
     */
    public init() {}
    private var pkgIdentifier_: Token = Token()
    private var lSquare_: Token = Token()
    private var macroAttrs_: Tokens = Tokens()
    private var rSquare_: Token = Token()
    private var lParen_: Token = Token()
    private var macroInputs_: Tokens = Tokens()
    private var rParen_: Token = Token()
    private var macroInputDecl_: Option<Decl> = None<Decl>
    private var hasParenthesis_: Bool = false
    var isCompileTimeVisible_ = false
    public mut prop fullIdentifier: Token {
        /*
         * @noThrow
         */
        get() {
            pkgIdentifier_
        }
        /*
         * @noThrow
         */
        set(v) {
            pkgIdentifier_ = v
        }
    }

    public mut prop lSquare: Token {
        /*
         * @noThrow
         */
        get() {
            lSquare_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, LSQUARE)
            lSquare_ = v
        }
    }
    public mut prop macroAttrs: Tokens {
        /*
         * @noThrow
         */
        get() {
            macroAttrs_
        }
        /*
         * @noThrow
         */
        set(v) {
            macroAttrs_ = v
        }
    }
    public mut prop rSquare: Token {
        /*
         * @noThrow
         */
        get() {
            rSquare_
        }
        /*
         * @throws ASTException
         */
        set(v) {
            checkTokenType(v, RSQUARE)
            rSquare_ = v
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
    public mut prop macroInputs: Tokens {
        /*
         * @noThrow
         */
        get() {
            macroInputs_
        }
        /*
         * @throws ConcurrentModificationException
         * @throws Error
         * @throws NoneValueException
         * @throws Exception
         * @throws IllegalMemoryException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ParseASTException
         * @throws ASTException
         */
        set(v) {
            macroInputs_ = v
            macroInputDecl_ = try {
                Some(FuncParam(v))
            } catch (e: ParseASTException | ASTException) {
                None
            }
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
    public mut prop macroInputDecl: Decl {
        /*
         * @throws ASTException
         */
        get() {
            match (macroInputDecl_) {
                case Some(v) => v
                case None => throw ASTException()
            }
        }
        /*
         * @throws NoneValueException
         * @throws ASTException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         */
        set(v) {
            macroInputDecl_ = Some(v)
            macroInputs_ = v.toTokens()
        }
    }
    /*
     * @throws NoneValueException
     * @throws ASTException
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toTokens(): Tokens {
        var ret = Tokens()
        for (i in 0..annotations.size) {
            ret.append(annotations[i].toTokens())
        }
        ret.append(keyword)
        let identArray = pkgIdentifier_.value.split(".")
        let identPos = pkgIdentifier_.pos
        var identColumn = identPos.column
        for (i in 0..identArray.size - 1) {
            let identifier = identArray[i]
            ret = ret.append(Token(TokenKind.IDENTIFIER, identifier).addPosition(identPos))
            identColumn = identColumn + Int32(identifier.size)
            ret = ret.append(Token(TokenKind.DOT).addPosition(identPos.fileID, identPos.line, identColumn))
            identColumn++
        }
        if (identArray.size > 0) {
            let identifier = identArray[identArray.size - 1]
            ret = ret + Token(TokenKind.IDENTIFIER, identifier).addPosition(identPos.fileID, identPos.line, identColumn)
        }
        if (isValidToken(lSquare_)) {
            ret.append(lSquare_).append(macroAttrs_).append(rSquare_)
        }
        if (isValidToken(lParen_)) {
            ret.append(lParen_).append(macroInputs_).append(rParen_).append(Token(NL))
        } else {
            match (macroInputDecl_) {
                case Some(v) => ret.append(Token(NL)).append(v)
                case None => ()
            }
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
        for (anno in annotations) {
            anno.traverse(v)
        }
        match (macroInputDecl_) {
            case Some(node) => node.traverse(v)
            case None => ()
        }
        return
    }

    /*
     * @throws ASTException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected func dump(indent: UInt16): String {
        var ret: String = "MacroExpandParam {\n"
        currentIndent = indent
        if (indent != 0 || beginNode) {
            currentIndent++
        }
        ret += getTokenIndent("-identifier", identifier, currentIndent)

        for (i in 0..annotations.size) {
            ret += getIndent(currentIndent) + "-annotations: ${i}, "
            ret += annotations[i].dump(currentIndent)
        }
        for (i in 0..macroAttrs_.size) {
            ret += getTokenIndent("-macroAttrs ${i}", macroAttrs[i], currentIndent)
        }
        for (i in 0..macroInputs_.size) {
            ret += getTokenIndent("-macroInputs ${i}", macroInputs[i], currentIndent)
        }
        match (macroInputDecl_) {
            case Some(node) =>
                ret += getIndent(currentIndent) + "-macroInputDecl: "
                ret += node.dump(currentIndent)
            case None => ()
        }
        ret += getIndent(indent) + "}\n"
        ret
    }
}
