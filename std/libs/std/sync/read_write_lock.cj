







package std.sync

import std.time.MonoTime

public class ReadWriteLock {
    private let _fair: Bool
    private let _readLock: Lock
    private let _writeLock: UniqueLock

    public prop readLock: Lock {
        /*
         * @noThrow
         */
        get() {
            _readLock
        }
    }
    public prop writeLock: UniqueLock {
        /*
         * @noThrow
         */
        get() {
            _writeLock
        }
    }


    /*
     * @noThrow
     */
    public init(fair!: Bool = false) {
        _fair = fair
        let readWriteLockImpl = ReadWriteLockImpl(isFair: fair)
        _readLock = ReadLock(readWriteLockImpl)
        _writeLock = WriteLock(readWriteLockImpl)
    }

    /*
     * @noThrow
     */
    public func isFair(): Bool {
        _fair
    }
}

class ReadLock <: Lock {
    /*
     * @noThrow
     */
    ReadLock(private let _readWriteLockImpl: ReadWriteLockImpl) {}

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     */
    public func lock(): Unit {
        _readWriteLockImpl.readLock()
    }
    /*
     * @throws NoneValueException
     * @throws Error
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func tryLock(): Bool {
        _readWriteLockImpl.tryReadLock()
    }
    /*
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws Error
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func unlock(): Unit {
        _readWriteLockImpl.readUnlock()
    }
}

class WriteLock <: UniqueLock {
    /*
     * @noThrow
     */
    WriteLock(private let _readWriteLockImpl: ReadWriteLockImpl) {}

    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func lock(): Unit {
        _readWriteLockImpl.writeLock()
    }
    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func tryLock(): Bool {
        _readWriteLockImpl.tryWriteLock()
    }
    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func unlock(): Unit {
        _readWriteLockImpl.writeUnlock()
    }

    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func condition(): Condition {
        _readWriteLockImpl.checkWriteLockStatus()
        return ReadWriteLockCondition(_readWriteLockImpl)
    }
}

class ReadWriteLockCondition <: Condition {
    private let waitQueue = SyncList()

    /*
     * @noThrow
     */
    ReadWriteLockCondition(private let lock: ReadWriteLockImpl) {
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws Error
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    public func wait(): Unit {
        wait(timeout: Duration.Max)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws Error
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    public func wait(timeout!: Duration): Bool {
        if (timeout <= Duration.Zero) {
            throw IllegalArgumentException("Timeout cannot be less than or equal to `Duration.Zero`.")
        }

        lock.checkWriteLockStatus()
        let writeCount = lock.getWriteCount()
        let success = waitQueue.waitInLock({=> lock.writeUnlock(writeCount: writeCount)}, timeout: timeout)
        lock.writeLock(writeCount: writeCount)
        return success
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws Error
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    public func waitUntil(predicate: () -> Bool): Unit {
        lock.checkWriteLockStatus()
        while (!predicate()) {
            wait()
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws Error
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    public func waitUntil(predicate: () -> Bool, timeout!: Duration): Bool {
        if (timeout <= Duration.Zero) {
            throw IllegalArgumentException("Timeout cannot be less than or equal to `Duration.Zero`.")
        }
        lock.checkWriteLockStatus()

        let startTime = MonoTime.now()
        var spentTime = Duration.Zero
        while (!predicate()) {
            if (spentTime >= timeout) {
                return false
            }

            let success = wait(timeout: timeout - spentTime)
            if (!success) {
                return false
            }
            spentTime = MonoTime.now() - startTime
        }
        return true
    }

    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func notify(): Unit {
        lock.checkWriteLockStatus()
        waitQueue.notifyOne()
    }

    /*
     * @throws Error
     * @throws IllegalSynchronizationStateException
     */
    public func notifyAll(): Unit {
        lock.checkWriteLockStatus()
        waitQueue.notifyAll()
    }
}
