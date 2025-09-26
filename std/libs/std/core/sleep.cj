









package std.core

const MAX_TIMEOUT_NS: Int64 = 0x7FFF_FFFF_FFFF_FFFF
let MAX_TIMEOUT_DURATION: Duration = Duration.nanosecond * MAX_TIMEOUT_NS

@Intrinsic
func intrinsicSleep(ns: Int64): Unit





/**
 * @throws ArithmeticException
 */
public func sleep(dur: Duration): Unit {
    let nanos = if (dur > MAX_TIMEOUT_DURATION) {
        MAX_TIMEOUT_NS
    } else if (dur < Duration.Zero) {
        0
    } else {
        dur.toNanoseconds()
    }
    intrinsicSleep(nanos)
}
