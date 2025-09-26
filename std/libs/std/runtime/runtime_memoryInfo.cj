







package std.runtime

@When[backend == "cjnative"]
import std.fs.*

@Intrinsic
func getMaxCjHeapSize(): Int64

@Intrinsic
func getAllocatedCjHeapSize(): Int64

@Intrinsic
func getRealHeapSize(): Int64

@When[backend == "cjnative"]
@Intrinsic
func dumpCjHeapData(fd: Int32): Bool

class MemoryInfoException <: Exception {
    init(message: String) {
        super(message)
    }

    protected func getClassName(): String {
        return "MemoryInfoException"
    }
}

@Deprecated[message: "All static Properties are converted to public functions."]
public struct MemoryInfo {


    public static prop maxHeapSize: Int64 {
        get() {
            getMaxHeapSize()
        }
    }


    public static prop allocatedHeapSize: Int64 {
        get() {
            getAllocatedHeapSize()
        }
    }


        /**
         * @throws MemoryInfoException
         */
    public static prop heapPhysicalMemory: Int64 {
        get() {
            getUsedHeapSize()
        }
    }
}

public func getMaxHeapSize(): Int64 {
    return getMaxCjHeapSize()
}

public func getAllocatedHeapSize(): Int64 {
    return getAllocatedCjHeapSize()
}

/**
 * @throws MemoryInfoException
 */
public func getUsedHeapSize(): Int64 {
    var ret = getRealHeapSize()
    match {
        case ret >= 0 => return ret
        case ret == -1 => throw MemoryInfoException("Failed to open the smaps file.")
        case ret == -2 => throw MemoryInfoException("Failed to get vaild value.")
        case _ => throw MemoryInfoException("Failed to get vaild errorcode.")
    }
}

/**
 * @throws IllegalMemoryException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws FSException
 * @throws MemoryInfoException
 */
@When[backend == "cjnative"]
public func dumpHeapData(path: Path): Unit {
    try (file = File(path, ReadWrite)) {
        let success = dumpCjHeapData(Int32(file.fileDescriptor.fileHandle))
        if (!success) {
            throw MemoryInfoException("Failed to dump heap data.")
        }
    }
    return
}
