






protected package std.deriving.api

import std.ast.*

public interface GenericsInjector {



    func injectGenerics(
        iface: QualifiedName,
        constrainedType: TypeNode,
        target: DerivingTarget): TypeNode

    func constraintsFor(
        iface: QualifiedName,
        generic: GenericDecl,
        target: DerivingTarget
    ): Array<GenericConstraint> {
        let upperBound = injectGenerics(iface, generic.toType(), target)
        let constraint = GenericConstraint()
        constraint.typeArgument = generic.toType()
        constraint.upperBound = Token(TokenKind.UPPERBOUND, "<:")
        constraint.upperBounds.add(upperBound)
        return [constraint]
    }

    static func noGenerics(): GenericsInjector  { DefaultGenreicInjector() }
    static func singleRecursive(): GenericsInjector { RecursiveGenericInjector() }
}

public struct DerivingInterfaceInfo {
    public DerivingInterfaceInfo(
        public let name: QualifiedName,
        public let superTypes: Array<QualifiedName>,
        public let genericsInjector: GenericsInjector
    ) {}
}

struct DefaultGenreicInjector <: GenericsInjector {
    public func injectGenerics(
        input: QualifiedName,
        _: TypeNode,
        _: DerivingTarget): TypeNode {
            return input.toType()
    }
}

struct RecursiveGenericInjector <: GenericsInjector {
    public func injectGenerics(
        iface: QualifiedName,
        constrainedType: TypeNode,
        _: DerivingTarget): TypeNode {
            return iface.toType(constrainedType)
    }
}
