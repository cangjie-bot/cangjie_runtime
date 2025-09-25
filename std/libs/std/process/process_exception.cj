







package std.process

import std.io.*



public class ProcessException <: IOException {
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
        return "ProcessException"
    }
}
