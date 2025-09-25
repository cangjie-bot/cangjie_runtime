







package std.core

public class SpawnException <: Exception {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "SpawnException"
    }
}
