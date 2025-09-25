






package std.unittest

import std.collection.*
import std.fs.*
import std.sync.Semaphore
import std.unittest.common.*

foreign {
    func CJ_FS_IsFileORLinkToFile(path: CString): Int8

    func CJ_FS_IsDirORLinkToFDir(path: CString): Int8
}

extend<K, V> HashMap<K, V> {
    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    func getOrInsert(key: K, default: V): V {
        this.addIfAbsent(key, default)
        this.get(key).getOrThrow()
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func getOrInsert(key: K, default: () -> V): V {
        match (this.get(key)) {
            case Some(value) => value
            case None =>
                let value = default()
                this.add(key, value)
                value
        }
    }
}

extend<T> Array<T> {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    operator func +(elem: T): Array<T> {
        let tmp = ArrayList(this)
        tmp.add(elem)
        tmp.toArray()
    }
}

extend<T> Array<T> where T <: Hashable & Equatable<T> {
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func removeDuplicatesStable(): Array<T> {
        let set = HashSet<T>()
        let result = ArrayList<T>()
        for (x in this where !set.contains(x)) {
            set.add(x)
            result.add(x)
        }
        result.toArray()
    }
}

extend<T> Array<T> where T <: Equatable<T> {
    /*
     * @throws IndexOutOfBoundsException
     */
    func containsFrom(index: Int64, subseq: Array<T>): Bool {
        if (this.size < index + subseq.size) { false } else {
            this.slice(index, subseq.size) == subseq
        }
    }







    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func split(delimiter: Array<T>): Array<Array<T>> {
        let parts = ArrayList<Array<T>>()
        var idxPartStart = 0
        for (idxAfterPartEnd in 0..this.size where this.containsFrom(idxAfterPartEnd, delimiter)) {
            parts.add(this.slice(idxPartStart, idxAfterPartEnd - idxPartStart))
            idxPartStart = idxAfterPartEnd + delimiter.size
        }
        parts.add(this.slice(idxPartStart, this.size - idxPartStart))
        parts.toArray()
    }
}

extend Array<Byte> {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func split(delimiter: String): Array<Array<Byte>> {
        split(delimiter.toArray())
    }
}

extend<T> ArrayList<T> {
    /*
     * @noThrow
     */
    func find(pred: (T) -> Bool): Option<T> {
        for (e in this) {
            if (pred(e)) {
                return e
            }
        }
        None
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func pop(): ?T {
        if (size == 0) {
            None
        } else {
            remove(at: size - 1)
        }
    }
}

extend DataModelStruct {
    /*
     * @noThrow
     */
    func tryGet(key: String): ?DataModel {
        for (field in this.getFields()) {
            if (field.getName() == key) {
                return Some(field.getData())
            }
        }
        return None
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws JsonException
     */
    func toJsonString(): String {
        this.toJson().toString()
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws JsonException
     */
    func toJsonBytes(): Array<Byte> {
        this.toJsonString().toArray()
    }

    /*
     * @throws JsonException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    static func fromJsonBytes(bytes: Array<Byte>): DataModel {
        let string = String.fromUtf8(bytes)
        let json = JsonValue.fromStr(string)
        DataModelStruct.fromJson(json)
    }
}

extend DataModel {
    /*
     * @throws Exception
     */
    func asStruct(): DataModelStruct {
        (this as DataModelStruct) ?? throw Exception("this data is not DataModelStruct")
    }
}

extend File {
    /*
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     */
    static func exists(path: String): Bool {
        if (path.contains("\0")) {
            return false
        }
        unsafe {
            let cPath = LibC.mallocCString(path)
            let exists: Int8 = CJ_FS_IsFileORLinkToFile(cPath)
            LibC.free(cPath)
            return exists > 0
        }
    }
}

extend Directory {
    /*
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     */
    static func exists(path: String): Bool {
        if (path.contains("\0")) {
            return false
        }
        unsafe {
            let cPath = LibC.mallocCString(path)
            let exists: Int8 = CJ_FS_IsDirORLinkToFDir(cPath)
            LibC.free(cPath)
            return exists > 0
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     * @throws FSException
     */
    static func ensureExists(path: Path): Unit {
        if (!Directory.exists(path.toString())) {
            Directory.create(path, recursive: true)
        }
    }
}

/*
 * @noThrow
 */
func min<T>(a: T, b: T): T where T <: Comparable<T> {
    if (a > b) {
        b
    } else {
        a
    }
}

/*
 * @noThrow
 */
func max<T>(a: T, b: T): T where T <: Comparable<T> {
    if (a < b) {
        b
    } else {
        a
    }
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func mapParallelOrdered<T, V>(bufferSize: Int64, f: (T) -> V): (Iterable<T>) -> Iterator<V> {
    { iter =>
        let futuresIter = iter |> map{ x => spawn { f(x) } }
        ParallelOrderedMapIterator(bufferSize, futuresIter)
    }
}

class ParallelOrderedMapIterator<T> <: Iterator<T> {
    var futures: ArrayList<Future<T>>
    var currentIdx: Int64 = 0
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    ParallelOrderedMapIterator(let bufferSize: Int64, let iter: Iterator<Future<T>>) {
        futures = iter.take(bufferSize) |> collectArrayList
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func next(): ?T {
        let result = futures.get(currentIdx) ?? return None
        if (let Some(fut) <- iter.next()) {
            futures[currentIdx] = fut
            currentIdx += 1
        } else {
            futures.remove(at: currentIdx)
        }
        if (futures.size != 0) {
            currentIdx = currentIdx % futures.size
        }
        result.get()
    }
}

class ChainIterator<T> <: Iterator<T> {
    /*
     * @noThrow
     */
    ChainIterator(let l: Iterator<T>, let r: Iterator<T>) {}

    /*
     * @noThrow
     */
    public override func next(): Option<T> {
        l.next() ?? r.next()
    }
}

/*
 * @noThrow
 */
func chain<T>(l: Iterable<T>, r: Iterable<T>): Iterable<T> {
    ChainIterator(l.iterator(), r.iterator())
}

private class BeforeEachIterator<T> <: Iterator<T> {
    private let action: (?T) -> Unit
    private let it: Iterator<T>
    private var previous: ?T = None

    /*
     * @noThrow
     */
    public init(it: Iterator<T>, action: (previous: ?T) -> Unit) {
        this.it = it
        this.action = action
    }

    /*
     * @noThrow
     */
    public func next(): Option<T> {
        action(previous)
        previous = match (it.next()) {
            case Some(value) => Some(value)
            case _ => None
        }
        return previous
    }
}

/*
 * @noThrow
 */
func beforeEach<T>(action: (previous: ?T) -> Unit): (Iterable<T>) -> Iterator<T> {
    return { it: Iterable<T> => BeforeEachIterator(it.iterator(), action) }
}

extend Semaphore {
    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    func doWith<R>(f: () -> R): R {
        this.acquire()
        try {
            f()
        } finally {
            this.release()
        }
    }
}
