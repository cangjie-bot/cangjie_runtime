







package std.core

public class Box<T> {
    public var value: T
    public init(v: T) {
        value = v
    }
}

extend<T> Box<T> <: Hashable where T <: Hashable {
    public func hashCode(): Int64 {
        return this.value.hashCode()
    }
}

extend<T> Box<T> <: Comparable<Box<T>> where T <: Comparable<T> {
    public operator func ==(that: Box<T>): Bool {
        return this.value == that.value
    }
    public operator func !=(that: Box<T>): Bool {
        return this.value != that.value
    }
    public operator func >(that: Box<T>): Bool {
        return this.value > that.value
    }
    public operator func <(that: Box<T>): Bool {
        return this.value < that.value
    }
    public operator func >=(that: Box<T>): Bool {
        return this.value >= that.value
    }
    public operator func <=(that: Box<T>): Bool {
        return this.value <= that.value
    }







    public func compare(that: Box<T>): Ordering {
        match {
            case this.value < that.value => Ordering.LT
            case this.value > that.value => Ordering.GT
            case _ => Ordering.EQ
        }
    }
}

extend<T> Box<T> <: ToString where T <: ToString {
    public func toString(): String {
        return this.value.toString()
    }
}
