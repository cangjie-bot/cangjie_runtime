







package std.runtime

@Intrinsic
/*
 * @noThrow
 */
func invokeGC(heavy: Bool): Unit

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func getCjGCCount(): Int64

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func getCjGCTime(): Int64

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func getCjGCFreedSize(): Int64

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func setCjGCThreshold(value: UInt64): Unit

@Deprecated[message: "Use 'public func gc(heavy!: Bool = false): Unit' instead."]
/*
 * @noThrow
 */
public func GC(heavy!: Bool = false): Unit {
    return gc(heavy: heavy)
}


@When[backend == "cjnative"]
@Deprecated[message: "Use 'public func setGCThreshold(value: UInt64): Unit' instead."]
/*
 * @noThrow
 */
public func SetGCThreshold(value: UInt64): Unit {
    return setGCThreshold(value)
}

/*
 * @noThrow
 */
public func gc(heavy!: Bool = false): Unit {
    unsafe { return invokeGC(heavy) }
}

@When[backend == "cjnative"]
/*
 * @noThrow
 */
public func setGCThreshold(value: UInt64): Unit {
    unsafe { setCjGCThreshold(value) }
}

@When[backend == "cjnative"]
/*
 * @noThrow
 */
public func getGCCount(): Int64 {
    return getCjGCCount()
}

@When[backend == "cjnative"]
/*
 * @noThrow
 */
public func getGCTime(): Int64 {
    return getCjGCTime()
}

@When[backend == "cjnative"]
/*
 * @noThrow
 */
public func getGCFreedSize(): Int64 {
    return getCjGCFreedSize()
}
