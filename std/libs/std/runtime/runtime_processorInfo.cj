







package std.runtime

@When[backend == "cjnative"]
import std.fs.*

@When[backend == "cjnative"]
@Intrinsic
func startCjCPUProfiling(): Bool

@When[backend == "cjnative"]
@Intrinsic
func stopCjCPUProfiling(fd: Int32): Bool

@FastNative
foreign func CJ_OS_ProcessorCount(): Int64

class ProfilingInfoException <: Exception {
    init(message: String) {
        super(message)
    }

    protected func getClassName(): String {
        return "ProfilingInfoException"
    }
}

@Deprecated[message: "All static Properties are converted to public functions."]
public struct ProcessorInfo {
    public static prop processorCount: Int64 {
        get() {
            getProcessorCount()
        }
    }
}

public func getProcessorCount(): Int64 {
    return unsafe { CJ_OS_ProcessorCount() }
}

/**
 * @throws ProfilingInfoException
 */
@When[backend == "cjnative"]
public func startCPUProfiling(): Unit {
    let success = startCjCPUProfiling()
    if (!success) {
        throw ProfilingInfoException("Failed to start cpu profiling.")
    }
    return
}

/**
 * @throws IllegalMemoryException
 * @throws IndexOutOfBoundsException
 * @throws FSException
 * @throws IllegalArgumentException
 * @throws ProfilingInfoException
 */
@When[backend == "cjnative"]
public func stopCPUProfiling(path: Path): Unit {
    try (file = File(path, ReadWrite)) {
        let success = stopCjCPUProfiling(Int32(file.fileDescriptor.fileHandle))
        if (!success) {
            throw ProfilingInfoException("Failed to stop cpu profiling.")
        }
    }
    return
}
