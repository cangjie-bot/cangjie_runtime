







package std.core


var globalOutOfMemoryError = OutOfMemoryError()

@C
func throwImplicitException(id: Int64, args: CPointer<Unit>): Unit {
    match (id) {
        case 0 => throw OutOfMemoryError()
        case 1 => throw StackOverflowError()
        case 2 => throw globalOutOfMemoryError
        case 3 =>
            var msg = (args as CPointer<UInt8>).getOrThrow()
            throw IncompatiblePackageException(createStrFromCPointer(msg))
        case _ => ()
    }
}


func throwArithmeticException(): Unit {
    throw ArithmeticException("Divided by zero!")
}

func createArithmeticExceptionMsg(msg: String): ArithmeticException {
    ArithmeticException(msg)
}

func throwArithmeticExceptionMsg(msg: String) {
    throw ArithmeticException(msg)
}

func createOverflowExceptionMsg(msg: String): OverflowException {
    OverflowException(msg)
}


func throwOverflowException(): Unit {
    throw OverflowException()
}

func throwIndexOutOfBoundsException(): Unit {
    throw IndexOutOfBoundsException()
}

func throwNegativeArraySizeException(): Unit {
    throw NegativeArraySizeException()
}

func callToString(e: ToString): String {
    e.toString()
}

func checkIsError(e: Object): Bool {
    e is Error
}

func throwError(msg: String): Unit {
    throw Error(msg)
}

func callPrintStackTrace(e: Exception): Unit {
    e.printStackTrace()
}

func callPrintStackTraceError(e: Error): Unit {
    e.printStackTrace()
}
