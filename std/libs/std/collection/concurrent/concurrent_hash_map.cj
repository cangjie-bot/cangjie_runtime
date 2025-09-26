







package std.collection.concurrent

import std.sync.*
import std.collection.MapEntryView





type KeyValue<K, V> = (Int64, K, V)



class KVList<K, V> where K <: Equatable<K> {
    var myData: Array<KeyValue<K, V>>
    var mySize: Int64







    static const INIT_ARRAY_SIZE = 2

    init() {
        this(INIT_ARRAY_SIZE)
    }

    init(capacity: Int64) {
        mySize = 0
        let zero: KeyValue<K, V> = unsafe { zeroValue<KeyValue<K, V>>() }
        myData = Array<KeyValue<K, V>>(capacity, repeat: zero)
    }

    init(blist: KVList<K, V>) {
        myData = blist.myData.clone()
        mySize = blist.mySize
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    @OverflowWrapping
    func contains(hash: Int64, key: K): Int64 {
        var i = 0
        while (i < mySize) {
            if (hash == myData[i][0] && key == myData[i][1]) {
                return i
            }
            i++
        }
        return -1
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    @OverflowWrapping
    func find(hash: Int64, key: K): ?V {
        var i = 0
        while (i < mySize) {
            if (hash == myData[i][0] && key == myData[i][1]) {
                return myData[i][2]
            }
            i++
        }
        return None
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    @OverflowWrapping
    func copyInsert(hash: Int64, key: K, value: V): KVList<K, V> {
        let copyList = KVList<K, V>(this)
        if (mySize == myData.size) {
            copyList.grow()
        }
        copyList.myData[mySize] = (hash, key, value)
        copyList.mySize++
        return copyList
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func copyPut(hash: Int64, key: K, value: V): (KVList<K, V>, ?V) {
        let i = contains(hash, key)
        if (i == -1) {
            return (copyInsert(hash, key, value), None)
        } else {
            let copyList = KVList<K, V>(this)
            copyList.myData[i] = (hash, key, value)
            return (copyList, myData[i][2])
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func copyRemove(hash: Int64, key: K, predicate: (V) -> Bool): (KVList<K, V>, ?V) {
        let i = contains(hash, key, predicate)
        if (i == -1) {
            return (this, None)
        }

        let copyList = copyRemoveUnChecked(i)
        return (copyList, myData[i][2])
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func copyRemoveUnChecked(idx: Int64): KVList<K, V> {
        let copyList = KVList<K, V>(this)
        var i = idx
        while (i + 1 < copyList.mySize) {
            copyList.myData[i] = copyList.myData[i + 1]
            i++
        }
        copyList.mySize--
        return copyList
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func copyReplace(hash: Int64, key: K, predicate: (V) -> Bool, eval: (V) -> V): (KVList<K, V>, ?V) {
        let i = contains(hash, key, predicate)
        if (i == -1) {
            return (this, None)
        }

        let copyList = KVList<K, V>(this)
        copyList.myData[i] = (hash, key, eval(copyList.myData[i][2]))
        return (copyList, myData[i][2])
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func copyEntryView(hash: Int64, key: K, fn: (entryView: MapEntryView<K, V>) -> Unit): (KVList<K, V>, ?V, ?Int64) {
        let i = contains(hash, key)
        var entryView = if (i == -1) {
            ConcurrentHashMapEntryView<K, V>(key, None)
        } else {
            ConcurrentHashMapEntryView<K, V>(key, myData[i][2])
        }

        fn(entryView)

        match ((i == -1, entryView.value)) {
            case (true, None) => return (this, None, None)
            case (true, Some(v)) => return (copyInsert(hash, key, v), v, 1)
            case (false, None) => return (copyRemoveUnChecked(i), None, -1)
            case (false, Some(v)) =>
                if (!entryView.update) {
                    return (this, v, None)
                }
                let copyList = KVList<K, V>(this)
                copyList.myData[i] = (hash, key, v)
                return (copyList, v, None)
        }
    }


    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    func migrate(mask: Int64, index: Int64): KVList<K, V> {
        let copyList = KVList<K, V>()
        var i = 0
        while (i < mySize) {
            if ((myData[i][0] & mask) == index) {
                copyList.append(myData[i])
            }
            i++
        }
        return copyList
    }

    prop size: Int64 {
        get() {
            mySize
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    operator func [](index: Int64): KeyValue<K, V> {
        myData[index]
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    func appendUncheck(element: KeyValue<K, V>) {
        myData[mySize] = element
        mySize++
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func grow(): Unit {
        let oldCapacity: Int64 = myData.size
        var newCapacity: Int64 = oldCapacity + (oldCapacity >> 1)
        let zero: KeyValue<K, V> = unsafe { zeroValue<KeyValue<K, V>>() }
        let newArr = Array<KeyValue<K, V>>(newCapacity, repeat: zero)
        myData.copyTo(newArr, 0, 0, mySize)
        myData = newArr
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    private func append(element: KeyValue<K, V>) {
        if (mySize == myData.size) {
            grow()
        }
        myData[mySize] = element
        mySize++
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    private func contains(hash: Int64, key: K, predicate: (V) -> Bool): Int64 {
        var i = 0
        while (i < mySize) {
            if (hash == myData[i][0] && key == myData[i][1] && predicate(myData[i][2])) {
                return i
            }
            i++
        }
        return -1
    }
}





enum FindKey<V> {
    | FIND(V)
    | NotFind
    | NotMigrate
}

struct Bucket<K, V> where K <: Equatable<K> {


    let atomic_ref_entries = AtomicOptionReference(None<KVList<K, V>>)


    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    func find(hash: Int64, key: K): FindKey<V> {
        if (let Some(entries) <- refList()) {
            if (let Some(v) <- entries.find(hash, key)) {
                return FIND(v)
            }
            return NotFind
        }
        return NotMigrate
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func copyAddIfAbsent(hash: Int64, key: K, value: V): ?V {
        if (let Some(entries) <- refList()) {
            if (let Some(v) <- entries.find(hash, key)) {
                return v
            }
            let copyEntries = entries.copyInsert(hash, key, value)
            atomic_ref_entries.store(copyEntries)
        } else {
            let copyEntries = KVList<K, V>()
            copyEntries.appendUncheck((hash, key, value))
            atomic_ref_entries.store(copyEntries)
        }
        return None
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func copyPut(hash: Int64, key: K, value: V): ?V {
        var copyEntries: KVList<K, V>
        var ret = None<V>
        if (let Some(entries) <- refList()) {
            (copyEntries, ret) = entries.copyPut(hash, key, value)
            atomic_ref_entries.store(copyEntries)
        } else {
            copyEntries = KVList<K, V>()
            copyEntries.appendUncheck((hash, key, value))
            atomic_ref_entries.store(copyEntries)
        }
        return ret
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func copyRemove(hash: Int64, key: K, predicate: (V) -> Bool): ?V {
        if (let Some(entries) <- refList()) {
            let (copyEntries, ret) = entries.copyRemove(hash, key, predicate)
            atomic_ref_entries.store(copyEntries)
            return ret
        }
        return None
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func copyReplace(hash: Int64, key: K, predicate: (V) -> Bool, eval: (V) -> V): ?V {
        if (let Some(entries) <- refList()) {
            let (copyEntries, ret) = entries.copyReplace(hash, key, predicate, eval)
            atomic_ref_entries.store(copyEntries)
            return ret
        }
        return None
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func copyEntryView(hash: Int64, key: K, fn: (entryView: MapEntryView<K, V>) -> Unit): (?V, ?Int64) {
        let entries = match (refList()) {
            case Some(es) => es
            case None => KVList<K, V>()
        }
        let (copyEntries, value, resize) = entries.copyEntryView(hash, key, fn)
        atomic_ref_entries.store(copyEntries)
        return (value, resize)
    }


    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func migrate(optEntries: ?KVList<K, V>, mask: Int64, index: Int64): Unit {
        if (refList().isSome()) {
            return
        }

        if (let Some(entries) <- optEntries) {
            let copyEntries = entries.migrate(mask, index)
            atomic_ref_entries.store(copyEntries)
        }
    }

    func refList(): ?KVList<K, V> {
        return atomic_ref_entries.load()
    }
}


class MutexLockGroup {
    let mutexes: Array<Mutex>
    private let mod: Int64

    /**
     * @throws IllegalSynchronizationStateException
     */
    init(cap: Int64) {
        mutexes = Array<Mutex>(cap, {_ => Mutex()})
        mod = cap - 1
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func lock(index: Int64): Unit {
        mutexes[(index & mod)].lock()
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func tryLock(index: Int64): Bool {
        mutexes[(index & mod)].tryLock()
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    func unlock(index: Int64): Unit {
        mutexes[(index & mod)].unlock()
    }
}



class HNode<K, V> where K <: Hashable & Equatable<K> {
    
    let buckets: Array<Bucket<K, V>>
    
    var freezeFlags: Array<Bool>
    let lockG: MutexLockGroup
    let version: Int64
    let migratingIndex = AtomicInt64(0)
    let migratedIndex = AtomicInt64(0)



    let pre: AtomicOptionReference<HNode<K, V>>

    /**
     * @throws IndexOutOfBoundsException
     */
    init(capacity: Int64, refPre: ?HNode<K, V>, lockG: MutexLockGroup, version: Int64) {
        let zero = unsafe { zeroValue<Bucket<K, V>>() }
        buckets = Array<Bucket<K, V>>(capacity, repeat: zero)
        for (i in 0..capacity) {
            buckets[i] = Bucket<K, V>()
        }
        freezeFlags = Array<Bool>(capacity, repeat: false)
        this.lockG = lockG
        this.version = version
        this.pre = AtomicOptionReference(refPre)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    func freeze(index: Int64) {
        lockG.lock(index)
        freezeFlags[index] = true
        lockG.unlock(index)
    }


    /**
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    @Frozen
    func getValue(hash: Int64, key: K): Option<V> {
        let index = hash & (buckets.size - 1)







        match (buckets[index].find(hash, key)) {
            case FIND(v) => return Some(v)
            case NotFind => return None<V>
            case NotMigrate =>
                if (let Some(preHT) <- pre.load()) {
                    return match (preHT.buckets[hash & (preHT.buckets.size - 1)].find(hash, key)) {
                        case FIND(v) => Some(v)
                        case _ => None<V>
                    }
                }
                return None<V>
        }
    }


    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    @OverflowWrapping
    func migrate(start: Int64, end: Int64, step: Int64): Unit {
        if (let Some(preHT) <- pre.load()) {
            lockG.lock(start)
            for (index in start..end : step) {
                if (buckets[index].refList().isSome()) {
                    continue
                }
                let preIndex = index & (preHT.buckets.size - 1)
                preHT.freeze(preIndex)
                buckets[index].migrate(preHT.buckets[preIndex].refList(), buckets.size - 1, index)
            }
            lockG.unlock(start)
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    func tryGetBucket(index: Int64): Bool {
        lockG.lock(index)
        if (freezeFlags[index]) {
            lockG.unlock(index)
            return false
        }

        if (buckets[index].refList().isSome()) {
            return true
        }

        if (let Some(preHT) <- pre.load()) {
            let preIndex = index & (preHT.buckets.size - 1)
            preHT.freeze(preIndex)
            buckets[index].migrate(preHT.buckets[preIndex].refList(), buckets.size - 1, index)
        }

        return true
    }
}

class ConcurrentHashMapEntryView<K, V> <: MapEntryView<K, V> {
    let _key: K
    var _value: ?V
    var update: Bool = false

    ConcurrentHashMapEntryView(key: K, value: ?V) {
        this._key = key
        this._value = value
    }

    public prop key: K {
        get() {
            key
        }
    }

    public mut prop value: ?V {
        get() {
            _value
        }
        set(val) {
            this.update = true
            this._value = val
        }
    }
}






public class ConcurrentHashMap<K, V> <: ConcurrentMap<K, V> & Collection<(K, V)> where K <: Hashable & Equatable<K> {
    
    private static const DEFAULT_CAPACITY: Int64 = 16

    
    private static const MAX_SIZE: Int64 = 4611686018427387904




    private static const DEFAULT_CONCUR_LEVEL: Int64 = 16

    
    private let counts = Array<AtomicInt64>(1 << COUNT_SIZE, {_ => AtomicInt64(0)})
    
    private static const COUNT_SIZE = 4

    
    let curHNodeVersion = AtomicInt64(0)

    
    let head: AtomicReference<HNode<K, V>>

    
    let lockG: Array<MutexLockGroup>










    let concurrencyLevel: Int64






    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public init(concurrencyLevel!: Int64 = DEFAULT_CONCUR_LEVEL) {
        let lockCnt = tableSizeFor(concurrencyLevel)
        this.lockG = Array<MutexLockGroup>(2, {_ => MutexLockGroup(lockCnt)})
        this.concurrencyLevel = lockCnt
        this.head = AtomicReference(HNode<K, V>(DEFAULT_CAPACITY, None, lockG[0], 0))
    }









    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(capacity: Int64, concurrencyLevel!: Int64 = DEFAULT_CONCUR_LEVEL) {
        if (capacity < 0) {
            throw IllegalArgumentException("Invalid size of Concurrent HashMap: ${capacity}.")
        }

        let lockCnt = tableSizeFor(concurrencyLevel)
        this.lockG = Array<MutexLockGroup>(2, {_ => MutexLockGroup(lockCnt)})
        this.concurrencyLevel = lockCnt
        this.head = AtomicReference(HNode<K, V>(tableSizeFor(capacity), None, lockG[0], 0))
    }





    /**
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public init(elements: Collection<(K, V)>, concurrencyLevel!: Int64 = DEFAULT_CONCUR_LEVEL) {
        let lockCnt = tableSizeFor(concurrencyLevel)
        this.lockG = Array<MutexLockGroup>(2, {_ => MutexLockGroup(lockCnt)})
        this.concurrencyLevel = lockCnt
        this.head = AtomicReference(HNode<K, V>(tableSizeFor(elements.size), None, lockG[0], 0))
        for ((k, v) in elements) {
            this.add(k, v)
        }
    }





    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(size: Int64, initElement: (Int64) -> (K, V), concurrencyLevel!: Int64 = DEFAULT_CONCUR_LEVEL) {
        if (size < 0) {
            throw IllegalArgumentException("Invalid size of Concurrent HashMap: ${size}.")
        }

        let lockCnt = tableSizeFor(concurrencyLevel)
        this.lockG = Array<MutexLockGroup>(2, {_ => MutexLockGroup(lockCnt)})
        this.concurrencyLevel = lockCnt
        this.head = AtomicReference(HNode<K, V>(tableSizeFor(size), None, lockG[0], 0))
        for (i in 0..size) {
            let (key, value) = initElement(i)
            this.add(key, value)
        }
    }





    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func get(key: K): ?V {
        let hash = key.hashCode()
        return head.load().getValue(hash, key)
    }





    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func contains(key: K): Bool {
        return match (get(key)) {
            case None => false
            case _ => true
        }
    }










    /**
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @Deprecated[message: "Use member function `public func add(key: K, value: V): ?V` instead."]
    public func put(key: K, value: V): ?V {
        return addInternal(key, value)
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func add(key: K, value: V): ?V {
        return addInternal(key, value)
    }













    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    @Deprecated[message: "Use member function `public func addIfAbsent(key: K, value: V): ?V` instead."]
    public func putIfAbsent(key: K, value: V): ?V {
        addIfAbsent(key, value)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    @Frozen
    public func addIfAbsent(key: K, value: V): ?V {
        let hash = key.hashCode()
        tryResize(hash)
        var ret = None<V>
        var curHT = head.load()
        var index = hash & (curHT.buckets.size - 1)

        if (let Some(v) <- curHT.getValue(hash, key)) {
            return Some(v)
        }

        while (true) {
            if (curHT.tryGetBucket(index)) {
                ret = curHT.buckets[index].copyAddIfAbsent(hash, key, value)
                curHT.lockG.unlock(index)
                break
            }
            curHT = head.load()
            index = hash & (curHT.buckets.size - 1)
        }

        countInc(ret, hash)
        return ret
    }








    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func remove(key: K): ?V {
        return removeInternal(key, {_ => true})
    }











    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    @Deprecated[message: "Use member function `public func entryView(K, (MapEntryView<K, V>) -> Unit)` instead."]
    public func remove(key: K, predicate: (V) -> Bool): ?V {
        return removeInternal(key, predicate)
    }











    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func replace(key: K, value: V): ?V {
        return replaceInternel(key, {_ => true}, {_ => value})
    }














    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    @Deprecated[message: "Use member function `public func entryView(key: K, fn: (MapEntryView<K, V>)->Unit): ?V` instead."]
    public func replace(key: K, eval: (V) -> V): ?V {
        return replaceInternel(key, {_ => true}, eval)
    }













    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    @Deprecated[message: "Use member function `public func entryView(key: K, fn: (MapEntryView<K, V>)->Unit): ?V` instead."]
    public func replace(key: K, predicate: (V) -> Bool, eval: (V) -> V): ?V {
        return replaceInternel(key, predicate, eval)
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func entryView(key: K, fn: (MapEntryView<K, V>) -> Unit): ?V {
        return entryViewInternal(key, fn)
    }







    /**
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public operator func [](key: K): V {
        return match (this.get(key)) {
            case None => throw NoneValueException("Value does not exist!\n")
            case Some(val) => val
        }
    }





    /**
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func [](key: K, value!: V): Unit {
        this.add(key, value)
    }




        /**
         * @throws IndexOutOfBoundsException
         */
    public prop size: Int64 {
        get() {
            var cnt: Int64 = 0
            for (i in 0..(1 << COUNT_SIZE)) {
                cnt += counts[i].load()
            }
            return cnt
        }
    }




    /**
     * @throws IndexOutOfBoundsException
     */
    public func isEmpty(): Bool {
        return (size == 0)
    }




    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func iterator(): ConcurrentHashMapIterator<K, V> {
        return ConcurrentHashMapIterator<K, V>(this)
    }

    
    /**
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    private func addInternal(key: K, value: V): ?V {
        let hash = key.hashCode()
        tryResize(hash)
        var ret = None<V>
        var curHT = head.load()
        var index = hash & (curHT.buckets.size - 1)
        while (true) {
            if (curHT.tryGetBucket(index)) {
                ret = curHT.buckets[index].copyPut(hash, key, value)
                curHT.lockG.unlock(index)
                break
            }
            curHT = head.load()
            index = hash & (curHT.buckets.size - 1)
        }
        countInc(ret, hash)
        return ret
    }

    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    private func replaceInternel(key: K, predicate: (V) -> Bool, eval: (V) -> V): ?V {
        let hash = key.hashCode()
        var ret = None<V>
        var curHT = head.load()
        var index = hash & (curHT.buckets.size - 1)
        while (true) {
            if (curHT.tryGetBucket(index)) {
                ret = curHT.buckets[index].copyReplace(hash, key, predicate, eval)
                curHT.lockG.unlock(index)
                break
            }
            curHT = head.load()
            index = hash & (curHT.buckets.size - 1)
        }
        return ret
    }

    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    private func removeInternal(key: K, predicate: (V) -> Bool): Option<V> {
        let hash = key.hashCode()
        var ret = None<V>
        var curHT = head.load()
        var index = hash & (curHT.buckets.size - 1)
        while (true) {
            if (curHT.tryGetBucket(index)) {
                ret = curHT.buckets[index].copyRemove(hash, key, predicate)
                curHT.lockG.unlock(index)
                break
            }
            curHT = head.load()
            index = hash & (curHT.buckets.size - 1)
        }
        if (ret.isSome()) {
            counts[hash & (counts.size - 1)].fetchSub(1)
        }
        return ret
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func entryViewInternal(key: K, fn: (MapEntryView<K, V>) -> Unit): ?V {
        let hash = key.hashCode()
        tryResize(hash)
        var ret = None<V>
        var resize = None<Int64>
        var curHT = head.load()
        var index = hash & (curHT.buckets.size - 1)

        while (true) {
            if (curHT.tryGetBucket(index)) {
                (ret, resize) = curHT.buckets[index].copyEntryView(hash, key, fn)
                curHT.lockG.unlock(index)
                break
            }
            curHT = head.load()
            index = hash & (curHT.buckets.size - 1)
        }

        if (let Some(v) <- resize) {
            counts[hash & (counts.size - 1)].fetchAdd(v)
        }
        return ret
    }

    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    private func tryResize(hash: Int64): Unit {
        let curHT = head.load()
        let sz = curHT.buckets.size
        if ((counts[hash & (counts.size - 1)].load() << COUNT_SIZE) < sz) {
            return
        }
        
        var i = curHT.migratingIndex.fetchAdd(1)
        var migrateCnt = 0
        while (i < concurrencyLevel) {
            curHT.migrate(i, sz, concurrencyLevel)
            migrateCnt++
            i = curHT.migratingIndex.fetchAdd(1)
        }
        curHT.migratedIndex.fetchAdd(migrateCnt)
        let newVersion = curHT.version + 1
        if (!curHNodeVersion.compareAndSwap(curHT.version, newVersion)) {
            return
        }
        while (curHT.migratedIndex.load() < concurrencyLevel) {}
        
        curHT.pre.store(None<HNode<K, V>>)
        head.store(HNode<K, V>(sz << 1, Some(curHT), lockG[newVersion & 1], newVersion))
    }






    private static func tableSizeFor(cap: Int64): Int64 {
        if (cap <= DEFAULT_CAPACITY) {
            return DEFAULT_CAPACITY
        }
        if (cap < MAX_SIZE) {
            var n: Int64 = cap - 1
            n |= n >> 1
            n |= n >> 2
            n |= n >> 4
            n |= n >> 8
            n |= n >> 16
            n |= n >> 32
            return n + 1
        } else {
            return MAX_SIZE
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func countInc(ret: ?V, hash: Int64): Unit {
        if (ret.isNone()) {
            counts[hash & (counts.size - 1)].fetchAdd(1);
        }
    }
}




public class ConcurrentHashMapIterator<K, V> <: Iterator<(K, V)> where K <: Hashable & Equatable<K> {
    
    private let curHT: HNode<K, V>

    
    private var curBucketIndex: Int64 = 0
    private var curEntries: ?KVList<K, V> = None

    
    private var entriesIndex: Int64 = 0

    /**
     * @throws IndexOutOfBoundsException
     */
    public init(cmap: ConcurrentHashMap<K, V>) {
        curHT = cmap.head.load()
        latestValidBucket(0)
    }




    /**
     * @throws IndexOutOfBoundsException
     */
    @Frozen
    public func next(): Option<(K, V)> {
        if (let Some(entries) <- curEntries) {
            let val = entries[entriesIndex]
            nextElement()
            return Some((val[1], val[2]))
        }
        return None<(K, V)>
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func nextElement() {
        if (let Some(entries) <- curEntries) {
            for (i in (entriesIndex + 1)..entries.size) {
                if (predicate(entries[i][0], curBucketIndex)) {
                    entriesIndex = i
                    return
                }
            }
        }

        let start = curBucketIndex + 1
        latestValidBucket(start)
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func latestValidBucket(start: Int64) {
        for (i in start..curHT.buckets.size) {
            let optEntries = curHT.buckets[i].refList()
            if (let Some(entries) <- optEntries) {
                if (validBucket(i, entries)) {
                    return
                }
            } else if (let Some(preHT) <- curHT.pre.load()) {
                let preIndex = i & (preHT.buckets.size - 1)
                if (let Some(preEntries) <- preHT.buckets[preIndex].refList()) {
                    if (validBucket(i, preEntries)) {
                        return
                    }
                }
            }
        }
        curBucketIndex = curHT.buckets.size
        curEntries = None
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func validBucket(index: Int64, entries: KVList<K, V>): Bool {
        for (i in 0..entries.size) {
            if (predicate(entries[i][0], index)) {
                curBucketIndex = index
                curEntries = entries
                entriesIndex = i
                return true
            }
        }
        return false
    }

    @OverflowWrapping
    private func predicate(hash: Int64, index: Int64): Bool {
        return ((hash & (curHT.buckets.size - 1)) == index)
    }
}
