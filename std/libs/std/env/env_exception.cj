







package std.env



public class EnvException <: Exception {
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
        return "EnvException"
    }
}
