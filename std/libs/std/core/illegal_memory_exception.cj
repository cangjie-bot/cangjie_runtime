







package std.core

public class IllegalMemoryException <: Exception {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "IllegalMemoryException"
    }
}
