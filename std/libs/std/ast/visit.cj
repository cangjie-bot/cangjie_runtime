







package std.ast

public abstract class Visitor {
    private var breakTraverseFlag = false
    /*
     * @noThrow
     */
    protected func needBreakTraverse(): Bool {
        if (breakTraverseFlag) {
            breakTraverseFlag = false
            return true
        }
        return false
    }

    /*
     * @noThrow
     */
    public func breakTraverse(): Unit {
        breakTraverseFlag = true
    }

    /*
     * @noThrow
     */
    protected open func visit(_: Node): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Expr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: IsExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: AsExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: LitConstExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: UnaryExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: BinaryExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ParenExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: CallExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: RefExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ReturnExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: AssignExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: MemberAccess): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: IfExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: LetPatternExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: MatchExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: WhileExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: LambdaExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: SpawnExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: SynchronizedExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TrailingClosureExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TypeConvExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ForInExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: PrimitiveTypeExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ArrayLiteral): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TupleLiteral): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: SubscriptExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: RangeExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Block): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: DoWhileExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: JumpExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: IncOrDecExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TryExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ThrowExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: OptionalExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: QuoteExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: MacroExpandExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: WildcardExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: VArrayExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Decl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ClassDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: FuncDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: MainDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: MacroDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: StructDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: InterfaceDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: PropDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: VarDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: PrimaryCtorDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: EnumDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: FuncParam): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TypeAliasDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ExtendDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: MacroExpandDecl): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TypeNode): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: RefType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: PrimitiveType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: FuncType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ThisType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ParenType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: QualifiedType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: PrefixType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TupleType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: VArrayType): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Pattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ConstPattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: WildcardPattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: VarPattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: VarOrEnumPattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ExceptTypePattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TypePattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: EnumPattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: TuplePattern): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: GenericParam): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: GenericConstraint): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: MatchCase): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Program): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: PackageHeader): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ImportList): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: ImportContent): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Constructor): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Argument): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Annotation): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Modifier): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: Body): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: PerformExpr): Unit {}
    
    /*
     * @noThrow
     */
    protected open func visit(_: ResumeExpr): Unit {}

    /*
     * @noThrow
     */
    protected open func visit(_: CommandTypePattern): Unit {}
}
