







package std.sync

public class Barrier {
    private let syncCounter: SyncCounter



    /**
     * @throws IllegalArgumentException
     */
    public init(count: Int64) {
        syncCounter = SyncCounter(count)
    }








    /**
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    public func wait(timeout!: Duration = Duration.Max): Unit {
        syncCounter.dec()
        syncCounter.waitUntilZero(timeout: timeout)
    }
}
