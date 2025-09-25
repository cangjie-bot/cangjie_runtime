







package std.core

public interface Any {}

public open class Object <: Any {
    public const init() {}
}






public func refEq(a: Object, b: Object): Bool {
    return intrinsicRefEq(a, b)
}
@Intrinsic
public unsafe func zeroValue<T>(): T

@Intrinsic
func intrinsicRefEq(a: Object, b: Object): Bool

@When[backend == "cjnative"]
@Intrinsic
func intrinsicRefEqRawArray<T>(a: RawArray<T>, b: RawArray<T>): Bool
