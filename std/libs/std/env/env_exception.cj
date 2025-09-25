







package std.env



public class EnvException <: Exception {
    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "EnvException"
    }
}
