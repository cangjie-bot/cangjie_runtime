# 类

## class ArrayDeque\<T>

```cangjie
public class ArrayDeque<T> <: Deque<T> {
    public init()
    public init(capacity: Int64)
}
```

功能：ArrayDeque 是双端队列（deque）实现类，可以在双端队列的两端进行元素的插入和删除操作。ArrayDeque 是根据可调整大小的数组实现的，其容量会在插入元素的过程中不断地增长，默认每次扩容 50% 大小。ArrayDeque 的实现采用了循环队列的方式，在没有扩容的情况下，其插入、删除、查看等操作的时间复杂度为 O(1)。

父类型：

- [Deque](./collection_package_interface.md#interface-dequet)\<T>

### prop capacity

```cangjie
public prop capacity: Int64
```

功能：获取此双端队列的容量。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### prop first

```cangjie
public prop first: ?T
```

功能：获取双端队列的头部元素。如果双端队列为空，返回 None。

类型：?T

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addLast(1)
    deque.addLast(2)
    
    let first = deque.first
    println("队列头部元素: ${first}")  // Some(1)
    
    let emptyDeque = ArrayDeque<String>()
    let noneFirst = emptyDeque.first
    println("空队列头部元素: ${noneFirst}")  // None
    
    return 0
}
```

运行结果：

```text
队列头部元素: Some(1)
空队列头部元素: None
```

### prop last

```cangjie
public prop last: ?T
```

功能：获取双端队列的尾部元素。如果双端队列为空，返回 None。

类型：?T

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addLast(1)
    deque.addLast(2)
    
    let last = deque.last
    println("队列尾部元素: ${last}")  // Some(2)
    
    let emptyDeque = ArrayDeque<String>()
    let noneLast = emptyDeque.last
    println("空队列尾部元素: ${noneLast}")  // None
    
    return 0
}
```

运行结果：

```text
队列尾部元素: Some(2)
空队列尾部元素: None
```

### prop size

```cangjie
public prop size: Int64
```

功能：返回此双端队列中的元素个数。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    println("初始大小: ${deque.size}")  // 0
    
    deque.addLast(1)
    deque.addLast(2)
    println("添加2个元素后大小: ${deque.size}")  // 2
    
    deque.removeFirst()
    println("删除1个元素后大小: ${deque.size}")  // 1
    
    return 0
}
```

运行结果：

```text
初始大小: 0
添加2个元素后大小: 2
删除1个元素后大小: 1
```

### init()

```cangjie
public init()
```

功能：构造一个空的双端队列，其容量大小为默认值 8。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    println("初始大小: ${deque.size}")      // 0
    println("初始容量: ${deque.capacity}")  // 8
    println("是否为空: ${deque.isEmpty()}") // true
    return 0
}
```

运行结果：

```text
初始大小: 0
初始容量: 8
是否为空: true
```

### init(Int64)

```cangjie
public init(capacity: Int64)
```

功能：构造一个具有指定容量的双端队列，当 capacity 小于默认容量 8 时，构造的 [ArrayDeque](#class-arraydequet) 初始容量为 8 。

参数：

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 指定的初始容量。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果参数的大小小于 0 则抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    // 指定容量大于默认容量
    let deque1 = ArrayDeque<Int64>(16)
    println("指定容量16的初始容量: ${deque1.capacity}")  // 16
    
    // 指定容量小于默认容量
    let deque2 = ArrayDeque<Int64>(4)
    println("指定容量4的初始容量: ${deque2.capacity}")   // 8
    
    return 0
}
```

运行结果：

```text
指定容量16的初始容量: 16
指定容量4的初始容量: 8
```

### func addFirst(T)

```cangjie
public func addFirst(element: T): Unit
```

功能：在此双端队列头部插入元素。

参数：

- element: T - 被插入到此双端队列的元素。

示例：

```
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addFirst(1)
    deque.addFirst(0)
    println(deque)  // [0, 1]
    return 0
}
```

运行结果：

```text
[0, 1]
```

### func addLast(T)

```cangjie
public func addLast(element: T): Unit
```

功能：在此双端队列尾部插入元素。

参数：

- element: T - 被插入到此双端队列的元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addLast(1)
    deque.addLast(2)
    println(deque)  // [1, 2]
    return 0
}
```

运行结果：

```text
[1, 2]
```

### func clear()

```cangjie
public func clear(): Unit
```

功能：清空此双端队列中的所有元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>(4)
    deque.addLast(1)
    deque.addLast(2)
    deque.clear()
    println("队列是否为空: ${deque.isEmpty()}")  // true
    return 0
}
```

运行结果：

```text
队列是否为空: true
```

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

功能：获取此双端队列中元素的迭代器，其顺序为从前到后的顺序。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 元素的迭代器。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addLast(1)
    deque.addLast(2)
    deque.addLast(3)
    
    // 使用for循环遍历
    for (element in deque) {
        println(element)
    }
    return 0
}
```

运行结果：

```text
1
2
3
```

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：判断此双端队列是否为空。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果为空，则返回 `true`，否则，返回 `false`。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque1 = ArrayDeque<Int64>()
    let deque2 = ArrayDeque<Int64>()
    deque2.addLast(1)
    
    println("deque1是否为空: ${deque1.isEmpty()}")  // true
    println("deque2是否为空: ${deque2.isEmpty()}")  // false
    return 0
}
```

运行结果：

```text
deque1是否为空: true
deque2是否为空: false
```

### func removeFirst()

```cangjie
public func removeFirst(): ?T
```

功能：删除双端队列中的头部元素并返回该值，如果此双端队列为空，返回 `None`。

返回值：

- ?T - 被删除的头部元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addLast(1)
    deque.addLast(2)
    
    let first = deque.removeFirst()
    println("删除的元素: ${first}")  // Some(1)
    println("删除后的队列: ${deque}")  // [2]
    
    let emptyDeque = ArrayDeque<Int64>()
    let noneElement = emptyDeque.removeFirst()
    println("从空队列删除的元素: ${noneElement}")  // None
    return 0
}
```

运行结果：

```text
删除的元素: Some(1)
删除后的队列: [2]
从空队列删除的元素: None
```

### func removeLast()

```cangjie
public func removeLast(): ?T
```

功能：删除双端队列中的尾部元素并返回该值，如果此双端队列为空，返回 `None`。

返回值：

- ?T - 被删除的尾部元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addLast(1)
    deque.addLast(2)
    
    let last = deque.removeLast()
    println("删除的元素: ${last}")  // Some(2)
    println("删除后的队列: ${deque}")  // [1]
    
    let emptyDeque = ArrayDeque<Int64>()
    let noneElement = emptyDeque.removeLast()
    println("从空队列删除的元素: ${noneElement}")  // None
    return 0
}
```

运行结果：

```text
删除的元素: Some(2)
删除后的队列: [1]
从空队列删除的元素: None
```

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

功能：增加此双端队列的容量。

将双端队列扩容 additional 大小，当 additional 小于等于零时，不发生扩容；当此双端队列剩余容量大于等于 additional 时，不发生扩容；当此双端队列剩余容量小于 additional 时，取（原始容量的1.5倍向下取整）与（additional + 已使用容量）两个值中的最大值进行扩容。

参数：

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 将要扩容的大小。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    
    // 初始容量为8
    println("初始容量: ${deque.capacity}")  // 8
    
    // 预留空间
    deque.reserve(10)
    println("预留10个元素后的容量: ${deque.capacity}")  // 12
    
    // 添加元素
    for (i in 0..5) {
        deque.addLast(i)
    }
    println("添加5个元素后容量: ${deque.capacity}")   // 12
    println("添加5个元素后大小: ${deque.size}")       // 5
    
    return 0
}
```

运行结果：

```text
初始容量: 8
预留10个元素后的容量: 12
添加5个元素后容量: 12
添加5个元素后大小: 5
```

### func toArray()

```cangjie
public func toArray(): Array<T>
```

功能：返回一个数组，其包含此双端队列中的所有元素，且顺序为从前到后的顺序。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - T 类型数组。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addLast(1)
    deque.addLast(2)
    deque.addLast(3)
    
    let array = deque.toArray()
    println(array)  // [1, 2, 3]
    return 0
}
```

运行结果：

```text
[1, 2, 3]
```

### extend\<T> ArrayDeque\<T> <: ToString where T <: ToString

```cangjie
extend<T> ArrayDeque<T> <: ToString where T <: ToString
```

功能：为 [ArrayDeque](./collection_package_class.md#class-arraydequet)\<T> 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：获取当前[ArrayDeque](./collection_package_class.md#class-arraydequet)\<T>实例的字符串表示。

该字符串包含双端队列内每个元素的字符串表示，其顺序为从前到后的顺序，形如："[elem1, elem2, elem3]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 转换得到的字符串。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let deque = ArrayDeque<Int64>()
    deque.addLast(1)
    deque.addLast(2)
    deque.addLast(3)
    println(deque.toString())  // [1, 2, 3]
    return 0
}
```

运行结果：

```text
队列: [1, 2, 3]
字符串: [1, 2, 3]
```

## class ArrayList\<T>

```cangjie
public class ArrayList<T> <: List<T> {
    public init()
    public init(capacity: Int64)
    public init(size: Int64, initElement: (Int64) -> T)
    public init(elements: Collection<T>)
}
```

功能：提供可变长度的数组的功能。

[ArrayList](collection_package_class.md#class-arraylistt) 是一种线性的动态数组，与 [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt) 不同，它可以根据需要自动调整大小，并且在创建时不需要指定大小。

> **说明：**
>
> - 当向动态数组中添加元素时，如果数组已满，则会重新分配更大的内存空间，并将原有的元素复制到新的内存空间中。
>
> - 动态数组的优点是可以节省内存空间，并且可以根据需要自动调整大小，因此非常适合需要频繁添加或删除元素的情况。但是，动态数组的缺点是在重新分配内存空间时可能会导致性能下降，因此在使用动态数组时需要考虑这一点。

父类型：

- [List](./collection_package_interface.md#interface-listt)\<T>

### prop size

```cangjie
public prop size: Int64
```

功能：返回此 [ArrayList](collection_package_class.md#class-arraylistt) 中的元素个数。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    println("初始大小: ${list.size}")  // 0
    
    list.add(1)
    list.add(2)
    println("添加2个元素后大小: ${list.size}")  // 2
    
    return 0
}
```

运行结果：

```text
初始大小: 0
添加2个元素后大小: 2
```

### prop capacity

```cangjie
public prop capacity: Int64
```

功能：返回此 [ArrayList](collection_package_class.md#class-arraylistt) 的容量大小。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    println("初始容量: ${list.capacity}")  // 16
    
    // 添加元素直到扩容
    for (i in 0..17) {
        list.add(i)
    }
    println("添加17个元素后容量: ${list.capacity}")  // 24
    
    return 0
}
```

运行结果：

```text
初始容量: 16
添加17个元素后容量: 24
```

### prop first

```cangjie
public prop first: ?T
```

功能：返回此 [ArrayList](collection_package_class.md#class-arraylistt) 中的第一个元素，如果没有则返回 None。

类型：?T

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    
    let first = list.first
    println("第一个元素: ${first}")  // Some(1)
    
    let emptyList = ArrayList<String>()
    let noneFirst = emptyList.first
    println("空列表第一个元素: ${noneFirst}")  // None
    
    return 0
}
```

运行结果：

```text
第一个元素: Some(1)
空列表第一个元素: None
```

### prop last

```cangjie
public prop last: ?T
```

功能：返回此 [ArrayList](collection_package_class.md#class-arraylistt) 中的最后一个元素，如果没有则返回 None。

类型：?T

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    
    let last = list.last
    println("最后一个元素: ${last}")  // Some(2)
    
    let emptyList = ArrayList<String>()
    let noneLast = emptyList.last
    println("空列表最后一个元素: ${noneLast}")  // None
    
    return 0
}
```

运行结果：

```text
最后一个元素: Some(2)
空列表最后一个元素: None
```

### init()

```cangjie
public init()
```

功能：构造一个初始容量大小为默认值`16`的[ArrayList](collection_package_class.md#class-arraylistt)。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    println("初始大小: ${list.size}")      // 0
    println("初始容量: ${list.capacity}")  // 16
    println("是否为空: ${list.isEmpty()}") // true
    return 0
}
```

运行结果：

```text
初始大小: 0
初始容量: 16
是否为空: true
```

### init(Collection\<T>)

```cangjie
public init(elements: Collection<T>)
```

功能：构造一个包含指定集合中所有元素的 [ArrayList](collection_package_class.md#class-arraylistt)。这些元素按照集合的迭代器返回的顺序排列。

参数：

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 传入集合。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let array = [1, 2, 3]
    let list = ArrayList<Int64>(array)
    println("列表内容: ${list}")  // [1, 2, 3]
    println("列表大小: ${list.size}")  // 3
    return 0
}
```

运行结果：

```text
列表内容: [1, 2, 3]
列表大小: 3
```

### init(Int64)

```cangjie
public init(capacity: Int64)
```

功能：构造一个初始容量为指定大小的 [ArrayList](collection_package_class.md#class-arraylistt)。

参数：

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 指定的初始容量大小。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果参数的大小小于 0 则抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    // 指定容量大于默认容量
    let list1 = ArrayList<Int64>(32)
    println("指定容量32的初始容量: ${list1.capacity}")  // 32
    
    // 指定容量小于默认容量
    let list2 = ArrayList<Int64>(8)
    println("指定容量8的初始容量: ${list2.capacity}")   // 16
    
    return 0
}
```

运行结果：

```text
指定容量32的初始容量: 32
指定容量8的初始容量: 16
```

### init(Int64, (Int64) -> T)

```cangjie
public init(size: Int64, initElement: (Int64) -> T)
```

功能：构造具有指定初始元素个数和指定规则函数的 [ArrayList](collection_package_class.md#class-arraylistt)。该构造函数根据参数 size 设置 [ArrayList](collection_package_class.md#class-arraylistt) 的容量。

参数：

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 初始化函数元素个数。
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) ->T - 传入初始化函数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 size 小于 0 则抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    // 创建一个包含5个元素的列表，每个元素的值为其索引的平方
    let list = ArrayList<Int64>(5, {
        index: Int64 => 
        index * index
    })
    
    println("列表内容: ${list}")  // [0, 1, 4, 9, 16]
    println("列表大小: ${list.size}")  // 5
    
    return 0
}
```

运行结果：

```text
列表内容: [0, 1, 4, 9, 16]
列表大小: 5
```

### static func of(Array\<T>)

```cangjie
public static func of(elements: Array<T>): ArrayList<T>
```

功能：构造一个包含指定数组中所有元素的 [ArrayList](collection_package_class.md#class-arraylistt)。

参数：

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - 传入数组。

返回值：

- [ArrayList](#class-arraylistt)\<T> - 元素为 T 类型的 ArrayList。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let array = [1, 2, 3, 4, 5]
    let list = ArrayList<Int64>.of(array)
    
    println("数组: ${array}")      // [1, 2, 3, 4, 5]
    println("列表: ${list}")       // [1, 2, 3, 4, 5]
    println("列表大小: ${list.size}")  // 5
    
    return 0
}
```

运行结果：

```text
数组: [1, 2, 3, 4, 5]
列表: [1, 2, 3, 4, 5]
列表大小: 5
```

### func add(T)

```cangjie
public func add(element: T): Unit
```

功能：将指定的元素附加到此 [ArrayList](collection_package_class.md#class-arraylistt) 的末尾。

参数：

- element: T - 插入的元素，类型为 T。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    list.add(3)
    
    println("列表内容: ${list}")  // [1, 2, 3]
    println("列表大小: ${list.size}")  // 3
    
    return 0
}
```

运行结果：

```text
列表内容: [1, 2, 3]
列表大小: 3
```

### func add(Collection\<T>)

```cangjie
public func add(all!: Collection<T>): Unit
```

功能：将指定集合中的所有元素附加到此 [ArrayList](collection_package_class.md#class-arraylistt) 的末尾。

函数会按照迭代器顺序遍历入参中的集合，并且将所有元素插入到此 [ArrayList](collection_package_class.md#class-arraylistt) 的尾部。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 需要插入的元素的集合。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    
    // 创建另一个列表作为Collection使用
    let newElements = ArrayList<Int64>()
    newElements.add(3)
    newElements.add(4)
    newElements.add(5)
    
    // 将新元素添加到原列表末尾
    list.add(all: newElements)
    
    println("列表内容: ${list}")  // [1, 2, 3, 4, 5]
    println("列表大小: ${list.size}")  // 5
    
    return 0
}
```

运行结果：

```text
列表内容: [1, 2, 3, 4, 5]
列表大小: 5
```

### func add(T, Int64)

```cangjie
public func add(element: T, at!: Int64): Unit
```

功能：在此 [ArrayList](collection_package_class.md#class-arraylistt) 中的指定位置插入指定元素。

参数：

- element: T - 要插入的 T 类型元素。
- at!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 插入元素的目标索引。

异常：

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - 当 at 超出范围时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(3)
    
    // 在索引1处插入元素2
    list.add(2, at: 1)
    
    println("列表内容: ${list}")  // [1, 2, 3]
    println("列表大小: ${list.size}")  // 3
    
    return 0
}
```

运行结果：

```text
列表内容: [1, 2, 3]
列表大小: 3
```

### func add(Collection\<T>, Int64)

```cangjie
public func add(all!: Collection<T>, at!: Int64): Unit
```

功能：从指定位置开始，将指定集合中的所有元素插入此 [ArrayList](collection_package_class.md#class-arraylistt)。

函数会按照迭代器顺序遍历入参中的集合，并且将所有元素插入到指定位置，原先在指定位置及其后的元素会后移。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 要插入的 T 类型元素集合。
- at!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 插入集合的目标索引。

异常：

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - 当 at 超出范围时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(5)
    
    // 在索引1处插入集合[2, 3, 4]
    let elements = ArrayList<Int64>()
    elements.add(2)
    elements.add(3)
    elements.add(4)
    list.add(all: elements, at: 1)
    
    println("列表内容: ${list}")  // [1, 2, 3, 4, 5]
    println("列表大小: ${list.size}")  // 5
    
    return 0
}
```

运行结果：

```text
列表内容: [1, 2, 3, 4, 5]
列表大小: 5
```

### func clear()

```cangjie
public func clear(): Unit
```

功能：从此 [ArrayList](collection_package_class.md#class-arraylistt) 中删除所有元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    list.add(3)
    
    println("清空前列表内容: ${list}")  // [1, 2, 3]
    println("清空前列表大小: ${list.size}")  // 3
    
    list.clear()
    
    println("清空后列表内容: ${list}")  // []
    println("清空后列表大小: ${list.size}")  // 0
    println("列表是否为空: ${list.isEmpty()}")  // true
    
    return 0
}
```

运行结果：

```text
清空前列表内容: [1, 2, 3]
清空前列表大小: 3
清空后列表内容: []
清空后列表大小: 0
列表是否为空: true
```

### func clone()

```cangjie
public func clone(): ArrayList<T>
```

功能：返回此 [ArrayList](collection_package_class.md#class-arraylistt) 实例的拷贝（浅拷贝）。

返回值：

- [ArrayList](collection_package_class.md#class-arraylistt)\<T> - 返回新 [ArrayList](collection_package_class.md#class-arraylistt)\<T>。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let originalList = ArrayList<Int64>()
    originalList.add(1)
    originalList.add(2)
    originalList.add(3)
    
    // 克隆列表
    let clonedList = originalList.clone()
    
    println("原始列表: ${originalList}")  // [1, 2, 3]
    println("克隆列表: ${clonedList}")    // [1, 2, 3]
    
    // 修改原始列表不会影响克隆列表
    originalList.add(4)
    println("修改后的原始列表: ${originalList}")  // [1, 2, 3, 4]
    println("克隆列表保持不变: ${clonedList}")    // [1, 2, 3]
    
    return 0
}
```

运行结果：

```text
原始列表: [1, 2, 3]
克隆列表: [1, 2, 3]
修改后的原始列表: [1, 2, 3, 4]
克隆列表保持不变: [1, 2, 3]
```

### func get(Int64)

```cangjie
public func get(index: Int64): ?T
```

功能：返回此 [ArrayList](collection_package_class.md#class-arraylistt) 中指定位置的元素。

参数：

- index: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 要返回的元素的索引。

返回值：

- ?T - 返回指定位置的元素，如果 index 大小小于 0 或者大于等于 [ArrayList](collection_package_class.md#class-arraylistt) 中的元素数量，返回 None。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(10)
    list.add(20)
    list.add(30)
    
    // 获取有效索引的元素
    let element = list.get(1)
    println("索引1处的元素: ${element}")  // Some(20)
    
    // 获取无效索引的元素
    let noneElement = list.get(5)
    println("索引5处的元素: ${noneElement}")  // None
    
    return 0
}
```

运行结果：

```text
索引1处的元素: Some(20)
索引5处的元素: None
```

### func getRawArray()

```cangjie
public unsafe func getRawArray(): Array<T>
```

功能：返回 [ArrayList](collection_package_class.md#class-arraylistt) 的原始数据。

> **注意：**
>
> 这是一个 unsafe 的接口，使用处需要在 unsafe 上下文中。
>
> 原始数据是指 [ArrayList](collection_package_class.md#class-arraylistt) 底层实现的数组，其大小大于等于 [ArrayList](collection_package_class.md#class-arraylistt) 中的元素数量，且索引大于等于 [ArrayList](collection_package_class.md#class-arraylistt) 大小的位置中可能包含有未初始化的元素，对其进行访问可能会产生未定义的行为。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - [ArrayList](collection_package_class.md#class-arraylistt) 的底层原始数据。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    list.add(3)
    
    // 获取原始数组
    unsafe {
        let rawArray = list.getRawArray()
        println("原始数组: ${rawArray}")
        println("原始数组大小: ${rawArray.size}")  // 可能大于列表大小
    }
    
    return 0
}
```

运行结果：

```text
原始数组: [1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
原始数组大小: 16
```

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    list.add(3)
    
    // 获取原始数组
    unsafe {
        let rawArray = list.getRawArray()
        println("原始数组: ${rawArray}")
        println("原始数组大小: ${rawArray.size}")  // 可能大于列表大小
    }
    
    return 0
}
```

运行结果：

```text
原始数组: [1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
原始数组大小: 16
```

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：判断 [ArrayList](collection_package_class.md#class-arraylistt) 是否为空。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果为空，则返回 `true`，否则，返回 `false`。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let emptyList = ArrayList<Int64>()
    let nonEmptyList = ArrayList<Int64>()
    nonEmptyList.add(1)
    
    println("空列表是否为空: ${emptyList.isEmpty()}")      // true
    println("非空列表是否为空: ${nonEmptyList.isEmpty()}")  // false
    
    return 0
}
```

运行结果：

```text
空列表是否为空: true
非空列表是否为空: false
```

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

功能：返回此 [ArrayList](collection_package_class.md#class-arraylistt) 中元素的迭代器。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - [ArrayList](collection_package_class.md#class-arraylistt) 中元素的迭代器。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    list.add(3)
    
    // 使用迭代器遍历列表
    let iter = list.iterator()
    while (iter.has_next()) {
        println(iter.next())
    }
    
    return 0
}
```

运行结果：

```text
1
2
3
```

### func remove(Int64)

```cangjie
public func remove(at!: Int64): T
```

功能：删除此 [ArrayList](collection_package_class.md#class-arraylistt) 中指定位置的元素。

参数：

- at!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 被删除元素的索引。

返回值：

- T - 被移除的元素。

异常：

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - 当 at 超出范围时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    list.add(3)
    
    // 删除索引为1的元素
    let removedElement = list.remove(at: 1)
    
    println("删除的元素: ${removedElement}")  // 2
    println("删除后的列表: ${list}")         // [1, 3]
    println("删除后的列表大小: ${list.size}") // 2
    
    return 0
}
```

运行结果：

```text
删除的元素: 2
删除后的列表: [1, 3]
删除后的列表大小: 2
```

### func remove(Range\<Int64>)

```cangjie
public func remove(range: Range<Int64>): Unit
```

功能：删除此 [ArrayList](collection_package_class.md#class-arraylistt) 中 [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) 范围所包含的所有元素。

> **注意：**
>
> 如果参数 range 是使用 [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) 构造函数构造的 [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) 实例，hasEnd 为 false 时，end 值不生效，且不受构造时传入的 isClosed 的值的影响，数组切片取到原数组最后一个元素。

参数：

- range: [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet)\<[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)> - 需要被删除的元素的范围。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 当 range 的 [step](collection_package_function.md#func-steptint64) 不等于 1 时抛出异常。
- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - 当 range 的 start 或 end 小于 0，或 end 大于 [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt) 的长度时抛出。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    for (i in 0..5) {
        list.add(i)
    }
    // list现在是[0, 1, 2, 3, 4, 5]
    
    // 删除索引1到3的元素(不包括3)
    let range = Range<Int64>(1, 3)
    list.remove(range)
    
    println("删除元素后的列表: ${list}")      // [0, 3, 4, 5]
    println("删除后的列表大小: ${list.size}") // 4
    
    return 0
}
```

运行结果：

```text
删除元素后的列表: [0, 3, 4, 5]
删除后的列表大小: 4
```

### func removeIf((T) -> Bool)

```cangjie
public func removeIf(predicate: (T) -> Bool): Unit
```

功能：删除此 [ArrayList](collection_package_class.md#class-arraylistt) 中满足给定 lambda 表达式或函数的所有元素。

参数：

- predicate: (T) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 传递判断删除的条件。

异常：

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - 当 `predicate` 中增删或者修改 [ArrayList](collection_package_class.md#class-arraylistt) 内元素时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    for (i in 0..5) {
        list.add(i)
    }
    // list现在是[0, 1, 2, 3, 4, 5]
    
    // 删除所有偶数元素
    list.removeIf((element: Int64) -> Bool {
        return element % 2 == 0
    })
    
    println("删除偶数后的列表: ${list}")      // [1, 3, 5]
    println("删除后的列表大小: ${list.size}") // 3
    
    return 0
}
```

运行结果：

```text
删除偶数后的列表: [1, 3, 5]
删除后的列表大小: 3
```

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

功能：增加此 [ArrayList](collection_package_class.md#class-arraylistt) 实例的容量。

将 [ArrayList](collection_package_class.md#class-arraylistt) 扩容 additional 大小，当 additional 小于等于零时，不发生扩容；当 [ArrayList](collection_package_class.md#class-arraylistt) 剩余容量大于等于 additional 时，不发生扩容；当 [ArrayList](collection_package_class.md#class-arraylistt) 剩余容量小于 additional 时，取（原始容量的1.5倍向下取整）与（additional + 已使用容量）两个值中的最大值进行扩容。

参数：

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 将要扩容的大小。

异常：

- [OverflowException](../../core/core_package_api/core_package_exceptions.md#class-overflowexception) - 当additional + 已使用容量超过Int64.Max时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    
    // 初始容量为16
    println("初始容量: ${list.capacity}")  // 16
    
    // 预留额外空间
    list.reserve(20)
    println("预留20个元素后的容量: ${list.capacity}")  // 32 (扩容到接近36的合适大小)
    
    // 添加元素
    for (i in 0..9) {
        list.add(i)
    }
    println("添加10个元素后容量: ${list.capacity}")   // 32
    println("添加10个元素后大小: ${list.size}")       // 10
    
    return 0
}
```

运行结果：

```text
初始容量: 16
预留20个元素后的容量: 32
添加10个元素后容量: 32
添加10个元素后大小: 10
```

### func reverse()

```cangjie
public func reverse(): Unit
```

功能：反转此 [ArrayList](collection_package_class.md#class-arraylistt) 中元素的顺序。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    for (i in 0..4) {
        list.add(i)
    }
    // list现在是[0, 1, 2, 3, 4]
    println("反转前: ${list}")  // [0, 1, 2, 3, 4]
    
    // 反转列表
    list.reverse()
    
    println("反转后: ${list}")  // [4, 3, 2, 1, 0]
    
    return 0
}
```

运行结果：

```text
反转前: [0, 1, 2, 3, 4]
反转后: [4, 3, 2, 1, 0]
```

### func slice(Range\<Int64>)

```cangjie
public func slice(range: Range<Int64>): ArrayList<T>
```

功能：以传入参数 range 作为索引，返回索引对应的 [ArrayList](collection_package_class.md#class-arraylistt)\<T>。

> **注意：**
>
> 如果参数 range 是使用 [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) 构造函数构造的 [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) 实例，有如下行为：
>
> 1. start 的值就是构造函数传入的值本身，不受构造时传入的 hasStart 的值的影响。
> 2. hasEnd 为 false 时，end 值不生效，且不受构造时传入的 isClosed 的值的影响，该数组切片取到原数组最后一个元素。

参数：

- range: [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet)\<[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)> - 传递切片的范围。

返回值：

- [ArrayList](collection_package_class.md#class-arraylistt)\<T> - 切片所得的数组。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 当 range.[step](collection_package_function.md#func-steptint64) 不等于 1 时，抛出异常。
- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - 当 range 无效时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    for (i in 0..5) {
        list.add(i)
    }
    // list现在是[0, 1, 2, 3, 4, 5]
    
    println("原列表: ${list}")  // [0, 1, 2, 3, 4, 5]
    
    // 通过范围操作符切片
    let range = Range<Int64>(1, 4)
    let sliceList = list[range]
    
    println("切片列表: ${sliceList}")     // [1, 2, 3]
    println("切片列表大小: ${sliceList.size}") // 3
    
    return 0
}
```

运行结果：

```text
原列表: [0, 1, 2, 3, 4, 5]
切片列表: [1, 2, 3]
切片列表大小: 3
```

### func sortBy((T, T) -> Ordering) <sup>(deprecated)</sup>

```cangjie
public func sortBy(comparator!: (T, T) -> Ordering): Unit
```

功能：对数组中的元素进行非稳定排序。

通过传入的比较函数，根据其返回值 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering) 类型的结果，可对数组进行自定义排序comparator: (t1: T, t2: T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering)，如果 comparator 的返回值为 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).GT，排序后 t1 在 t2后；如果 comparator 的返回值为 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).LT，排序后 t1 在t2 前；如果 comparator 的返回值为 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).EQ，且为稳定排序，那么 t1 在 t2 之前； 如果 comparator 的返回值为 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).EQ，且为不稳定排序，那么 t1，t2 顺序不确定。
> **注意：**
>
> 未来版本即将废弃，使用 [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) 替代。

参数：

- comparator!: (T, T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering) - (T, T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering) 类型。

示例：

<!-- verify -->
```cangjie
import std.collection.*
import std.core.*

main() {
    let list = ArrayList<Int64>()
    list.add(3)
    list.add(1)
    list.add(4)
    list.add(2)
    // list现在是[3, 1, 4, 2]
    println("排序前: ${list}")  // [3, 1, 4, 2]
    
    // 按降序排序
    list.sortBy((a: Int64, b: Int64) -> Ordering {
        if (a > b) {
            return Ordering.GT
        } else if (a < b) {
            return Ordering.LT
        } else {
            return Ordering.EQ
        }
    })
    
    println("排序后: ${list}")  // [4, 3, 2, 1]
    
    return 0
}
```

运行结果：

```text
排序前: [3, 1, 4, 2]
排序后: [4, 3, 2, 1]
```

### func sortBy(Bool, (T, T) -> Ordering) <sup>(deprecated)</sup>

```cangjie
public func sortBy(stable!: Bool, comparator!: (T, T) -> Ordering): Unit
```

功能：对数组中的元素进行排序。

通过传入的比较函数，根据其返回值 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering) 类型的结果，可对数组进行自定义排序comparator: (t1: T, t2: T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering)，如果 comparator 的返回值为 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).GT，排序后 t1 在 t2后；如果 comparator 的返回值为 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).LT，排序后 t1 在t2 前；如果 comparator 的返回值为 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).EQ，且为稳定排序，那么 t1 在 t2 之前； 如果 comparator 的返回值为 [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).EQ，且为不稳定排序，那么 t1，t2 顺序不确定。

> **注意：**
>
> 未来版本即将废弃，使用 [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) 替代。

参数：

- stable!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 是否使用稳定排序。
- comparator!: (T, T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering) - (T, T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering) 类型。

示例：

<!-- verify -->
```cangjie
import std.collection.*
import std.core.*

main() {
    let list = ArrayList<Int64>()
    list.add(3)
    list.add(1)
    list.add(4)
    list.add(2)
    // list现在是[3, 1, 4, 2]
    println("排序前: ${list}")  // [3, 1, 4, 2]
    
    // 使用稳定排序按降序排序
    list.sortBy(stable: true, (a: Int64, b: Int64) -> Ordering {
        if (a > b) {
            return Ordering.GT
        } else if (a < b) {
            return Ordering.LT
        } else {
            return Ordering.EQ
        }
    })
    
    println("稳定排序后: ${list}")  // [4, 3, 2, 1]
    
    return 0
}
```

运行结果：

```text
排序前: [3, 1, 4, 2]
稳定排序后: [4, 3, 2, 1]
```

### func toArray()

```cangjie
public func toArray(): Array<T>
```

功能：返回一个数组，其中包含此列表中按正确顺序排列的所有元素。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - T 类型数组。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    for (i in 0..4) {
        list.add(i)
    }
    // list现在是[0, 1, 2, 3, 4]
    println("列表: ${list}")  // [0, 1, 2, 3, 4]
    
    // 转换为数组
    let array = list.toArray()
    
    println("数组: ${array}")      // [0, 1, 2, 3, 4]
    println("数组大小: ${array.size}") // 5
    
    return 0
}
```

运行结果：

```text
列表: [0, 1, 2, 3, 4]
数组: [0, 1, 2, 3, 4]
数组大小: 5
```

### operator func \[](Int64)

```cangjie
public operator func [](index: Int64): T
```

功能：操作符重载 - get。

参数：

- index: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 表示 get 接口的索引。

返回值：

- T - 索引位置的元素的值。

异常：

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - 当 index 超出范围时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(10)
    list.add(20)
    list.add(30)
    
    // 通过索引访问元素
    let element = list[1]
    println("索引1处的元素: ${element}")  // 20
    
    // 修改索引处的元素
    list[1] = 25
    println("修改后索引1处的元素: ${list[1]}")  // 25
    println("修改后的列表: ${list}")           // [10, 25, 30]
    
    return 0
}
```

运行结果：

```text
索引1处的元素: 20
修改后索引1处的元素: 25
修改后的列表: [10, 25, 30]
```

### operator func \[](Int64, T)

```cangjie
public operator func [](index: Int64, value!: T): Unit
```

功能：操作符重载，通过下标运算符用指定的元素替换此列表中指定位置的元素。

参数：

- index: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 要设置的索引值。
- value!: T - 要设置的 T 类型的值。

异常：

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - 当 index 超出范围时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(10)
    list.add(20)
    list.add(30)
    
    println("修改前的列表: ${list}")  // [10, 20, 30]
    
    // 通过索引修改元素
    list[1] = 25
    
    println("修改后的列表: ${list}")  // [10, 25, 30]
    println("索引1处的元素: ${list[1]}") // 25
    
    return 0
}
```

运行结果：

```text
修改前的列表: [10, 20, 30]
修改后的列表: [10, 25, 30]
索引1处的元素: 25
```

### operator func \[](Range\<Int64>)

```cangjie
public operator func [](range: Range<Int64>): ArrayList<T>
```

功能：运算符重载 - 切片。

> **注意：**
>
> - 如果参数 range 是使用 [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) 构造函数构造的 [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) 实例，有如下行为：
>     - start 的值就是构造函数传入的值本身，不受构造时传入的 hasStart 的值的影响。
>     - hasEnd 为 false 时，end 值不生效，且不受构造时传入的 isClosed 的值的影响，数组切片取到原数组最后一个元素。
>
> - 切片操作返回的 [ArrayList](collection_package_class.md#class-arraylistt) 为全新的对象，与原 [ArrayList](collection_package_class.md#class-arraylistt) 无引用关系。

参数：

- range: [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet)\<[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)> - 传递切片的范围。

返回值：

- [ArrayList](collection_package_class.md#class-arraylistt)\<T> - 切片所得的数组。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 当 range.[step](collection_package_function.md#func-steptint64) 不等于 1 时，抛出异常。
- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - 当 range 无效时，抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    for (i in 0..5) {
        list.add(i)
    }
    // list现在是[0, 1, 2, 3, 4, 5]
    
    println("原列表: ${list}")  // [0, 1, 2, 3, 4, 5]
    
    // 通过范围操作符切片
    let sliceList = list[1..4]
    
    println("切片列表: ${sliceList}")        // [1, 2, 3]
    println("切片列表大小: ${sliceList.size}") // 3
    
    return 0
}
```

运行结果：

```text
原列表: [0, 1, 2, 3, 4, 5]
切片列表: [1, 2, 3]
切片列表大小: 3
```

### extend\<T> ArrayList\<T> <: Equatable\<ArrayList\<T>> where T <: Equatable\<T>

```cangjie
extend<T> ArrayList<T> <: Equatable<ArrayList<T>> where T <: Equatable<T>
```

功能：为 [ArrayList](./collection_package_class.md#class-arraylistt)\<T> 类型扩展 [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[ArrayList](./collection_package_class.md#class-arraylistt)\<T>> 接口，支持判等操作。

父类型：

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[ArrayList](#class-arraylistt)\<T>>

#### operator func ==(ArrayList\<T>)

```cangjie
public operator func ==(that: ArrayList<T>): Bool
```

功能：判断当前实例与参数指向的 [ArrayList](./collection_package_class.md#class-arraylistt) 实例是否相等。

两个数组相等指的是两者对应位置的元素分别相等。

参数：

- that: [ArrayList](./collection_package_class.md#class-arraylistt)\<T> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果相等，则返回 true，否则返回 false。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list1 = ArrayList<Int64>()
    list1.add(1)
    list1.add(2)
    list1.add(3)
    
    let list2 = ArrayList<Int64>()
    list2.add(1)
    list2.add(2)
    list2.add(3)
    
    let list3 = ArrayList<Int64>()
    list3.add(1)
    list3.add(2)
    
    println("list1 == list2: ${list1 == list2}")  // true
    println("list1 == list3: ${list1 == list3}")  // false
    
    return 0
}
```

运行结果：

```text
list1 == list2: true
list1 == list3: false
```

#### operator func !=(ArrayList\<T>)

```cangjie
public operator func !=(that: ArrayList<T>): Bool
```

功能：判断当前实例与参数指向的 [ArrayList](./collection_package_class.md#class-arraylistt) 实例是否不等。

参数：

- that: [ArrayList](./collection_package_class.md#class-arraylistt)\<T> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果不等，则返回 true，否则返回 false。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list1 = ArrayList<Int64>()
    list1.add(1)
    list1.add(2)
    list1.add(3)
    
    let list2 = ArrayList<Int64>()
    list2.add(1)
    list2.add(2)
    
    let list3 = ArrayList<Int64>()
    list3.add(1)
    list3.add(2)
    list3.add(3)
    
    println("list1 != list2: ${list1 != list2}")  // true
    println("list1 != list3: ${list1 != list3}")  // false
    
    return 0
}
```

运行结果：

```text
list1 != list2: true
list1 != list3: false
```

#### func contains(T)

```cangjie
public func contains(element: T): Bool
```

功能：判断当前数组中是否含有指定元素 `element`。

参数：

- element: T - 待寻找的元素。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果数组中包含指定元素，返回 true，否则返回 false。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    list.add(3)
    
    println("列表包含元素2: ${list.contains(2)}")  // true
    println("列表包含元素5: ${list.contains(5)}")  // false
    
    return 0
}
```

运行结果：

```text
列表包含元素2: true
列表包含元素5: false
```

### extend\<T> ArrayList\<T> <: SortExtension where T <: Comparable\<T> <sup>(deprecated)</sup>

```cangjie
extend<T> ArrayList<T> where T <: Comparable<T>
```

功能：为 [ArrayList](./collection_package_class.md#class-arraylistt)\<T> 扩展 [SortExtension](../../sort/sort_package_api/sort_package_interfaces.md#interface-sortextension-deprecated) 接口，支持数组排序。

> **注意：**
>
> 未来版本即将废弃。

父类型：

- [SortExtension](../../sort/sort_package_api/sort_package_interfaces.md#interface-sortextension-deprecated)

#### func sort() <sup>(deprecated)</sup>

```cangjie
public func sort(): Unit
```

功能：将当前数组内元素以升序的方式非稳定排序。

> **注意：**
>
> 未来版本即将废弃，使用 [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) 替代。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(3)
    list.add(1)
    list.add(4)
    list.add(2)
    // list现在是[3, 1, 4, 2]
    println("排序前: ${list}")  // [3, 1, 4, 2]
    
    // 升序排序
    list.sort()
    
    println("排序后: ${list}")  // [1, 2, 3, 4]
    
    return 0
}
```

运行结果：

```text
排序前: [3, 1, 4, 2]
排序后: [1, 2, 3, 4]
```

#### func sort(Bool) <sup>(deprecated)</sup>

```cangjie
public func sort(stable!: Bool): Unit
```

功能：将当前数组内元素以升序的方式排序。

参数：

- stable!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 是否使用稳定排序。

> **注意：**
>
> 未来版本即将废弃，使用 [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) 替代。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(3)
    list.add(1)
    list.add(4)
    list.add(2)
    // list现在是[3, 1, 4, 2]
    println("排序前: ${list}")  // [3, 1, 4, 2]
    
    // 使用稳定排序升序排序
    list.sort(stable: true)
    
    println("稳定排序后: ${list}")  // [1, 2, 3, 4]
    
    return 0
}
```

运行结果：

```text
排序前: [3, 1, 4, 2]
稳定排序后: [1, 2, 3, 4]
```

#### func sortDescending() <sup>(deprecated)</sup>

```cangjie
public func sortDescending(): Unit
```

功能：将当前数组内元素以降序的方式非稳定排序。

> **注意：**
>
> 未来版本即将废弃，使用 [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) 替代。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(3)
    list.add(1)
    list.add(4)
    list.add(2)
    // list现在是[3, 1, 4, 2]
    println("排序前: ${list}")  // [3, 1, 4, 2]
    
    // 降序排序
    list.sortDescending()
    
    println("降序排序后: ${list}")  // [4, 3, 2, 1]
    
    return 0
}
```

运行结果：

```text
排序前: [3, 1, 4, 2]
降序排序后: [4, 3, 2, 1]
```

#### func sortDescending(Bool) <sup>(deprecated)</sup>

```cangjie
public func sortDescending(stable!: Bool): Unit
```

功能：将当前数组内元素以降序的方式排序。

参数：

- stable!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 是否使用稳定排序。

> **注意：**
>
> 未来版本即将废弃，使用 [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) 替代。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(3)
    list.add(1)
    list.add(4)
    list.add(2)
    // list现在是[3, 1, 4, 2]
    println("排序前: ${list}")  // [3, 1, 4, 2]
    
    // 使用稳定排序降序排序
    list.sortDescending(stable: true)
    
    println("稳定降序排序后: ${list}")  // [4, 3, 2, 1]
    
    return 0
}
```

运行结果：

```text
排序前: [3, 1, 4, 2]
稳定降序排序后: [4, 3, 2, 1]
```

### extend\<T> ArrayList\<T> <: ToString where T <: ToString

```cangjie
extend<T> ArrayList<T> <: ToString where T <: ToString
```

功能：为 [ArrayList](./collection_package_class.md#class-arraylistt)\<T> 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：将当前数组转换为字符串。

该字符串包含数组内每个元素的字符串表示，形如："[elem1, elem2, elem3]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 转换得到的字符串。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let list = ArrayList<Int64>()
    list.add(1)
    list.add(2)
    list.add(3)
    
    let str = list.toString()
    
    println("列表: ${list}")     // [1, 2, 3]
    println("字符串: ${str}")    // [1, 2, 3]
    println("字符串长度: ${str.size}") // 9
    
    return 0
}
```

运行结果：

```text
列表: [1, 2, 3]
字符串: [1, 2, 3]
字符串长度: 9
```

## class ArrayQueue\<T>

```cangjie
public class ArrayQueue<T> <: Queue<T> {
    public init()
    public init(capacity: Int64)
}
```

功能：基于数组实现的循环队列数据结构。

父类型：

- [Queue](./collection_package_interface.md#interface-queuet)\<T>

### prop capacity

```cangjie
public prop capacity: Int64
```

功能：获取此队列的容量。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 初始容量为8
    println("初始容量: ${queue.capacity}")  // 8
    
    // 指定容量构造
    let queue2 = ArrayQueue<Int64>(16)
    println("指定容量: ${queue2.capacity}")  // 16
    
    return 0
}
```

运行结果：

```text
初始容量: 8
指定容量: 16
```

### prop size

```cangjie
public prop size: Int64
```

功能：返回此队列中的元素个数。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 初始大小为0
    println("初始大小: ${queue.size}")  // 0
    
    // 添加元素后大小变化
    queue.add(1)
    queue.add(2)
    println("添加元素后大小: ${queue.size}")  // 2
    
    return 0
}
```

运行结果：

```text
初始大小: 0
添加元素后大小: 2
```

### init()

```cangjie
public init()
```

功能：构造一个空的队列，其容量大小为默认值 8。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    // 使用默认构造函数创建队列
    let queue = ArrayQueue<Int64>()
    
    println("初始大小: ${queue.size}")      // 0
    println("初始容量: ${queue.capacity}")  // 8
    println("是否为空: ${queue.isEmpty()}") // true
    
    return 0
}
```

运行结果：

```text
初始大小: 0
初始容量: 8
是否为空: true
```

### init(Int64)

```cangjie
public init(capacity: Int64)
```

功能：构造一个具有指定容量的队列，当 capacity 小于默认容量 8 时，构造的 [ArrayQueue](#class-arrayqueuet) 初始容量为 8 。

参数：

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 指定的初始容量。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果参数的大小小于 0 则抛出异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    // 指定容量大于默认容量
    let queue1 = ArrayQueue<Int64>(16)
    println("指定容量16的队列容量: ${queue1.capacity}")  // 16
    
    // 指定容量小于默认容量
    let queue2 = ArrayQueue<Int64>(4)
    println("指定容量4的队列容量: ${queue2.capacity}")   // 8
    
    // 添加元素测试
    queue2.add(1)
    queue2.add(2)
    println("添加元素后大小: ${queue2.size}")  // 2
    
    return 0
}
```

运行结果：

```text
指定容量16的队列容量: 16
指定容量4的队列容量: 8
添加元素后大小: 2
```

### func add(T)

```cangjie
public func add(element: T): Unit
```

功能：在此队列尾部插入元素。

参数：

- element: T - 被插入到此双端队列的元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 添加元素到队列尾部
    queue.add(1)
    queue.add(2)
    queue.add(3)
    
    println("队列大小: ${queue.size}")      // 3
    println("队列容量: ${queue.capacity}")  // 8
    
    // 查看队列头部元素
    let head = queue.peek()
    println("队列头部元素: ${head}")  // Some(1)
    
    return 0
}
```

运行结果：

```text
队列大小: 3
队列容量: 8
队列头部元素: Some(1)
```

### func clear()

```cangjie
public func clear(): Unit
```

功能：清空此队列中的所有元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 添加一些元素
    queue.add(1)
    queue.add(2)
    queue.add(3)
    
    println("清空前大小: ${queue.size}")      // 3
    println("清空前是否为空: ${queue.isEmpty()}") // false
    
    // 清空队列
    queue.clear()
    
    println("清空后大小: ${queue.size}")      // 0
    println("清空后是否为空: ${queue.isEmpty()}") // true
    
    return 0
}
```

运行结果：

```text
清空前大小: 3
清空前是否为空: false
清空后大小: 0
清空后是否为空: true
```

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

功能：获取此队列中元素的迭代器，其顺序为从前到后的顺序。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 元素的迭代器。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 添加元素
    queue.add(1)
    queue.add(2)
    queue.add(3)
    
    // 使用迭代器遍历队列
    let iter = queue.iterator()
    println(iter.next())
    println(iter.next())
    println(iter.next())
    
    return 0
}
```

运行结果：

```text
Some(1)
Some(2)
Some(3)
```

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：判断此队列是否为空。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果为空，则返回 `true`，否则，返回 `false`。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 空队列
    println("空队列是否为空: ${queue.isEmpty()}")  // true
    
    // 添加元素后
    queue.add(1)
    println("添加元素后是否为空: ${queue.isEmpty()}")  // false
    
    // 移除所有元素后
    queue.remove()
    println("移除元素后是否为空: ${queue.isEmpty()}")  // true
    
    return 0
}
```

运行结果：

```text
空队列是否为空: true
添加元素后是否为空: false
移除元素后是否为空: true
```

### func peek()

```cangjie
public func peek():?T
```

功能：查看此队列头部元素。此操作不会删除元素。

返回值：

- ?T - 队列的头部元素，如果队列为空，返回`None`。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 查看空队列的头部元素
    let emptyPeek = queue.peek()
    println("空队列头部元素: ${emptyPeek}")  // None
    
    // 添加元素后查看头部元素
    queue.add(10)
    queue.add(20)
    let peekValue = queue.peek()
    println("队列头部元素: ${peekValue}")  // Some(10)
    
    // 查看头部元素不会移除元素
    println("查看后队列大小: ${queue.size}")  // 2
    
    return 0
}
```

运行结果：

```text
空队列头部元素: None
队列头部元素: Some(10)
查看后队列大小: 2
```

### func remove()

```cangjie
public func remove(): ?T
```

功能：删除队列中的头部元素并返回该值，如果此队列为空，返回 `None`。

返回值：

- ?T - 被删除的头部元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 从空队列移除元素
    let emptyRemove = queue.remove()
    println("从空队列移除元素: ${emptyRemove}")  // None
    
    // 添加元素后移除
    queue.add(10)
    queue.add(20)
    queue.add(30)
    
    let removedElement = queue.remove()
    println("移除的元素: ${removedElement}")  // Some(10)
    println("移除后队列大小: ${queue.size}")   // 2
    
    return 0
}
```

运行结果：

```text
从空队列移除元素: None
移除的元素: Some(10)
移除后队列大小: 2
```

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

功能：增加此队列的容量。

将队列扩容 additional 大小，当 additional 小于等于零时，不发生扩容；当此队列剩余容量大于等于 additional 时，不发生扩容；当此队列剩余容量小于 additional 时，取（原始容量的 1.5 倍向下取整）与（additional + 已使用容量）两个值中的最大值进行扩容。

参数：

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 将要扩容的大小。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 初始容量
    println("初始容量: ${queue.capacity}")  // 8
    
    // 预留额外空间
    queue.reserve(10)
    println("预留空间后容量: ${queue.capacity}")  // 16 (扩容到接近18的合适大小)
    
    // 添加元素测试
    for (i in 0..15) {
        queue.add(i)
    }
    println("添加16个元素后容量: ${queue.capacity}")  // 16
    println("添加16个元素后大小: ${queue.size}")    // 16
    
    return 0
}
```

运行结果：

```text
初始容量: 8
预留空间后容量: 12
添加16个元素后容量: 18
添加16个元素后大小: 15
```

### func toArray()

```cangjie
public func toArray(): Array<T>
```

功能：返回一个数组，其包含此队列中的所有元素，且顺序为从前到后的顺序。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - T 类型数组。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 添加元素
    queue.add(1)
    queue.add(2)
    queue.add(3)
    
    println("队列: ${queue}")  // [1, 2, 3]
    
    // 转换为数组
    let array = queue.toArray()
    
    println("数组: ${array}")      // [1, 2, 3]
    println("数组大小: ${array.size}") // 3
    
    return 0
}
```

运行结果：

```text
队列: [1, 2, 3]
数组: [1, 2, 3]
数组大小: 3
```

### extend\<T> ArrayQueue\<T> <: ToString where T <: ToString

```cangjie
extend<T> ArrayQueue<T> <: ToString where T <: ToString
```

功能：为 [ArrayQueue](./collection_package_class.md#class-arrayqueuet)\<T> 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：获取当前[ArrayQueue](./collection_package_class.md#class-arrayqueuet)\<T>实例的字符串表示。

该字符串包含双端队列内每个元素的字符串表示，其顺序为从前到后的顺序，形如："[elem1, elem2, elem3]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 转换得到的字符串。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let queue = ArrayQueue<Int64>()
    
    // 空队列转字符串
    let emptyStr = queue.toString()
    println("空队列字符串: ${emptyStr}")  // []
    
    // 添加元素后转字符串
    queue.add(1)
    queue.add(2)
    queue.add(3)
    
    let str = queue.toString()
    println("队列字符串: ${str}")      // [1, 2, 3]
    println("字符串长度: ${str.size}")  // 9
    
    return 0
}
```

运行结果：

```text
空队列字符串: []
队列字符串: [1, 2, 3]
字符串长度: 9
```


## class ArrayStack\<T>

```cangjie
public class ArrayStack<T> <: Stack<T> {
    public init(capacity: Int64)
    public init()
}
```

功能：[ArrayStack](#class-arraystackt) 是一种基于数组 [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt) 实现的栈 [Stack](./collection_package_interface.md#interface-stackt) 数据结构。ArrayStack 的实现方式是使用一个数组来存储栈中的元素，同时使用一个指针来指向栈顶元素的位置。

[ArrayStack](#class-arraystackt) 只支持后进先出（Last In First Out，LIFO），只能在头部进行插入删除操作，并且 [ArrayStack](#class-arraystackt) 会根据实际需要进行扩容。

父类型：

- [Stack](./collection_package_interface.md#interface-stackt)\<T>

### prop capacity

```cangjie
public prop capacity: Int64
```

功能：栈的容量大小。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 初始容量为8
    println("初始容量: ${stack.capacity}")  // 8
    
    // 指定容量构造
    let stack2 = ArrayStack<Int64>(16)
    println("指定容量: ${stack2.capacity}")  // 16
    
    return 0
}
```

运行结果：

```text
初始容量: 8
指定容量: 16
```

### prop size

```cangjie
public prop size: Int64
```

功能：栈中元素的数量。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 初始大小为0
    println("初始大小: ${stack.size}")  // 0
    
    // 添加元素后大小变化
    stack.add(1)
    stack.add(2)
    println("添加元素后大小: ${stack.size}")  // 2
    
    return 0
}
```

运行结果：

```text
初始大小: 0
添加元素后大小: 2
```

### func init()

```cangjie
public init()
```

功能：构造一个空的 [ArrayStack](#class-arraystackt)，其初始容量为 8。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    // 使用默认构造函数创建栈
    let stack = ArrayStack<Int64>()
    
    println("初始大小: ${stack.size}")      // 0
    println("初始容量: ${stack.capacity}")  // 8
    println("是否为空: ${stack.isEmpty()}") // true
    
    return 0
}
```

运行结果：

```text
初始大小: 0
初始容量: 8
是否为空: true
```

### func init(Int64)

```cangjie
public init(capacity: Int64)
```

功能：构造一个空的 [ArrayStack](#class-arraystackt)，其初始容量为指定的值。当 capacity 小于默认容量 8 时，构造的 [ArrayStack](#class-arraystackt) 初始容量为 8。

参数：

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 初始容量大小。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 当入参为负数时，抛出此异常。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    // 指定容量大于默认容量
    let stack1 = ArrayStack<Int64>(16)
    println("指定容量16的栈容量: ${stack1.capacity}")  // 16
    
    // 指定容量小于默认容量
    let stack2 = ArrayStack<Int64>(4)
    println("指定容量4的栈容量: ${stack2.capacity}")   // 8
    
    // 添加元素测试
    stack2.add(1)
    stack2.add(2)
    println("添加元素后大小: ${stack2.size}")  // 2
    
    return 0
}
```

运行结果：

```text
指定容量16的栈容量: 16
指定容量4的栈容量: 8
添加元素后大小: 2
```

### func add(T)

```cangjie
public func add(element: T): Unit
```

功能：在栈顶添加元素。

参数：

- element: T - 添加的元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 添加元素到栈顶
    stack.add(1)
    stack.add(2)
    stack.add(3)
    
    println("栈大小: ${stack.size}")      // 3
    println("栈容量: ${stack.capacity}")  // 8
    
    // 查看栈顶元素
    let top = stack.peek()
    println("栈顶元素: ${top}")  // Some(3)
    
    return 0
}
```

运行结果：

```text
栈大小: 3
栈容量: 8
栈顶元素: Some(3)
```

### func clear()

```cangjie
public func clear(): Unit
```

功能：清空当前的 [ArrayStack](#class-arraystackt)。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 添加一些元素
    stack.add(1)
    stack.add(2)
    stack.add(3)
    
    println("清空前大小: ${stack.size}")      // 3
    println("清空前是否为空: ${stack.isEmpty()}") // false
    
    // 清空栈
    stack.clear()
    
    println("清空后大小: ${stack.size}")      // 0
    println("清空后是否为空: ${stack.isEmpty()}") // true
    
    return 0
}
```

运行结果：

```text
清空前大小: 3
清空前是否为空: false
清空后大小: 0
清空后是否为空: true
```

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：判断此 [ArrayStack](#class-arraystackt) 是否为空。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果为空，返回 true，否则返回 false。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 空栈
    println("空栈是否为空: ${stack.isEmpty()}")  // true
    
    // 添加元素后
    stack.add(1)
    println("添加元素后是否为空: ${stack.isEmpty()}")  // false
    
    // 移除所有元素后
    stack.remove()
    println("移除元素后是否为空: ${stack.isEmpty()}")  // true
    
    return 0
}
```

运行结果：

```text
空栈是否为空: true
添加元素后是否为空: false
移除元素后是否为空: true
```

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

功能：返回此 [ArrayStack](#class-arraystackt) 中元素的迭代器，其顺序为出栈的顺序。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 栈中元素的迭代器。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 添加元素
    stack.add(1)
    stack.add(2)
    stack.add(3)
    
    // 使用迭代器遍历栈
    let iter = stack.iterator()
    println(iter.next())
    println(iter.next())
    println(iter.next())
    
    return 0
}
```

运行结果：

```text
Some(3)
Some(2)
Some(1)
```

### func peek()

```cangjie
public func peek(): ?T
```

功能：获取栈顶的元素，该操作不会做出栈操作，只查看栈顶的元素。当栈为空时，返回 `None`。

返回值：

- ?T - 栈顶的元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 查看空栈的栈顶元素
    let emptyPeek = stack.peek()
    println("空栈栈顶元素: ${emptyPeek}")  // None
    
    // 添加元素后查看栈顶元素
    stack.add(10)
    stack.add(20)
    let peekValue = stack.peek()
    println("栈顶元素: ${peekValue}")  // Some(20)
    
    // 查看栈顶元素不会移除元素
    println("查看后栈大小: ${stack.size}")  // 2
    
    return 0
}
```

运行结果：

```text
空栈栈顶元素: None
栈顶元素: Some(20)
查看后栈大小: 2
```

### func remove()

```cangjie
public func remove(): ?T
```

功能：出栈操作，删除栈顶的元素并且返回这个元素。当栈为空时，返回 `None`。

返回值：

- ?T - 被删除的栈顶元素。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 从空栈移除元素
    let emptyRemove = stack.remove()
    println("从空栈移除元素: ${emptyRemove}")  // None
    
    // 添加元素后移除
    stack.add(10)
    stack.add(20)
    stack.add(30)
    
    let removedElement = stack.remove()
    println("移除的元素: ${removedElement}")  // Some(30)
    println("移除后栈大小: ${stack.size}")   // 2
    
    return 0
}
```

运行结果：

```text
从空栈移除元素: None
移除的元素: Some(30)
移除后栈大小: 2
```

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

功能：为当前 [ArrayStack](#class-arraystackt) 扩容相应的空间。当 additional 小于等于零时，不发生扩容；如果当前剩余空间大小大于等于 additional，不进行扩容操作，否则当前 [ArrayStack](#class-arraystackt) 会扩容至 size + additional 大小。

参数：

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 将要扩容的大小。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 初始容量
    println("初始容量: ${stack.capacity}")  // 8
    
    // 预留额外空间
    stack.reserve(10)
    println("预留空间后容量: ${stack.capacity}")  // 12 (扩容到接近18的合适大小)
    
    // 添加元素测试
    for (i in 0..15) {
        stack.add(i)
    }
    println("添加16个元素后容量: ${stack.capacity}")  // 18
    println("添加16个元素后大小: ${stack.size}")    // 16
    
    return 0
}
```

运行结果：

```text
初始容量: 8
预留空间后容量: 12
添加16个元素后容量: 18
添加16个元素后大小: 15
```

### func toArray()

```cangjie
public func toArray(): Array<T>
```

功能：返回一个数组，其中元素为栈中的元素，顺序为栈的出栈顺序。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - T 类型数组。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 添加元素
    stack.add(1)
    stack.add(2)
    stack.add(3)
    
    println("栈: ${stack}")  // [3, 2, 1]
    
    // 转换为数组
    let array = stack.toArray()
    
    println("数组: ${array}")      // [3, 2, 1]
    println("数组大小: ${array.size}") // 3
    
    return 0
}
```

运行结果：

```text
栈: [3, 2, 1]
数组: [3, 2, 1]
数组大小: 3
```

### extend\<T> ArrayStack\<T> <: ToString where T <: ToString

```cangjie
extend<T> ArrayStack<T> <: ToString where T <: ToString
```

功能：为 ArrayStack 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：获取当前 [ArrayStack](./collection_package_class.md#class-arraystackt)\<T> 实例的字符串表示。

该字符串包含栈内每个元素的字符串表示，其顺序为从后到前的顺序。形如："[elem1, elem2, elem3]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 当前栈的字符串表示。

示例：

<!-- verify -->
```cangjie
import std.collection.*

main() {
    let stack = ArrayStack<Int64>()
    
    // 空栈转字符串
    let emptyStr = stack.toString()
    println("空栈字符串: ${emptyStr}")  // []
    
    // 添加元素后转字符串
    stack.add(1)
    stack.add(2)
    stack.add(3)
    
    let str = stack.toString()
    println("栈字符串: ${str}")      // [3, 2, 1]
    println("字符串长度: ${str.size}")  // 9
    
    return 0
}
```

运行结果：

```text
空栈字符串: []
栈字符串: [3, 2, 1]
字符串长度: 9
```


## class HashMapIterator\<K, V> where K <: Hashable & Equatable\<K>

```cangjie
public class HashMapIterator<K, V> <: Iterator<(K, V)> where K <: Hashable & Equatable<K> {
    public init(map: HashMap<K, V>)
}
```

功能：此类主要实现 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的迭代器功能。

父类型：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<(K, V)>

### init(HashMap\<K, V>)

```cangjie
public init(map: HashMap<K, V>)
```

功能：创建 [HashMapIterator](collection_package_class.md#class-hashmapiteratork-v-where-k--hashable--equatablek)\<K, V> 实例。

参数：

- [map](collection_package_function.md#func-mapt-rt---r): [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)\<K, V> - 传入 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)\<K, V>。

### func next()

```cangjie
public func next(): ?(K, V)
```

功能：返回迭代器中的下一个元素。

返回值：

- ?(K, V) - 迭代器中的下一个元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装。

异常：

- [ConcurrentModificationException](collection_package_exception.md#class-concurrentmodificationexception) - 当函数检测到不同步的并发修改，抛出异常。

### func remove()

```cangjie
public func remove(): Option<(K, V)>
```

功能：删除此 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 迭代器的 next 函数返回的元素，此函数只能在 next 函数调用时调用一次。

返回值：

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)> - 返回被删除的元素。

异常：

- [ConcurrentModificationException](collection_package_exception.md#class-concurrentmodificationexception) - 当函数检测到不同步的并发修改，抛出异常。

## class HashMap\<K, V> where K <: Hashable & Equatable\<K>

```cangjie
public class HashMap<K, V> <: Map<K, V> where K <: Hashable & Equatable<K> {
    public init()
    public init(elements: Array<(K, V)>)
    public init(elements: Collection<(K, V)>)
    public init(capacity: Int64)
    public init(size: Int64, initElement: (Int64) -> (K, V))
}
```

功能：[Map](collection_package_interface.md#interface-mapk-v) 接口的哈希表实现。

哈希表是一种常用的数据结构，它可以用来快速地查找、插入和删除数据。哈希表的基本原理是将数据映射到一个数组中，这个数组称为哈希表。每个数据元素都有一个对应的哈希值，这个哈希值可以用来确定该元素在哈希表中的位置。

哈希表的特点是快速的查找、插入和删除操作，时间复杂度通常是O(1)。由于哈希表底层的数组大小是动态的，所以哈希表不能保证元素的顺序不可变。

父类型：

- [Map](collection_package_interface.md#interface-mapk-v)\<K, V>

### prop capacity

```cangjie
public prop capacity: Int64
```

功能：返回 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的容量。

返回值：

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的容量。

### prop size

```cangjie
public prop size: Int64
```

功能：返回键值对的个数。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init()

```cangjie
public init()
```

功能：构造一个具有默认初始容量为16和默认负载因子为空的 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)。

### init(Array\<(K, V)>)

```cangjie
public init(elements: Array<(K, V)>)
```

功能：通过传入的键值对数组构造一个 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)。

该构造函数根据传入数组的 size 设置 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的容量。由于[HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 内部不允许键重复，当 [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt) 中存在重复的键时，按照迭代器顺序，出现在后面的键值对将会覆盖前面的键值对。

参数：

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<(K, V)> - 初始化该 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的键值对数组。

### init(Collection\<(K, V)>)

```cangjie
public init(elements: Collection<(K, V)>)
```

功能：通过传入的键值对集合构造一个 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)。

该构造函数根据传入集合 elements 的 size 设置 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的容量。由于[HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 内部不允许键重复，当 [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt) 中存在重复的键时，按照迭代器顺序，出现在后面的键值对将会覆盖前面的键值对。

参数：

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<(K, V)> - 初始化该 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的键值对集合。

### init(Int64)

```cangjie
public init(capacity: Int64)
```

功能：构造一个带有传入容量大小的 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)。

参数：

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 初始化容量大小。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 capacity 小于 0 则抛出异常。

### init(Int64, (Int64) -> (K, V))

```cangjie
public init(size: Int64, initElement: (Int64) -> (K, V))
```

功能：通过传入的元素个数 size 和函数规则来构造 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)。

构造出的 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的容量受 size 大小影响。由于[HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 内部不允许键重复，当函数 initElement 生成相同的键时，后构造的键值对将会覆盖之前出现的键值对。

参数：

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 初始化该 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的函数规则。
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) -> (K, V) - 初始化该 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的函数规则。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 size 小于 0 则抛出异常。

### func add(K, V)

```cangjie
public func add(key: K, value: V): Option<V>
```

功能：将键值对放入 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中。

对于 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中已有的键，该键的值将被新值替换，并且返回旧的值。

参数：

- key: K - 要放置的键。
- value: V - 要分配的值。

返回值：

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V> - 如果赋值之前 key 存在，旧的 value 用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装；否则，返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V>.None。

示例：

使用示例见 [HashMap 的 get/add/contains 函数](../collection_package_samples/sample_hashmap_get_add_contains.md)。

### func add(Collection\<(K, V)>)

```cangjie
public func add(all!: Collection<(K, V)>): Unit
```

功能：按照 elements 的迭代器顺序将新的键值对集合放入 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中。

对于 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中已有的键，该键的值将被新值替换。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<(K, V)> - 需要添加进 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的键值对集合。

示例：

使用示例见 [HashMap 的 add/remove/clear 函数](../collection_package_samples/sample_hashmap_add_remove_clear.md)。

### func clear()

```cangjie
public func clear(): Unit
```

功能：清除所有键值对。

示例：

使用示例见 [HashMap 的 add/remove/clear 函数](../collection_package_samples/sample_hashmap_add_remove_clear.md)。

### func clone()

```cangjie
public func clone(): HashMap<K, V>
```

功能：克隆 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)。

返回值：

- [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)\<K, V> - 返回一个 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)。

### func contains(K)

```cangjie
public func contains(key: K): Bool
```

功能：判断是否包含指定键的映射。

参数：

- key: K - 传递要判断的 key。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果存在，则返回 true；否则，返回 false。

示例：

使用示例见 [HashMap 的 get/add/contains 函数](../collection_package_samples/sample_hashmap_get_add_contains.md)。

### func contains(Collection\<K>)

```cangjie
public func contains(all!: Collection<K>): Bool
```

功能：判断是否包含指定集合中所有键的映射。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<K> - 键传递待判断的 keys。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果都包含，则返回 true；否则，返回 false。

### func entryView(K)

```cangjie
public func entryView(key: K): MapEntryView<K, V>
```

功能：如果不包含特定键，返回一个空的引用视图。如果包含特定键，则返回该键对应的元素的引用视图。

参数：

- key: K - 要添加的键值对的键。

返回值：

- [MapEntryView](./collection_package_interface.md#interface-mapentryviewk-v)\<K, V> - 一个引用视图。

### func get(K)

```cangjie
public func get(key: K): ?V
```

功能：返回指定键映射到的值，如果 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 不包含指定键的映射，则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V>.None。

参数：

- key: K - 传入的键。

返回值：

- ?V - 键对应的值。用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装。

示例：

使用示例见 [HashMap 的 get/add/contains 函数](../collection_package_samples/sample_hashmap_get_add_contains.md)。

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：判断 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 是否为空，如果是，则返回 true；否则，返回 false。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 是否为空。

### func iterator()

```cangjie
public func iterator(): HashMapIterator<K, V>
```

功能：返回 HashMap 的迭代器。

返回值：

- [HashMapIterator](collection_package_class.md#class-hashmapiteratork-v-where-k--hashable--equatablek)\<K, V> - 返回 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 的迭代器。

### func keys()

```cangjie
public func keys(): EquatableCollection<K>
```

功能：返回 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中所有的 key，并将所有 key 存储在一个 Keys 容器中。

返回值：

- [EquatableCollection](collection_package_interface.md#interface-equatablecollectiont)\<K> - 保存所有返回的 key。

### func remove(Collection\<K>)

```cangjie
public func remove(all!: Collection<K>): Unit
```

功能：从此 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中删除指定集合中键的映射（如果存在）。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<K> - 传入要删除的键的集合。

### func remove(K)

```cangjie
public func remove(key: K): Option<V>
```

功能：从此 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中删除指定键的映射（如果存在）。

参数：

- key: K - 传入要删除的 key。

返回值：

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V> - 被从 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中移除的键对应的值，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装，如果 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)中不存该键，返回 None 。

示例：

使用示例见 [HashMap 的 add/remove/clear 函数](../collection_package_samples/sample_hashmap_add_remove_clear.md)。

### func removeIf((K, V) -> Bool)

```cangjie
public func removeIf(predicate: (K, V) -> Bool): Unit
```

功能：传入 lambda 表达式，如果满足条件，则删除对应的键值对。

该函数会遍历整个[HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)，所以满足 `predicate(K, V) == true` 的键值对都会被删除。

参数：

- predicate: (K, V) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 传递一个 lambda 表达式进行判断。

异常：

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - 当 `predicate` 中增删或者修改 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 内键值对时，抛出异常。

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

功能：扩容当前的[HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)。

将 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 扩容 additional 大小当 additional 小于等于零时，不发生扩容；当 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 剩余容量大于等于 additional 时，不发生扩容；当 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 剩余容量小于 additional 时，取（原始容量的1.5倍向下取整）与（additional + 已使用容量）中的最大值进行扩容。

参数：

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 将要扩容的大小。

异常：

- [OverflowException](../../core/core_package_api/core_package_exceptions.md#class-overflowexception) - 当additional + 已使用容量超过Int64.Max时，抛出异常。

### func toArray()

```cangjie
public func toArray(): Array<(K, V)>
```

功能：构造一个包含 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 内键值对的数组，并返回。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<(K, V)> - 包含容器内所有键值对的数组。

### func values()

```cangjie
public func values(): Collection<V>
```

功能：返回 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 中包含的值，并将所有的 value 存储在一个 Values 容器中。

返回值：

- [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<V> - 保存所有返回的 value。

### operator func \[](K, V)

```cangjie
public operator func [](key: K, value!: V): Unit
```

功能：运算符重载 add 方法，如果键存在，新 value 覆盖旧 value，如果键不存在，添加此键值对。

参数：

- key: K - 传递值进行判断。
- value!: V - 传递要设置的值。

### operator func \[](K)

```cangjie
public operator func [](key: K): V
```

功能：运算符重载 get 方法，如果键存在，返回键对应的值。

参数：

- key: K - 传递值进行判断。

返回值：

- V - 与键对应的值。

异常：

- [NoneValueException](../../core/core_package_api/core_package_exceptions.md#class-nonevalueexception) - 如果该 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 不存在该键，抛此异常。

### extend\<K, V> HashMap\<K, V> <: Equatable\<HashMap\<K, V>> where V <: Equatable\<V>

```cangjie
extend<K, V> HashMap<K, V> <: Equatable<HashMap<K, V>> where V <: Equatable<V>
```

功能：为 [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> 类型扩展 [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V>> 接口，支持判等操作。

父类型：

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V>>

#### operator func ==(HashMap\<K, V>)

```cangjie
public operator func ==(right: HashMap<K, V>): Bool
```

功能：判断当前实例与参数指向的 [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> 实例是否相等。

两个 [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> 相等指的是其中包含的键值对完全相等。

参数：

- right: [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果相等，则返回 true，否则返回 false。

#### operator func !=(HashMap\<K, V>)

```cangjie
public operator func !=(right: HashMap<K, V>): Bool
```

功能：判断当前实例与参数指向的 [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> 实例是否不等。

参数：

- right: [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果不等，则返回 true，否则返回 false。

### extend\<K, V> HashMap\<K, V> <: ToString where V <: ToString, K <: ToString

```cangjie
extend<K, V> HashMap<K, V> <: ToString where V <: ToString, K <: ToString
```

功能：为 [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：将当前 [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> 实例转换为字符串。

该字符串包含 [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> 内每个键值对的字符串表示，形如："[(k1, v1), (k2, v2), (k3, v3)]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 转换得到的字符串。

## class HashSet\<T> where T <: Hashable & Equatable\<T>

```cangjie
public class HashSet<T> <: Set<T> where T <: Hashable & Equatable<T> {
    public init()
    public init(elements: Collection<T>)
    public init(elements: Array<T>)
    public init(capacity: Int64)
    public init(size: Int64, initElement: (Int64) -> T)
}
```

功能：基于 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 实现的 [Set](collection_package_interface.md#interface-sett) 接口的实例。

[HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)中的元素是无序的，不允许有重复元素。当我们向[HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)中添加元素时，[HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)会根据元素的哈希值来确定该元素在哈希表中的位置。

> **提示：**
>
> [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 是基于 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 实现的，因此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的容量、内存布局、时间性能等都和 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 相同。

父类型：

- [Set](collection_package_interface.md#interface-sett)\<T>

### prop size

```cangjie
public prop size: Int64
```

功能：返回此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的元素个数。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init(Int64, (Int64) -> T)

```cangjie
public init(size: Int64, initElement: (Int64) -> T)
```

功能：通过传入的函数元素个数 size 和函数规则来构造 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)。构造出的 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的容量受 size 大小影响。

参数：

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 初始化函数中元素的个数。
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) ->T - 初始化函数规则。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 size 小于 0，抛出异常。

### init()

```cangjie
public init()
```

功能：构造一个空的 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)，初始容量为 16。

### init(Array\<T>)

```cangjie
public init(elements: Array<T>)
```

功能：使用传入的数组构造 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)。该构造函数根据传入数组 elements 的 size 设置 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的容量。

参数：

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - 初始化 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的数组。

### init(Collection\<T>)

```cangjie
public init(elements: Collection<T>)
```

功能：使用传入的集合构造 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)。该构造函数根据传入集合 elements 的 size 设置 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的容量。

参数：

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 初始化 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的集合。

### init(Int64)

```cangjie
public init(capacity: Int64)
```

功能：使用传入的容量构造一个 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)。

参数：

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 初始化容量大小。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 capacity 小于 0，抛出异常。

### func add(T)

```cangjie
public func add(element: T): Bool
```

功能：将指定的元素添加到 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 中, 若添加的元素在 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 中存在, 则添加失败。

参数：

- element: T - 指定的元素。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果添加成功，则返回 true；否则，返回 false。

示例：

使用示例见 [HashSet 的 add/iterator/remove 函数](../collection_package_samples/sample_hashset_add_iterator_remove.md)。

### func add(Collection\<T>)

```cangjie
public func add(all!: Collection<T>): Unit
```

功能：添加 [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) 中的所有元素至此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 中，如果元素存在，则不添加。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 需要被添加的元素的集合。

### prop capacity

```cangjie
public prop capacity: Int64
```

功能：返回此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的内部数组容量大小。

> **注意：**
>
> 容量大小不一定等于 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的 size。

返回值：

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 返回此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的内部数组容量大小。

### func clear()

```cangjie
public func clear(): Unit
```

功能：从此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 中移除所有元素。

### func clone()

```cangjie
public func clone(): HashSet<T>
```

功能：克隆 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)。

返回值：

- [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - 返回克隆到的 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)。

### func contains(T)

```cangjie
public func contains(element: T): Bool
```

功能：判断 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 是否包含指定元素。

参数：

- element: T - 指定的元素。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果包含指定元素，则返回 true；否则，返回 false。

### func contains(Collection\<T>)

```cangjie
public func contains(all!: Collection<T>): Bool
```

功能：判断 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 是否包含指定 [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) 中的所有元素。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 指定的元素集合。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 包含 [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) 中的所有元素，则返回 true；否则，返回 false。

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：判断 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 是否为空。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果为空，则返回 true；否则，返回 false。

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

功能：返回此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的迭代器。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 返回此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 的迭代器。

示例：

使用示例见 [HashSet 的 add/iterator/remove 函数](../collection_package_samples/sample_hashset_add_iterator_remove.md)。

### func remove(T)

```cangjie
public func remove(element: T): Bool
```

功能：如果指定元素存在于此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 中，则将其移除。

参数：

- element: T - 需要被移除的元素。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - true，表示移除成功；false，表示移除失败。

示例：

使用示例见 [HashSet 的 add/iterator/remove 函数](../collection_package_samples/sample_hashset_add_iterator_remove.md)。

### func remove(Collection\<T>)

```cangjie
public func remove(all!: Collection<T>): Unit
```

功能：移除此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 中那些也包含在指定 [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) 中的所有元素。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 需要从此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 中移除的元素的集合。

### func removeIf((T) -> Bool)

```cangjie
public func removeIf(predicate: (T) -> Bool): Unit
```

功能：传入 lambda 表达式，如果满足 `true` 条件，则删除对应的元素。

参数：

- predicate: (T) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 是否删除元素的判断条件。

异常：

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - 当 `predicate` 中增删或者修改 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 内元素时，抛出异常。

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

功能：将 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 扩容 additional 大小，当 additional 小于等于零时，不发生扩容；当 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 剩余容量大于等于 additional 时，不发生扩容；当 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 剩余容量小于 additional 时，取（原始容量的1.5倍向下取整）与（additional + 已使用容量）中的最大值进行扩容。

参数：

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 将要扩容的大小。

异常：

- [OverflowException](../../core/core_package_api/core_package_exceptions.md#class-overflowexception) - 当additional + 已使用容量超过Int64.Max时，抛出异常。

### func retain(Set\<T>)

```cangjie
public func retain(all!: Set<T>): Unit
```

功能：从此 [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) 中保留 [Set](collection_package_interface.md#interface-sett) 中的元素。

参数：

- all!: [Set](collection_package_interface.md#interface-sett)\<T> - 需要保留的 [Set](collection_package_interface.md#interface-sett)。

### func subsetOf(ReadOnlySet\<T>)

```cangjie
public func subsetOf(other: ReadOnlySet<T>): Bool
```

功能：检查该集合是否为其他 [ReadOnlySet](collection_package_interface.md#interface-readonlysett) 的子集。

参数：

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - 传入集合，此函数将判断当前集合是否为 other 的子集。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果该 [Set](collection_package_interface.md#interface-sett) 是指定 [ReadOnlySet](collection_package_interface.md#interface-readonlysett) 的子集，则返回 true；否则返回 false。

### func toArray()

```cangjie
public func toArray(): Array<T>
```

功能：返回一个包含容器内所有元素的数组。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - T 类型数组。

### operator func &(ReadOnlySet\<T>)

```cangjie
public operator func &(other: ReadOnlySet<T>): HashSet<T>
```

功能：返回包含两个集合交集的元素的新集合。

参数：

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - 传入集合。

返回值：

- [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - T 类型集合。

### operator func |(ReadOnlySet\<T>)

```cangjie
public operator func |(other: ReadOnlySet<T>): HashSet<T>
```

功能：返回包含两个集合并集的元素的新集合。

参数：

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - 传入集合。

返回值：

- [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - T 类型集合。

### operator func -(ReadOnlySet\<T>)

```cangjie
public operator func -(other: ReadOnlySet<T>): HashSet<T>
```

功能：返回包含两个集合差集的元素的新集合。

参数：

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - 传入集合。

返回值：

- [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - T 类型集合。

### extend\<T> HashSet\<T> <: Equatable\<HashSet\<T>>

```cangjie
extend<T> HashSet<T> <: Equatable<HashSet<T>>
```

功能：为 [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> 类型扩展 [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T>> 接口，支持判等操作。

父类型：

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T>>

#### operator func ==(HashSet\<T>)

```cangjie
public operator func ==(that: HashSet<T>): Bool
```

功能：判断当前实例与参数指向的 [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> 实例是否相等。

两个 [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> 相等指的是其中包含的元素完全相等。

参数：

- that: [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果相等，则返回 true，否则返回 false。

#### operator func !=(HashSet\<T>)

```cangjie
public operator func !=(that: HashSet<T>): Bool
```

功能：判断当前实例与参数指向的 [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> 实例是否不等。

参数：

- that: [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果不等，则返回 true，否则返回 false。

### extend\<T> HashSet\<T> <: ToString where T <: ToString

```cangjie
extend<T> HashSet<T> <: ToString where T <: ToString
```

功能：为 [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：将当前 [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> 实例转换为字符串。

该字符串包含 [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> 内每个元素的字符串表示，形如："[elem1, elem2, elem3]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 转换得到的字符串。

## class LinkedListNode\<T>

```cangjie
public class LinkedListNode<T>
```

功能：[LinkedListNode](collection_package_class.md#class-linkedlistnodet) 是 [LinkedList](collection_package_class.md#class-linkedlistt) 上的节点。

可以通过 [LinkedListNode](collection_package_class.md#class-linkedlistnodet) 对 [LinkedList](collection_package_class.md#class-linkedlistt) 进行前向后向遍历操作，也可以访问和修改元素的值。

[LinkedListNode](collection_package_class.md#class-linkedlistnodet) 只能通过对应 [LinkedList](collection_package_class.md#class-linkedlistt) 的 'nodeAt'、'firstNode'、'lastNode' 获得，当 [LinkedList](collection_package_class.md#class-linkedlistt) 删除掉对应的节点时，会造成一个悬空的节点，对悬空的节点进行任何操作都会抛 '[IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception)' 异常。

### prop next

```cangjie
public prop next: Option<LinkedListNode<T>>
```

功能：获取当前节点的下一个节点，如果没有则返回 None。

类型：[Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>>

异常：

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - 如果该节点不属于任何链表实例，抛此异常。

### prop prev

```cangjie
public prop prev: Option<LinkedListNode<T>>
```

功能：获取当前节点的前一个节点，如果没有则返回 None。

类型：[Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>>

异常：

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - 如果该节点不属于任何链表实例，抛此异常。

### prop value

```cangjie
public mut prop value: T
```

功能：获取或者修改元素的值。

类型：T

异常：

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - 如果该节点不属于任何链表实例，抛此异常。

## class LinkedList\<T>

```cangjie
public class LinkedList<T> <: Collection<T> {
    public init()
    public init(elements: Collection<T>)
    public init(elements: Array<T>)
    public init(size: Int64, initElement: (Int64)-> T)
}
```

功能：实现双向链表的数据结构。

双向链表是一种常见的数据结构，它由一系列节点组成，每个节点都包含两个指针，一个指向前一个节点，另一个指向后一个节点。这种结构允许在任何一个节点上进行双向遍历，即可以从头节点开始向后遍历，也可以从尾节点开始向前遍历。

[LinkedList](collection_package_class.md#class-linkedlistt) 不支持并发操作，并且对集合中元素的修改不会使迭代器失效，只有在添加和删除元素的时候会使迭代器失效。

父类型：

- [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T>

### prop first

```cangjie
public prop first: ?T
```

功能：链表中第一个元素的值，如果是空链表则返回 None。

类型：?T

### prop firstNode

```cangjie
public prop firstNode: ?LinkedListNode<T>
```

功能：获取链表中的第一个元素的节点。

类型：?[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>

### prop last

```cangjie
public prop last: ?T
```

功能：链表中最后一个元素的值，如果是空链表则返回 None。

类型：?T

### prop lastNode

```cangjie
public prop lastNode: ?LinkedListNode<T>
```

功能：获取链表中的最后一个元素的节点。

类型：?[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>

### prop size

```cangjie
public prop size: Int64
```

功能：链表中的元素数量。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init()

```cangjie
public init()
```

功能：构造一个空的链表。

### init(Array\<T>)

```cangjie
public init(elements: Array<T>)
```

功能：按照数组的遍历顺序构造一个包含指定集合元素的 [LinkedList](collection_package_class.md#class-linkedlistt) 实例。

参数：

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - 将要放入此链表中的元素数组。

### init(Collection\<T>)

```cangjie
public init(elements: Collection<T>)
```

功能：按照集合迭代器返回元素的顺序构造一个包含指定集合元素的链表。

参数：

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 将要放入此链表中的元素集合。

### init(Int64, (Int64)-> T)

```cangjie
public init(size: Int64, initElement: (Int64)-> T)
```

功能：创建一个包含 size 个元素，且第 n 个元素满足 ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64))-> T 条件的链表。

参数：

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 要创建的链表元素数量。
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) ->T - 元素的初始化参数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果指定的链表长度小于 0 则抛此异常。

### func addLast(T)

```cangjie
public func addLast(element: T): LinkedListNode<T>
```

功能：在链表的尾部位置添加一个元素，并且返回该元素的节点。

参数：

- element: T - 要添加到链表中的元素。

返回值：

- [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 指向该元素的节点。

### func backward(LinkedListNode\<T>)

```cangjie
public func backward(mark: LinkedListNode<T>): Iterator<T>
```

功能：获取一个从 mark 节点开始，到所对应链表的头部节点的所有元素的迭代器。

参数：

- mark: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 开始的元素节点。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 对应元素的迭代器。

异常：

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - 如果该节点不属于任何链表实例，抛此异常。

### func clear()

```cangjie
public func clear(): Unit
```

功能：删除链表中的所有元素。

### func forward(LinkedListNode\<T>)

```cangjie
public func forward(mark: LinkedListNode<T>): Iterator<T>
```

功能：获取一个从 mark 节点开始，到所对应链表的尾部节点的所有元素的迭代器。

参数：

- mark: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 开始的元素节点。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 对应元素的迭代器。

异常：

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - 如果该节点不属于任何链表实例，抛此异常。

### func addAfter(LinkedListNode\<T>,T)

```cangjie
public func addAfter(node: LinkedListNode<T>, element: T): LinkedListNode<T>
```

功能：在链表中指定节点的后面插入一个元素，并且返回该元素的节点。

参数：

- node: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 指定的节点。
- element: T - 要添加到链表中的元素。

返回值：

- [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 指向被插入元素的节点。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果指定的节点不属于该链表，则抛此异常。

### func addBefore(LinkedListNode\<T>,T)

```cangjie
public func addBefore(node: LinkedListNode<T>, element: T): LinkedListNode<T>
```

功能：在链表中指定节点的前面插入一个元素，并且返回该元素的节点。

参数：

- node: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 指定的节点。
- element: T - 要添加到链表中的元素。

返回值：

- [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 指向被插入元素的节点。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果指定的节点不属于该链表，则抛此异常。

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：返回此链表是否为空链表的判断。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果此链表中不包含任何元素，返回 true。

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

功能：返回当前集合中元素的迭代器，其顺序是从链表的第一个节点到链表的最后一个节点。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 当前集合中元素的迭代器。

### func nodeAt(Int64)

```cangjie
public func nodeAt(index: Int64): Option<LinkedListNode<T>>
```

功能：获取链表中的第 index 个元素的节点，编号从 0 开始。

该函数的时间复杂度为 O(n)。

参数：

- index: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 指定获取第 index 个元素的节点。

返回值：

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>> - 编号为 index 的节点，如果没有则返回 None。

### func removeFirst()

```cangjie
public func removeFirst() : ?T
```

功能：移除链表的第一个元素，并返回该元素的值。

返回值：

- ?T - 被删除的元素的值，若链表为空则返回 None。

### func removeLast()

```cangjie
public func removeLast() : ?T
```

功能：移除链表的最后一个元素，并返回该元素的值。

返回值：

- ?T - 被删除的元素的值，若链表为空则返回 None。

### func addFirst(T)

```cangjie
public func addFirst(element: T): LinkedListNode<T>
```

功能：在链表的头部位置插入一个元素，并且返回该元素的节点。

参数：

- element: T - 要添加到链表中的元素。

返回值：

- [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 指向该元素的节点。

### func remove(LinkedListNode\<T>)

```cangjie
public func remove(node: LinkedListNode<T>): T
```

功能：删除链表中指定节点。

参数：

- node: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 要被删除的节点。

返回值：

- T - 被删除的节点的值。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果指定的节点不属于该链表，则抛此异常。

### func removeIf((T)-> Bool)

```cangjie
public func removeIf(predicate: (T)-> Bool): Unit
```

功能：删除此链表中满足给定 lambda 表达式或函数的所有元素。

参数：

- predicate: (T) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 对于要删除的元素，返回值为 true。

异常：

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - 当 `predicate` 中增删或者修改 [LinkedList](./collection_package_class.md#class-linkedlistt) 内节点时，抛出异常。

### func reverse()

```cangjie
public func reverse(): Unit
```

功能：反转此链表中的元素顺序。

### func splitOff(LinkedListNode\<T>)

```cangjie
public func splitOff(node: LinkedListNode<T>): LinkedList<T>
```

功能：从指定的节点 node 开始，将链表分割为两个链表，如果分割成功，node 不在当前的链表内，而是作为首个节点存在于新的链表内部。

参数：

- node: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - 要分割的位置。

返回值：

- [LinkedList](collection_package_class.md#class-linkedlistt)\<T> - 原链表分割后新产生的链表。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果指定的节点不属于该链表，则抛此异常。

### func toArray()

```cangjie
public func toArray(): Array<T>
```

功能：返回一个数组，数组包含该链表中的所有元素，并且顺序与链表的顺序相同。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - T 类型数组。

### extend\<T> LinkedList\<T> <: Equatable\<LinkedList\<T>> where T <: Equatable\<T>

```cangjie
extend<T> LinkedList<T> <: Equatable<LinkedList<T>> where T <: Equatable<T>
```

功能：为 [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> 类型扩展 [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[LinkedList](./collection_package_class.md#class-linkedlistt)\<T>> 接口，支持判等操作。

父类型：

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[LinkedList](#class-linkedlistt)\<T>>

#### operator func ==(LinkedList\<T>)

```cangjie
public operator func ==(right: LinkedList<T>): Bool
```

功能：判断当前实例与参数指向的 [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> 实例是否相等。

两个 [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> 相等指的是其中包含的元素完全相等。

参数：

- right: [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果相等，则返回 true，否则返回 false。

#### operator func !=(LinkedList\<T>)

```cangjie
public operator func !=(right: LinkedList<T>): Bool
```

功能：判断当前实例与参数指向的 [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> 实例是否不等。

参数：

- right: [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果不等，则返回 true，否则返回 false。

### extend\<T> LinkedList\<T> <: ToString where T <: ToString

```cangjie
extend<T> LinkedList<T> <: ToString where T <: ToString
```

功能：为 [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：将当前 [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> 实例转换为字符串。

该字符串包含 [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> 内每个元素的字符串表示，形如："[elem1, elem2, elem3]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 转换得到的字符串。

## class TreeMap\<K, V> where K <: Comparable\<K>

```cangjie
public class TreeMap<K, V> <: OrderedMap<K, V> where K <: Comparable<K> {
    public init()
    public init(elements: Collection<(K, V)>)
    public init(elements: Array<(K,V)>)
    public init(size: Int64, initElement: (Int64) -> (K, V))
}
```

功能：基于平衡二叉搜索树实现的 [OrderedMap](collection_package_interface.md#interface-orderedmapk-v) 接口实例。

这个类的主要目的是提供一个有序的 key-value 存储结构，它可以快速地插入、删除、查找元素。

[TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 可以用于任何需要有序键值对存储的场景，例如数据库、缓存、查找表等。

父类型：

- [OrderedMap](collection_package_interface.md#interface-orderedmapk-v)\<K, V>

### prop first

```cangjie
public prop first: ?(K, V)
```

功能：获取 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的第一个元素。

返回值：

- ?(K, V) - 如果存在第一个元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该元素并返回；否则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)>.None。

### prop last

```cangjie
public prop last: ?(K, V)
```

功能：获取 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的最后一个元素。

返回值：

- ?(K, V) - 如果存在最后一个元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该元素并返回；否则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)>.None。

### prop size

```cangjie
public prop size: Int64
```

功能：返回键值的个数。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init()

```cangjie
public init()
```

功能：构造一个空的 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek)。

### init(Array\<(K,V)>)

```cangjie
public init(elements: Array<(K,V)>)
```

功能：通过传入的键值对数组构造一个 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek)。

按照 elements 的先后顺序将元素插入到 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 内，由于 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中不允许出现相同的键，如果 elements 中有相同的键时，后出现的键值对将会覆盖先出现的键值对。

参数：

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<(K, V)> - 初始化该 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的键值对数组。

### init(Collection\<(K, V)>)

```cangjie
public init(elements: Collection<(K, V)>)
```

功能：通过传入的键值对集合构造一个 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek)。

按照 elements 的迭代器顺序将元素插入到 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 内，由于 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中不允许出现相同的键，如果 elements 中有相同的键时，后出现(迭代器顺序)的键值对将会覆盖先出现的键值对。

参数：

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<(K, V)> - 初始化该 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的键值对集合。

### init(Int64, (Int64) -> (K, V))

```cangjie
public init(size: Int64, initElement: (Int64) -> (K, V))
```

功能：通过传入的元素个数 size 和函数规则来构造 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek)。

参数：

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 传入的元素个数。
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) -> (K, V) - 初始化该 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的函数规则。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 size 小于 0 则抛出异常。

### func add(K, V)

```cangjie
public func add(key: K, value: V): Option<V>
```

功能：将新的键值对放入 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中。对于 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中已有的键，该键的值将被新值替换。

参数：

- key: K - 要放置的键。
- value: V - 要分配的值。

返回值：

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V> - 如果赋值之前 key 存在，旧的 value 用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装并返回；否则，返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V>.None。

### func add(Collection\<(K, V)>)

```cangjie
public func add(all!: Collection<(K, V)>): Unit
```

功能：将新的键值对集合放入 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中。对于 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中已有的键，该键的值将被新值替换。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<(K, V)> - 需要添加进 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的键值对集合。

### func backward(K, Bool)

```cangjie
public func backward(mark: K, inclusive!: Bool = true): Iterator<(K, V)>
```

功能：获取从第一个键小于等于 mark 的节点按降序遍历到 [first](./collection_package_class.md#prop-first-3) 的迭代器。如果该节点的键等于 mark ，那么根据 `inclusive!` 确定是否包含该键对应的节点。

参数：

- mark: K - 用于确定从哪里开始的键。
- inclusive!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 当 `mark` 是迭代器的首个元素的 key 时，指定是否包含 mark 作为起始点，默认为 `true`。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<(K, V)> - 对应元素的迭代器。

### func clear()

```cangjie
public func clear(): Unit
```

功能：清除所有键值对。

### func clone()

```cangjie
public func clone(): TreeMap<K, V>
```

功能：克隆 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek)。

返回值：

- [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> - 返回一个 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 实例。

### func contains(K)

```cangjie
public func contains(key: K): Bool
```

功能：判断是否包含指定键的映射。

参数：

- key: K - 传递要判断的 key。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果存在，则返回 true；否则，返回 false。

### func contains(Collection\<K>)

```cangjie
public func contains(all!: Collection<K>): Bool
```

功能：判断是否包含指定集合键的映射。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<K> - 键的集合。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果存在，则返回 true；否则，返回 false。

### func entryView(K)

```cangjie
public func entryView(k: K): MapEntryView<K, V>
```

功能：如果不包含特定键，返回一个空的引用视图。如果包含特定键，则返回该键对应的元素的引用视图。

参数：

- k: K - 要添加的键值对的键。

返回值：

- [MapEntryView](./collection_package_interface.md#interface-mapentryviewk-v)\<K, V> - 一个引用视图。

### func forward(K, Bool)

```cangjie
public func forward(mark: K, inclusive!: Bool = true): Iterator<(K, V)>
```

功能：获取从第一个键大于等于 mark 的节点按升序遍历到 [last](./collection_package_class.md#prop-last-3) 结束的一个迭代器。如果该节点的键等于 mark ，那么根据 `inclusive!` 确定是否包含该键对应的节点。

参数：

- mark: K - 用于确定从哪里开始的键。
- inclusive!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 当 `mark` 是迭代器的首个元素的 key 时，指定是否包含 mark 作为起始点，默认为 `true`。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<(K, V)> - 对应元素的迭代器。

### func get(K)

```cangjie
public func get(key: K): ?V
```

功能：返回指定键映射的值。

参数：

- key: K - 指定的键。

返回值：

- ?V - 如果存在这样一个值，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该值并返回；否则，返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V>.None。

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：判断 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 是否为空。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果为空，返回 true，否则返回 false。

### func iterator()

```cangjie
public func iterator(): Iterator<(K, V)>
```

功能：返回 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的迭代器，迭代器按 Key 值从小到大的顺序迭代。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<(K, V)> - [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的迭代器。

### func keys()

```cangjie
public func keys(): EquatableCollection<K>
```

功能：返回 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中所有的 key，并将所有 key 存储在一个容器中。

返回值：

- [EquatableCollection](collection_package_interface.md#interface-equatablecollectiont)\<K> - 包含所有键的集合。

### func removeFirst()

```cangjie
public func removeFirst(): ?(K, V)
```

功能：删除 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的第一个元素。

返回值：

- ?(K, V) - 如果存在第一个元素，那么删除该元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该元素并返回；否则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)>.None。

### func removeLast()

```cangjie
public func removeLast(): ?(K, V)
```

功能：删除 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 的最后一个元素。

返回值：

- ?(K, V) - 如果存在最后一个元素，那么删除该元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该元素并返回；否则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)>.None。

### func remove(K)

```cangjie
public func remove(key: K): Option<V>
```

功能：从此映射中删除指定键的映射（如果存在）。

参数：

- key: K - 传入要删除的 key。

返回值：

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V> - 被移除映射的值用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装，如果 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中不存在指定的键，返回 None。

### func remove(Collection\<K>)

```cangjie
public func remove(all!: Collection<K>): Unit
```

功能：从此映射中删除指定集合的映射（如果存在）。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<K> - 传入要删除的键的集合。

### func removeIf((K, V) -> Bool)

```cangjie
public func removeIf(predicate: (K, V) -> Bool): Unit
```

功能：传入 lambda 表达式，如果满足条件，则删除对应的键值。

参数：

- predicate: (K, V) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 传递一个 lambda 表达式进行判断。

异常：

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - 当 `predicate` 中增删或者修改 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 内键值对时，抛出异常。

### func values()

```cangjie
public func values(): Collection<V>
```

功能：返回 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 中包含的值，并将所有的 value 存储在一个容器中。

返回值：

- [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<V> - 包含所有值的集合。

### operator func \[](K, V)

```cangjie
public operator func [](key: K, value!: V): Unit
```

功能：运算符重载集合，如果键存在，新 value 覆盖旧 value，如果键不存在，添加此键值对。

参数：

- key: K - 传递值进行判断。
- value!: V - 传递要设置的值。

### operator func \[](K)

```cangjie
public operator func [](key: K): V
```

功能：运算符重载集合，如果键存在，返回键对应的值。

参数：

- key: K - 传递值进行判断。

返回值：

- V - 与键对应的值。

异常：

- [NoneValueException](../../core/core_package_api/core_package_exceptions.md#class-nonevalueexception) - 如果该 [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) 不存在该键，抛出异常。

### extend\<K, V> TreeMap\<K, V> <: Equatable\<TreeMap\<K, V>> where V <: Equatable\<V>

```cangjie
extend<K, V> TreeMap<K, V> <: Equatable<TreeMap<K, V>> where V <: Equatable<V>
```

功能：为 [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> 类型扩展 [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V>> 接口，支持判等操作。

父类型：

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V>>

#### operator func ==(TreeMap\<K, V>)

```cangjie
public operator func ==(right: TreeMap<K, V>): Bool
```

功能：判断当前实例与参数指向的 [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> 实例是否相等。

两个 [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> 相等指的是其中包含的键值对完全相等。

参数：

- right: [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果相等，则返回 true，否则返回 false。

#### operator func !=(TreeMap\<K, V>)

```cangjie
public operator func !=(right: TreeMap<K, V>): Bool
```

功能：判断当前实例与参数指向的 [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> 实例是否不等。

参数：

- right: [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果不等，则返回 true，否则返回 false。

### extend\<K, V> TreeMap\<K, V> <: ToString where V <: ToString, K <: ToString & Comparable\<K>

```cangjie
extend<K, V> TreeMap<K, V> <: ToString where V <: ToString, K <: ToString & Comparable<K>
```

功能：为 [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：将当前 [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> 实例转换为字符串。

该字符串包含 [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> 内每个键值对的字符串表示，形如："[(k1, v1), (k2, v2), (k3, v3)]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 转换得到的字符串。

## class TreeSet\<T> where T <: Comparable\<T>

```cangjie
public class TreeSet<T> <: OrderedSet<T> where T <: Comparable<T> {
    public init()
    public init(elements: Collection<T>)
    public init(size: Int64, initElement: (Int64) -> T)
}
```

功能：基于 [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) 实现的 [Set](collection_package_interface.md#interface-sett) 接口的实例。

这个类的主要目的是提供一个有序的元素存储结构，它可以快速地插入、删除、查找元素。

[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 可以用于任何需要有序元素存储的场景，例如数据库、缓存、查找表等。

父类型：

- [OrderedSet](collection_package_interface.md#interface-orderedsett)\<T>

### prop first

```cangjie
public prop first: ?T
```

功能：获取 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 的第一个元素。

类型：?T - 如果存在第一个元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该元素并返回；否则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T>.None。

### prop last

```cangjie
public prop last: ?T
```

功能：获取 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 的最后一个元素。

类型：?T - 如果存在最后一个元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该元素并返回；否则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T>.None。

### prop size

```cangjie
public prop size: Int64
```

功能：返回元素的个数。

类型：[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init()

```cangjie
public init()
```

功能：构造一个空的 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)。

### init(Collection\<T>)

```cangjie
public init(elements: Collection<T>)
```

功能：通过传入的元素集合构造一个 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)。

按照 elements 的迭代器顺序将元素插入到 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 内，由于 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中不允许出现相同的元素，如果 elements 中有多个相同的元素时，[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 只会保留一个元素。

参数：

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 初始化该 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 的元素集合。

### init(Int64, (Int64) -> T)

```cangjie
public init(size: Int64, initElement: (Int64) -> T)
```

功能：通过传入的元素个数 size 和函数规则来构造 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)。

参数：

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 传入的元素个数。
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) -> T - 初始化该 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 的函数规则。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 size 小于 0 则抛出异常。

### static func of(Array\<T>)

```cangjie
public static func of(elements: Array<T>): TreeSet<T>
```

功能：构造一个包含指定数组中所有元素的 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)。

按照 elements 的先后顺序将元素插入到 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 内，由于 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中不允许出现相同的元素，如果 elements 中有多个相同的元素时，[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 只会保留一个元素。

参数：

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - 传入数组。

返回值：

- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - 元素为 T 类型的 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)。

### func add(T)

```cangjie
public func add(element: T): Bool
```

功能：将新的元素放入 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中。若添加的元素在 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中存在, 则添加失败。

参数：

- element: T - 指定的元素。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果添加成功，则返回 true；否则，返回 false。

### func add(Collection\<T>)

```cangjie
public func add(all!: Collection<T>): Unit
```

功能：添加 [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) 中的所有元素至此 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中，如果元素存在，则不添加。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 需要被添加的元素的集合。

### func backward(T, Bool)

```cangjie
public func backward(mark: T, inclusive!: Bool = true): Iterator<T>
```

功能：获取从第一个键小于等于 mark 的节点按降序遍历到 [first](./collection_package_class.md#prop-first-4) 的迭代器。如果该节点的键等于 mark ，那么根据 `inclusive!` 确定是否包含该键对应的节点。

参数：

- mark: T - 用于确定从哪里开始的元素。
- inclusive!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 当 `mark` 是迭代器的首个元素时，指定是否包含 mark 作为起始点，默认为 `true`。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 对应元素的迭代器。

### func clear()

```cangjie
public func clear(): Unit
```

功能：清除所有元素。

### func clone()

```cangjie
public func clone(): TreeSet<T>
```

功能：克隆 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)。

返回值：

- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - 返回一个 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 实例。

### func contains(T)

```cangjie
public func contains(element: T): Bool
```

功能：判断是否包含指定元素。

参数：

- element: T - 指定的元素。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果包含指定元素，则返回 true；否则，返回 false。

### func contains(Collection\<T>)

```cangjie
public func contains(all!: Collection<T>): Bool
```

功能：判断 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 是否包含指定 [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) 中的所有元素。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 指定的元素集合。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果此 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 包含 [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) 中的所有元素，则返回 true；否则，返回 false。

### func forward(T, Bool)

```cangjie
public func forward(mark: T, inclusive!: Bool = true): Iterator<T>
```

功能：获取从第一个元素大于等于 mark 的节点按升序遍历到 [last](./collection_package_class.md#prop-last-3) 结束的一个迭代器。如果该节点的元素等于 mark ，那么根据 `inclusive!` 确定是否包含该元素对应的节点。

参数：

- mark: T - 用于确定从哪里开始的元素。
- inclusive!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 当 `mark` 是迭代器的首个元素时，指定是否包含 mark 作为起始点，默认为 `true`。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - 对应元素的迭代器。

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

功能：判断 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 是否为空。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果为空，返回 true，否则返回 false。

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

功能：返回 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 的迭代器，迭代器按元素值从小到大的顺序迭代。

返回值：

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 的迭代器。

### func removeFirst()

```cangjie
public func removeFirst(): ?T
```

功能：删除 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 的第一个元素。

返回值：

- ?T - 如果存在第一个元素，那么删除该元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该元素并返回；否则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T>.None。

### func removeLast()

```cangjie
public func removeLast(): ?T
```

功能：删除 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 的最后一个元素。

返回值：

- ?T - 如果存在最后一个元素，那么删除该元素，用 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) 封装该元素并返回；否则返回 [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T>.None。

### func remove(T)

```cangjie
public func remove(element: T): Bool
```

功能：如果指定元素存在于此 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中，则将其移除。

参数：

- element: T - 需要被移除的元素。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - true，表示移除成功；false，表示移除失败。

### func remove(Collection\<T>)

```cangjie
public func remove(all!: Collection<T>): Unit
```

功能：移除此 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中那些也包含在指定 [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) 中的所有元素。

参数：

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - 需要从此[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中移除的元素的集合。

### func removeIf((T) -> Bool)

```cangjie
public func removeIf(predicate: (T) -> Bool): Unit
```

功能：传入 lambda 表达式，如果满足 `true` 条件，则删除对应的元素。

参数：

- predicate: (T) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 是否删除元素的判断条件。

异常：

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - 当 `predicate` 中增删或者修改 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 内元素时，抛出异常。

### func retain(Set\<T>)

```cangjie
public func retain(all!: Set<T>): Unit
```

功能：从此 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 中保留 [Set](collection_package_interface.md#interface-sett) 中的元素，其他元素将被移除。

参数：

- all!: [Set](collection_package_interface.md#interface-sett)\<T> - 需要保留的 [Set](collection_package_interface.md#interface-sett)。

### func subsetOf(ReadOnlySet\<T>)

```cangjie
public func subsetOf(other: ReadOnlySet<T>): Bool
```

功能：检查该集合是否为其他 [ReadOnlySet](collection_package_interface.md#interface-readonlysett) 的子集。

参数：

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - 传入集合，此函数将判断当前集合是否为 other 的子集。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果该 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) 是指定 [ReadOnlySet](collection_package_interface.md#interface-readonlysett) 的子集，则返回 true；否则返回 false。

### func toArray()

```cangjie
public func toArray(): Array<T>
```

功能：返回一个包含容器内所有元素的数组。

返回值：

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - T 类型数组。

### operator func &(ReadOnlySet\<T>)

```cangjie
public operator func &(other: ReadOnlySet<T>): TreeSet<T>
```

功能：返回包含两个集合交集的元素的新集合。

参数：

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - 传入集合。

返回值：

- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - T 类型集合。

### operator func |(ReadOnlySet\<T>)

```cangjie
public operator func |(other: ReadOnlySet<T>): TreeSet<T>
```

功能：返回包含两个集合并集的元素的新集合。

参数：

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - 传入集合。

返回值：

- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - T 类型集合。

### operator func -(ReadOnlySet\<T>)

```cangjie
public operator func -(other: ReadOnlySet<T>): TreeSet<T>
```

功能：返回包含两个集合差集的元素的新集合。

参数：

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - 传入集合。

返回值：

- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - T 类型集合。

### extend\<T> TreeSet\<T> <: Equatable\<TreeSet\<T>>

```cangjie
extend<T> TreeSet<T> <: Equatable<TreeSet<T>>
```

功能：为 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> 类型扩展 [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T>> 接口，支持判等操作。

父类型：

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T>>

#### operator func ==(TreeSet\<T>)

```cangjie
public operator func ==(that: TreeSet<T>): Bool
```

功能：判断当前实例与参数指向的 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> 实例是否相等。

两个 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> 相等指的是其中包含的元素完全相等。

参数：

- that: [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果相等，则返回 true，否则返回 false。

#### operator func !=(TreeSet\<T>)

```cangjie
public operator func !=(that: TreeSet<T>): Bool
```

功能：判断当前实例与参数指向的 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> 实例是否不等。

参数：

- that: [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - 被比较的对象。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 如果不等，则返回 true，否则返回 false。

### extend\<T> TreeSet\<T> <: ToString where T <: ToString

```cangjie
extend<T> TreeSet<T> <: ToString where T <: ToString
```

功能：为 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> 扩展 [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) 接口，支持转字符串操作。

父类型：

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

功能：将当前 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> 实例转换为字符串。

该字符串包含 [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> 内每个元素的字符串表示，形如："[elem1, elem2, elem3]"。

返回值：

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - 转换得到的字符串。