







package std.sync

import std.time.MonoTime









public class Mutex <: UniqueLock {


    /*
     * @throws IllegalSynchronizationStateException
     */
    public init() {
        var isNull = mutexInit(this)
        if (isNull) {
            throw IllegalSynchronizationStateException("Mutex initialization failure.")
        }
    }



    /*
     * @noThrow
     */
    public func lock(): Unit {
        mutexLock(this)
    }




    /*
     * @noThrow
     */
    public func tryLock(): Bool {
        return mutexTryLock(this)
    }




    /*
     * @throws IllegalSynchronizationStateException
     */
    public func unlock(): Unit {
        checkMutexStatus()
        mutexUnlock(this)
    }



    /*
     * @throws IllegalSynchronizationStateException
     */
    public func condition(): Condition {
        checkMutexStatus()
        return MutexCondition(this)
    }


    /*
     * @throws IllegalSynchronizationStateException
     */
    func checkMutexStatus(): Unit {
        let status = mutexCheckStatus(this)
        if (!status) {
            throw IllegalSynchronizationStateException("Mutex is not locked by current thread.")
        }
    }
}


class MutexCondition <: Condition {
    private let condition: Monitor

    /*
     * @throws IllegalSynchronizationStateException
     */
    init(mutex: Mutex) {
        condition = Monitor(mutex)
    }



    /*
     * @throws IllegalSynchronizationStateException
     */
    public func wait(): Unit {
        condition.checkMutexStatus()
        monitorWait(condition, MAX_TIMEOUT_NS)
    }






    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public func wait(timeout!: Duration): Bool {
        let timeoutNanos = getTimeoutNanos(timeout)
        condition.checkMutexStatus()
        return monitorWait(condition, timeoutNanos)
    }



    /*
     * @throws IllegalSynchronizationStateException
     */
    public func waitUntil(predicate: () -> Bool): Unit {
        condition.checkMutexStatus()
        while (!predicate()) {
            monitorWait(condition, MAX_TIMEOUT_NS)
        }
    }



    /*
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     */
    public func waitUntil(predicate: () -> Bool, timeout!: Duration): Bool {
        let timeoutNanos = getTimeoutNanos(timeout)
        condition.checkMutexStatus()

        let startTime = MonoTime.now()
        var spentTime = 0
        while (!predicate()) {
            if (spentTime >= timeoutNanos) {
                return false
            }

            let success = monitorWait(condition, timeoutNanos - spentTime)
            if (!success) {
                return false
            }
            spentTime = (MonoTime.now() - startTime).toNanoseconds()
        }
        return true
    }



    /*
     * @throws IllegalSynchronizationStateException
     */
    public func notify(): Unit {
        condition.checkMutexStatus()
        monitorNotify(condition)
    }



    /*
     * @throws IllegalSynchronizationStateException
     */
    public func notifyAll(): Unit {
        condition.checkMutexStatus()
        monitorNotifyAll(condition)
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    func getTimeoutNanos(timeout: Duration): Int64 {
        if (timeout <= Duration.Zero) {
            throw IllegalArgumentException("Timeout cannot be less than or equal to `Duration.Zero`.")
        }
        return match (timeout > MAX_TIMEOUT_DURATION) {
            case true => MAX_TIMEOUT_NS
            case false => timeout.toNanoseconds()
        }
    }
}
