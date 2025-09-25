







package std.core

class ThreadLocalKey <: Hashable {
    static const ALPHA = 0x61c8864680b583eb
    static let CURR = AtomicInt64(0)
    static func nextHash(): Int64 {
        return CURR.fetchAdd(ALPHA)
    }

    let code: Int64 = nextHash()

    func equals(another: ThreadLocalKey): Bool {
        return code == another.hashCode()
    }

    public func hashCode(): Int64 {
        return code
    }
}

let EMPTY_KEY = ThreadLocalKey()
let DELETED_KEY = ThreadLocalKey()


public class ThreadLocal<T> {
    let key: ThreadLocalKey = ThreadLocalKey()


    public func get(): ?T {
        let map: ThreadLocalMap = getThreadLocalMap()
        return map.get(tlKey: key)
    }




    public func set(value: ?T): Unit {
        let map: ThreadLocalMap = getThreadLocalMap()
        match (value) {
            case Some(v) => map.set(tlKey: key, value: v)
            case None => map.remove(tlKey: key)
        }
    }
}

func getThreadLocalMap(): ThreadLocalMap {
    return match (Thread.currentThread._threadLocalMap) {
        case Some(map) => map
        case None =>
            let map = ThreadLocalMap()
            Thread.currentThread._threadLocalMap = map
            map
    }
}

struct Entry {
    let tlKey: ThreadLocalKey
    let boxedValue: Object

    init(k: ThreadLocalKey, v: Object) {
        tlKey = k
        boxedValue = v
    }

    func isValid(): Bool {
        return !tlKey.equals(EMPTY_KEY) && !tlKey.equals(DELETED_KEY)
    }
}

let EMPTY_ENTRY = Entry(EMPTY_KEY, EMPTY_KEY)
let DELETED_ENTRY = Entry(DELETED_KEY, DELETED_KEY)

class ThreadLocalMap {
    private static let DEFAULT_CAPACITY: Int64 = 16

    var entries: Array<Entry>
    var size: Int64 = 0

    init() {
        entries = Array<Entry>(DEFAULT_CAPACITY, repeat: EMPTY_ENTRY)
    }

    func get<T>(tlKey!: ThreadLocalKey): Option<T> {
        return match (findEntry(tlKey)) {
            case Some(index) => (entries[index].boxedValue as Box<T>).getOrThrow()
                .value
            case None => None
        }
    }

    func set<T>(tlKey!: ThreadLocalKey, value!: T): Unit {
        let index = findIndexToInsert(tlKey, entries)
        if (entries[index].tlKey.equals(EMPTY_ENTRY.tlKey)) {
            size += 1
        }
        entries[index] = Entry(tlKey, Box<T>(value))
        if (needResize()) {
            resize()
        }
    }

    func remove(tlKey!: ThreadLocalKey): Unit {
        if (let Some(index) <- findEntry(tlKey)) {
            entries[index] = DELETED_ENTRY
        }
    }
    private func findEntry(tlKey: ThreadLocalKey): Option<Int64> {
        var index = tlKey.hashCode() & (entries.size - 1)
        while (true) {
            let entry = entries[index]
            if (entry.tlKey.equals(EMPTY_ENTRY.tlKey)) {
                return None
            }
            if (tlKey.equals(entry.tlKey)) {
                return Some(index)
            } else {
                index = (index + 1) & (entries.size - 1)
            }
        }
        return None
    }

    private func findIndexToInsert(tlKey: ThreadLocalKey, arr: Array<Entry>): Int64 {
        var index = tlKey.hashCode() & (arr.size - 1)
        while (true) {
            let entry = arr[index]
            if (!entry.isValid()) {
                return index
            }
            if (tlKey.equals(entry.tlKey)) {
                return index
            } else {
                index = (index + 1) & (arr.size - 1)
            }
        }
        return -1
    }


    private func needResize(): Bool {
        let threshold = (entries.size * 3) >> 2
        return size > threshold
    }


    private func resize(): Unit {
        let newCapacity = entries.size << 1
        let newEntries = Array<Entry>(newCapacity, repeat: EMPTY_ENTRY)

        var validEntryCount = 0

        for (i in 0..entries.size) {
            let entry = entries[i]
            if (entry.isValid()) {
                let index = findIndexToInsert(entry.tlKey, newEntries)
                newEntries[index] = entry
                validEntryCount += 1
            }
        }

        size = validEntryCount
        entries = newEntries
    }
}
