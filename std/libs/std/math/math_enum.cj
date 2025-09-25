










package std.math

public enum RoundingMode <: Equatable<RoundingMode> & ToString {
    | Ceiling
    | Down
    | Floor
    | HalfEven
    | HalfUp
    | Up

    public operator func ==(that: RoundingMode): Bool {
        return match ((this, that)) {
            case (Ceiling, Ceiling) => true
            case (Down, Down) => true
            case (Floor, Floor) => true
            case (HalfEven, HalfEven) => true
            case (HalfUp, HalfUp) => true
            case (Up, Up) => true
            case _ => false
        }
    }

    public func toString(): String {
        return match (this) {
            case Ceiling => "Ceiling"
            case Down => "Down"
            case Floor => "Floor"
            case HalfEven => "HalfEven"
            case HalfUp => "HalfUp"
            case Up => "Up"
        }
    }
}
