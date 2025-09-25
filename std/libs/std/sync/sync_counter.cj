







package std.sync

public class SyncCounter {
    private var countValue: AtomicInt64
    private let syncList: SyncList



    /*
     * @throws IllegalArgumentException
     */
    public init(count: Int64) {
        if (count < 0) {
            throw IllegalArgumentException("Negative count.")
        }
        countValue = AtomicInt64(count)
        syncList = SyncList()
    }


    public prop count: Int64 {
        /*
         * @noThrow
         */
        get() {
            return countValue.load()
        }
    }




    /*
     * @throws IllegalSynchronizationStateException
     */
    public func dec(): Unit {
        if (countValue.load() <= 0) {
            return
        }
        let oldValue = countValue.fetchSub(1)
        if (oldValue == 1) {
            syncList.notifyAll()
        }
    }






    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public func waitUntilZero(timeout!: Duration = Duration.Max): Unit {
        syncList.waitIf({=> countValue.load() > 0}, timeout: timeout)
    }
}
