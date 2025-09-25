







package std.core


var globalOutOfMemoryError = OutOfMemoryError()

@C
/*
 * @throws IllegalArgumentException
 * @throws NoneValueException
 * @throws IncompatiblePackageException
 * @throws StackOverflowError
 * @throws OutOfMemoryError
 */
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


/*
 * @throws ArithmeticException
 */
func throwArithmeticException(): Unit {
    throw ArithmeticException("Divided by zero!")
}

/*
 * @noThrow
 */
func createArithmeticExceptionMsg(msg: String): ArithmeticException {
    ArithmeticException(msg)
}

/*
 * @throws ArithmeticException
 */
func throwArithmeticExceptionMsg(msg: String) {
    throw ArithmeticException(msg)
}

/*
 * @noThrow
 */
func createOverflowExceptionMsg(msg: String): OverflowException {
    OverflowException(msg)
}


/*
 * @throws OverflowException
 */
func throwOverflowException(): Unit {
    throw OverflowException()
}

/*
 * @throws IndexOutOfBoundsException
 */
func throwIndexOutOfBoundsException(): Unit {
    throw IndexOutOfBoundsException()
}

/*
 * @throws NegativeArraySizeException
 */
func throwNegativeArraySizeException(): Unit {
    throw NegativeArraySizeException()
}

/*
 * @noThrow
 */
func callToString(e: ToString): String {
    e.toString()
}

/*
 * @noThrow
 */
func checkIsError(e: Object): Bool {
    e is Error
}

/*
 * @throws Error
 */
func throwError(msg: String): Unit {
    throw Error(msg)
}

/*
 * @throws OutOfMemoryError
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func callPrintStackTrace(e: Exception): Unit {
    e.printStackTrace()
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws OutOfMemoryError
 */
func callPrintStackTraceError(e: Error): Unit {
    e.printStackTrace()
}
