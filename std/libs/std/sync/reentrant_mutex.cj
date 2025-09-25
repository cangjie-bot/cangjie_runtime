







package std.sync









@Deprecated[message: "Use `public class Mutex` instead."]
public open class ReentrantMutex <: Lock {
    private let mutex: Mutex

    
    public init() {
        this.mutex = Mutex()
    }

    init(mutex: Mutex) {
        this.mutex = mutex
    }



    public open func lock(): Unit {
        mutex.lock()
    }




    public open func tryLock(): Bool {
        return mutex.tryLock()
    }




    public open func unlock(): Unit {
        mutex.unlock()
    }

    func checkMutexStatus(): Unit {
        mutex.checkMutexStatus()
    }
}
