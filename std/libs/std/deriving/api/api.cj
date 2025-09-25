






protected package std.deriving.api

import std.ast.*
import std.collection.*


public struct DerivingSettings {
    public DerivingSettings(
        public let interfaces: Array<DerivingInterfaceSettings>,
        public let excludedFields: Array<TargetNamedAttribute>,
        public let casesOrder: Array<TargetEnumCase>,
        public let fieldsOrder: Array<Identifier>,
        public let includedProperties: Array<PropDecl>
    ) {}

    public prop interfaceNames: Array<QualifiedName> {
        get() { interfaces |> map { it: DerivingInterfaceSettings => it.name } |> collectArray }
    }
}

public struct TargetEnumCase {
    public TargetEnumCase(
        public let name: String,
        public let constructor: Constructor,
        public let fields: Array<TargetEnumField>
    ) {}
}

public struct TargetEnumField {
    public TargetEnumField(
        public let position: Int64,
        public let fieldType: TypeNode
    ) {}
}

public enum TargetNamedAttribute {
    | FieldAttribute(VarDecl)
    | ConstructorFieldAttribute(FuncParam)
    | PropertyAttribute(PropDecl)
}





public struct DerivingTarget {
    public DerivingTarget(
        public let declaration: Decl,
        public let namedFields: Array<TargetNamedAttribute>,
        public let enumCases: Array<TargetEnumCase>,
        public let settings: DerivingSettings
    ) {}

    public prop interfaces: Array<DerivingInterfaceSettings> {
        get() { settings.interfaces }
    }

    public prop interfaceNames: Array<QualifiedName> {
        get() { settings.interfaceNames }
    }

    public func findIntefaceSettings(name: QualifiedName): ?DerivingInterfaceSettings {
        interfaces.iterator()
            .filter { it => it.name == name }
            .first()
    }
}

public struct DerivingInterfaceSettings {
    public DerivingInterfaceSettings(
        public let name: QualifiedName,
        public let generics: Array<DerivingGenericSettings>
    ) {}
}
