










package std.time





public struct MonoTime <: Hashable & Comparable<MonoTime> {


    let d: Duration




    public static func now(): MonoTime {
        let (sec, ns) = monoNow()
        return MonoTime(Duration(sec, UInt32(ns)))
    }


    private init(d: Duration) {
        this.d = d
    }





    public operator func +(r: Duration): MonoTime {
        if (r > Duration.Max - d || r < Duration.Zero - d) {
            throw ArithmeticException("The result exceeds the range of 'MonoTime'.")
        }
        return MonoTime(d + r)
    }





    public operator func -(r: Duration): MonoTime {
        if (d - Duration.Max > r || d < r) {
            throw ArithmeticException("The result exceeds the range of 'MonoTime'.")
        }
        return MonoTime(d - r)
    }





    public operator func -(r: MonoTime): Duration {
        return this.d - r.d
    }





    public operator func ==(r: MonoTime): Bool {
        return this.d == r.d
    }





    public operator func !=(r: MonoTime): Bool {
        return this.d != r.d
    }





    public operator func >=(r: MonoTime): Bool {
        return this.d >= r.d
    }





    public operator func >(r: MonoTime): Bool {
        return this.d > r.d
    }





    public operator func <=(r: MonoTime): Bool {
        return this.d <= r.d
    }





    public operator func <(r: MonoTime): Bool {
        return this.d < r.d
    }





    public func compare(rhs: MonoTime): Ordering {
        match {
            case this < rhs => Ordering.LT
            case this > rhs => Ordering.GT
            case _ => Ordering.EQ
        }
    }




    public func hashCode(): Int64 {
        return d.hashCode()
    }
}
