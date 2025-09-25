







package std.reflect

import std.collection.*


public enum ModifierInfo <: Equatable<ModifierInfo> & Hashable & ToString {
    | Open
    | Override
    | Redef
    | Abstract
    | Sealed
    | Mut
    | Static

    static func byMask(mask: UInt32): Collection<ModifierInfo> {
        let result = ArrayList<ModifierInfo>()

        appendModifier(Open, mask, result)
        appendModifier(Override, mask, result)
        appendModifier(Redef, mask, result)
        appendModifier(Abstract, mask, result)
        appendModifier(Sealed, mask, result)
        appendModifier(Mut, mask, result)
        appendModifier(Static, mask, result)

        result.toArray()
    }

    static func isAbstract(mask: UInt32): Bool {
        (mask & 0x1 << 9) != 0
    }

    @When[backend == "cjnative"]
    static func isPublic(mask: UInt32): Bool {
        ((mask & 0x1 << 3) != 0) || ((mask & 0x1 << 10) != 0)
    }

    private static func appendModifier(modifier: ModifierInfo, mask: UInt32, modifiers: ArrayList<ModifierInfo>) {
        if ((mask & getMask(modifier)) != 0) {
            modifiers.add(modifier)
        }
    }

    static func isMutable(mask: UInt32): Bool {
        let finalMask: UInt32 = 0x1 << 4
        (mask & finalMask) == 0
    }

    public override operator func == (that: ModifierInfo): Bool {
        match ((this, that)) {
            case (Open, Open) => true
            case (Override, Override) => true
            case (Redef, Redef) => true
            case (Abstract, Abstract) => true
            case (Sealed, Sealed) => true
            case (Mut, Mut) => true
            case (Static, Static) => true
            case _ => false
        }
    }

    public override operator func != (that: ModifierInfo): Bool {
        return !(this == that)
    }

    public func hashCode(): Int64 {
        return match (this) {
            case Open => "open".hashCode()
            case Override => "override".hashCode()
            case Redef => "redef".hashCode()
            case Abstract => "abstract".hashCode()
            case Sealed => "sealed".hashCode()
            case Mut => "mut".hashCode()
            case Static => "static".hashCode()
        }
    }

    public override func toString(): String {
        return match (this) {
            case Open => "open"
            case Override => "override"
            case Redef => "redef"
            case Abstract => "abstract"
            case Sealed => "sealed"
            case Mut => "mut"
            case Static => "static"
        }
    }
}

func containsModifier(source: Collection<ModifierInfo>, modifier: ModifierInfo): Bool {
    for (item in source) {
        if (item == modifier) {
            return true
        }
    }
    return false
}
















@When[backend == "cjnative"]
func getMask(modifier: ModifierInfo): UInt32 {
    match (modifier) {
        case Open => 0x1 << 6
        case Override => 0x1 << 7
        case Redef => 0x1 << 8
        case Abstract => 0x1 << 9
        case Sealed => 0x1 << 10
        case Mut => 0x1 << 11
        case Static => 0x1 << 12
    }
}
