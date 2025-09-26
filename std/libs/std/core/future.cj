







package std.core

@Intrinsic
func futureInit<T>(future: Future<T>): Unit

@Intrinsic
func futureIsComplete<T>(future: Future<T>): Bool

@Intrinsic
func futureWait<T>(future: Future<T>, timeout: Int64): Unit

@Intrinsic
func futureNotifyAll<T>(future: Future<T>): Unit

@FastNative
foreign func CJ_CORE_PrintOomHint(): Unit

let INT64_MAX: Int64 = 0x7fff_ffff_ffff_ffffi64

private open class FutureResult {}

private class FutureResInit <: FutureResult {}

private class FutureOk<T> <: FutureResult {
    var value: T
    init(v: T) {
        value = v
    }
}

private class FutureErr <: FutureResult {
    static let cachedResult = FutureErr(globalOutOfMemoryError)
    var err: Error
    init(e: Error) {
        err = e
    }
}

private class FutureExcept <: FutureResult {
    var except: Exception
    init(e: Exception) {
        except = e
    }
}

public class Future<T> {
    private let _thread: Thread = Thread()
    private var result: FutureResult = FutureResInit()
    private var executeFn: () -> T

    private init(fn: () -> T) {
        this.executeFn = fn
        unsafe { futureInit(this) }
    }

    public prop thread: Thread {
        get() {
            _thread
        }
    }




    public func get(): T {
        let isComplete = unsafe { futureIsComplete(this) }
        if (!isComplete) {
            unsafe { futureWait(this, Int64.Max) }
        }
        match (result) {
            case v: FutureOk<T> => return v.value
            case e: FutureExcept => throw e.except
            case e: FutureErr => throw e.err
            case _ => return get()
        }
    }




    public func tryGet(): Option<T> {
        let isComplete = unsafe { futureIsComplete(this) }
        if (!isComplete) {
            return Option<T>.None
        }
        match (result) {
            case v: FutureOk<T> => return v.value
            case e: FutureExcept => throw e.except
            case e: FutureErr => throw e.err
            case _ => return get()
        }
    }







    /**
     * @throws ArithmeticException
     * @throws TimeoutException
     */
    public func get(timeout: Duration): T {
        if (timeout <= Duration.Zero) {
            return get()
        }
        let isComplete = unsafe { futureIsComplete(this) }
        if (!isComplete) {
            unsafe { futureWait(this, timeout.toNanoseconds()) }
            let isCompleteAfterWait = unsafe { futureIsComplete(this) }
            if (!isCompleteAfterWait) {
                throw TimeoutException()
            }
        }
        match (result) {
            case v: FutureOk<T> => return v.value
            case e: FutureExcept => throw e.except
            case e: FutureErr => throw e.err
            case _ => return get()
        }
    }



    public func cancel(): Unit {
        this._thread.setCancellationRequest()
    }








    /**
     * @throws Error
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    func execute(): Unit {
        this._thread.waitForCJThreadHandle()
        setThreadObject(this._thread)
        try {
            this.result = FutureOk<T>(executeFn())
        } catch (ex: Exception) {
            this.result = FutureExcept(ex)
            handleException(ex)
        } catch (er: OutOfMemoryError) {
            this.result = FutureErr.cachedResult
            unsafe { CJ_CORE_PrintOomHint() }
        } catch (er: Error) {
            this.result = FutureErr(er)
            er.printStackTrace()
        } finally {
            unsafe { futureNotifyAll(this) }
        }
        this._thread.clearRuntimeCJThreadHandle()
        return
    }
    /**
     * @throws Error
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    static func executeClosure(fn: () -> T): Unit {
        try {
            fn()
        } catch (ex: Exception) {
            handleException(ex)
        } catch (_: OutOfMemoryError) {
            eprintln("An exception has occurred:")
            eprintln("    Out of memory")
        } catch (er: Error) {
            er.printStackTrace()
        }
        return
    }
}




public interface ThreadContext {
    func end(): Unit
    func hasEnded(): Bool
}
