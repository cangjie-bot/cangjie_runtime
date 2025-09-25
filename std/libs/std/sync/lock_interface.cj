







package std.sync










public interface Lock {



    /*
     * @noThrow
     */
    func lock(): Unit




    /*
     * @noThrow
     */
    func tryLock(): Bool




    /*
     * @noThrow
     */
    func unlock(): Unit
}

public interface UniqueLock <: Lock {



    /*
     * @noThrow
     */
    func condition(): Condition
}


public interface Condition {



    /*
     * @noThrow
     */
    func wait(): Unit






    /*
     * @noThrow
     */
    func wait(timeout!: Duration): Bool



    /*
     * @noThrow
     */
    func waitUntil(predicate: () -> Bool): Unit



    /*
     * @noThrow
     */
    func waitUntil(predicate: () -> Bool, timeout!: Duration): Bool



    /*
     * @noThrow
     */
    func notify(): Unit



    /*
     * @noThrow
     */
    func notifyAll(): Unit
}
