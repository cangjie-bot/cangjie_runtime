










package std.time






@FastNative
foreign func CJ_TIME_Now(): NativeClock

@FastNative
foreign func CJ_TIME_MonotonicNow(): NativeClock






func systemNow(): (Int64, Int64) {
    let nc = unsafe { CJ_TIME_Now() }
    return (nc.sec, nc.nanosec)
}

func monoNow(): (Int64, Int64) {
    let nc = unsafe { CJ_TIME_MonotonicNow() }
    return (nc.sec, nc.nanosec)
}
