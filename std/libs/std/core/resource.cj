







package std.core

public interface Resource {
    /*
     * @noThrow
     */
    func isClosed(): Bool
    /*
     * @noThrow
     */
    func close(): Unit
}
