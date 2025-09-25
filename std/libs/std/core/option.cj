







package std.core

public enum Option<T> {
    /*
     * @noThrow
     */
    Some(T)
    | None


    @Frozen
    /*
     * @throws NoneValueException
     */
    public func getOrThrow(): T {
        match (this) {
            case Some(v) => v
            case None => throw NoneValueException()
        }
    }


    @Frozen
    /*
     * @throws getOrThrow
     */
    public func getOrThrow(exception: () -> Exception): T {
        match (this) {
            case Some(v) => v
            case None => throw exception()
        }
    }

    @Frozen
    /*
     * @noThrow
     */
    public func getOrDefault(other: () -> T): T {
        match (this) {
            case Some(v) => v
            case None => other()
        }
    }

    @Frozen
    /*
     * @noThrow
     */
    public func isNone(): Bool {
        match (this) {
            case None => true
            case Some(_) => false
        }
    }

    @Frozen
    /*
     * @noThrow
     */
    public func isSome(): Bool {
        match (this) {
            case Some(_) => true
            case None => false
        }
    }

    /*
     * @noThrow
     */
    public func map<R>(transform: (T) -> R): Option<R> {
        match (this) {
            case Some(v) => Some(transform(v))
            case None => None
        }
    }

    /*
     * @noThrow
     */
    public func filter(predicate: (T) -> Bool): Option<T> {
        let v = this ?? return None
        if (predicate(v)) {
            return v
        }
        return None
    }

    /*
     * @noThrow
     */
    public func flatMap<R>(transform: (T) -> Option<R>): Option<R> {
        match (this) {
            case Some(v) => transform(v)
            case None => None
        }
    }
}

/*
 * @noThrow
 */
public func ifSome<T>(o: Option<T>, action: (T) -> Unit): Unit {
    match (o) {
        case Some(v) => action(v)
        case None => ()
    }
}

/*
 * @noThrow
 */
public func ifNone<T>(o: Option<T>, action: () -> Unit): Unit {
    match (o) {
        case Some(v) => ()
        case None => action()
    }
}

extend<T> Option<T> <: Equatable<Option<T>> where T <: Equatable<T> {
    @Frozen
    /*
     * @noThrow
     */
    public operator func ==(that: Option<T>): Bool {
        return match ((this, that)) {
            case (Some(v1), Some(v2)) => v1 == v2
            case (None, None) => true
            case _ => false
        }
    }

    @Frozen
    /*
     * @noThrow
     */
    public operator func !=(that: Option<T>): Bool {
        return !(this == that)
    }
}

extend<T> Option<T> <: ToString where T <: ToString {
    /*
     * @noThrow
     */
    public func toString(): String {
        match (this) {
            case Some(s) => "Some(${s})"
            case None => "None"
        }
    }
}

extend<T> Option<T> <: Hashable where T <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return match (this) {
            case Some(v) => v.hashCode()
            case None => 0
        }
    }
}

extend<T> Option<Option<T>> {
    /*
     * @noThrow
     */
    public func flatten(): Option<T> {
        match (this) {
            case Some(o) => o
            case None => None
        }
    }
}
