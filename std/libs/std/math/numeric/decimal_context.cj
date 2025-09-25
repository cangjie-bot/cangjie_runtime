







package std.math.numeric





public enum OverflowStrategy <: Equatable<OverflowStrategy> & ToString {
    | Saturating
    | Throwing
    | Wrapping

    public operator func ==(that: OverflowStrategy): Bool {
        return match ((this, that)) {
            case (Saturating, Saturating) => true
            case (Throwing, Throwing) => true
            case (Wrapping, Wrapping) => true
            case _ => false
        }
    }

    public func toString(): String {
        return match (this) {
            case Saturating => "Saturating"
            case Throwing => "Throwing"
            case Wrapping => "Wrapping"
        }
    }
}
