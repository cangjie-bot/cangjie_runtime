







package std.runtime

@When[backend == "cjnative"]
import std.fs.*

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func startCjCPUProfiling(): Bool

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func stopCjCPUProfiling(fd: Int32): Bool

@FastNative
foreign func CJ_OS_ProcessorCount(): Int64

class ProfilingInfoException <: Exception {
    /*
     * @noThrow
     */
    init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected func getClassName(): String {
        return "ProfilingInfoException"
    }
}

@Deprecated[message: "All static Properties are converted to public functions."]
              /*
               * @noThrow
               */
public struct ProcessorInfo {
    public static prop processorCount: Int64 {
        /*
         * @noThrow
         */
        get() {
            getProcessorCount()
        }
    }
}

/*
 * @noThrow
 */
public func getProcessorCount(): Int64 {
    return unsafe { CJ_OS_ProcessorCount() }
}

@When[backend == "cjnative"]
/*
 * @throws ProfilingInfoException
 */
public func startCPUProfiling(): Unit {
    let success = startCjCPUProfiling()
    if (!success) {
        throw ProfilingInfoException("Failed to start cpu profiling.")
    }
    return
}

@When[backend == "cjnative"]
/*
 * @throws IllegalMemoryException
 * @throws IndexOutOfBoundsException
 * @throws FSException
 * @throws IllegalArgumentException
 * @throws ProfilingInfoException
 */
public func stopCPUProfiling(path: Path): Unit {
    try (file = File(path, ReadWrite)) {
        let success = stopCjCPUProfiling(Int32(file.fileDescriptor.fileHandle))
        if (!success) {
            throw ProfilingInfoException("Failed to stop cpu profiling.")
        }
    }
    return
}
