







package std.core

public class IndexOutOfBoundsException <: Exception {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "IndexOutOfBoundsException"
    }
}
