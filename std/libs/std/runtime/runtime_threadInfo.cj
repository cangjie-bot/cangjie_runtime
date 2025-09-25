







package std.runtime

@When[backend == "cjnative"]
@Intrinsic
func getThreadNumber(): Int64

@When[backend == "cjnative"]
@Intrinsic
func getBlockingThreadNumber(): Int64

@When[backend == "cjnative"]
@Intrinsic
func getNativeThreadNumber(): Int64

@When[backend == "cjnative"]
@Deprecated[message: "All static Properties are converted to public functions."]
public struct ThreadInfo {


    public static prop threadCount: Int64 {
        get() {
            getThreadCount()
        }
    }


    public static prop blockingThreadCount: Int64 {
        get() {
            getBlockingThreadCount()
        }
    }


    public static prop nativeThreadCount: Int64 {
        get() {
            getNativeThreadCount()
        }
    }
}

@When[backend == "cjnative"]
public func getThreadCount(): Int64 {
    return getThreadNumber()
}

@When[backend == "cjnative"]
public func getBlockingThreadCount(): Int64 {
    return getBlockingThreadNumber()
}

@When[backend == "cjnative"]
public func getNativeThreadCount(): Int64 {
    return getNativeThreadNumber()
}
