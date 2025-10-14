package std.unittest

import std.time.*
import std.env.*
import std.collection.*
import std.runtime.*

// it is created here so that we collect statistics before any of the user code is initialized
var memoryStats = MemoryStats()


class MemoryStats {
    let statsStack = ArrayList<MemoryInfo>()
    MemoryStats() {
        statsStack.add(        
            MemoryInfo(
                "",
                getAllocatedHeapSize() + getGCFreedSize(),
                getGCCount(),
                0.0
        ))
    }

    func push(name: String): MemoryInfo {
        let new = MemoryInfo.collect(name)
        let diff = new - statsStack.last.getOrThrow()
        statsStack.add(new)
        diff
    }

    func currentBaseline(): MemoryInfo {
        statsStack.last.getOrThrow()
    }

    // returns current diff from last baseline
    func updateAndDiff(from!: Int64): MemoryInfo {
        let current = MemoryInfo.collect("")
        let prev = statsStack[from]
        
        //update baseline to account for not garbage collected objects
        statsStack[statsStack.size-1] = current
        current - prev
    }

    func pop(): MemoryInfo {
        let current = MemoryInfo.collect("")
        let prev = statsStack.pop().getOrThrow()

        //update baseline to account for not garbage collected objects
        statsStack[statsStack.size-1] = current
        current - prev
    }
}

struct MemoryInfo {
    MemoryInfo(
        let name: String,
        let allocatedBytes: Int64,
        let gcInvocations: Int64,
        let gcTimeNs: Float64
    ) {}

    static func collect(name: String): MemoryInfo {
        // measure time before all because it invokes GC
        let time = measureGcTime()
        MemoryInfo(
            name,
            getAllocatedHeapSize() + getGCFreedSize(),
            getGCCount(),
            time
        )
    }

    static func measureGcTime(): Float64 {
        let gcCount = getGCCount()
        let gcTime = getGCTime()    
        gc(heavy: true) // should we do that twice to measure actual mark and copy time for persistent objects?
        while (getGCCount() <= gcCount) {}
        Float64(getGCTime() - gcTime)
    }

    operator func -(other: MemoryInfo): MemoryInfo {
        MemoryInfo(
            other.name,
            this.allocatedBytes - other.allocatedBytes,
            this.gcInvocations - other.gcInvocations,
            this.gcTimeNs - other.gcTimeNs
        )
    }
}

// Unittest static init is called before any other package init.
// So here we add some random allocations so that statically allocated objects in user code do not have 
// determenistic memory location. This allows us to check whether benchmark results 
// depend on layout of objects in memory.
let randomHeapOffset = { => 
    var r = RandomizedAlloc()
    r.fill(DateTime.now().toUnixTimeStamp().toNanoseconds())
    r
}()

struct RandomizedAlloc {
    // using Option instead of empty array because empty array does still allocate
    var pageAlloc: Option<Array<Byte>> = None
    var cacheLineAlloc: Option<Array<Byte>> = None
    var objectsAlloc: Option<Array<Object>> = None
    RandomizedAlloc() {}

    mut func clear() {
        pageAlloc = None
        cacheLineAlloc = None
        objectsAlloc = None
    }

    mut func fill(seed: Int64) {
        let cacheAllocSize = seed & 0x3f  // 64
        let pageAllocSize = seed & (0xfff-0x3f) // 4096 
        // let objects = seed & (0x7000) >> 12 // use 3 of remaining bytes

        pageAlloc = Array(pageAllocSize, repeat: 1)
        // objectsAlloc = Array(objects, { _ => Object()})
        cacheLineAlloc = Array(cacheAllocSize, repeat: 1)

    }
}