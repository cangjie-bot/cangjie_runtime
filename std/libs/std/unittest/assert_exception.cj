








package std.unittest



public class AssertException <: Exception {
    let cause: ?CheckResult

    /*
     * @noThrow
     */
    public init() {
        super()
        this.cause = None
    }

    /*
     * @noThrow
     */
    init(message: String, cause: CheckResult) {
        super(message)
        this.cause = cause
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
        this.cause = None
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "AssertException"
    }
}



public class AssertIntermediateException <: Exception {
    let diagram: PowerAssertDiagram

    public let expression: String
    public let originalException: Exception

    /*
     * @noThrow
     */
    init(exception: Exception, expression: String, message: String, diagram: PowerAssertDiagram) {
        super(message)
        this.originalException = exception
        this.expression = expression
        this.diagram = diagram
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func getOriginalStackTrace(): String {
        let traceElementArray = originalException.getStackTrace()
        var result = "Thrown exception while computing assert expression:\n" + originalException.toString() + "\n"
        for (element in traceElementArray) {
            var packageName = element.declaringClass
            var packageDelimiter = if (packageName.isEmpty()) { "" } else { "." }
            var methodName = element.methodName
            var fileName = element.fileName
            var lineNumber = element.lineNumber.toString()
            result += "\t at ${packageName}${packageDelimiter}${methodName}(${fileName}:${lineNumber})\n"
        }
        return result
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "AssertIntermediateException"
    }
}
