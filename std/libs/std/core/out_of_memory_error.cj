







package std.core

public class OutOfMemoryError <: Error {
    /*
     * @noThrow
     */
    init() {
        super()
    }
    /*
     * @noThrow
     */
    init(message: String) {
        super(message)
    }
    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "OutOfMemoryError"
    }
}
