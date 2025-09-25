







package std.fs

import std.io.IOException

public class FSException <: IOException {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "FSException"
    }
}
