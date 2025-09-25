






package std.unittest

public open class UnittestException <: Exception {
    /*
     * @noThrow
     */
    init() {
        super()
    }

    /*
     * @noThrow
     */
    init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected open override func getClassName(): String {
        return "UnittestException"
    }
}

class ErrorWrapperException <: Exception {
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    init(error: Error) {
        super(error.getStackTraceMessage())
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    init(message: String, error: Error) {
        super("${message}:\n${error.getStackTraceMessage()}")
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "ErrorWrapperException"
    }

    /*
     * @noThrow
     */
    public override func toString(): String {
        if (this.message.isEmpty()) {
            return getClassName()
        }
        return this.message
    }
}

public class UnittestTimeoutException <: Exception {
    /*
     * @noThrow
     */
    init() {
        super()
    }

    /*
     * @noThrow
     */
    protected open override func getClassName(): String {
        return "UnittestTimeoutException"
    }
}

public class UnittestCliOptionsFormatException <: UnittestException {
    /*
     * @throws IllegalArgumentException
     */
    init(optionName: String, actual!: String, expected!: String) {
        super(
            "Wrong ${optionName} option argument format. " +
            "Provided: ${actual}. " +
            expected
        )
    }

    /*
     * @noThrow
     */
    init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "UnittestCliOptionsFormatException"
    }
}
