







package std.core

public open class IllegalArgumentException <: Exception {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected open override func getClassName(): String {
        return "IllegalArgumentException"
    }
}
