







package std.runtime

@When[backend == "cjnative"]
import std.fs.*

@Intrinsic
/*
 * @noThrow
 */
func getMaxCjHeapSize(): Int64

@Intrinsic
/*
 * @noThrow
 */
func getAllocatedCjHeapSize(): Int64

@Intrinsic
/*
 * @noThrow
 */
func getRealHeapSize(): Int64

@When[backend == "cjnative"]
@Intrinsic
/*
 * @noThrow
 */
func dumpCjHeapData(fd: Int32): Bool

class MemoryInfoException <: Exception {
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
        return "MemoryInfoException"
    }
}

@Deprecated[message: "All static Properties are converted to public functions."]
              /*
               * @noThrow
               */
public struct MemoryInfo {


    public static prop maxHeapSize: Int64 {
        /*
         * @noThrow
         */
        get() {
            getMaxHeapSize()
        }
    }


    public static prop allocatedHeapSize: Int64 {
        /*
         * @noThrow
         */
        get() {
            getAllocatedHeapSize()
        }
    }


    public static prop heapPhysicalMemory: Int64 {
        /*
         * @throws MemoryInfoException
         */
        get() {
            getUsedHeapSize()
        }
    }
}

/*
 * @noThrow
 */
public func getMaxHeapSize(): Int64 {
    return getMaxCjHeapSize()
}

/*
 * @noThrow
 */
public func getAllocatedHeapSize(): Int64 {
    return getAllocatedCjHeapSize()
}

/*
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

@When[backend == "cjnative"]
/*
 * @throws IllegalMemoryException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws FSException
 * @throws MemoryInfoException
 */
public func dumpHeapData(path: Path): Unit {
    try (file = File(path, ReadWrite)) {
        let success = dumpCjHeapData(Int32(file.fileDescriptor.fileHandle))
        if (!success) {
            throw MemoryInfoException("Failed to dump heap data.")
        }
    }
    return
}
