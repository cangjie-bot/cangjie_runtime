







package std.runtime

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func getThreadNumber(): Int64

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func getBlockingThreadNumber(): Int64

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func getNativeThreadNumber(): Int64

@When[backend == "cjnative"]
@Deprecated[message: "All static Properties are converted to public functions."]
              /*
               * @noThrow
               */
public struct ThreadInfo {


    public static prop threadCount: Int64 {
        /*
         * @noThrow
         */
        get() {
            getThreadCount()
        }
    }


    public static prop blockingThreadCount: Int64 {
        /*
         * @noThrow
         */
        get() {
            getBlockingThreadCount()
        }
    }


    public static prop nativeThreadCount: Int64 {
        /*
         * @noThrow
         */
        get() {
            getNativeThreadCount()
        }
    }
}

@When[backend == "cjnative"]
/*
 * @noThrow
 */
public func getThreadCount(): Int64 {
    return getThreadNumber()
}

@When[backend == "cjnative"]
/*
 * @noThrow
 */
public func getBlockingThreadCount(): Int64 {
    return getBlockingThreadNumber()
}

@When[backend == "cjnative"]
/*
 * @noThrow
 */
public func getNativeThreadCount(): Int64 {
    return getNativeThreadNumber()
}
