







package std.core

public class NoneValueException <: Exception {
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
        return "NoneValueException"
    }
}
