







package std.core

public open class Error <: ToString {
    private var detailMessage: String = String.empty
    var pcArray: RawArray<UInt64> = RawArray<UInt64>(1, repeat: 0)
    var traceElementArray: Array<StackTraceElement> = []

    /*
     * @noThrow
     */
    init() {
        pcArray = fillInStackTrace(RawArray<UInt64>(1, repeat: 0), detailMessage.toArray().rawptr)
    }

    /*
     * @noThrow
     */
    init(message: String) {
        detailMessage = message
        pcArray = fillInStackTrace(RawArray<UInt64>(1, repeat: 0), detailMessage.toArray().rawptr)
    }

    /*
     * @noThrow
     */
    protected open func getClassName(): String {
        return "Error"
    }

    public open prop message: String {
        /*
         * @noThrow
         */
        get() {
            return detailMessage
        }
    }

    /*
     * @noThrow
     */
    public open func toString(): String {
        let className: String = getClassName()
        let message: String = this.message
        if (message.isEmpty()) {
            return className
        }
        return "${className}: ${message}"
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    public open func printStackTrace(): Unit {
        eprintln("An exception has occurred: ${getStackTraceMessage()}")
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func getStackTraceMessage(): String {
        let message = StringBuilder()
        message.append(toString() + "\n")

        traceElementArray = getStackTrace()
        for (element in traceElementArray) {
            var packageDelimiter: String = if (element.declaringClass.isEmpty()) { "" } else { "." }
            message.append(
                "\t at ${element.declaringClass}${packageDelimiter}${element.methodName}(${element.fileName}:${element.lineNumber})\n")
        }

        return message.toString()
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func getStackTrace(): Array<StackTraceElement> {
        getStackTraceImpl(pcArray)
    }
}
