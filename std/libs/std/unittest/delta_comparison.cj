






package std.unittest





public interface NearEquatable<CT, D> {







    func isNear(obj: CT, delta!: D): Bool
}



public struct RelativeDelta<T> {
    public RelativeDelta(let absolute!: T, let relative!: T) {}
}
/**
 * @throws IllegalArgumentException
 */
public func isNearExpansion<CT, D>(l: CT, r: CT, delta!: D, cmpType!: String): Bool where CT <: NearEquatable<CT, D> & Comparable<CT> {
    match (cmpType) {
        case "LT" => !l.isNear(r, delta: delta) && l < r
        case "GT" => !l.isNear(r, delta: delta) && l > r
        case "LE" => l.isNear(r, delta: delta) || l <= r
        case "GE" => l.isNear(r, delta: delta) || l >= r
        case "NOT_EQ" => !l.isNear(r, delta: delta)
        case "EQ" => l.isNear(r, delta: delta)
        case notSupportedCmpType => throw IllegalArgumentException("Given '${notSupportedCmpType}' is not supported.")
    }
}
/**
 * @throws IllegalArgumentException
 */
public func isNearExpansion<CT, D>(l: CT, r: CT, delta!: D, cmpType!: String, overloadHack!: Bool = true): Bool where CT <: NearEquatable<CT, D> {
    match (cmpType) {
        case "NOT_EQ" => !l.isNear(r, delta: delta)
        case "EQ" => l.isNear(r, delta: delta)
        case _ => throw IllegalArgumentException("Trying to compare incomparable objects.")
    }
}
