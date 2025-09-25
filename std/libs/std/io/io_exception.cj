







package std.io


public open class IOException <: Exception {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override open func getClassName(): String {
        return "IOException"
    }
}
