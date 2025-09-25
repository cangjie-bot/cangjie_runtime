







package std.core

@Intrinsic
/*
 * @noThrow
 */
func setThreadObject(thread: Thread): Unit

/*
 * @throws Error
 * @throws OutOfMemoryError
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func handleException(ex: Exception): Unit {
    let exceptionHandler = Thread.exceptionHandler.load()
    try {
        match (exceptionHandler) {
            case Some(handler) => try {
                handler(Thread.currentThread, ex)
            } catch (e: Exception) {
                eprintln("Thread id: ${Thread.currentThread.id} throws an exception in the exception handler")
            }
            case None => ex.printStackTrace()
        }
    } catch (e: Exception) {
        eprintln("While handling the uncaught exception, another exception occurs.")
    } catch (e: Error) {
        eprintln("While handling the uncaught exception, another error occurs.")
    }
}



/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws OutOfMemoryError
 */
func handleError(er: Error): Unit {
    try {
        match (er) {
            case _: OutOfMemoryError =>
                eprintln("An exception has occurred:")
                eprintln("OutOfMemoryError")
            case _ => er.printStackTrace()
        }
    } catch (e: Exception) {
        eprintln("While handling the uncaught error, another exception occurs.")
    } catch (e: Error) {
        eprintln("While handling the uncaught error, another error occurs.")
    }
}
