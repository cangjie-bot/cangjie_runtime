







package std.core

let MAX_INT_NATIVE: IntNative = IntNative(Int64.Max)
let MIN_INT_NATIVE: IntNative = IntNative(Int64.Min)
let MAX_UINT_NATIVE: UIntNative = UIntNative(UInt64.Max)

public class OverflowException <: ArithmeticException {
    /*
     * @noThrow
     */
    public init() {
        super()
    }
    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }
    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "OverflowException"
    }
}
