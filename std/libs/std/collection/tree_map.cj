









package std.collection

const DEGREE: Int64 = 6
const MIN_ENTRY_SIZE: Int64 = DEGREE - 1
const MAX_ENTRY_SIZE: Int64 = 2 * DEGREE - 1
const MIN_CHILD_SIZE: Int64 = DEGREE
const MAX_CHILD_SIZE: Int64 = 2 * DEGREE

public class TreeMap<K, V> <: OrderedMap<K, V> where K <: Comparable<K> {
    
    private var _size: Int64 = 0

    
    private var modCount: Int64 = 0

    
    private var root: Node<K, V>




    /*
     * @noThrow
     */
    public init() {
        this.root = Node<K, V>(Node<K, V>.nullNode())
    }




    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public init(elements: Collection<(K, V)>) {
        this.root = Node<K, V>(Node<K, V>.nullNode())
        for (i in elements) {
            this.add(i[0], i[1])
        }
    }






    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public init(elements: Array<(K, V)>) {
        this.root = Node<K, V>(Node<K, V>.nullNode())
        for (i in elements) {
            this.add(i[0], i[1])
        }
    }









    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(size: Int64, initElement: (Int64) -> (K, V)) {
        if (size < 0) {
            throw IllegalArgumentException("Invalid size of TreeMap: ${size}.")
        } else {
            this.root = Node<K, V>(Node<K, V>.nullNode())
            for (i in 0..size) {
                let element: (K, V) = initElement(i)
                this.add(element[0], element[1])
            }
        }
    }







    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public func get(key: K): ?V {
        let sr = searchEntry(this.root, key)
        return match (sr.replaceNode) {
            case Some(v) => v.getEntry(sr.index).getOrThrow().value
            case None => None
        }
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    public func contains(key: K): Bool {
        searchEntry(this.root, key).replaceNode.isSome()
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    public func contains(all!: Collection<K>): Bool {
        for (key in all where !this.contains(key)) {
            return false
        }
        return true
    }










    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(key: K, value: V): Option<V> {
        if (this.root.entrySize == MAX_ENTRY_SIZE) {
            let newNode: Node<K, V> = Node<K, V>(Node<K, V>.nullNode())
            newNode.insertChild(0, this.root)
            this.root._parent = newNode
            splitNode(newNode, this.root, 0)
            this.root = newNode
        }
        return inserEntry(this.root, TreeMapEntry<K, V>(key, value))
    }







    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(all!: Collection<(K, V)>): Unit {
        for ((k, v) in all) {
            this.add(k, v)
        }
    }







    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func remove(key: K): Option<V> {
        if (this.isEmpty()) {
            return None
        }
        if (let Some(_) <- get(key)) {
            return deleteEntry(this.root, key)
        } else {
            return None
        }
    }






    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func remove(all!: Collection<K>): Unit {
        for (key in all) {
            this.remove(key)
        }
    }






    /*
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    public func removeIf(predicate: (K, V) -> Bool): Unit {
        var sr: SearchResult<K, V> = getFirstEntry()
        while (let Some(node) <- sr.replaceNode) {
            let item: TreeMapEntry<K, V> = node.getEntry(sr.index).getOrThrow()
            let lockVersion = this.modCount
            let needDelete = predicate(item.key, item.value)
            if (this.modCount != lockVersion) {
                throw ConcurrentModificationException("The predicate cannot contain a modify operation.")
            }
            let ssr = successor(sr)
            match (ssr.replaceNode) {
                case Some(v) =>
                    let key = v.getEntry(ssr.index).getOrThrow().key
                    if (needDelete) {
                        deleteEntry(node, item.key)
                        sr = searchEntry(this.root, key)
                    } else {
                        sr = ssr
                    }
                case None =>
                    if (needDelete) {
                        deleteEntry(node, item.key)
                    }
                    break
            }
        }
    }




    /*
     * @noThrow
     */
    public func clear(): Unit {
        this._size = 0
        this.modCount++
        this.root = Node<K, V>(Node<K, V>.nullNode())
    }






    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func clone(): TreeMap<K, V> {
        return TreeMap<K, V>(this)
    }









    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public operator func [](key: K): V {
        return match (this.get(key)) {
            case None => throw NoneValueException("Value does not exist!")
            case Some(val) => val
        }
    }







    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func [](key: K, value!: V): Unit {
        this.add(key, value)
    }






    /*
     * @noThrow
     */
    public func keys(): EquatableCollection<K> {
        return TreeMapKeys<K, V>(this)
    }






    /*
     * @noThrow
     */
    public func values(): Collection<V> {
        return TreeMapValues<K, V>(this)
    }






    public prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            return this._size
        }
    }






    /*
     * @noThrow
     */
    public func isEmpty(): Bool {
        return this.root.isEmpty()
    }






    @Frozen
    /*
     * @throws NoneValueException
     */
    public func iterator(): Iterator<(K, V)> {
        let node = TreeMapEntryView(this, getFirstEntry())
        return TreeMapIterator<K, V>(node)
    }






    public prop first: ?(K, V) {
        /*
         * @throws NoneValueException
         */
        get() {
            let sr: SearchResult<K, V> = getFirstEntry()
            match (sr.replaceNode) {
                case Some(v) =>
                    let item = v.getEntry(sr.index).getOrThrow()
                    return (item.key, item.value)
                case None => None
            }
        }
    }






    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func removeFirst(): ?(K, V) {
        let sr: SearchResult<K, V> = getFirstEntry()
        match (sr.replaceNode) {
            case Some(v) =>
                let item = v.getEntry(sr.index).getOrThrow()
                deleteEntry(v, item.key)
                return (item.key, item.value)
            case None => None
        }
    }






    public prop last: ?(K, V) {
        /*
         * @throws NoneValueException
         */
        get() {
            let sr: SearchResult<K, V> = getLastEntry()
            match (sr.replaceNode) {
                case Some(v) =>
                    let item = v.getEntry(sr.index).getOrThrow()
                    return (item.key, item.value)
                case None => None
            }
        }
    }






    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func removeLast(): ?(K, V) {
        let sr: SearchResult<K, V> = getLastEntry()
        match (sr.replaceNode) {
            case Some(v) =>
                let item = v.getEntry(sr.index).getOrThrow()
                deleteEntry(v, item.key)
                return (item.key, item.value)
            case None => None
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func searchNearestEntryView(array: ArrayList<K>, key: K, forward!: Bool): TreeMapEntryView<K, V> {
        var (left, right, mid) = (0, array.size - 1, 0)

        while (left <= right) {
            mid = left + (right - left) / 2
            if (array[mid] < key) {
                left = mid + 1
            } else if (array[mid] > key) {
                right = mid - 1
            } else {
                break
            }
        }

        let result = if (forward && left < array.size && array[left] > key) {
            array[left]
        } else if (!forward && right >= 0 && array[right] < key) {
            array[right]
        } else {
            return TreeMapEntryView<K, V>(this, SearchResult<K, V>(-1, None))
        }
        return TreeMapEntryView<K, V>(this, searchEntry(this.root, result))
    }











    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public func backward(mark: K, inclusive!: Bool = true): Iterator<(K, V)> {
        var entry = this.searchEntry(this.root, mark)
        return match (entry.replaceNode) {
            case Some(_) => BackwardIterator(TreeMapEntryView(this, entry), mark, inclusive)
            case None =>
                if (mark > last.getOrThrow()[0]) {
                    BackwardIterator(TreeMapEntryView(this, getLastEntry()), mark, true)
                } else if (mark > first.getOrThrow()[0]) {
                    let view: TreeMapEntryView<K, V> = searchNearestEntryView(this.keys() |> collectArrayList, mark,
                        forward: false)
                    BackwardIterator(view, mark, true)
                } else {
                    BackwardIterator(TreeMapEntryView(this, getFirstEntry()), mark, false)
                }
        }
    }











    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public func forward(mark: K, inclusive!: Bool = true): Iterator<(K, V)> {
        var entry = this.searchEntry(this.root, mark)
        return match (entry.replaceNode) {
            case Some(_) => ForwardIterator(TreeMapEntryView(this, entry), mark, inclusive)
            case None =>
                if (mark < this.first.getOrThrow()[0]) {
                    ForwardIterator(TreeMapEntryView(this, getFirstEntry()), mark, true)
                } else if (mark <= this.last.getOrThrow()[0]) {
                    let view: TreeMapEntryView<K, V> = searchNearestEntryView(this.keys() |> collectArrayList, mark,
                        forward: true)
                    ForwardIterator(view, mark, true)
                } else {
                    ForwardIterator(TreeMapEntryView(this, getLastEntry()), mark, false)
                }
        }
    }

    
    /*
     * @noThrow
     */
    func version(): Int64 {
        return this.modCount
    }

    
    /*
     * @throws NoneValueException
     */
    func getFirstEntry(): SearchResult<K, V> {
        if (this.root.isEmpty()) {
            return SearchResult<K, V>(-1, None)
        }
        var curNode: Node<K, V> = this.root
        while (!curNode.isLeaf()) {
            curNode = curNode.getChild(0).getOrThrow()
        }
        return SearchResult<K, V>(0, curNode)
    }

    
    /*
     * @throws NoneValueException
     */
    func getLastEntry(): SearchResult<K, V> {
        if (this.root.isEmpty()) {
            return SearchResult<K, V>(-1, None)
        }
        var curNode: Node<K, V> = this.root
        while (!curNode.isLeaf()) {
            curNode = curNode.getChild(curNode.entrySize).getOrThrow()
        }
        return SearchResult<K, V>(curNode.entrySize - 1, curNode)
    }

    
    /*
     * @throws IndexOutOfBoundsException
     */
    func searchEntry(node: ?Node<K, V>, key: K): SearchResult<K, V> {
        if (let Some(node) <- node) {
            var sr: SearchResult<K, V> = node.searchEntry(key)
            return match (sr.replaceNode) {
                case Some(_) => sr
                case None =>
                    if (root.isLeaf()) {
                        sr
                    } else {
                        searchEntry(node.getChild(sr.index), key)
                    }
            }
        }
        return SearchResult<K, V>(-1, None)
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func searchEntryFromRoot(key: K): SearchResult<K, V> {
        return searchEntry(this.root, key)
    }

    
    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func inserEntry(node: Node<K, V>, entry: TreeMapEntry<K, V>): Option<V> {
        let sr: SearchResult<K, V> = node.searchEntry(entry.key)
        match (sr.replaceNode) {
            case Some(node) =>
                let tmp = node.getEntry(sr.index).getOrThrow()
                let oldValue = tmp.value
                tmp.value = entry.value
                return oldValue
            case None =>
                if (node.isLeaf()) {
                    this._size++
                    this.modCount++
                    node.insertEntry(sr.index, entry)
                    return None
                }
                var childNode: Node<K, V> = node.getChild(sr.index).getOrThrow()
                if (childNode.entrySize == MAX_ENTRY_SIZE) {
                    splitNode(node, childNode, sr.index)
                    if (entry.key > node.getEntry(sr.index).getOrThrow().key) {
                        childNode = node.getChild(sr.index + 1).getOrThrow()
                    }
                }
                return inserEntry(childNode, entry)
        }
    }

    
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func splitNode(node: Node<K, V>, splitNode: Node<K, V>, index: Int64) {
        var rightNode: Node<K, V> = Node<K, V>(node)
        for (i in DEGREE..MAX_ENTRY_SIZE) {
            rightNode.entries.add(splitNode.entries[i])
        }
        var midEntry: TreeMapEntry<K, V> = splitNode.entries[DEGREE - 1]
        for (i in MAX_ENTRY_SIZE - 1..DEGREE - 2 : -1) {
            splitNode.entries.remove(at: i)
        }
        if (!splitNode.isLeaf()) {
            for (i in DEGREE..MAX_CHILD_SIZE) {
                let child = splitNode.children[i]
                rightNode.children.add(child)
                child._parent = rightNode
            }
            for (i in MAX_CHILD_SIZE - 1..DEGREE - 1 : -1) {
                splitNode.children.remove(at: i)
            }
        }
        node.insertEntry(midEntry)
        node.insertChild(index + 1, rightNode)
    }

    
    /*
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func deleteEntry(node: Node<K, V>, key: K): Option<V> {
        var sr: SearchResult<K, V> = node.searchEntry(key)
        match (sr.replaceNode) {
            case Some(v) =>
                let oldValue: V
                if (!v.isLeaf()) {
                    var psr = predecessor(sr)
                    if (let Some(rNode) <- psr.replaceNode) {
                        let entry = node.getEntry(sr.index).getOrThrow()
                        let rEntry = rNode.getEntry(psr.index).getOrThrow()
                        let key = entry.key
                        let value = entry.value
                        entry.reset(rEntry.key, rEntry.value)
                        rEntry.reset(key, value)
                        sr = psr
                    }
                }
                var curNode = sr.replaceNode.getOrThrow()
                oldValue = curNode.getEntry(sr.index).getOrThrow().value
                curNode.deleteEntry(sr.index)
                this._size--
                this.modCount++
                while (curNode.entrySize < MIN_ENTRY_SIZE) {
                    if (curNode._parent.isNone()) {
                        break
                    }
                    let psr: SearchResult<K, V> = parentOf(curNode)
                    let parent: Node<K, V> = psr.replaceNode.getOrThrow()
                    var broNode: ?Node<K, V> = Node<K, V>.nullNode()
                    if (psr.index > 0 && parent.getChild(psr.index - 1).getOrThrow().entrySize > MIN_ENTRY_SIZE) {
                        broNode = parent.getChild(psr.index - 1).getOrThrow()
                        curNode.insertEntry(0, parent.getEntry(psr.index - 1).getOrThrow())
                        parent.deleteEntry(psr.index - 1)
                        parent.insertEntry(psr.index - 1, broNode.getOrThrow().getEntry(broNode.getOrThrow().entrySize - 1).getOrThrow())
                        if (broNode?.isLeaf() == false) {
                            let child = broNode.getOrThrow().getChild(broNode.getOrThrow().entrySize).getOrThrow()
                            curNode.insertChild(0, child)
                            child._parent = curNode
                            broNode?.deleteChild(broNode.getOrThrow().entrySize)
                        }
                        broNode?.deleteEntry(broNode.getOrThrow().entrySize - 1)
                        continue
                    }
                    if (psr.index < parent.childrenSize - 1 && parent.getChild(psr.index + 1).getOrThrow().entrySize >
                        MIN_ENTRY_SIZE) {
                        broNode = parent.getChild(psr.index + 1).getOrThrow()
                        curNode.insertEntry(curNode.entrySize, parent.getEntry(psr.index).getOrThrow())
                        parent.deleteEntry(psr.index)
                        parent.insertEntry(psr.index, broNode.getOrThrow().getEntry(0).getOrThrow())
                        if (broNode?.isLeaf() == false) {
                            let child = broNode.getOrThrow().getChild(0).getOrThrow()
                            curNode.insertChild(curNode.entrySize, child)
                            child._parent = curNode
                            broNode?.deleteChild(0)
                        }
                        broNode?.deleteEntry(0)
                        continue
                    }
                    if (psr.index > 0) {
                        broNode = parent.getChild(psr.index - 1).getOrThrow()
                        broNode?.insertEntry(parent.getEntry(psr.index - 1).getOrThrow())
                        for (i in 0..curNode.entrySize) {
                            broNode?.insertEntry(broNode.getOrThrow().entrySize, curNode.getEntry(i).getOrThrow())
                        }
                        if (!curNode.isLeaf()) {
                            for (i in 0..curNode.childrenSize) {
                                let child = curNode.getChild(i).getOrThrow()
                                broNode?.insertChild(broNode.getOrThrow().childrenSize, child)
                                child._parent = broNode
                            }
                        }
                        parent.deleteEntry(psr.index - 1)
                        parent.deleteChild(psr.index)
                    } else {
                        broNode = parent.getChild(psr.index + 1).getOrThrow()
                        curNode.insertEntry(parent.getEntry(psr.index).getOrThrow())
                        for (i in 0..broNode.getOrThrow().entrySize) {
                            curNode.insertEntry(curNode.entrySize, broNode.getOrThrow().getEntry(i).getOrThrow())
                        }
                        for (i in broNode.getOrThrow().entrySize - 1..-1 : -1) {
                            broNode?.deleteEntry(i)
                        }
                        if (broNode?.isLeaf() == false) {
                            for (i in 0..broNode.getOrThrow().childrenSize) {
                                let child = broNode.getOrThrow().getChild(i).getOrThrow()
                                curNode.insertChild(curNode.childrenSize, child)
                                child._parent = curNode
                            }
                        }
                        parent.deleteEntry(psr.index)
                        parent.deleteChild(psr.index + 1)
                    }
                    if (parent._parent.isNone() && parent.isEmpty()) {
                        this.root = if (broNode.getOrThrow().isEmpty()) {
                            curNode
                        } else {
                            broNode.getOrThrow()
                        }
                        this.root._parent = Node<K, V>.nullNode()
                        break
                    }
                    curNode = parent
                }
                return oldValue
            case None => deleteEntry(node.getChild(sr.index).getOrThrow(), key)
        }
    }

    
    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     */
    func predecessor(sr: SearchResult<K, V>): SearchResult<K, V> {
        var curSr = sr
        var curNode = sr.replaceNode.getOrThrow()
        if (curNode.isLeaf()) {
            while (curSr.index < 1 && curNode._parent.isSome()) {
                curSr = parentOf(curNode)
                curNode = curSr.replaceNode.getOrThrow()
            }
            if (curSr.index < 1) {
                return SearchResult<K, V>(-1, None)
            }

            return SearchResult<K, V>(curSr.index - 1, curNode)
        }
        var leftChild = curNode.getChild(sr.index).getOrThrow()
        while (!leftChild.isLeaf()) {
            leftChild = leftChild.getChild(leftChild.childrenSize - 1).getOrThrow()
        }
        return SearchResult<K, V>(leftChild.entrySize - 1, leftChild)
    }

    
    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     */
    func successor(sr: SearchResult<K, V>): SearchResult<K, V> {
        var curSr = sr
        var curNode = sr.replaceNode.getOrThrow()
        if (curNode.isLeaf()) {
            if (curSr.index < curNode.entrySize - 1) {
                return SearchResult<K, V>(curSr.index + 1, curNode)
            }

            if (curNode._parent.isNone()) {
                return SearchResult<K, V>(-1, None)
            }

            curSr = parentOf(curNode)
            curNode = curSr.replaceNode.getOrThrow()
            while (curSr.index > curNode.entrySize - 1 && curNode._parent.isSome()) {
                curSr = parentOf(curNode)
                curNode = curSr.replaceNode.getOrThrow()
            }
            if (curSr.index > curNode.entrySize - 1) {
                return SearchResult<K, V>(-1, None)
            }

            return SearchResult<K, V>(curSr.index, curNode)
        }
        var rightChild = curNode.getChild(curSr.index + 1).getOrThrow()
        while (!rightChild.isLeaf()) {
            rightChild = rightChild.getChild(0).getOrThrow()
        }

        return SearchResult<K, V>(0, rightChild)
    }

    
    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     */
    func parentOf(node: Node<K, V>): SearchResult<K, V> {
        let parent = node._parent
        var index = 0
        for (i in 0..parent.getOrThrow().childrenSize) {
            if (parent.getOrThrow().getChild(i).getOrThrow().quickEquals(node)) {
                index = i
                break
            }
        }

        return SearchResult<K, V>(index, parent)
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func entryView(k: K): MapEntryView<K, V> {
        let sr = searchEntry(this.root, k)
        return TreeMapEntryView(this, sr, key: k)
    }
}

extend<K, V> TreeMap<K, V> <: ToString where V <: ToString, K <: ToString & Comparable<K> {




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let size: Int64 = this.size
        if (size == 0) {
            return "[]"
        }
        let emptyString: String = String.empty
        let elementSize: Int64 = (size << 1) + 1
        let stringArray: Array<String> = Array<String>(elementSize, repeat: emptyString)
        stringArray[0] = "["
        var index: Int64 = 1
        for ((k, v) in this) {
            stringArray[index] = "(${k}, ${v})"
            stringArray[index + 1] = ", "
            index += 2
        }
        stringArray[elementSize - 1] = "]"
        return String.join(stringArray)
    }
}

extend<K, V> TreeMap<K, V> <: Equatable<TreeMap<K, V>> where V <: Equatable<V> {







    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public operator func ==(right: TreeMap<K, V>): Bool {
        if (refEq(this, right)) {
            return true
        }

        if (this.size != right.size) {
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







    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public operator func !=(right: TreeMap<K, V>): Bool {
        return !(this == right)
    }
}

struct TreeMapEntryView<K, V> <: MapEntryView<K, V> where K <: Comparable<K> {
    let map: TreeMap<K, V>
    var curNode: SearchResult<K, V>
    var lockVersion: Int64
    var _key: ?K
    /*
     * @noThrow
     */
    init(map: TreeMap<K, V>, curNode: SearchResult<K, V>, key!: ?K = None) {
        this.map = map
        this.curNode = curNode
        this.lockVersion = map.version()
        this._key = key
    }





    public prop key: K {
        /*
         * @throws NoneValueException
         * @throws ConcurrentModificationException
         */
        get() {
            if (lockVersion != this.map.version()) {
                throw ConcurrentModificationException()
            }

            return if (let Some(node) <- curNode.replaceNode) {
                let entry = node.getEntry(curNode.index).getOrThrow()
                entry.key
            } else {
                this._key.getOrThrow()
            }
        }
    }





    public mut prop value: ?V {
        /*
         * @throws NoneValueException
         * @throws ConcurrentModificationException
         */
        get() {
            if (lockVersion != this.map.version()) {
                throw ConcurrentModificationException()
            }

            return match (curNode.replaceNode) {
                case Some(node) =>
                    let entry = node.getEntry(curNode.index).getOrThrow()
                    entry.value
                case None => throw NoneValueException("Value does not exist!")
            }
        }
        /*
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ConcurrentModificationException
         */
        set(v) {
            if (lockVersion != this.map.version()) {
                throw ConcurrentModificationException()
            }

            if (v.isNone()) {
                map.remove(key)
            } else {
                match (curNode.replaceNode) {
                    case Some(node) =>
                        let entry = node.getEntry(curNode.index).getOrThrow()
                        entry.value = v.getOrThrow()
                    case None =>
                        map.add(key, v.getOrThrow())
                        curNode = this.map.searchEntryFromRoot(_key.getOrThrow())
                }
                lockVersion = this.map.version()
            }
        }
    }

    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     */
    func nextNode(): TreeMapEntryView<K, V> {
        let sr = this.map.successor(curNode)
        return TreeMapEntryView<K, V>(this.map, sr)
    }

    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     */
    func prevNode(): TreeMapEntryView<K, V> {
        let sr = this.map.predecessor(curNode)
        return TreeMapEntryView<K, V>(this.map, sr)
    }

    /*
     * @noThrow
     */
    func isSome(): Bool {
        return curNode.replaceNode.isSome()
    }
}

class ForwardIterator<K, V> <: Iterator<(K, V)> where K <: Comparable<K> {
    private var curNode: TreeMapEntryView<K, V>
    private var key: K
    private var inclusive: Bool






    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     */
    init(node: TreeMapEntryView<K, V>, key: K, inclusive: Bool) {
        this.curNode = if (inclusive || !node.isSome()) {
            node
        } else {
            node.nextNode()
        }
        this.key = key
        this.inclusive = inclusive
    }








    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws ConcurrentModificationException
     */
    public func next(): Option<(K, V)> {
        checkVersion(curNode)
        if (curNode.isSome()) {
            let item = curNode
            curNode = curNode.nextNode()
            return match (item.value) {
                case Some(value) => (item.key, value)
                case None => None
            }
        }
        return None
    }
}

class BackwardIterator<K, V> <: Iterator<(K, V)> where K <: Comparable<K> {
    private var curNode: TreeMapEntryView<K, V>
    private var key: K
    private var inclusive: Bool






    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     */
    init(node: TreeMapEntryView<K, V>, key: K, inclusive: Bool) {
        this.curNode = if (inclusive || !node.isSome()) {
            node
        } else {
            node.prevNode()
        }
        this.key = key
        this.inclusive = inclusive
    }








    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws ConcurrentModificationException
     */
    public func next(): Option<(K, V)> {
        checkVersion(curNode)
        if (curNode.isSome()) {
            let item = curNode
            curNode = curNode.prevNode()
            return match (item.value) {
                case Some(value) => (item.key, value)
                case None => None
            }
        }
        return None
    }
}

/*
 * @throws ConcurrentModificationException
 */
func checkVersion<K, V>(node: TreeMapEntryView<K, V>) where K <: Comparable<K> {
    if (node.lockVersion != node.map.version()) {
        throw ConcurrentModificationException()
    }
}




class TreeMapKeys<K, V> <: EquatableCollection<K> where K <: Comparable<K> {
    private let map: TreeMap<K, V>
    /*
     * @noThrow
     */
    public init(m: TreeMap<K, V>) {
        this.map = m
    }






    public prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            return this.map.size
        }
    }






    /*
     * @noThrow
     */
    public func isEmpty(): Bool {
        return this.map.isEmpty()
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    public func contains(element: K): Bool {
        return this.map.contains(element)
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    public func contains(all!: Collection<K>): Bool {
        return this.map.contains(all: all)
    }






    @Frozen
    /*
     * @throws NoneValueException
     */
    public func iterator(): Iterator<K> {
        return map.iterator().map<K> {i: (K, V) => i[0]}
    }
}




class TreeMapValues<K, V> <: Collection<V> where K <: Comparable<K> {
    private let map: TreeMap<K, V>

    /*
     * @noThrow
     */
    public init(m: TreeMap<K, V>) {
        this.map = m
    }






    public prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            return this.map.size
        }
    }






    /*
     * @noThrow
     */
    public func isEmpty(): Bool {
        return this.map.isEmpty()
    }






    @Frozen
    /*
     * @throws NoneValueException
     */
    public func iterator(): Iterator<V> {
        return map.iterator().map<V> {i: (K, V) => i[1]}
    }
}




class TreeMapIterator<K, V> <: Iterator<(K, V)> where K <: Comparable<K> {
    private var curNode: TreeMapEntryView<K, V>






    /*
     * @noThrow
     */
    public init(node: TreeMapEntryView<K, V>) {
        this.curNode = node
    }








    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     * @throws NoneValueException
     */
    public func next(): Option<(K, V)> {
        checkVersion(curNode)
        if (curNode.isSome()) {
            let item = curNode
            curNode = curNode.nextNode()
            return (item.key, item.value.getOrThrow())
        }
        return None
    }
}

class Node<K, V> where K <: Comparable<K> {
    var entries: ArrayList<TreeMapEntry<K, V>>
    var _parent: ?Node<K, V>
    var children: ArrayList<Node<K, V>>

    /*
     * @noThrow
     */
    static func nullNode(): ?Node<K, V> {
        return None<Node<K, V>>
    }

    /*
     * @noThrow
     */
    init(parent: ?Node<K, V>) {
        this._parent = parent
        this.entries = ArrayList<TreeMapEntry<K, V>>()
        this.children = ArrayList<Node<K, V>>()
    }

    /*
     * @noThrow
     */
    func isLeaf(): Bool {
        return this.children.size == 0
    }

    prop entrySize: Int64 {
        /*
         * @noThrow
         */
        get() {
            this.entries.size
        }
    }

    prop childrenSize: Int64 {
        /*
         * @noThrow
         */
        get() {
            this.children.size
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func quickEquals(that: Node<K, V>): Bool {
        if (this.entrySize == that.entrySize && this.entrySize != 0) {
            if (this.entries[0].key == that.entries[0].key) {
                return true
            }
            return false
        }
        return false
    }

    /*
     * @noThrow
     */
    func isEmpty(): Bool {
        return entrySize == 0
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func searchEntry(key: K): SearchResult<K, V> {
        if (entrySize == 0) {
            return SearchResult(0, None)
        }
        var begin: Int64 = 0
        var end: Int64 = entrySize - 1
        var mid: Int64 = 0
        while (begin < end) {
            mid = begin + ((end - begin) >> 1)
            let midKey: K = this.entries[mid].key
            if (key == midKey) {
                break
            } else if (key > midKey) {
                begin = mid + 1
            } else {
                end = mid - 1
            }
        }
        return if (begin < end) {
            SearchResult<K, V>(mid, this)
        } else if (begin == end) {
            let midKey: K = this.entries[begin].key
            if (key == midKey) {
                SearchResult<K, V>(begin, this)
            } else if (key > midKey) {
                SearchResult<K, V>(begin + 1, None)
            } else {
                SearchResult<K, V>(begin, None)
            }
        } else {
            SearchResult<K, V>(begin, None)
        }
    }

    /*
     * @noThrow
     */
    func getEntry(index: Int64): Option<TreeMapEntry<K, V>> {
        return entries.get(index)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func insertEntry(entry: TreeMapEntry<K, V>): Option<V> {
        var sr = searchEntry(entry.key)
        match (sr.replaceNode) {
            case Some(v) =>
                let tmp = v.entries[sr.index]
                let oldValue = tmp.value
                tmp.value = entry.value
                return oldValue
            case None =>
                this.entries.add(entry, at: sr.index)
                return Option<V>.None
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func insertEntry(index: Int64, entry: TreeMapEntry<K, V>): Unit {
        this.entries.add(entry, at: index)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func deleteEntry(index: Int64): Unit {
        this.entries.remove(at: index)
    }

    /*
     * @noThrow
     */
    func getChild(index: Int64): ?Node<K, V> {
        return this.children.get(index)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func deleteChild(index: Int64): Unit {
        this.children.remove(at: index)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func insertChild(index: Int64, node: Node<K, V>) {
        this.children.add(node, at: index)
    }
}

struct SearchResult<K, V> where K <: Comparable<K> {
    private var _index: Int64
    private var _replaceNode: ?Node<K, V>

    /*
     * @noThrow
     */
    init(index: Int64, node: ?Node<K, V>) {
        this._replaceNode = node
        this._index = index
    }

    prop index: Int64 {
        /*
         * @noThrow
         */
        get() {
            this._index
        }
    }

    prop replaceNode: ?Node<K, V> {
        /*
         * @noThrow
         */
        get() {
            this._replaceNode
        }
    }
}

class TreeMapEntry<K, V> where K <: Comparable<K> {
    private var _key: K
    private var _value: V

    /*
     * @noThrow
     */
    init(key: K, value: V) {
        this._key = key
        this._value = value
    }

    prop key: K {
        /*
         * @noThrow
         */
        get() {
            _key
        }
    }

    mut prop value: V {
        /*
         * @noThrow
         */
        get() {
            _value
        }
        /*
         * @noThrow
         */
        set(v) {
            this._value = v
        }
    }

    /*
     * @noThrow
     */
    func reset(key: K, value: V) {
        this._key = key
        this._value = value
    }
}
