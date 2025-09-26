






package std.unittest

public open class UnittestException <: Exception {
    init() {
        super()
    }

    init(message: String) {
        super(message)
    }

    protected open override func getClassName(): String {
        return "UnittestException"
    }
}

class ErrorWrapperException <: Exception {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    init(error: Error) {
        super(error.getStackTraceMessage())
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    init(message: String, error: Error) {
        super("${message}:\n${error.getStackTraceMessage()}")
    }

    protected override func getClassName(): String {
        return "ErrorWrapperException"
    }

    public override func toString(): String {
        if (this.message.isEmpty()) {
            return getClassName()
        }
        return this.message
    }
}

public class UnittestTimeoutException <: Exception {
    init() {
        super()
    }

    protected open override func getClassName(): String {
        return "UnittestTimeoutException"
    }
}

public class UnittestCliOptionsFormatException <: UnittestException {
    /**
     * @throws IllegalArgumentException
     */
    init(optionName: String, actual!: String, expected!: String) {
        super(
            "Wrong ${optionName} option argument format. " +
            "Provided: ${actual}. " +
            expected
        )
    }

    init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "UnittestCliOptionsFormatException"
    }
}
