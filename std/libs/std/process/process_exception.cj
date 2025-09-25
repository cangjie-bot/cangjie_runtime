







package std.process

import std.io.*



public class ProcessException <: IOException {
    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "ProcessException"
    }
}
