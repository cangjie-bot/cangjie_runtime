






package std.unittest.prop_test





class LazyNode<T> {
    
    public let head: T

    
     var lazyTail: Lazy<LazyNode<T>>

    
    public prop tail: ?LazyNode<T> {
        /*
         * @noThrow
         */
        get() {
            lazyTail.get()
        }
    }
    
    /*
     * @noThrow
     */
    init(head: T, tail: () -> ?LazyNode<T>) {
        this.head = head
        this.lazyTail = Lazy(tail)
    }

    
    /*
     * @noThrow
     */
    init(head: T, tail: Lazy<LazyNode<T>>) {
        this.head = head
        this.lazyTail = tail
    }

    
    /*
     * @noThrow
     */
    init(head: T) {
        this.head = head
        this.lazyTail = Lazy()
    }

    
    /*
     * @noThrow
     */
    func concat(other: ?LazyNode<T>): LazyNode<T> {
        LazyNode<T>(head) {
            tail?.concat(other) ?? other
        }
    }

    
    /*
     * @noThrow
     */
    func mixWith(other: ?LazyNode<T>): LazyNode<T> {
        LazyNode<T>(head) {
            match (other) {
                case Some(that) => that.mixWith(tail)
                case None => tail
            }
        }
    }


    /*
     * @noThrow
     */
    func cycle(): LazyNode<T> {
        let result = LazyNode<T>(head)
        result.lazyTail = Lazy {
            tail?.concat(result)
        }
        result
    }

    
    /*
     * @noThrow
     */
    static func mix(l1: ?LazyNode<T>, l2: ?LazyNode<T>): Lazy<LazyNode<T>> {
        match (l1) {
            case Some(e1) => Lazy { e1.mixWith(l2) }
            case None => Lazy { l2 }
        }
    }

    
    /*
     * @noThrow
     */
    static func mix(l1: ?LazyNode<T>, l2: ?LazyNode<T>, l3: ?LazyNode<T>): Lazy<LazyNode<T>> {
        match (l1) {
            case Some(n1) =>
                Lazy { LazyNode<T>(n1.head, LazyNode<T>.mix(l2, l3, n1.tail)) }
            case None => mix(l2, l3)
        }
    }

    
    /*
     * @noThrow
     */
    static func mix(l1: ?LazyNode<T>, l2: ?LazyNode<T>, l3: ?LazyNode<T>, l4: ?LazyNode<T>): Lazy<LazyNode<T>> {
        match (l1) {
            case Some(n1) =>
                Lazy { LazyNode<T>(n1.head, LazyNode<T>.mix(l2, l3, l4, n1.tail)) }
            case None => mix(l2, l3, l4)
        }
    }

    
    /*
     * @noThrow
     */
    static func mix(l1: ?LazyNode<T>, l2: ?LazyNode<T>, l3: ?LazyNode<T>,
                    l4: ?LazyNode<T>, l5: ?LazyNode<T>): Lazy<LazyNode<T>> {
        match (l1) {
            case Some(n1) =>
                Lazy { LazyNode<T>(n1.head, LazyNode<T>.mix(l2, l3, l4, l5, n1.tail)) }
            case None => mix(l2, l3, l4, l5)
        }
    }

    
    /*
     * @noThrow
     */
    func prepend(element: T): LazyNode<T> {
        LazyNode<T>(element, Lazy(this))
    }

    
    /*
     * @noThrow
     */
    func map<U>(body: (T) -> U): LazyNode<U> {
        LazyNode<U>(body(head)) {
            tail?.map(body)
        }
    }

    
    /*
     * @noThrow
     */
    public static func ofIterator(iterable: Iterator<T>): Lazy<LazyNode<T>> {
        func proceed(iterator: Iterator<T>): Lazy<LazyNode<T>> {
            Lazy<LazyNode<T>> {
                match (iterator.next()) {
                    case Some(h) => LazyNode(h, proceed(iterator))
                    case None => None
                }
            }
        }
        proceed(iterable)
    }
}


class LazyNodeIterator<T> <: Iterator<T> {
    /*
     * @noThrow
     */
    LazyNodeIterator(private var current: ?LazyNode<T>) {
    }

    
    /*
     * @noThrow
     */
    public func next(): ?T {
        match (current) {
            case Some(node) =>
                current = node.tail
                node.head
            case _ => None
        }
    }
}






public class LazySeq<T> <: Iterable<T> {
    /*
     * @noThrow
     */
    private LazySeq(private var root: Lazy<LazyNode<T>>) {
    }


    /*
     * @noThrow
     */
    private init(iterable: Iterable<T>) {
        this.root = LazyNode.ofIterator(iterable.iterator())
    }



    /*
     * @noThrow
     */
    public static func of(iterable: Iterable<T>) {
        match (iterable) {
            case self: LazySeq<T> => self
            case _ => LazySeq(iterable)
        }
    }



    /*
     * @throws IndexOutOfBoundsException
     */
    public static func of(array: Array<T>) {
        var self = LazySeq<T>()
        var index = array.size - 1
        while (index >= 0) {
            self = self.prepend(array[index])
            index--
        }
        self
    }


    /*
     * @noThrow
     */
    public init(element: T) {
        this.root = Lazy(LazyNode(element))
    }


    /*
     * @noThrow
     */
    public init() {
        this.root = Lazy()
    }


    /*
     * @noThrow
     */
    public func iterator(): Iterator<T> {
        LazyNodeIterator(root.get())
    }




    /*
     * @noThrow
     */
    public func concat(other: LazySeq<T>): LazySeq<T> {
        let newRoot = match (this.root.get()) {
            case None => return other
            case Some(root) =>
                Lazy { root.concat(other.root.get()) }
        }
        LazySeq(newRoot)
    }


    /*
     * @noThrow
     */
    public func prepend(element: T): LazySeq<T> {
        LazySeq(Lazy(LazyNode(element, this.root)))
    }


    /*
     * @noThrow
     */
    public func append(element: T): LazySeq<T> {
        concat(LazySeq<T>(element))
    }



    /*
     * @noThrow
     */
    public func mixWith(other: LazySeq<T>): LazySeq<T> {
        let newRoot = match (this.root.get()) {
            case None => return other
            case Some(root) => Lazy {root.mixWith(other.root.get())}
        }
        LazySeq(newRoot)
    }



    /*
     * @noThrow
     */
    public static func mix(l1: LazySeq<T>, l2: LazySeq<T>) {
        let newRoot = Lazy<LazyNode<T>>.flat {
            LazyNode<T>.mix(l1.root.get(), l2.root.get())
        }
        LazySeq(newRoot)
    }


    /*
     * @noThrow
     */
    public static func mix(l1: LazySeq<T>, l2: LazySeq<T>, l3: LazySeq<T>) {
        let newRoot = Lazy<LazyNode<T>>.flat {
            LazyNode<T>.mix(l1.root.get(), l2.root.get(), l3.root.get())
        }
        LazySeq(newRoot)
    }


    /*
     * @noThrow
     */
    public static func mix(l1: LazySeq<T>, l2: LazySeq<T>, l3: LazySeq<T>, l4: LazySeq<T>) {
        let newRoot = Lazy<LazyNode<T>>.flat {
            LazyNode<T>.mix(l1.root.get(), l2.root.get(), l3.root.get(), l4.root.get())
        }
        LazySeq(newRoot)
    }


    /*
     * @noThrow
     */
    public static func mix(l1: LazySeq<T>, l2: LazySeq<T>, l3: LazySeq<T>, l4: LazySeq<T>, l5: LazySeq<T>) {
        let newRoot = Lazy<LazyNode<T>>.flat {
            LazyNode<T>.mix(l1.root.get(), l2.root.get(), l3.root.get(), l4.root.get(), l5.root.get())
        }
        LazySeq(newRoot)
    }



    /*
     * @noThrow
     */
    public func map<U>(body: (T) -> U): LazySeq<U> {
        let newRoot = Lazy<LazyNode<U>> {
            this.root.get()?.map(body)
        }
        LazySeq(newRoot)
    }
}
