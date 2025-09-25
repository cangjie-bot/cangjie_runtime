







package std.collection

public class ConcurrentModificationException <: Exception {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "ConcurrentModificationException"
    }
}
