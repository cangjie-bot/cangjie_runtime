







package std.core

public open class StackTraceElement {
    public let declaringClass: String
    public let methodName: String
    public let fileName: String
    public let lineNumber: Int64

    /*
     * @noThrow
     */
    public init(declaringClass: String, methodName: String, fileName: String, lineNumber: Int64) {
        this.declaringClass = declaringClass
        this.methodName = methodName
        this.fileName = fileName
        this.lineNumber = lineNumber
    }
}
