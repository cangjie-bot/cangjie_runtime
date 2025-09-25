







package std.core






public interface Collection<T> <: Iterable<T> {
    prop size: Int64
    func isEmpty(): Bool

    func toArray(): Array<T> {
        return Array<T>(this)
    }
}
