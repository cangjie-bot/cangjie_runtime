







package std.core

@When[backend == "cjnative"]
@Intrinsic
func isThreadObjectInited(): Bool

@When[backend == "cjnative"]
@Intrinsic
func getThreadObject(): Thread

@FastNative
foreign func CJ_MRT_SetCJThreadName(handle: CPointer<Unit>, name: CPointer<UInt8>, len: Int64): Unit

@FastNative
foreign func CJ_MRT_GetCJThreadId(handle: CPointer<Unit>): Int64

@FastNative
foreign func CJ_MRT_GetCurrentCJThread(): CPointer<Unit>

const INVALID_ID: Int64 = -1

public class Thread {
    static let exceptionHandler = AtomicBox<Option<(Thread, Exception) -> Unit>>(None)

    private let _name = AtomicBox<String>("")
    private let _hasCancellation = AtomicBool(false)
    private let _id = AtomicInt64(INVALID_ID)
    var _threadLocalMap: Option<ThreadLocalMap> = None
    private var _rtCJThreadHandle = CPointer<Unit>()
    private let _rtCJThreadHandleRefCount = AtomicInt64(0)
    init() {}



    protected func setRuntimeCJThreadHandle(handle: CPointer<Unit>): Unit {
        _rtCJThreadHandle = handle
        let cjThreadId = unsafe { CJ_MRT_GetCJThreadId(handle) }
        _id.store(cjThreadId)
    }












    func waitForCJThreadHandle(): Unit {
        while (_id.load() == INVALID_ID) {
            intrinsicSleep(0)
        }
    }



    func clearRuntimeCJThreadHandle(): Unit {
        while (true) {
            let old = _rtCJThreadHandleRefCount.load()
            if (old == 0 && _rtCJThreadHandleRefCount.compareAndSwap(0, -1)) {
                _rtCJThreadHandle = CPointer<Unit>()
                return
            }
        }
    }



    /**
     * @throws Error
     */
    private func acquireCJThreadHandle(): CPointer<Unit> {
        while (true) {
            let old = _rtCJThreadHandleRefCount.load()
            if (old == -1) {
                return CPointer<Unit>()
            } else if (_rtCJThreadHandleRefCount.compareAndSwap(old, old + 1)) {
                if (_rtCJThreadHandle.isNull()) {
                    throw Error("Invalid CJThread handle")
                }
                return _rtCJThreadHandle
            }
        }
        throw Error("Never reached")
    }

    private func releaseCJThreadHandle(): Unit {
        _rtCJThreadHandleRefCount.fetchAdd(-1)
    }
        /**
         * @throws Error
         */
    public static prop currentThread: Thread {
        get() {
            if (isThreadObjectInited()) {
                return getThreadObject()
            } else {
                let thread = Thread()
                let rtCJThreadHandle = unsafe { CJ_MRT_GetCurrentCJThread() }
                if (rtCJThreadHandle.isNull()) {
                    throw Error("Invalid CJThread handle")
                }
                thread.setRuntimeCJThreadHandle(rtCJThreadHandle)
                setThreadObject(thread)
                thread
            }
        }
    }

        /**
         * @throws Error
         */
    public prop id: Int64 {
        get() {
            var cjThreadId = _id.load()
            if (cjThreadId == INVALID_ID) {
                throw Error("Invalid thread id")
            }
            return cjThreadId
        }
    }

    /**
     * @throws [set] Error
     */
    public mut prop name: String {
        get() {
            _name.load()
        }
        set(newName) {
            _name.store(newName)
            let handle = unsafe { acquireArrayRawData(name.rawData()) }
            let rtCJThreadHandle = acquireCJThreadHandle()
            if (!rtCJThreadHandle.isNull()) {
                unsafe {
                    CJ_MRT_SetCJThreadName(rtCJThreadHandle, handle.pointer, name.size)
                }
                releaseCJThreadHandle()
            }
            unsafe { releaseArrayRawData(handle) }
        }
    }



    public prop hasPendingCancellation: Bool {
        get() {
            _hasCancellation.load()
        }
    }

    func setCancellationRequest(): Unit {
        this._hasCancellation.store(true)
    }

    public static func handleUncaughtExceptionBy(exHandler: (Thread, Exception) -> Unit): Unit {
        Thread.exceptionHandler.store(exHandler)
    }
}
