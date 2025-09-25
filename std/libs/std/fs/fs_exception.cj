







package std.fs

import std.io.IOException

public class FSException <: IOException {
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
        return "FSException"
    }
}
