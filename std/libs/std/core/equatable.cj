







package std.core

public interface Equal<T> {
    /*
     * @noThrow
     */
    operator func ==(rhs: T): Bool
}

public interface NotEqual<T> {
    /*
     * @noThrow
     */
    operator func !=(rhs: T): Bool
}

public interface Equatable<T> <: Equal<T> & NotEqual<T> {
    /*
     * @noThrow
     */
    operator func !=(rhs: T): Bool {
        !(this == rhs)
    }
}

/*
 * @noThrow
 */
extend Bool <: Equatable<Bool> {}

/*
 * @noThrow
 */
extend Unit <: Equatable<Unit> {}

extend<T> Range<T> <: Equatable<Range<T>> where T <: Countable<T> & Comparable<T> & Equatable<T> {
    /*
     * @noThrow
     */
    public operator func ==(that: Range<T>): Bool {
        this.start == that.start && this.end == that.end && this.step == that.step && this.isClosed == that.isClosed
    }
}
