









package std.collection

struct HashMapEntry<K, V> {
    public let hash: Int64
    public let next: Int64
    public let key: K
    public let value: V

    @Frozen
    init(h: Int64, n: Int64, k: K, v: V) {
        hash = h
        next = n
        key = k
        value = v
    }

    @Frozen
    init() {
        hash = -1
        next = -1
        key = unsafe { zeroValue<K>() }
        value = unsafe { zeroValue<V>() }
    }
}




class HashMapKeys<K, V> <: EquatableCollection<K> where K <: Hashable & Equatable<K> {
    private let map: HashMap<K, V>

    @Frozen
    init(m: HashMap<K, V>) {
        map = m
    }






    @Frozen
    public prop size: Int64 {
        get() {
            return map.size
        }
    }






    @Frozen
    public func isEmpty(): Bool {
        return map.isEmpty()
    }







    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func contains(element: K): Bool {
        return map.contains(element)
    }







    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func contains(all!: Collection<K>): Bool {
        return map.contains(all: all)
    }






    @Frozen
    public func iterator(): Iterator<K> {
        return map.iterator().map<K> {i: (K, V) => i[0]}
    }


    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func toArray(): Array<K> {
        let keys = Array<K>(size, repeat: unsafe { zeroValue<K>() })
        var index = 0
        var pos = 0
        while (index < size) {
            if (map.entries[pos].hash >= 0) {
                keys[index] = map.entries[pos].key
                index++
            }
            pos++
        }
        return keys
    }
}




class HashMapValues<K, V> <: Collection<V> where K <: Hashable & Equatable<K> {
    private let map: HashMap<K, V>

    @Frozen
    init(m: HashMap<K, V>) {
        map = m
    }






    @Frozen
    public prop size: Int64 {
        get() {
            return map.size
        }
    }






    @Frozen
    public func isEmpty(): Bool {
        return map.isEmpty()
    }






    @Frozen
    public func iterator(): Iterator<V> {
        return map.iterator().map<V> {i: (K, V) => i[1]}
    }


    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func toArray(): Array<V> {
        let values = Array<V>(size, repeat: unsafe { zeroValue<V>() })
        var index = 0
        var pos = 0
        while (index < size) {
            if (map.entries[pos].hash >= 0) {
                values[index] = map.entries[pos].value
                index++
            }
            pos++
        }
        return values
    }
}



class HashMapEntryView<K, V> <: MapEntryView<K, V> where K <: Hashable & Equatable<K> {
    private let map: HashMap<K, V>
    private let _key: K
    private let hash: Int64
    private var index: Int64

    private var _isAbsent: Bool
    private var lockVersion: Int64

    @Frozen
    init(isAbsent: Bool, key: K, hash: Int64, index: Int64, map: HashMap<K, V>) {
        this._isAbsent = isAbsent
        this._key = key
        this.hash = hash
        this.map = map
        this.index = index
        this.lockVersion = map.version()
    }

        /**
         * @throws ConcurrentModificationException
         */
    @Frozen
    public prop key: K {
        get() {
            getKey()
        }
    }

    /**
     * @throws [set] IllegalArgumentException
     * @throws [set] NoneValueException
     * @throws [get|set] ConcurrentModificationException
     * @throws [get|set] IndexOutOfBoundsException
     */
    @Frozen
    public mut prop value: ?V {
        get() {
            getValue()
        }
        set(value) {
            return if (value.isNone()) {
                map.remove(_key)
                _isAbsent = true
            } else {
                setValue(value.getOrThrow())
            }
        }
    }






    /**
     * @throws ConcurrentModificationException
     */
    @Frozen
    func getKey(): K {
        if (lockVersion != map.version()) {
            throw ConcurrentModificationException()
        }
        return _key
    }






    /**
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    @Frozen
    func getValue(): ?V {
        if (lockVersion != map.version()) {
            throw ConcurrentModificationException()
        }
        return if (_isAbsent) {
            None
        } else {
            map.entries[index].value
        }
    }







    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    @Frozen
    private func setValue(v: V) {
        if (lockVersion != map.version()) {
            throw ConcurrentModificationException()
        }
        if (_isAbsent) {
            var bucketIndex: Int64 = map.getIndex(hash, map.buckets.size)
            if (map.freeSize > 0) {
                index = map.freeIndex
                map.freeIndex = map.entries[index].next
                map.freeSize--
            } else {
                if (map.resize(map.size + 1)) {
                    bucketIndex = map.getIndex(hash, map.buckets.size)
                }
                index = map.appendIndex
                map.appendIndex++
            }
            map.entries[index] = HashMapEntry<K, V>(hash, map.buckets[bucketIndex], key, v)
            map.modCount++
            map.buckets[bucketIndex] = index
            lockVersion = map.modCount
            _isAbsent = false
        } else {
            let temp = map.entries[index]
            map.entries[index] = HashMapEntry<K, V>(temp.hash, temp.next, temp.key, v)
        }
    }
}





public class HashMap<K, V> <: Map<K, V> where K <: Hashable & Equatable<K> {

    
    private static const MAX_BUCKET_SIZE: Int64 = 4611686018427387904



    private static const LOAD_FACTOR: Float32 = 0.75



    private static const DEFAULT_CAPACITY: Int64 = 16

    
    
    var appendIndex: Int64 = 0

    
    var freeIndex: Int64 = -1

    
    var freeSize: Int64 = 0

    
    var modCount: Int64 = 0b00000000

    
    var buckets: Array<Int64>

    
    var entries: Array<HashMapEntry<K, V>>




    @Frozen
    public init() {
        buckets = Array<Int64>(DEFAULT_CAPACITY, repeat: -1)
        entries = Array<HashMapEntry<K, V>>(
            DEFAULT_CAPACITY,
            repeat: HashMapEntry<K, V>()
        )
    }






    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public init(elements: Collection<(K, V)>) {
        let bucketSize: Int64 = elements.size + (elements.size >> 1)
        buckets = Array<Int64>(tableSizeFor(bucketSize), repeat: -1)
        entries = Array<HashMapEntry<K, V>>(elements.size, repeat: HashMapEntry<K, V>())
        for (i in elements) {
            putWithoutResize(i[0], i[1])
        }
    }






    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public init(elements: Array<(K, V)>) {
        let bucketSize: Int64 = elements.size + (elements.size >> 1)
        buckets = Array<Int64>(tableSizeFor(bucketSize), repeat: -1)
        entries = Array<HashMapEntry<K, V>>(elements.size, repeat: HashMapEntry<K, V>())
        for (i in elements) {
            putWithoutResize(i[0], i[1])
        }
    }








    /**
     * @throws IllegalArgumentException
     */
    @Frozen
    public init(capacity: Int64) {
        if (capacity < 0) {
            throw IllegalArgumentException("Invalid size of HashMap: ${capacity}.")
        }
        let bucketSize = capacity + (capacity >> 1)
        buckets = Array<Int64>(tableSizeFor(bucketSize), repeat: -1)
        entries = Array<HashMapEntry<K, V>>(capacity, repeat: HashMapEntry<K, V>())
    }









    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    @Frozen
    public init(size: Int64, initElement: (Int64) -> (K, V)) {
        if (size < 0) {
            throw IllegalArgumentException("Invalid size of HashMap: ${size}.")
        } else {
            buckets = Array<Int64>(tableSizeFor(size), repeat: -1)
            entries = Array<HashMapEntry<K, V>>(size, repeat: HashMapEntry<K, V>())
            for (i in 0..size) {
                let element: (K, V) = initElement(i)
                add(element[0], element[1])
            }
        }
    }

    @Frozen
    private init(other: HashMap<K, V>) {
        buckets = other.buckets.clone()
        entries = other.entries.clone()
        appendIndex = other.appendIndex
        freeIndex = other.freeIndex
        freeSize = other.freeSize
    }







    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func get(key: K): ?V {
        let hash: Int64 = getHash(key.hashCode())
        let index: Int64 = getIndex(hash, buckets.size)
        var bucket: Int64 = buckets[index]
        while (bucket >= 0) {
            if (hash == entries[bucket].hash && key == entries[bucket].key) {
                return entries[bucket].value
            }
            bucket = entries[bucket].next
        }
        return None
    }










    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    @OverflowWrapping
    public func add(key: K, value: V): Option<V> {
        let hash: Int64 = getHash(key.hashCode())
        var bucketIndex: Int64 = getIndex(hash, buckets.size)
        var entryIndex: Int64 = buckets[bucketIndex]
        while (entryIndex >= 0) {
            if (hash == entries[entryIndex].hash && key == entries[entryIndex].key) {
                let oldValue: Option<V> = Some(entries[entryIndex].value)
                entries[entryIndex] = HashMapEntry<K, V>(entries[entryIndex].hash, entries[entryIndex].next,
                    entries[entryIndex].key, value)
                return oldValue
            }
            entryIndex = entries[entryIndex].next
        }
        if (freeSize > 0) {
            entryIndex = freeIndex
            freeIndex = entries[entryIndex].next
            freeSize--
        } else {
            if (resize(size + 1)) {
                bucketIndex = getIndex(hash, buckets.size)
            }
            entryIndex = appendIndex
            appendIndex++
        }

        entries[entryIndex] = HashMapEntry<K, V>(hash, buckets[bucketIndex], key, value)
        modCount++
        buckets[bucketIndex] = entryIndex
        return Option<V>.None
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    @OverflowWrapping
    protected func putWithoutResize(key: K, value: V): Unit {
        let hash: Int64 = getHash(key.hashCode())
        var bucketIndex: Int64 = getIndex(hash, buckets.size)
        var entryIndex: Int64 = buckets[bucketIndex]
        while (entryIndex >= 0) {
            if (hash == entries[entryIndex].hash && key == entries[entryIndex].key) {
                entries[entryIndex] = HashMapEntry<K, V>(entries[entryIndex].hash, entries[entryIndex].next,
                    entries[entryIndex].key, value)
                return
            }
            entryIndex = entries[entryIndex].next
        }

        entryIndex = appendIndex
        appendIndex++

        entries[entryIndex] = HashMapEntry<K, V>(hash, buckets[bucketIndex], key, value)
        modCount++
        buckets[bucketIndex] = entryIndex
    }







    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func entryView(key: K): MapEntryView<K, V> {
        let hash: Int64 = getHash(key.hashCode())
        var index: Int64 = getIndex(hash, buckets.size)
        var entryIndex: Int64 = buckets[index]
        while (entryIndex >= 0) {
            if (hash == entries[entryIndex].hash && key == entries[entryIndex].key) {
                return HashMapEntryView<K, V>(false, key, hash, entryIndex, this)
            }
            entryIndex = entries[entryIndex].next
        }
        return HashMapEntryView<K, V>(true, key, hash, entryIndex, this)
    }







    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func add(all!: Collection<(K, V)>): Unit {
        if (all.size > entries.size) {
            resize(all.size)
        }
        for ((k, v) in all) {
            add(k, v)
        }
    }







    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    @OverflowWrapping
    public func remove(key: K): Option<V> {
        let NULL_KEY: K = unsafe { zeroValue<K>() }
        let NULL_VALUE: V = unsafe { zeroValue<V>() }
        let hash: Int64 = getHash(key.hashCode())
        let index: Int64 = getIndex(hash, buckets.size)
        var bucket: Int64 = buckets[index]
        var pre: Int64 = -1
        while (bucket >= 0) {
            if (hash == entries[bucket].hash && key == entries[bucket].key) {
                if (pre < 0) {
                    buckets[index] = entries[bucket].next
                } else {
                    let temp = entries[pre]
                    entries[pre] = HashMapEntry<K, V>(temp.hash, entries[bucket].next, temp.key, temp.value)
                }
                let removeEnt: V = entries[bucket].value
                entries[bucket] = HashMapEntry<K, V>(-1, freeIndex, NULL_KEY, NULL_VALUE)
                freeIndex = bucket
                freeSize++
                modCount++
                return Some(removeEnt)
            }
            pre = bucket
            bucket = entries[bucket].next
        }
        return None
    }






    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func remove(all!: Collection<K>): Unit {
        for (key in all) {
            remove(key)
        }
    }






    /**
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    @Frozen
    @OverflowWrapping
    public func removeIf(predicate: (K, V) -> Bool): Unit {
        let NULL_KEY: K = unsafe { zeroValue<K>() }
        let NULL_VALUE: V = unsafe { zeroValue<V>() }
        var lockVersion = modCount
        for (i in 0..buckets.size where buckets[i] != -1) {
            var next: Int64 = buckets[i]
            var pre: Int64 = -1
            while (next >= 0) {
                let item = entries[next]
                if (predicate(item.key, item.value)) {
                    if (lockVersion != modCount) {
                        throw ConcurrentModificationException("The predicate cannot contain a modify operation.")
                    }
                    if (pre < 0) {
                        buckets[i] = item.next
                    } else {
                        let temp = entries[pre]
                        entries[pre] = HashMapEntry<K, V>(temp.hash, item.next, temp.key, temp.value)
                    }
                    entries[next] = HashMapEntry<K, V>(-1, freeIndex, NULL_KEY, NULL_VALUE)
                    freeIndex = next
                    freeSize++
                    modCount++
                    lockVersion++
                } else {
                    if (lockVersion != modCount) {
                        throw ConcurrentModificationException("The predicate cannot contain a modify operation.")
                    }
                    pre = next
                }
                next = item.next
            }
        }
    }




    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    @OverflowWrapping
    public func clear(): Unit {
        for (i in 0..entries.size where entries[i].hash >= 0) {
            entries[i] = HashMapEntry<K, V>()
        }

        for (i in 0..buckets.size where buckets[i] != -1) {
            buckets[i] = -1
        }

        modCount++
        freeIndex = -1
        appendIndex = 0
        freeSize = 0
    }








    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func reserve(additional: Int64): Unit {
        if (additional <= 0 || size + additional < capacity) {
            return
        }

        resize(size + additional)
        modCount++
    }







    @Frozen
    public prop capacity: Int64 {
        get() {
            return entries.size
        }
    }







    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func contains(all!: Collection<K>): Bool {
        for (key in all where !contains(key)) {
            return false
        }
        return true
    }







    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func contains(key: K): Bool {
        if (appendIndex - freeSize == 0) {
            return false
        }
        let hash: Int64 = getHash(key.hashCode())
        let index: Int64 = getIndex(hash, buckets.size)
        var bucket: Int64 = buckets[index]
        while (bucket >= 0) {
            if (hash == entries[bucket].hash && key == entries[bucket].key) {
                return true
            }
            bucket = entries[bucket].next
        }
        return false
    }






    @Frozen
    public func clone(): HashMap<K, V> {
        return HashMap<K, V>(this)
    }






    @Frozen
    public func keys(): EquatableCollection<K> {
        return HashMapKeys<K, V>(this)
    }






    @Frozen
    public func values(): Collection<V> {
        return HashMapValues<K, V>(this)
    }









    /**
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    @Frozen
    public operator func [](key: K): V {
        return match (get(key)) {
            case None => throw NoneValueException("Value does not exist!\n")
            case Some(val) => val
        }
    }







    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public operator func [](key: K, value!: V): Unit {
        add(key, value)
    }









    @Frozen
    @OverflowWrapping
    func getIndex(hash: Int64, size: Int64): Int64 {
        return hash & (size - 1)
    }







    @Frozen
    @OverflowWrapping
    private func getHash(hashCode: Int64): Int64 {
        hashCode ^ (hashCode >> 32)
    }






    @Frozen
    public prop size: Int64 {
        get() {
            return appendIndex - freeSize
        }
    }






    @Frozen
    public func iterator(): HashMapIterator<K, V> {
        return HashMapIterator<K, V>(this)
    }






    @Frozen
    public func isEmpty(): Bool {
        return (appendIndex - freeSize) == 0
    }






    @Frozen
    func version(): Int64 {
        return modCount
    }

    @Frozen
    private func max(l: Int64, r: Int64) {
        return if (l >= r) {
            l
        } else {
            r
        }
    }


    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func toArray(): Array<(K, V)> {
        let arr = Array<(K, V)>(size, repeat: unsafe { (zeroValue<K>(), zeroValue<V>()) })
        var index = 0
        var pos = 0
        while (index < size) {
            if (entries[pos].hash >= 0) {
                arr[index] = (entries[pos].key, entries[pos].value)
                index++
            }
            pos++
        }
        return arr
    }







    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    @OverflowWrapping
    func resize(argCap: Int64): Bool {
        var isRehash: Bool = false
        let oldBucketsSize = buckets.size
        let allowedBucketSize = Int64(Float32(oldBucketsSize) * LOAD_FACTOR)
        if (argCap >= allowedBucketSize) {
            let newCapOfBuckets = max(oldBucketsSize << 1, tableSizeFor(argCap))
            let newBuckets: Array<Int64> = Array<Int64>(newCapOfBuckets, repeat: -1)
            for (i in 0..entries.size) {
                if (entries[i].hash >= 0) {
                    let bucket: Int64 = getIndex(entries[i].hash, newCapOfBuckets)
                    entries[i] = HashMapEntry<K, V>(entries[i].hash, newBuckets[bucket], entries[i].key,
                        entries[i].value)
                    newBuckets[bucket] = i
                }
            }
            buckets = newBuckets
            isRehash = true
        }
        if (argCap > entries.size) {
            let oldEntriesSize = entries.size
            let newCapOfEntries = max(oldEntriesSize + (oldEntriesSize >> 1), argCap)
            let newEntries = Array<HashMapEntry<K, V>>(
                newCapOfEntries,
                repeat: HashMapEntry<K, V>()
            )
            entries.copyTo(newEntries, 0, 0, oldEntriesSize)
            entries = newEntries
        }
        return isRehash
    }






    @Frozen
    private static func tableSizeFor(cap: Int64): Int64 {
        if (cap <= DEFAULT_CAPACITY) {
            return DEFAULT_CAPACITY
        }
        if (cap < MAX_BUCKET_SIZE) {
            var n: Int64 = cap - 1
            n |= n >> 1
            n |= n >> 2
            n |= n >> 4
            n |= n >> 8
            n |= n >> 16
            n |= n >> 32
            return n + 1
        } else {
            return MAX_BUCKET_SIZE
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    func removePosition(hash: Int64, pos: Int64) {
        let index: Int64 = getIndex(hash, buckets.size)
        var bucket: Int64 = buckets[index]
        var pre: Int64 = -1
        while (bucket != pos) {
            pre = bucket
            bucket = entries[bucket].next
        }
        if (pre < 0) {
            buckets[index] = entries[pos].next
        } else {
            entries[pre] = HashMapEntry<K, V>(entries[pre].hash, entries[pos].next, entries[pre].key, entries[pre].value)
        }
        entries[pos] = HashMapEntry<K, V>(-1, freeIndex, unsafe { zeroValue<K>() }, unsafe { zeroValue<V>() })
        freeIndex = bucket
        freeSize++
        modCount++
    }
}




extend<K, V> HashMap<K, V> <: ToString where V <: ToString, K <: ToString {
    /**
     * @throws ConcurrentModificationException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    @Frozen
    public func toString(): String {
        if (size == 0) {
            return "[]"
        }
        let sb = StringBuilder("[")
        let it = iterator()
        var tmp: (K, V) = it.next().getOrThrow()
        while (let Some(next) <- it.next()) {
            sb.append(r'(')
            sb.append(tmp[0])
            unsafe { sb.appendFromUtf8Unchecked(", ".toArray()) }
            sb.append(tmp[1])
            unsafe { sb.appendFromUtf8Unchecked("), ".toArray()) }
            tmp = next
        }
        sb.append(r'(')
        sb.append(tmp[0])
        unsafe { sb.appendFromUtf8Unchecked(", ".toArray()) }
        sb.append(tmp[1])
        unsafe { sb.appendFromUtf8Unchecked(")]".toArray()) }
        return sb.toString()
    }
}






extend<K, V> HashMap<K, V> <: Equatable<HashMap<K, V>> where V <: Equatable<V> {
    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public operator func ==(right: HashMap<K, V>): Bool {
        if (refEq(this, right)) {
            return true
        }
        if (size != right.size) {
            return false
        }
        for ((leftKey, leftValue) in this) {
            var a = match (right.get(leftKey)) {
                case Some(v) => v
                case None => return false
            }
            if (a != leftValue) {
                return false
            }
        }
        return true
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public operator func !=(right: HashMap<K, V>): Bool {
        if (size != right.size) {
            return true
        }
        for ((leftKey, leftValue) in this) {
            var a = match (right.get(leftKey)) {
                case Some(v) => v
                case None => return true
            }
            if (a != leftValue) {
                return true
            }
        }
        return false
    }
}




public class HashMapIterator<K, V> <: Iterator<(K, V)> where K <: Hashable & Equatable<K> {
    
    private var lockVersion: Int64
    private var index: Int64
    private let data: HashMap<K, V>
    private var isRemoved: Bool






    @Frozen
    public init(map: HashMap<K, V>) {
        isRemoved = true
        data = map
        lockVersion = map.version()
        index = -1
    }








    /**
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    @Frozen
    public func next(): ?(K, V) {
        if (lockVersion != data.version()) {
            throw ConcurrentModificationException()
        }
        let size: Int64 = data.entries.size
        do {
            index++
        } while (index < size && data.entries[index].hash < 0)
        if (index >= size) {
            return Option<(K, V)>.None
        }
        isRemoved = false
        return Some((data.entries[index].key, data.entries[index].value))
    }












    /**
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    @Frozen
    public func remove(): Option<(K, V)> {
        if (lockVersion != data.version()) {
            throw ConcurrentModificationException()
        }
        if (isRemoved || data.size <= 0 || index >= data.entries.size || data.entries[index].hash < 0) {
            return None<(K, V)>
        }
        let item = data.entries[index]
        data.removePosition(item.hash, index)
        isRemoved = true
        lockVersion = data.version()
        return Some((item.key, item.value))
    }
}
