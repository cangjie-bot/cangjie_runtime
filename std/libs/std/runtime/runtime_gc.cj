







package std.runtime

@Intrinsic
func invokeGC(heavy: Bool): Unit

@When[backend == "cjnative"]
@Intrinsic
func getCjGCCount(): Int64

@When[backend == "cjnative"]
@Intrinsic
func getCjGCTime(): Int64

@When[backend == "cjnative"]
@Intrinsic
func getCjGCFreedSize(): Int64

@When[backend == "cjnative"]
@Intrinsic
func setCjGCThreshold(value: UInt64): Unit

@Deprecated[message: "Use 'public func gc(heavy!: Bool = false): Unit' instead."]
public func GC(heavy!: Bool = false): Unit {
    return gc(heavy: heavy)
}


@When[backend == "cjnative"]
@Deprecated[message: "Use 'public func setGCThreshold(value: UInt64): Unit' instead."]
public func SetGCThreshold(value: UInt64): Unit {
    return setGCThreshold(value)
}

public func gc(heavy!: Bool = false): Unit {
    unsafe { return invokeGC(heavy) }
}

@When[backend == "cjnative"]
public func setGCThreshold(value: UInt64): Unit {
    unsafe { setCjGCThreshold(value) }
}

@When[backend == "cjnative"]
public func getGCCount(): Int64 {
    return getCjGCCount()
}

@When[backend == "cjnative"]
public func getGCTime(): Int64 {
    return getCjGCTime()
}

@When[backend == "cjnative"]
public func getGCFreedSize(): Int64 {
    return getCjGCFreedSize()
}
