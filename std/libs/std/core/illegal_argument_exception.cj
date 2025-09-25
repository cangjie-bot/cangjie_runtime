







package std.core

public open class IllegalArgumentException <: Exception {
    /*
     * @noThrow
     */
    public init() {
        super()
    }
    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }
    /*
     * @noThrow
     */
    protected open override func getClassName(): String {
        return "IllegalArgumentException"
    }
}
