







package std.core

public class OutOfMemoryError <: Error {
    init() {
        super()
    }
    init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "OutOfMemoryError"
    }
}
