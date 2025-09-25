







package std.sync



@Deprecated[message: "Use `public interface Lock` instead."]
public interface IReentrantMutex {
    func lock(): Unit
    func tryLock(): Bool
    func unlock(): Unit
}

public class IllegalSynchronizationStateException <: Exception {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "IllegalSynchronizationStateException"
    }
}
