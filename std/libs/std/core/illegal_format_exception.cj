







package std.core

public open class IllegalFormatException <: IllegalArgumentException {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "IllegalFormatException"
    }
}
