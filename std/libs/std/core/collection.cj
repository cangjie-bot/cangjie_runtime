







package std.core






public interface Collection<T> <: Iterable<T> {
    prop size: Int64
    /*
     * @noThrow
     */
    func isEmpty(): Bool

    /*
     * @noThrow
     */
    func toArray(): Array<T> {
        return Array<T>(this)
    }
}
