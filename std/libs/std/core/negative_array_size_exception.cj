







package std.core

public class NegativeArraySizeException <: Exception {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "NegativeArraySizeException"
    }
}
