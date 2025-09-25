







package std.core

public class IncompatiblePackageException <: Exception {
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
        return "IncompatiblePackageException"
    }
}
