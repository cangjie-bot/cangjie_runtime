







package std.sync









@Deprecated[message: "Use `public class Mutex` instead."]
public open class ReentrantMutex <: Lock {
    private let mutex: Mutex

    
    /*
     * @throws IllegalSynchronizationStateException
     */
    public init() {
        this.mutex = Mutex()
    }

    /*
     * @noThrow
     */
    init(mutex: Mutex) {
        this.mutex = mutex
    }



    /*
     * @noThrow
     */
    public open func lock(): Unit {
        mutex.lock()
    }




    /*
     * @noThrow
     */
    public open func tryLock(): Bool {
        return mutex.tryLock()
    }




    /*
     * @throws IllegalSynchronizationStateException
     */
    public open func unlock(): Unit {
        mutex.unlock()
    }

    /*
     * @throws IllegalSynchronizationStateException
     */
    func checkMutexStatus(): Unit {
        mutex.checkMutexStatus()
    }
}
