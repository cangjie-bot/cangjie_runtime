







package std.core

public interface Equal<T> {
    operator func ==(rhs: T): Bool
}

public interface NotEqual<T> {
    operator func !=(rhs: T): Bool
}

public interface Equatable<T> <: Equal<T> & NotEqual<T> {
    operator func !=(rhs: T): Bool {
        !(this == rhs)
    }
}

extend Bool <: Equatable<Bool> {}

extend Unit <: Equatable<Unit> {}

extend<T> Range<T> <: Equatable<Range<T>> where T <: Countable<T> & Comparable<T> & Equatable<T> {
    public operator func ==(that: Range<T>): Bool {
        this.start == that.start && this.end == that.end && this.step == that.step && this.isClosed == that.isClosed
    }
}
