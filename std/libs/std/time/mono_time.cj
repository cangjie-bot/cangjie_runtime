










package std.time





public struct MonoTime <: Hashable & Comparable<MonoTime> {


    let d: Duration




    /*
     * @noThrow
     */
    public static func now(): MonoTime {
        let (sec, ns) = monoNow()
        return MonoTime(Duration(sec, UInt32(ns)))
    }


    /*
     * @noThrow
     */
    private init(d: Duration) {
        this.d = d
    }





    /*
     * @throws ArithmeticException
     */
    public operator func +(r: Duration): MonoTime {
        if (r > Duration.Max - d || r < Duration.Zero - d) {
            throw ArithmeticException("The result exceeds the range of 'MonoTime'.")
        }
        return MonoTime(d + r)
    }





    /*
     * @throws ArithmeticException
     */
    public operator func -(r: Duration): MonoTime {
        if (d - Duration.Max > r || d < r) {
            throw ArithmeticException("The result exceeds the range of 'MonoTime'.")
        }
        return MonoTime(d - r)
    }





    /*
     * @throws ArithmeticException
     */
    public operator func -(r: MonoTime): Duration {
        return this.d - r.d
    }





    /*
     * @noThrow
     */
    public operator func ==(r: MonoTime): Bool {
        return this.d == r.d
    }





    /*
     * @noThrow
     */
    public operator func !=(r: MonoTime): Bool {
        return this.d != r.d
    }





    /*
     * @noThrow
     */
    public operator func >=(r: MonoTime): Bool {
        return this.d >= r.d
    }





    /*
     * @noThrow
     */
    public operator func >(r: MonoTime): Bool {
        return this.d > r.d
    }





    /*
     * @noThrow
     */
    public operator func <=(r: MonoTime): Bool {
        return this.d <= r.d
    }





    /*
     * @noThrow
     */
    public operator func <(r: MonoTime): Bool {
        return this.d < r.d
    }





    /*
     * @noThrow
     */
    public func compare(rhs: MonoTime): Ordering {
        match {
            case this < rhs => Ordering.LT
            case this > rhs => Ordering.GT
            case _ => Ordering.EQ
        }
    }




    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return d.hashCode()
    }
}
