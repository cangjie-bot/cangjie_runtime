







package std.sync

@Deprecated
public enum ReadWriteMutexMode {
    | Unfair
    | Fair
}

@Deprecated[message: "Use `public class ReadWriteLock` instead."]
public class ReentrantReadWriteMutex {
    private let readMutex_: ReentrantReadMutex
    private let writeMutex_: ReentrantWriteMutex

    /*
     * @throws IllegalSynchronizationStateException
     */
    public init(mode!: ReadWriteMutexMode = ReadWriteMutexMode.Unfair) {
        let isFair: Bool = match (mode) {
            case Unfair => false
            case Fair => true
        }
        let rwMutexImpl = ReadWriteLockImpl(isFair: isFair)
        readMutex_ = ReentrantReadMutex(rwMutexImpl)
        writeMutex_ = ReentrantWriteMutex(rwMutexImpl)
    }

    public prop readMutex: ReentrantReadMutex {
        /*
         * @noThrow
         */
        get() {
            return readMutex_
        }
    }

    public prop writeMutex: ReentrantWriteMutex {
        /*
         * @noThrow
         */
        get() {
            return writeMutex_
        }
    }
}

@Deprecated[message: "Use `public interface Lock` instead."]
public class ReentrantReadMutex <: ReentrantMutex {
    private let rwMutex: ReadWriteLockImpl

    /*
     * @throws IllegalSynchronizationStateException
     */
    init(rwMutex: ReadWriteLockImpl) {
        this.rwMutex = rwMutex
    }











    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     */
    public func lock(): Unit {
        rwMutex.readLock()
    }





    /*
     * @throws NoneValueException
     * @throws Error
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func tryLock(): Bool {
        return rwMutex.tryReadLock()
    }





    /*
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws Error
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func unlock(): Unit {
        rwMutex.readUnlock()
    }
}

@Deprecated[message: "Use `public interface UniqueLock` instead."]
public class ReentrantWriteMutex <: ReentrantMutex {
    private let rwMutex: ReadWriteLockImpl

    /*
     * @throws IllegalSynchronizationStateException
     */
    init(rwMutex: ReadWriteLockImpl) {
        this.rwMutex = rwMutex
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func lock(): Unit {
        rwMutex.writeLock()
    }





    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func tryLock(): Bool {
        return rwMutex.tryWriteLock()
    }








    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func unlock(): Unit {
        rwMutex.writeUnlock()
    }
}

class ReadWriteLockImpl {
    let isFair: Bool
    let state = AtomicUInt64(0)
    private static let SHARE_UNIT: UInt64 = 1 << 32
    private static let WRITE_UNIT: UInt64 = 1
    private static let NO_THREAD = -1

    /*
     * @noThrow
     */
    init(isFair!: Bool) {
        this.isFair = isFair
    }
    /*
     * @noThrow
     */
    private static func decodeWriteCount(state: UInt64): Int64 {
        return Int64(state & 0xFFFFFFFF)
    }

    /*
     * @noThrow
     */
    private static func decodeShareCount(state: UInt64): Int64 {
        return Int64(state >> 32)
    }

    /*
     * @noThrow
     */
    func getWriteCount(): Int64 {
        return decodeWriteCount(state.load())
    }

    /*
     * @noThrow
     */
    private func incWriteCount(writeCount!: Int64 = 1): Unit {
        state.fetchAdd(WRITE_UNIT * UInt64(writeCount))
    }

    /*
     * @noThrow
     */
    private func decWriteCount(writeCount!: Int64 = 1): Unit {
        state.fetchSub(WRITE_UNIT * UInt64(writeCount))
    }

    /*
     * @noThrow
     */
    private func getShareCount(): Int64 {
        return decodeShareCount(state.load())
    }

    /*
     * @noThrow
     */
    private func incShareCount(): Unit {
        state.fetchAdd(SHARE_UNIT)
    }

    /*
     * @noThrow
     */
    private func decShareCount(): Unit {
        state.fetchSub(SHARE_UNIT)
    }
    private let writeOwner = AtomicInt64(0)
    private let waitingWriters = AtomicInt64(0)
    private let threadReadCount = ThreadLocal<Int64>()

    /*
     * @throws IndexOutOfBoundsException
     * @throws Error
     * @throws NoneValueException
     */
    private func getThreadReadCount(): Int64 {
        match (threadReadCount.get()) {
            case Some(v) => return v
            case None => return 0
        }
    }

    /*
     * @throws NoneValueException
     * @throws Error
     * @throws IndexOutOfBoundsException
     */
    private func incThreadReadCount(): Unit {
        match (threadReadCount.get()) {
            case Some(v) => threadReadCount.set(v + 1)
            case None => threadReadCount.set(1)
        }
    }

    /*
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws Error
     * @throws IndexOutOfBoundsException
     */
    private func decThreadReadCount(): Unit {
        match (threadReadCount.get()) {
            case Some(v) =>
                if (v < 1) {
                    eprintln("Invalid thread read count.")
                }
                threadReadCount.set(v - 1)
            case None => eprintln("Invalid thread read count. Thread does not acquire mutex.")
        }
    }
    private let readerSyncList = SyncList()
    private let writerSyncList = SyncList()

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     */
    func readLock(): Unit {
        let currThread = Thread.currentThread.id
        if (writeOwner.load() == currThread) {
            let currState = state.load()
            if (decodeWriteCount(currState) < 1) {
                throw IllegalSynchronizationStateException("Inconsistent state.")
            }
            incShareCount()
            incThreadReadCount()
            return
        }
        if (getThreadReadCount() > 0) {
            let currState = state.load()
            if (decodeShareCount(currState) <= 0 || decodeWriteCount(currState) != 0) {
                throw IllegalSynchronizationStateException("Inconsistent state.")
            }
            incShareCount()
            incThreadReadCount()
            return
        }
        while (true) {
            let currState = state.load()
            if (decodeWriteCount(currState) > 0) {
                readerSyncList.waitIf({=> getWriteCount() > 0})
            } else if (isFair && waitingWriters.load() > 0) {
                readerSyncList.waitIf({=> waitingWriters.load() > 0})
            } else {
                if (decodeWriteCount(currState) != 0) {
                    throw IllegalSynchronizationStateException("Inconsistent state.")
                }
                if (state.compareAndSwap(currState, currState + SHARE_UNIT)) {
                    incThreadReadCount()
                    return
                }
            }
        }
    }

    /*
     * @throws NoneValueException
     * @throws Error
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    func tryReadLock(): Bool {
        let currThread = Thread.currentThread.id
        if (writeOwner.load() == currThread) {
            incShareCount()
            incThreadReadCount()
            return true
        }
        while (true) {
            let currState = state.load()
            if (decodeWriteCount(currState) > 0) {
                return false
            } else {
                if (decodeWriteCount(currState) != 0) {
                    throw IllegalSynchronizationStateException("Inconsistent state.")
                }
                if (state.compareAndSwap(currState, currState + SHARE_UNIT)) {
                    incThreadReadCount()
                    return true
                } else {
                }
            }
        }
        return false
    }

    /*
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws Error
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    func readUnlock(): Unit {
        let currThread = Thread.currentThread.id
        if (getThreadReadCount() < 1) {
            throw IllegalSynchronizationStateException("Read-Lock is not locked by current thread.")
        } else if (writeOwner.load() == currThread) {
            let currState = state.load()
            if (decodeShareCount(currState) <= 0 || decodeWriteCount(currState) <= 0) {
                throw IllegalSynchronizationStateException("Inconsistent state.")
            }
            decShareCount()
            decThreadReadCount()
        } else {
            decThreadReadCount()
            while (true) {
                let currState = state.load()
                if (decodeShareCount(currState) <= 0 || decodeWriteCount(currState) != 0) {
                    throw IllegalSynchronizationStateException("Inconsistent state.")
                }
                if (!state.compareAndSwap(currState, currState - SHARE_UNIT)) {
                    continue
                }
                if (currState == SHARE_UNIT) {
                    writerSyncList.notifyOne()
                }
                return
            }
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    func writeLock(writeCount!: Int64 = 1): Unit {
        let currThread = Thread.currentThread.id
        if (writeOwner.load() == currThread) {
            let currState = state.load()
            if (decodeWriteCount(currState) <= 0) {
                throw IllegalSynchronizationStateException("Inconsistent state.")
            }
            incWriteCount(writeCount: writeCount)
            return
        }
        if (getThreadReadCount() != 0) {
            throw IllegalSynchronizationStateException("Read-Lock is hold by the current thread.")
        }
        while (true) {
            let currState = state.load()
            if (decodeWriteCount(currState) > 0) {
                writerSyncList.waitIf({=> getWriteCount() > 0})
            } else if (decodeShareCount(currState) > 0) {
                waitingWriters.fetchAdd(1)
                writerSyncList.waitIf({=> getShareCount() > 0})
                waitingWriters.fetchSub(1)
            } else {
                if (currState != 0) {
                    throw IllegalSynchronizationStateException("Inconsistent state.")
                }
                if (state.compareAndSwap(currState, WRITE_UNIT * UInt64(writeCount))) {
                    writeOwner.store(currThread)
                    return
                } else {
                }
            }
        }
    }

    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    func tryWriteLock(): Bool {
        let currThread = Thread.currentThread.id
        if (writeOwner.load() == currThread) {
            let currState = state.load()
            if (decodeWriteCount(currState) <= 0) {
                throw IllegalSynchronizationStateException("Inconsistent state.")
            }
            incWriteCount()
            return true
        }
        while (true) {
            let currState = state.load()
            if (decodeWriteCount(currState) > 0) {
                return false
            } else if (decodeShareCount(currState) > 0) {
                return false
            } else {
                if (currState != 0) {
                    throw IllegalSynchronizationStateException("Inconsistent state.")
                }
                if (state.compareAndSwap(currState, WRITE_UNIT)) {
                    writeOwner.store(currThread)
                    return true
                } else {
                }
            }
        }
        return false
    }

    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    func checkWriteLockStatus(): Unit {
        let currThread = Thread.currentThread.id
        if (writeOwner.load() != currThread) {
            throw IllegalSynchronizationStateException("Write-Lock is not locked by current thread.")
        }
    }

    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    func writeUnlock(): Unit {
        checkWriteLockStatus()
        writeUnlock(writeCount: 1)
    }

    /*
     * @throws IllegalSynchronizationStateException
     */
    func writeUnlock(writeCount!: Int64): Unit {
        let currState = state.load()
        if (decodeWriteCount(currState) == writeCount) {
            if (decodeShareCount(currState) > 0) {
                writeOwner.store(NO_THREAD)
                decWriteCount(writeCount: writeCount)
                readerSyncList.notifyAll()
                return
            }
            writeOwner.store(NO_THREAD)
            decWriteCount(writeCount: writeCount)
            if (isFair) {
                if (!readerSyncList.notifyAll()) {
                    writerSyncList.notifyOne()
                }
                return
            }
            if (!writerSyncList.notifyOne()) {
                readerSyncList.notifyAll()
            }
        } else {
            decWriteCount(writeCount: writeCount)
        }
    }
}
