







package std.sync










public interface Lock {



    func lock(): Unit




    func tryLock(): Bool




    func unlock(): Unit
}

public interface UniqueLock <: Lock {



    func condition(): Condition
}


public interface Condition {



    func wait(): Unit






    func wait(timeout!: Duration): Bool



    func waitUntil(predicate: () -> Bool): Unit



    func waitUntil(predicate: () -> Bool, timeout!: Duration): Bool



    func notify(): Unit



    func notifyAll(): Unit
}
