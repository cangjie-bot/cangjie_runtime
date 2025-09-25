







package std.sync

public class Barrier {
    private let syncCounter: SyncCounter



    public init(count: Int64) {
        syncCounter = SyncCounter(count)
    }








    public func wait(timeout!: Duration = Duration.Max): Unit {
        syncCounter.dec()
        syncCounter.waitUntilZero(timeout: timeout)
    }
}
