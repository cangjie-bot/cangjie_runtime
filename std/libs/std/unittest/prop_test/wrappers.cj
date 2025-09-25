






package std.unittest.prop_test




public struct Function0Wrapper<R> {
    /*
     * @noThrow
     */
    public Function0Wrapper(public let function: () -> R) {}

    /*
     * @noThrow
     */
    public operator func () (): R { function() }
}


public struct TupleWrapper2<T0, T1> {
    /*
     * @noThrow
     */
    public TupleWrapper2(public let tuple: (T0, T1)) {}

    /*
     * @noThrow
     */
    public func apply<R>(f: (T0, T1) -> R): R {
        f(tuple[0], tuple[1])
    }
}


public struct TupleWrapper3<T0, T1, T2> {
    /*
     * @noThrow
     */
    public TupleWrapper3(public let tuple: (T0, T1, T2)) {}

    /*
     * @noThrow
     */
    public func apply<R>(f: (T0, T1, T2) -> R): R {
        f(tuple[0], tuple[1], tuple[2])
    }
}


public struct TupleWrapper4<T0, T1, T2, T3> {
    /*
     * @noThrow
     */
    public TupleWrapper4(public let tuple: (T0, T1, T2, T3)) {}

    /*
     * @noThrow
     */
    public func apply<R>(f: (T0, T1, T2, T3) -> R): R {
        f(tuple[0], tuple[1], tuple[2], tuple[3])
    }
}


public struct TupleWrapper5<T0, T1, T2, T3, T4> {
    /*
     * @noThrow
     */
    public TupleWrapper5(public let tuple: (T0, T1, T2, T3, T4)) {}

    /*
     * @noThrow
     */
    public func apply<R>(f: (T0, T1, T2, T3, T4) -> R): R {
        f(tuple[0], tuple[1], tuple[2], tuple[3], tuple[4])
    }
}



extend<T0, T1> TupleWrapper2<T0, T1> <: ToString
        where T0 <: ToString, T1 <: ToString {
    /*
     * @noThrow
     */
    public func toString() { "(${tuple[0]}, ${tuple[1]})" }
}

extend<T0, T1, T2> TupleWrapper3<T0, T1, T2> <: ToString
        where T0 <: ToString, T1 <: ToString, T2 <: ToString {
    /*
     * @noThrow
     */
    public func toString() { "(${tuple[0]}, ${tuple[1]}, ${tuple[2]})" }
}

extend<T0, T1, T2, T3> TupleWrapper4<T0, T1, T2, T3> <: ToString
        where T0 <: ToString, T1 <: ToString, T2 <: ToString, T3 <: ToString {
    /*
     * @noThrow
     */
    public func toString() { "(${tuple[0]}, ${tuple[1]}, ${tuple[2]}, ${tuple[3]})" }
}

extend<T0, T1, T2, T3, T4> TupleWrapper5<T0, T1, T2, T3, T4> <: ToString
        where T0 <: ToString, T1 <: ToString, T2 <: ToString, T3 <: ToString, T4 <: ToString {
    /*
     * @noThrow
     */
    public func toString() { "(${tuple[0]}, ${tuple[1]}, ${tuple[2]}, ${tuple[3]}, ${tuple[4]})" }
}


extend<T0, T1> TupleWrapper2<T0, T1> <: Equatable<TupleWrapper2<T0, T1>> where T0 <: Equatable<T0>, T1 <: Equatable<T1> {
    /*
     * @noThrow
     */
    public operator func ==(other: TupleWrapper2<T0, T1>) {
        return this.tuple == other.tuple
    }

    /*
     * @noThrow
     */
    public operator func !=(other: TupleWrapper2<T0, T1>) {
        return this.tuple != other.tuple
    }
}

extend<T0, T1, T2> TupleWrapper3<T0, T1, T2> <: Equatable<TupleWrapper3<T0, T1, T2>>
        where T0 <: Equatable<T0>, T1 <: Equatable<T1>, T2 <: Equatable<T2> {
    /*
     * @noThrow
     */
    public operator func ==(other: TupleWrapper3<T0, T1, T2>) {
        return this.tuple == other.tuple
    }

    /*
     * @noThrow
     */
    public operator func !=(other: TupleWrapper3<T0, T1, T2>) {
        return this.tuple != other.tuple
    }
}

extend<T0, T1, T2, T3> TupleWrapper4<T0, T1, T2, T3> <: Equatable<TupleWrapper4<T0, T1, T2, T3>>
        where T0 <: Equatable<T0>, T1 <: Equatable<T1>, T2 <: Equatable<T2>, T3 <: Equatable<T3> {
    /*
     * @noThrow
     */
    public operator func ==(other: TupleWrapper4<T0, T1, T2, T3>) {
        return this.tuple == other.tuple
    }

    /*
     * @noThrow
     */
    public operator func !=(other: TupleWrapper4<T0, T1, T2, T3>) {
        return this.tuple != other.tuple
    }
}

extend<T0, T1, T2, T3, T4> TupleWrapper5<T0, T1, T2, T3, T4> <: Equatable<TupleWrapper5<T0, T1, T2, T3, T4>>
        where T0 <: Equatable<T0>, T1 <: Equatable<T1>, T2 <: Equatable<T2>, T3 <: Equatable<T3>, T4 <: Equatable<T4> {
    /*
     * @noThrow
     */
    public operator func ==(other: TupleWrapper5<T0, T1, T2, T3, T4>) {
        return this.tuple == other.tuple
    }

    /*
     * @noThrow
     */
    public operator func !=(other: TupleWrapper5<T0, T1, T2, T3, T4>) {
        return this.tuple != other.tuple
    }
}



public interface IndexAccess {
    /*
     * @noThrow
     */
    func getElementAsAny(index: Int64): ?Any
}

extend<T0, T1> TupleWrapper2<T0, T1> <: IndexAccess {
    /*
     * @noThrow
     */
    public func getElementAsAny(index: Int64): ?Any {
        match (index) {
            case 0 => tuple[0]
            case 1 => tuple[1]
            case _ => None
        }
    }
}

extend<T0, T1, T2> TupleWrapper3<T0, T1, T2> <: IndexAccess {
    /*
     * @noThrow
     */
    public func getElementAsAny(index: Int64): ?Any {
        match (index) {
            case 0 => tuple[0]
            case 1 => tuple[1]
            case 2 => tuple[2]
            case _ => None
        }
    }
}

extend<T0, T1, T2, T3> TupleWrapper4<T0, T1, T2, T3> <: IndexAccess {
    /*
     * @noThrow
     */
    public func getElementAsAny(index: Int64): ?Any {
        match (index) {
            case 0 => tuple[0]
            case 1 => tuple[1]
            case 2 => tuple[2]
            case 3 => tuple[3]
            case _ => None
        }
    }
}

extend<T0, T1, T2, T3, T4> TupleWrapper5<T0, T1, T2, T3, T4> <: IndexAccess {
    /*
     * @noThrow
     */
    public func getElementAsAny(index: Int64): ?Any {
        match (index) {
            case 0 => tuple[0]
            case 1 => tuple[1]
            case 2 => tuple[2]
            case 3 => tuple[3]
            case 4 => tuple[4]
            case _ => None
        }
    }
}
