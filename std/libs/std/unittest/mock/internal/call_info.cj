






protected package std.unittest.mock.internal

public struct Call {
    public let typeArgs: Array<String>
    public let receiver: Option<(Object, Array<String>)>

    /*
     * @throws IndexOutOfBoundsException
     */
    public Call(
        _receiver: Option<Object>,
        _typeArgs: Array<ToString>,
        public let args: Array<Any>,
        public let funcInfo: FuncInfo
    ) {
        let callTypeArgsSize = funcInfo.typeParams.size
        let outerDeclTypeArgsSize = _typeArgs.size - callTypeArgsSize

        typeArgs = Array(callTypeArgsSize) { i => _typeArgs[i + outerDeclTypeArgsSize].toString() }
        receiver = match(_receiver) {
            case Some(r) => (r, Array(outerDeclTypeArgsSize) { i => _typeArgs[i].toString() })
            case _ => Option<(Object, Array<String>)>.None
        }
    }
}

public struct FuncInfo {
    /*
     * @noThrow
     */
    public FuncInfo(
        public let id: DeclId,
        public let params: Array<ParameterInfo>,
        public let typeParams: Array<String>,
        public let location: (String, Int64, Int64),
        public let hasImplementation: Bool,
        public let outerDeclId: Option<DeclId>,
        public let hasDefaultValue: Bool,
        public let returnTypeName: String,
        public let isAccessible: Bool,
        public let kind: DeclKind
    ) {}
}

public enum DeclKind {
      /*
       * @noThrow
       */
    | Method(  String)
      /*
       * @noThrow
       */
    | FieldGetter(  String,  Bool)
      /*
       * @noThrow
       */
    | FieldSetter(  String)
      /*
       * @noThrow
       */
    | PropertyGetter(  String,  Bool)
      /*
       * @noThrow
       */
    | PropertySetter(  String)
      /*
       * @noThrow
       */
    | TopLevelFunction(  String)
      /*
       * @noThrow
       */
    | StaticMethod(  String)
      /*
       * @noThrow
       */
    | StaticPropertyGetter(  String)
      /*
       * @noThrow
       */
    | StaticPropertySetter(  String)
      /*
       * @noThrow
       */
    | StaticFieldGetter(  String)
      /*
       * @noThrow
       */
    | StaticFieldSetter(  String)
      /*
       * @noThrow
       */
    | TopLevelVariableGetter(  String)
      /*
       * @noThrow
       */
    | TopLevelVariableSetter(  String)
}

public struct ParameterInfo {
    /*
     * @noThrow
     */
    public ParameterInfo(
        public let name: String,
        public let position: Int64,
        public let isNamed: Bool,
        public let hasDefaultValue: Bool
    ) {}
}

public struct DeclId <: Equatable<DeclId> & Hashable {
    /*
     * @noThrow
     */
    public DeclId(
        public let mangledName: String,
        public let shortName: String
    ) {}

    /*
     * @noThrow
     */
    public operator func ==(that: DeclId): Bool {
        this.mangledName == that.mangledName
    }

    /*
     * @noThrow
     */
    public operator func !=(that: DeclId): Bool {
        this.mangledName != that.mangledName
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        mangledName.hashCode()
    }
}
