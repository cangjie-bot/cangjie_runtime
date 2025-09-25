







package std.core

public interface Any {}

public open class Object <: Any {
    /*
     * @noThrow
     */
    public const init() {}
}






/*
 * @noThrow
 */
public func refEq(a: Object, b: Object): Bool {
    return intrinsicRefEq(a, b)
}
@Intrinsic
/*
 * @noThrow
 */
public unsafe func zeroValue<T>(): T

@Intrinsic
/*
 * @noThrow
 */
func intrinsicRefEq(a: Object, b: Object): Bool

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func intrinsicRefEqRawArray<T>(a: RawArray<T>, b: RawArray<T>): Bool
