






protected package std.unittest.mock.internal

public struct Call {
    public let typeArgs: Array<String>
    public let receiver: Option<(Object, Array<String>)>

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
    | Method(  String)
    | FieldGetter(  String,  Bool)
    | FieldSetter(  String)
    | PropertyGetter(  String,  Bool)
    | PropertySetter(  String)
    | TopLevelFunction(  String)
    | StaticMethod(  String)
    | StaticPropertyGetter(  String)
    | StaticPropertySetter(  String)
    | StaticFieldGetter(  String)
    | StaticFieldSetter(  String)
    | TopLevelVariableGetter(  String)
    | TopLevelVariableSetter(  String)
}

public struct ParameterInfo {
    public ParameterInfo(
        public let name: String,
        public let position: Int64,
        public let isNamed: Bool,
        public let hasDefaultValue: Bool
    ) {}
}

public struct DeclId <: Equatable<DeclId> & Hashable {
    public DeclId(
        public let mangledName: String,
        public let shortName: String
    ) {}

    public operator func ==(that: DeclId): Bool {
        this.mangledName == that.mangledName
    }

    public operator func !=(that: DeclId): Bool {
        this.mangledName != that.mangledName
    }

    public func hashCode(): Int64 {
        mangledName.hashCode()
    }
}
