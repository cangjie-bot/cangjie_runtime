







package std.core

@Intrinsic
func fillInStackTrace(pc: RawArray<UInt64>, message: RawArray<UInt8>): RawArray<UInt64>

@Intrinsic
func decodeStackTrace(pc: UInt64, funcStart: UInt64, funcDesc: UInt64): StackTraceData


struct StackTraceData {
    let className: RawArray<UInt8> = EMPTY_UINT8_RAW_ARRAY
    let methodName: RawArray<UInt8> = EMPTY_UINT8_RAW_ARRAY
    let fileName: RawArray<UInt8> = EMPTY_UINT8_RAW_ARRAY
    let lineNumber: Int64 = 0
}

func getStackTraceImpl(pcArray: RawArray<UInt64>): Array<StackTraceElement> {
    let frameSize = arraySize(pcArray) / 3
    let emptyElement = StackTraceElement("", "", "", 0)
    let stackTraceArray = Array<StackTraceElement>(frameSize, repeat: emptyElement)
    var eleSize: Int64 = 0
    for (i in 0..frameSize) {
        let data = decodeStackTrace(arrayGet(pcArray, i * 3), arrayGet(pcArray, i * 3 + 1), arrayGet(pcArray, i * 3 + 2))
        if (data.lineNumber == 0 && arraySize(data.fileName) == 0) {
            continue
        }
        if (data.lineNumber == -1) {
            continue
        }
        let stkEle = StackTraceElement(
            String(data.className),
            String(data.methodName),
            String(data.fileName),
            data.lineNumber
        )
        stackTraceArray[eleSize] = stkEle
        eleSize++
    }
    return stackTraceArray.clone(0..eleSize)
}

public open class Exception <: ToString {
    private var detailMessage: String = String.empty
    private var pcArray: RawArray<UInt64> = RawArray<UInt64>(1, repeat: 0)
    private var traceElementArray: Array<StackTraceElement> = []

    public init() {
        pcArray = fillInStackTrace(RawArray<UInt64>(1, repeat: 0), detailMessage.toArray().rawptr)
    }

    public init(message: String) {
        detailMessage = message
        pcArray = fillInStackTrace(RawArray<UInt64>(1, repeat: 0), detailMessage.toArray().rawptr)
    }

    protected open func getClassName(): String {
        return "Exception"
    }

    public open prop message: String {
        get() {
            return detailMessage
        }
    }

    public open func toString(): String {
        let className: String = getClassName()
        let message: String = this.message
        if (message.isEmpty()) {
            return className
        }
        return "${className}: ${message}"
    }

    public func printStackTrace(): Unit {
        eprintln("An exception has occurred:")
        eprintln(toString())
        traceElementArray = getStackTrace()
        for (element in traceElementArray) {
            if (element.declaringClass.isEmpty() && element.methodName.isEmpty()) {
                eprintln("\t at ${element.fileName}:${element.lineNumber}")
            } else {
                let packageDelimiter: String = if (element.declaringClass.isEmpty()) { "" } else { "." }
                eprintln(
                    "\t at ${element.declaringClass}${packageDelimiter}${element.methodName}(${element.fileName}:${element.lineNumber})")
            }
        }
    }

    public func getStackTrace(): Array<StackTraceElement> {
        getStackTraceImpl(pcArray)
    }
}
