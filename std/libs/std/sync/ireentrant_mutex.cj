







package std.sync



@Deprecated[message: "Use `public interface Lock` instead."]
public interface IReentrantMutex {
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

public class IllegalSynchronizationStateException <: Exception {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }
    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "IllegalSynchronizationStateException"
    }
}
