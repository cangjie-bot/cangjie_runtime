







package std.sync

public class Semaphore {
    private var countValue: AtomicInt64
    private let monitor: Monitor
    private let initValue: Int64



    public init(count: Int64) {
        if (count < 0) {
            throw IllegalArgumentException("Negative count.")
        }
        initValue = count
        countValue = AtomicInt64(count)
        monitor = Monitor()
    }


    public prop count: Int64 {
        get() {
            return countValue.load()
        }
    }







    public func acquire(amount!: Int64 = 1): Unit {
        if (amount < 0 || amount > initValue) {
            throw IllegalArgumentException("Invalid amount to acquire.")
        }
        synchronized(monitor) {
            while (countValue.load() < amount) {
                monitor.wait()
            }
            countValue.fetchSub(amount)
        }
    }





    public func tryAcquire(amount!: Int64 = 1): Bool {
        if (amount < 0 || amount > initValue) {
            throw IllegalArgumentException("Invalid amount to acquire.")
        }
        synchronized(monitor) {
            if (countValue.load() < amount) {
                return false
            } else {
                countValue.fetchSub(amount)
                return true
            }
        }
    }






    public func release(amount!: Int64 = 1): Unit {
        if (amount < 0 || amount > initValue) {
            throw IllegalArgumentException("Invalid amount to acquire.")
        }
        synchronized(monitor) {
            let oldValue = countValue.load()
            let newValue = oldValue + amount
            if (newValue > initValue) {
                countValue.store(initValue)
            } else {
                countValue.store(newValue)
            }
            monitor.notifyAll()
        }
    }
}
