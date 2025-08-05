# Class

## class ArrayDeque\<T>

```cangjie
public class ArrayDeque<T> <: Deque<T> {
    public init()
    public init(capacity: Int64)
}
```

Functionality: ArrayDeque is an implementation class of double-ended queue (deque) that supports insertion and removal operations at both ends. ArrayDeque is implemented using a resizable array, with its capacity continuously growing during element insertion, defaulting to a 50% expansion each time. The implementation employs a circular queue approach, achieving O(1) time complexity for insertion, deletion, and access operations when no expansion occurs.

Parent Types:

- [Deque](./collection_package_interface.md#interface-dequet)\<T>

### prop capacity

```cangjie
public prop capacity: Int64
```

Functionality: Gets the capacity of this deque.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### prop first

```cangjie
public prop first: ?T
```

Functionality: Gets the first element of this deque. Returns None if the deque is empty.

Type: ?T

### prop last

```cangjie
public prop last: ?T
```

Functionality: Gets the last element of this deque. Returns None if the deque is empty.

Type: ?T

### prop size

```cangjie
public prop size: Int64
```

Functionality: Returns the number of elements in this deque.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init()

```cangjie
public init()
```

Functionality: Constructs an empty deque with default capacity of 8.

### init(Int64)

```cangjie
public init(capacity: Int64)
```

Functionality: Constructs a deque with specified capacity. When capacity is less than the default value 8, the initial capacity of [ArrayDeque](#class-arraydequet) will be 8.

Parameters:

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - Specified initial capacity.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the parameter value is less than 0.

### func addFirst(T)

```cangjie
public func addFirst(element: T): Unit
```

Functionality: Inserts an element at the front of this deque.

Parameters:

- element: T - The element to be inserted.

### func addLast(T)

```cangjie
public func addLast(element: T): Unit
```

Functionality: Inserts an element at the end of this deque.

Parameters:

- element: T - The element to be inserted.

### func clear()

```cangjie
public func clear(): Unit
```

Functionality: Removes all elements from this deque.

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

Functionality: Returns an iterator over the elements in this deque in proper sequence (front to back).

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - An iterator over the elements.

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

Functionality: Checks if this deque is empty.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if empty, otherwise `false`.

### func removeFirst()

```cangjie
public func removeFirst(): ?T
```

Functionality: Removes and returns the first element of this deque. Returns `None` if empty.

Return Value:

- ?T - The removed first element.

### func removeLast()

```cangjie
public func removeLast(): ?T
```

Functionality: Removes and returns the last element of this deque. Returns `None` if empty.

Return Value:

- ?T - The removed last element.

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

Functionality: Increases the capacity of this deque.

Expands the deque's capacity by 'additional' size. No expansion occurs when:
1. 'additional' ≤ 0
2. Remaining capacity ≥ 'additional'

When expansion is needed, the new capacity will be the maximum between:
1. Floor(original capacity × 1.5)
2. additional + used capacity

Parameters:

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The amount of capacity to add.

### func toArray()

```cangjie
public func toArray(): Array<T>
```

Functionality: Returns an array containing all elements of this deque in proper sequence (front to back).

Return Value:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - An array of type T.

### extend\<T> ArrayDeque\<T> <: ToString where T <: ToString

```cangjie
extend<T> ArrayDeque<T> <: ToString where T <: ToString
```

Functionality: Extends [ArrayDeque](./collection_package_class.md#class-arraydequet)\<T> with [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface, supporting string conversion.

Parent Types:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Functionality: Gets the string representation of this [ArrayDeque](./collection_package_class.md#class-arraydequet)\<T> instance.

The string contains each element's string representation in front-to-back order, formatted as: "[elem1, elem2, elem3]".

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The resulting string.

## class ArrayList\<T>

```cangjie
public class ArrayList<T> <: List<T> {
    public init()
    public init(capacity: Int64)
    public init(size: Int64, initElement: (Int64) -> T)
    public init(elements: Collection<T>)
}
```

Functionality: Provides functionality for resizable arrays.

[ArrayList](collection_package_class.md#class-arraylistt) is a linear dynamic array that differs from [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt) by automatically resizing as needed and not requiring size specification during creation.

> **Note:**
>
> - When adding elements to a full array, it reallocates larger memory space and copies existing elements.
>
> - Advantages: Saves memory and automatically adjusts size, making it ideal for frequent add/remove operations.
> - Disadvantages: Performance may degrade during reallocation, which should be considered when using dynamic arrays.

Parent Types:

- [List](./collection_package_interface.md#interface-listt)\<T>

### prop size

```cangjie
public prop size: Int64
```

Functionality: Returns the number of elements in this [ArrayList](collection_package_class.md#class-arraylistt).

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### prop capacity

```cangjie
public prop capacity: Int64
```

Functionality: Returns the capacity of this [ArrayList](collection_package_class.md#class-arraylistt).

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### prop first

```cangjie
public prop first: ?T
```

Functionality: Returns the first element of this [ArrayList](collection_package_class.md#class-arraylistt), or None if empty.

Type: ?T

### prop last

```cangjie
public prop last: ?T
```

Functionality: Returns the last element of this [ArrayList](collection_package_class.md#class-arraylistt), or None if empty.

Type: ?T

### init()

```cangjie
public init()
```

Functionality: Constructs an empty [ArrayList](collection_package_class.md#class-arraylistt) with default initial capacity of 16.

### init(Collection\<T>)

```cangjie
public init(elements: Collection<T>)
```

Functionality: Constructs an [ArrayList](collection_package_class.md#class-arraylistt) containing all elements from the specified collection, maintaining their iteration order.

Parameters:

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - The input collection.

### init(Int64)

```cangjie
public init(capacity: Int64)
```

Function: Constructs an [ArrayList](collection_package_class.md#class-arraylistt) with the specified initial capacity.

Parameters:

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The specified initial capacity size.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the parameter value is less than 0.

### init(Int64, (Int64) -> T)

```cangjie
public init(size: Int64, initElement: (Int64) -> T)
```

Function: Constructs an [ArrayList](collection_package_class.md#class-arraylistt) with the specified initial element count and initialization function. This constructor sets the capacity of [ArrayList](collection_package_class.md#class-arraylistt) based on the size parameter.

Parameters:

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The number of elements to initialize.
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) ->T - The initialization function.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if size is less than 0.

### static func of(Array\<T>)

```cangjie
public static func of(elements: Array<T>): ArrayList<T>
```

Function: Constructs an [ArrayList](collection_package_class.md#class-arraylistt) containing all elements from the specified array.

Parameters:

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - The input array.

Return Value:

- [ArrayList](#class-arraylistt)\<T> - An ArrayList with elements of type T.

### func add(T)

```cangjie
public func add(element: T): Unit
```

Function: Appends the specified element to the end of this [ArrayList](collection_package_class.md#class-arraylistt).

Parameters:

- element: T - The element to insert, of type T.

Example:

See [ArrayList's add function example](../collection_package_samples/sample_arraylist_add.md).

### func add(Collection\<T>)

```cangjie
public func add(all!: Collection<T>): Unit
```

Function: Appends all elements from the specified collection to the end of this [ArrayList](collection_package_class.md#class-arraylistt).

The function traverses the input collection in iterator order and inserts all elements to the tail of this [ArrayList](collection_package_class.md#class-arraylistt).

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - The collection of elements to insert.

### func add(T, Int64)

```cangjie
public func add(element: T, at!: Int64): Unit
```

Function: Inserts the specified element at the specified position in this [ArrayList](collection_package_class.md#class-arraylistt).

Parameters:

- element: T - The element of type T to insert.
- at!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The target index for insertion.

Exceptions:

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - Thrown when 'at' is out of bounds.

Example:

See [ArrayList's add function example](../collection_package_samples/sample_arraylist_add.md).

### func add(Collection\<T>, Int64)

```cangjie
public func add(all!: Collection<T>, at!: Int64): Unit
```

Function: Inserts all elements from the specified collection into this [ArrayList](collection_package_class.md#class-arraylistt) starting from the specified position.

The function traverses the input collection in iterator order and inserts all elements at the specified position, shifting existing elements from that position onward.

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - The collection of elements of type T to insert.
- at!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The target index for insertion.

Exceptions:

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - Thrown when 'at' is out of bounds.

Example:

See [ArrayList's add function example](../collection_package_samples/sample_arraylist_add.md).

### func clear()

```cangjie
public func clear(): Unit
```

Function: Removes all elements from this [ArrayList](collection_package_class.md#class-arraylistt).

Example:

See [ArrayList's remove/clear/slice functions example](../collection_package_samples/sample_arraylist_remove_clear_slice.md).

### func clone()

```cangjie
public func clone(): ArrayList<T>
```

Function: Returns a copy (shallow copy) of this [ArrayList](collection_package_class.md#class-arraylistt) instance.

Return Value:

- [ArrayList](collection_package_class.md#class-arraylistt)\<T> - A new [ArrayList](collection_package_class.md#class-arraylistt)\<T>.

### func get(Int64)

```cangjie
public func get(index: Int64): ?T
```

Function: Returns the element at the specified position in this [ArrayList](collection_package_class.md#class-arraylistt).

Parameters:

- index: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The index of the element to return.

Return Value:

- ?T - The element at the specified position, or None if index is less than 0 or greater than or equal to the number of elements in [ArrayList](collection_package_class.md#class-arraylistt).

Example:

See [ArrayList's get/set functions example](../collection_package_samples/sample_arraylist_get_set.md).

### func getRawArray()

```cangjie
public unsafe func getRawArray(): Array<T>
```

Function: Returns the raw data of [ArrayList](collection_package_class.md#class-arraylistt).

> **Note:**
>
> This is an unsafe interface and must be used within an unsafe context.
>
> Raw data refers to the underlying array implementation of [ArrayList](collection_package_class.md#class-arraylistt), whose size is greater than or equal to the number of elements in [ArrayList](collection_package_class.md#class-arraylistt). Positions with indices greater than or equal to the size of [ArrayList](collection_package_class.md#class-arraylistt) may contain uninitialized elements, and accessing them may result in undefined behavior.

Return Value:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - The underlying raw data of [ArrayList](collection_package_class.md#class-arraylistt).

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

Function: Determines whether this [ArrayList](collection_package_class.md#class-arraylistt) is empty.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if empty, otherwise `false`.

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

Function: Returns an iterator over the elements in this [ArrayList](collection_package_class.md#class-arraylistt).

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - An iterator over the elements in [ArrayList](collection_package_class.md#class-arraylistt).

### func remove(Int64)

```cangjie
public func remove(at!: Int64): T
```

Function: Removes the element at the specified position in this [ArrayList](collection_package_class.md#class-arraylistt).

Parameters:

- at!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The index of the element to remove.

Return Value:

- T - The removed element.

Exceptions:

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - Thrown when 'at' is out of bounds.

Example:

See [ArrayList's remove/clear/slice functions example](../collection_package_samples/sample_arraylist_remove_clear_slice.md).

### func remove(Range\<Int64>)

```cangjie
public func remove(range: Range<Int64>): Unit
```

Function: Removes all elements in this [ArrayList](collection_package_class.md#class-arraylistt) that are included in the [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet).

> **Note:**
>
> If the range parameter is constructed using the [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) constructor, when hasEnd is false, the end value does not take effect (regardless of the isClosed value passed during construction), and the array slice includes elements up to the last element of the original array.

Parameters:

- range: [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet)\<[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)> - The range of elements to remove.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when the [step](collection_package_function.md#func-steptint64) of range is not equal to 1.
- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - Thrown when the start or end of range is less than 0, or end is greater than the length of [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt).

### func removeIf((T) -> Bool)

```cangjie
public func removeIf(predicate: (T) -> Bool): Unit
```

Function: Removes all elements from this [ArrayList](collection_package_class.md#class-arraylistt) that satisfy the given lambda expression or function.

Parameters:

- predicate: (T) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The condition predicate for removal.

Exceptions:

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - Thrown when elements are added, removed, or modified within `predicate` in [ArrayList](collection_package_class.md#class-arraylistt).

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

Function: Increases the capacity of this [ArrayList](collection_package_class.md#class-arraylistt) instance.

Expands [ArrayList](collection_package_class.md#class-arraylistt) by the additional size. No expansion occurs if additional is less than or equal to zero. No expansion occurs if the remaining capacity of [ArrayList](collection_package_class.md#class-arraylistt) is greater than or equal to additional. If the remaining capacity is less than additional, the expansion size is the maximum of (original capacity multiplied by 1.5, rounded down) and (additional + used capacity).

Parameters:

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The size to expand by.

Exceptions:

- [OverflowException](../../core/core_package_api/core_package_exceptions.md#class-overflowexception) - Thrown when additional + used capacity exceeds Int64.Max.

### func reverse()

```cangjie
public func reverse(): Unit
```

Function: Reverses the order of elements in this [ArrayList](collection_package_class.md#class-arraylistt).

### func slice(Range\<Int64>)

```cangjie
public func slice(range: Range<Int64>): ArrayList<T>
```

Function: Returns an [ArrayList](collection_package_class.md#class-arraylistt)\<T> corresponding to the indices specified by the input parameter `range`.

> **Note:**
>
> If the parameter `range` is a [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) instance constructed using the [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) constructor, the following behaviors apply:
>
> 1. The `start` value is exactly the value passed to the constructor, unaffected by the `hasStart` parameter during construction.
> 2. When `hasEnd` is false, the `end` value is ineffective and unaffected by the `isClosed` parameter during construction. The array slice will include elements up to the last element of the original array.

Parameters:

- `range`: [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet)\<[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)> - The range specifying the slice.

Return Value:

- [ArrayList](collection_package_class.md#class-arraylistt)\<T> - The sliced array.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when `range.[step](collection_package_function.md#func-steptint64)` is not equal to 1.
- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - Thrown when `range` is invalid.

Example:

For usage examples, see [ArrayList's remove/clear/slice functions](../collection_package_samples/sample_arraylist_remove_clear_slice.md).

### func sortBy((T, T) -> Ordering) <sup>(deprecated)</sup>

```cangjie
public func sortBy(comparator!: (T, T) -> Ordering): Unit
```

Function: Performs an unstable sort on the array elements.

By passing a comparison function that returns a result of type [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering), the array can be custom-sorted. If the comparator returns [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).GT, `t1` will appear after `t2` after sorting; if it returns [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).LT, `t1` will appear before `t2`; if it returns [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).EQ and the sort is stable, `t1` will appear before `t2`; if the sort is unstable, the order of `t1` and `t2` is indeterminate.

> **Note:**
>
> This function will be deprecated in future versions. Use [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) instead.

Parameters:

- `comparator!`: (T, T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering) - A function of type (T, T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).

### func sortBy(Bool, (T, T) -> Ordering) <sup>(deprecated)</sup>

```cangjie
public func sortBy(stable!: Bool, comparator!: (T, T) -> Ordering): Unit
```

Function: Performs a sort on the array elements.

By passing a comparison function that returns a result of type [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering), the array can be custom-sorted. If the comparator returns [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).GT, `t1` will appear after `t2` after sorting; if it returns [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).LT, `t1` will appear before `t2`; if it returns [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).EQ and the sort is stable, `t1` will appear before `t2`; if the sort is unstable, the order of `t1` and `t2` is indeterminate.

> **Note:**
>
> This function will be deprecated in future versions. Use [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) instead.

Parameters:

- `stable!`: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Whether to use stable sorting.
- `comparator!`: (T, T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering) - A function of type (T, T) -> [Ordering](../../core/core_package_api/core_package_enums.md#enum-ordering).

### func toArray()

```cangjie
public func toArray(): Array<T>
```

Function: Returns an array containing all elements of this list in proper sequence.

Return Value:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - An array of type T.

### operator func []\(Int64)

```cangjie
public operator func [](index: Int64): T
```

Function: Operator overload - get.

Parameters:

- `index`: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The index for the get operation.

Return Value:

- T - The value of the element at the specified index.

Exceptions:

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - Thrown when `index` is out of bounds.

### operator func []\(Int64, T)

```cangjie
public operator func [](index: Int64, value!: T): Unit
```

Function: Operator overload - replaces the element at the specified position in this list with the specified element.

Parameters:

- `index`: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The index to set.
- `value!`: T - The value of type T to set.

Exceptions:

- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - Thrown when `index` is out of bounds.

### operator func []\(Range\<Int64>)

```cangjie
public operator func [](range: Range<Int64>): ArrayList<T>
```

Function: Operator overload - slice.

> **Note:**
>
> - If the parameter `range` is a [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) instance constructed using the [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) constructor, the following behaviors apply:
>     - The `start` value is exactly the value passed to the constructor, unaffected by the `hasStart` parameter during construction.
>     - When `hasEnd` is false, the `end` value is ineffective and unaffected by the `isClosed` parameter during construction. The array slice will include elements up to the last element of the original array.
>
> - The [ArrayList](collection_package_class.md#class-arraylistt) returned by the slice operation is a new object with no reference to the original [ArrayList](collection_package_class.md#class-arraylistt).

Parameters:

- `range`: [Range](../../core/core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet)\<[Int64](../../core/core_package_api/core_package_intrinsics.md#int64)> - The range specifying the slice.

Return Value:

- [ArrayList](collection_package_class.md#class-arraylistt)\<T> - The sliced array.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when `range.[step](collection_package_function.md#func-steptint64)` is not equal to 1.
- [IndexOutOfBoundsException](../../core/core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) - Thrown when `range` is invalid.

### extend\<T> ArrayList\<T> <: Equatable\<ArrayList\<T>> where T <: Equatable\<T>

```cangjie
extend<T> ArrayList<T> <: Equatable<ArrayList<T>> where T <: Equatable<T>
```

Function: Extends the [ArrayList](./collection_package_class.md#class-arraylistt)\<T> type with the [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[ArrayList](./collection_package_class.md#class-arraylistt)\<T>> interface, supporting equality comparison.

Parent Types:

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[ArrayList](#class-arraylistt)\<T>>

#### operator func ==(ArrayList\<T>)

```cangjie
public operator func ==(that: ArrayList<T>): Bool
```

Function: Determines whether the current instance is equal to the [ArrayList](./collection_package_class.md#class-arraylistt) instance specified by the parameter.

Two arrays are considered equal if their corresponding elements are equal.

Parameters:

- `that`: [ArrayList](./collection_package_class.md#class-arraylistt)\<T> - The object to compare.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if equal, otherwise false.

#### operator func !=(ArrayList\<T>)

```cangjie
public operator func !=(that: ArrayList<T>): Bool
```

Function: Determines whether the current instance is not equal to the [ArrayList](./collection_package_class.md#class-arraylistt) instance specified by the parameter.

Parameters:

- `that`: [ArrayList](./collection_package_class.md#class-arraylistt)\<T> - The object to compare.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if not equal, otherwise false.

#### func contains(T)

```cangjie
public func contains(element: T): Bool
```

Function: Determines whether the current array contains the specified element `element`.

Parameters:

- `element`: T - The element to search for.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if the array contains the specified element, otherwise false.

### extend\<T> ArrayList\<T> <: SortExtension where T <: Comparable\<T> <sup>(deprecated)</sup>

```cangjie
extend<T> ArrayList<T> where T <: Comparable<T>
```

Function: Extends the [ArrayList](./collection_package_class.md#class-arraylistt)\<T> type with the [SortExtension](../../sort/sort_package_api/sort_package_interfaces.md#interface-sortextension-deprecated) interface, supporting array sorting.

> **Note:**
>
> This will be deprecated in future versions.

Parent Types:

- [SortExtension](../../sort/sort_package_api/sort_package_interfaces.md#interface-sortextension-deprecated)

#### func sort() <sup>(deprecated)</sup>

```cangjie
public func sort(): Unit
```

Function: Sorts the elements of the current array in ascending order (unstable sort).

> **Note:**
>
> This will be deprecated in future versions. Use [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) instead.

#### func sort(Bool) <sup>(deprecated)</sup>

```cangjie
public func sort(stable!: Bool): Unit
```

Function: Sorts the elements of the current array in ascending order.

Parameters:

- `stable!`: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Whether to use stable sorting.

> **Note:**
>
> This will be deprecated in future versions. Use [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) instead.

#### func sortDescending() <sup>(deprecated)</sup>

```cangjie
public func sortDescending(): Unit
```

Function: Sorts the elements of the current array in descending order (unstable sort).

> **Note:**
>
> This will be deprecated in future versions. Use [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) instead.

#### func sortDescending(Bool) <sup>(deprecated)</sup>

```cangjie
public func sortDescending(stable!: Bool): Unit
```

Function: Sorts the elements of the current array in descending order.

Parameters:

- `stable!`: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Whether to use stable sorting.

> **Note:**
>
> This will be deprecated in future versions. Use [sort](../../sort/sort_package_api/sort_package_funcs.md#func-sorttlistt-bool-bool-where-t--comparablet) instead.

### extend\<T> ArrayList\<T> <: ToString where T <: ToString

```cangjie
extend<T> ArrayList<T> <: ToString where T <: ToString
```

Function: Extends the [ArrayList](./collection_package_class.md#class-arraylistt)\<T> type with the [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface, supporting string conversion.

Parent Types:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Function: Converts the current array to a string.

The string contains the string representation of each element in the array, formatted as: "[elem1, elem2, elem3]".

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The resulting string.
## class ArrayQueue\<T>

```cangjie
public class ArrayQueue<T> <: Queue<T> {
    public init()
    public init(capacity: Int64)
}
```

Function: A circular queue data structure implemented using arrays.

Parent Types:

- [Queue](./collection_package_interface.md#interface-queuet)\<T>

### prop capacity

```cangjie
public prop capacity: Int64
```

Function: Gets the capacity of this queue.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### prop size

```cangjie
public prop size: Int64
```

Function: Returns the number of elements in this queue.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init()

```cangjie
public init()
```

Function: Constructs an empty queue with default capacity of 8.

### init(Int64)

```cangjie
public init(capacity: Int64)
```

Function: Constructs a queue with specified capacity. When capacity is less than the default capacity of 8, the initial capacity of the constructed [ArrayQueue](#class-arrayqueuet) will be 8.

Parameters:

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - Specified initial capacity.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when the parameter value is less than 0.

### func add(T)

```cangjie
public func add(element: T): Unit
```

Function: Inserts an element at the tail of this queue.

Parameters:

- element: T - The element to be inserted into this deque.

### func clear()

```cangjie
public func clear(): Unit
```

Function: Clears all elements in this queue.

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

Function: Gets an iterator for elements in this queue in front-to-back order.

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - An iterator for the elements.

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

Function: Checks whether this queue is empty.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if empty, otherwise `false`.

### func peek()

```cangjie
public func peek():?T
```

Function: Retrieves the head element of this queue without removing it.

Return Value:

- ?T - The head element of the queue, returns `None` if the queue is empty.

### func remove()

```cangjie
public func remove(): ?T
```

Function: Removes and returns the head element of this queue. Returns `None` if the queue is empty.

Return Value:

- ?T - The removed head element.

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

Function: Increases the capacity of this queue.

Expands the queue capacity by the additional size. No expansion occurs when:
1. additional is less than or equal to zero
2. remaining capacity is greater than or equal to additional
When remaining capacity is less than additional, the new capacity will be the maximum between:
1. Original capacity multiplied by 1.5 (floored)
2. additional + used capacity

Parameters:

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The size to expand.

### func toArray()

```cangjie
public func toArray(): Array<T>
```

Function: Returns an array containing all elements in this queue in front-to-back order.

Return Value:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - An array of type T.

### extend\<T> ArrayQueue\<T> <: ToString where T <: ToString

```cangjie
extend<T> ArrayQueue<T> <: ToString where T <: ToString
```

Function: Extends [ArrayQueue](./collection_package_class.md#class-arrayqueuet)\<T> with [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface, supporting string conversion.

Parent Types:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Function: Gets the string representation of the current [ArrayQueue](./collection_package_class.md#class-arrayqueuet)\<T> instance.

The string contains string representations of all elements in the deque in front-to-back order, formatted as: "[elem1, elem2, elem3]".

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted string.

## class ArrayStack\<T>

```cangjie
public class ArrayStack<T> <: Stack<T> {
    public init(capacity: Int64)
    public init()
}
```

Function: [ArrayStack](#class-arraystackt) is a stack [Stack](./collection_package_interface.md#interface-stackt) data structure implemented using arrays [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt). The implementation uses an array to store stack elements with a pointer indicating the top element position.

[ArrayStack](#class-arraystackt) only supports Last In First Out (LIFO) operations, allowing insertion/deletion only at the head, and automatically expands capacity as needed.

Parent Types:

- [Stack](./collection_package_interface.md#interface-stackt)\<T>

### prop capacity

```cangjie
public prop capacity: Int64
```

Function: The capacity of the stack.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### prop size

```cangjie
public prop size: Int64
```

Function: The number of elements in the stack.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### func init()

```cangjie
public init()
```

Function: Constructs an empty [ArrayStack](#class-arraystackt) with default capacity of 8.

### func init(Int64)

```cangjie
public init(capacity: Int64)
```

Function: Constructs an empty [ArrayStack](#class-arraystackt) with specified initial capacity. When capacity is less than the default capacity of 8, the initial capacity will be 8.

Parameters:

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - Initial capacity size.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when the input parameter is negative.

### func add(T)

```cangjie
public func add(element: T): Unit
```

Function: Adds an element at the top of the stack.

Parameters:

- element: T - The element to add.

### func clear()

```cangjie
public func clear(): Unit
```

Function: Clears the current [ArrayStack](#class-arraystackt).

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

Function: Checks whether this [ArrayStack](#class-arraystackt) is empty.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if empty, otherwise false.

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

Function: Returns an iterator for elements in this [ArrayStack](#class-arraystackt) in pop order.

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - An iterator for stack elements.

### func peek()

```cangjie
public func peek(): ?T
```

Function: Retrieves the top element without removing it. Returns `None` if the stack is empty.

Return Value:

- ?T - The top element of the stack.

### func remove()

```cangjie
public func remove(): ?T
```

Function: Pop operation, removes the top element from the stack and returns it. Returns `None` when the stack is empty.

Return Value:

- ?T - The removed top element of the stack.

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

Function: Expands the capacity of the current [ArrayStack](#class-arraystackt) by the specified amount. No expansion occurs if `additional` is less than or equal to zero; if the current remaining space is greater than or equal to `additional`, no expansion is performed. Otherwise, the current [ArrayStack](#class-arraystackt) will expand to `size + additional`.

Parameters:

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The amount of space to expand.

### func toArray()

```cangjie
public func toArray(): Array<T>
```

Function: Returns an array containing the elements of the stack in the order they would be popped.

Return Value:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - An array of type T.

### extend\<T> ArrayStack\<T> <: ToString where T <: ToString

```cangjie
extend<T> ArrayStack<T> <: ToString where T <: ToString
```

Function: Extends the [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface for ArrayStack, enabling string conversion.

Parent Types:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Function: Retrieves the string representation of the current [ArrayStack](./collection_package_class.md#class-arraystackt)\<T> instance.

The string includes the string representation of each element in the stack, ordered from back to front, formatted as: "[elem1, elem2, elem3]".

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string representation of the current stack.

## class HashMapIterator\<K, V> where K <: Hashable & Equatable\<K>

```cangjie
public class HashMapIterator<K, V> <: Iterator<(K, V)> where K <: Hashable & Equatable<K> {
    public init(map: HashMap<K, V>)
}
```

Function: This class primarily implements the iterator functionality for [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Parent Types:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<(K, V)>

### init(HashMap\<K, V>)

```cangjie
public init(map: HashMap<K, V>)
```

Function: Creates an instance of [HashMapIterator](collection_package_class.md#class-hashmapiteratork-v-where-k--hashable--equatablek)\<K, V>.

Parameters:

- [map](collection_package_function.md#func-mapt-rt---r): [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)\<K, V> - The input [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)\<K, V>.

### func next()

```cangjie
public func next(): ?(K, V)
```

Function: Returns the next element in the iterator.

Return Value:

- ?(K, V) - The next element in the iterator, encapsulated in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont).

Exceptions:

- [ConcurrentModificationException](collection_package_exception.md#class-concurrentmodificationexception) - Thrown when the function detects unsynchronized concurrent modifications.

### func remove()

```cangjie
public func remove(): Option<(K, V)>
```

Function: Removes the element returned by the `next` function of this [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) iterator. This function can only be called once per call to `next`.

Return Value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)> - The removed element.

Exceptions:

- [ConcurrentModificationException](collection_package_exception.md#class-concurrentmodificationexception) - Thrown when the function detects unsynchronized concurrent modifications.

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

Function: A hash table implementation of the [Map](collection_package_interface.md#interface-mapk-v) interface.

A hash table is a commonly used data structure for fast lookup, insertion, and deletion of data. The basic principle of a hash table is to map data to an array, known as the hash table. Each data element has a corresponding hash value, which determines its position in the hash table.

Hash tables are characterized by fast lookup, insertion, and deletion operations, typically with O(1) time complexity. Since the underlying array size is dynamic, hash tables do not guarantee immutable element order.

Parent Types:

- [Map](collection_package_interface.md#interface-mapk-v)\<K, V>

### prop capacity

```cangjie
public prop capacity: Int64
```

Function: Returns the capacity of the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The capacity of the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

### prop size

```cangjie
public prop size: Int64
```

Function: Returns the number of key-value pairs.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init()

```cangjie
public init()
```

Function: Constructs a [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) with a default initial capacity of 16 and a default load factor.

### init(Array\<(K, V)>)

```cangjie
public init(elements: Array<(K, V)>)
```

Function: Constructs a [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) using the provided array of key-value pairs.

This constructor sets the capacity of the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) based on the size of the input array. Since [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) does not allow duplicate keys internally, if the [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt) contains duplicate keys, the later key-value pairs will overwrite the earlier ones according to the iterator order.

Parameters:

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<(K, V)> - The array of key-value pairs used to initialize the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

### init(Collection\<(K, V)>)

```cangjie
public init(elements: Collection<(K, V)>)
```

Function: Constructs a [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) using the provided collection of key-value pairs.

This constructor sets the capacity of the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) based on the size of the input collection. Since [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) does not allow duplicate keys internally, if the [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt) contains duplicate keys, the later key-value pairs will overwrite the earlier ones according to the iterator order.

Parameters:

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<(K, V)> - The collection of key-value pairs used to initialize the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

### init(Int64)

```cangjie
public init(capacity: Int64)
```

Function: Constructs a [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) with the specified initial capacity.

Parameters:

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The initial capacity.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if `capacity` is less than 0.

### init(Int64, (Int64) -> (K, V))

```cangjie
public init(size: Int64, initElement: (Int64) -> (K, V))
```

Function: Constructs a [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) using the specified size and a function rule.

The capacity of the constructed [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) is influenced by the `size` parameter. Since [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) does not allow duplicate keys internally, if the `initElement` function generates duplicate keys, the later key-value pairs will overwrite the earlier ones.

Parameters:

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The number of elements to initialize the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) -> (K, V) - The function rule used to initialize the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if `size` is less than 0.

### func add(K, V)

```cangjie
public func add(key: K, value: V): Option<V>
```

Function: Inserts a key-value pair into the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

For keys already present in the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek), the value will be replaced with the new value, and the old value will be returned.

Parameters:

- key: K - The key to insert.
- value: V - The value to assign.

Return Value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V> - If the key existed before assignment, the old value is returned encapsulated in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont); otherwise, returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V>.None.

Example:

See [HashMap's get/add/contains functions](../collection_package_samples/sample_hashmap_get_add_contains.md) for usage examples.

### func add(Collection\<(K, V)>)

```cangjie
public func add(all!: Collection<(K, V)>): Unit
```

Function: Inserts a new collection of key-value pairs into the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) in the order specified by the iterator of `elements`.

For keys already present in the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek), the values will be replaced with the new values.

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<(K, V)> - The collection of key-value pairs to add to the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Example:

See [HashMap's add/remove/clear functions](../collection_package_samples/sample_hashmap_add_remove_clear.md) for usage examples.

### func addIfAbsent(K, V)

```cangjie
func addIfAbsent(key: K, value: V): ?V
```

Function: Adds the specified key-value pair `key-value` if the key is not already present in the current [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek). Otherwise, no modification is made.

Parameters:

- key: K - The key of the key-value pair to add.
- value: V - The value of the key-value pair to add.

Return Value:

- ?V - If the key already exists in the current [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) when this function is called, returns the old value associated with the key; otherwise, returns None.

### func clear()

```cangjie
public func clear(): Unit
```

Function: Clears all key-value pairs.

Example:

See [HashMap's add/remove/clear functions](../collection_package_samples/sample_hashmap_add_remove_clear.md) for usage examples.### func clone()

```cangjie
public func clone(): HashMap<K, V>
```

Function: Clones a [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Return Value:

- [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek)\<K, V> - Returns a cloned [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

### func contains(K)

```cangjie
public func contains(key: K): Bool
```

Function: Checks whether a mapping for the specified key exists.

Parameters:

- key: K - The key to check.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if the key exists; otherwise, returns false.

Example:

See usage example in [HashMap's get/add/contains functions](../collection_package_samples/sample_hashmap_get_add_contains.md).

### func contains(Collection\<K>)

```cangjie
public func contains(all!: Collection<K>): Bool
```

Function: Checks whether mappings for all keys in the specified collection exist.

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<K> - The collection of keys to check.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if all keys exist; otherwise, returns false.

### func entryView(K)

```cangjie
public func entryView(key: K): MapEntryView<K, V>
```

Function: Returns an empty reference view if the specified key doesn't exist. If the key exists, returns a reference view of the corresponding element.

Parameters:

- key: K - The key of the key-value pair to add.

Return Value:

- [MapEntryView](./collection_package_interface.md#interface-mapentryviewk-v)\<K, V> - A reference view.

### func get(K)

```cangjie
public func get(key: K): ?V
```

Function: Returns the value mapped to the specified key. If the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) doesn't contain a mapping for the key, returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V>.None.

Parameters:

- key: K - The input key.

Return Value:

- ?V - The value corresponding to the key, wrapped in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont).

Example:

See usage example in [HashMap's get/add/contains functions](../collection_package_samples/sample_hashmap_get_add_contains.md).

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

Function: Checks whether the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) is empty. Returns true if empty; otherwise, returns false.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Whether the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) is empty.

### func iterator()

```cangjie
public func iterator(): HashMapIterator<K, V>
```

Function: Returns an iterator for the HashMap.

Return Value:

- [HashMapIterator](collection_package_class.md#class-hashmapiteratork-v-where-k--hashable--equatablek)\<K, V> - Returns an iterator for the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

### func keys()

```cangjie
public func keys(): EquatableCollection<K>
```

Function: Returns all keys in the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek), stored in a Keys container.

Return Value:

- [EquatableCollection](collection_package_interface.md#interface-equatablecollectiont)\<K> - A container holding all returned keys.

### func remove(Collection\<K>)

```cangjie
public func remove(all!: Collection<K>): Unit
```

Function: Removes mappings for all keys in the specified collection from this [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) (if they exist).

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<K> - The collection of keys to remove.

### func remove(K)

```cangjie
public func remove(key: K): Option<V>
```

Function: Removes the mapping for the specified key from this [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) (if it exists).

Parameters:

- key: K - The key to remove.

Return Value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V> - The value corresponding to the removed key, wrapped in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont). Returns None if the key doesn't exist in the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Example:

See usage example in [HashMap's add/remove/clear functions](../collection_package_samples/sample_hashmap_add_remove_clear.md).

### func removeIf((K, V) -> Bool)

```cangjie
public func removeIf(predicate: (K, V) -> Bool): Unit
```

Function: Takes a lambda expression and removes key-value pairs that satisfy the condition.

This function traverses the entire [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek), so all key-value pairs where `predicate(K, V) == true` will be removed.

Parameters:

- predicate: (K, V) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - A lambda expression for condition checking.

Exceptions:

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - Thrown when `predicate` adds, removes, or modifies key-value pairs within the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

### func replace(K, V)

```cangjie
func replace(key: K, value: V): ?V
```

Function: If the specified key exists in the current [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek), updates its value to the new value. Otherwise, no changes are made.

Parameters:

- key: K - The key of the key-value pair to modify.
- value: V - The new value for the key-value pair.

Return Value:

- ?V - If the key exists, returns its old value. Otherwise, returns None.

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

Function: Expands the current [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Expands the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) by the specified additional size. No expansion occurs if additional is less than or equal to zero. No expansion occurs if the remaining capacity of the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek) is greater than or equal to additional. If the remaining capacity is less than additional, the expansion size is the maximum between (original capacity * 1.5, rounded down) and (additional + used capacity).

Parameters:

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The size to expand by.

Exceptions:

- [OverflowException](../../core/core_package_api/core_package_exceptions.md#class-overflowexception) - Thrown when additional + used capacity exceeds Int64.Max.

### func toArray()

```cangjie
public func toArray(): Array<(K, V)>
```

Function: Constructs and returns an array containing all key-value pairs in the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Return Value:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<(K, V)> - An array containing all key-value pairs in the container.

### func values()

```cangjie
public func values(): Collection<V>
```

Function: Returns all values in the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek), stored in a Values container.

Return Value:

- [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<V> - A container holding all returned values.

### operator func []\(K, V)

```cangjie
public operator func [](key: K, value!: V): Unit
```

Function: Operator overload for the add method. If the key exists, the new value overwrites the old value. If the key doesn't exist, adds the key-value pair.

Parameters:

- key: K - The key to check.
- value!: V - The value to set.

#### operator func []\(K)

```cangjie
public operator func [](key: K): V
```

Function: Operator overload for the get method. If the key exists, returns the corresponding value.

Parameters:

- key: K - The key to check.

Return Value:

- V - The value corresponding to the key.

Exceptions:

- [NoneValueException](../../core/core_package_api/core_package_exceptions.md#class-nonevalueexception) - Thrown if the key doesn't exist in the [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

### extend\<K, V> HashMap\<K, V> <: Equatable\<HashMap\<K, V>> where V <: Equatable\<V>

```cangjie
extend<K, V> HashMap<K, V> <: Equatable<HashMap<K, V>> where V <: Equatable<V>
```

Function: Extends the [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> type with the [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V>> interface, enabling equality checks.

Parent Type:

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V>>

#### operator func ==(HashMap\<K, V>)

```cangjie
public operator func ==(right: HashMap<K, V>): Bool
```

Function: Checks whether the current instance is equal to the specified [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> instance.

Two [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> instances are equal if they contain identical key-value pairs.

Parameters:

- right: [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> - The object to compare.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if equal; otherwise, returns false.

#### operator func !=(HashMap\<K, V>)

```cangjie
public operator func !=(right: HashMap<K, V>): Bool
```

Function: Checks whether the current instance is not equal to the specified [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> instance.Parameters:

- right: [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> - The object to be compared.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if not equal, otherwise false.

### extend\<K, V> HashMap\<K, V> <: ToString where V <: ToString, K <: ToString

```cangjie
extend<K, V> HashMap<K, V> <: ToString where V <: ToString, K <: ToString
```

Function: Extends the [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface for [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V>, enabling string conversion operations.

Parent Types:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Function: Converts the current [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V> instance to a string.

The string includes the string representation of each key-value pair in the [HashMap](./collection_package_class.md#class-hashmapk-v)\<K, V>, formatted as: "[(k1, v1), (k2, v2), (k3, v3)]".

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted string.

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

Function: An implementation of the [Set](collection_package_interface.md#interface-sett) interface based on [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Elements in [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) are unordered and do not allow duplicates. When adding elements to [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet), the hash value of the element determines its position in the hash table.

> **Note:**
>
> [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) is implemented based on [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek), so its capacity, memory layout, and time performance are identical to [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

Parent Types:

- [Set](collection_package_interface.md#interface-sett)\<T>

### prop size

```cangjie
public prop size: Int64
```

Function: Returns the number of elements in this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init(Int64, (Int64) -> T)

```cangjie
public init(size: Int64, initElement: (Int64) -> T)
```

Function: Constructs a [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) using the specified number of elements `size` and an initialization function. The capacity of the constructed [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) is influenced by `size`.

Parameters:

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The number of elements in the initialization function.
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) -> T - The initialization function rule.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if `size` is less than 0.

### init()

```cangjie
public init()
```

Function: Constructs an empty [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) with an initial capacity of 16.

### init(Array\<T>)

```cangjie
public init(elements: Array<T>)
```

Function: Constructs a [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) using the specified array. The constructor sets the capacity of the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) based on the size of the input array `elements`.

Parameters:

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - The array used to initialize the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

### init(Collection\<T>)

```cangjie
public init(elements: Collection<T>)
```

Function: Constructs a [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) using the specified collection. The constructor sets the capacity of the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) based on the size of the input collection `elements`.

Parameters:

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - The collection used to initialize the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

### init(Int64)

```cangjie
public init(capacity: Int64)
```

Function: Constructs a [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) with the specified capacity.

Parameters:

- capacity: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The initial capacity size.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if `capacity` is less than 0.

### func add(T)

```cangjie
public func add(element: T): Bool
```

Function: Adds the specified element to the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet). If the element already exists, the addition fails.

Parameters:

- element: T - The specified element.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if the addition is successful; otherwise, returns false.

Example:

See [HashSet's add/iterator/remove functions](../collection_package_samples/sample_hashset_add_iterator_remove.md) for usage examples.

### func add(Collection\<T>)

```cangjie
public func add(all!: Collection<T>): Unit
```

Function: Adds all elements from the specified [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont) to this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet). Existing elements are not added.

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - The collection of elements to be added.

### prop capacity

```cangjie
public prop capacity: Int64
```

Function: Returns the internal array capacity of this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

> **Note:**
>
> The capacity size does not necessarily equal the `size` of the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The internal array capacity of this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

### func clear()

```cangjie
public func clear(): Unit
```

Function: Removes all elements from this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

### func clone()

```cangjie
public func clone(): HashSet<T>
```

Function: Clones the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

Return Value:

- [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - The cloned [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

### func contains(T)

```cangjie
public func contains(element: T): Bool
```

Function: Checks if the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) contains the specified element.

Parameters:

- element: T - The specified element.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if the element is contained; otherwise, returns false.

### func contains(Collection\<T>)

```cangjie
public func contains(all!: Collection<T>): Bool
```

Function: Checks if the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) contains all elements from the specified [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont).

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - The specified collection of elements.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if all elements from the collection are contained; otherwise, returns false.

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

Function: Checks if the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) is empty.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if empty; otherwise, returns false.

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

Function: Returns an iterator for this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - The iterator for this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

Example:

See [HashSet's add/iterator/remove functions](../collection_package_samples/sample_hashset_add_iterator_remove.md) for usage examples.

### func remove(T)

```cangjie
public func remove(element: T): Bool
```

Function: Removes the specified element from this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) if it exists.

Parameters:

- element: T - The element to be removed.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if the removal is successful; otherwise, returns false.

Example:

See [HashSet's add/iterator/remove functions](../collection_package_samples/sample_hashset_add_iterator_remove.md) for usage examples.

### func remove(Collection\<T>)

```cangjie
public func remove(all!: Collection<T>): Unit
```

Function: Removes all elements from this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) that are also contained in the specified [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont).

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - The collection of elements to be removed from this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

### func removeIf((T) -> Bool)

```cangjie
public func removeIf(predicate: (T) -> Bool): Unit
```

Function: Pass in a lambda expression to delete corresponding elements if the `true` condition is met.

Parameters:

- predicate: (T) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The condition to determine whether to delete an element.

Exceptions:

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - Thrown when elements are added, deleted, or modified within the `predicate` in a [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet).

### func reserve(Int64)

```cangjie
public func reserve(additional: Int64): Unit
```

Function: Expands the [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) by the specified `additional` size. No expansion occurs if:
- `additional` is less than or equal to zero
- The remaining capacity of [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) is greater than or equal to `additional`

When the remaining capacity is less than `additional`, the expansion size will be the maximum between:
1. The floor value of 1.5 times the original capacity
2. The sum of `additional` and the currently used capacity

Parameters:

- additional: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The size to expand.

Exceptions:

- [OverflowException](../../core/core_package_api/core_package_exceptions.md#class-overflowexception) - Thrown when `additional` + used capacity exceeds Int64.Max.

### func retain(Set\<T>)

```cangjie
public func retain(all!: Set<T>): Unit
```

Function: Retains only the elements in this [HashSet](collection_package_class.md#class-hashsett-where-t--hashable--equatablet) that are also present in the specified [Set](collection_package_interface.md#interface-sett).

Parameters:

- all!: [Set](collection_package_interface.md#interface-sett)\<T> - The set of elements to retain.

### func subsetOf(ReadOnlySet\<T>)

```cangjie
public func subsetOf(other: ReadOnlySet<T>): Bool
```

Function: Checks whether this set is a subset of another [ReadOnlySet](collection_package_interface.md#interface-readonlysett).

Parameters:

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The set to check against.

Returns:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if this [Set](collection_package_interface.md#interface-sett) is a subset of the specified [ReadOnlySet](collection_package_interface.md#interface-readonlysett); otherwise, `false`.

### func toArray()

```cangjie
public func toArray(): Array<T>
```

Function: Returns an array containing all elements in the container.

Returns:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - An array of type T.

### operator func &(ReadOnlySet\<T>)

```cangjie
public operator func &(other: ReadOnlySet<T>): HashSet<T>
```

Function: Returns a new set containing the intersection of elements from both sets.

Parameters:

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The input set.

Returns:

- [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - A set of type T.

### operator func |(ReadOnlySet\<T>)

```cangjie
public operator func |(other: ReadOnlySet<T>): HashSet<T>
```

Function: Returns a new set containing the union of elements from both sets.

Parameters:

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The input set.

Returns:

- [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - A set of type T.

### operator func -(ReadOnlySet\<T>)

```cangjie
public operator func -(other: ReadOnlySet<T>): HashSet<T>
```

Function: Returns a new set containing the difference of elements between the two sets.

Parameters:

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The input set.

Returns:

- [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - A set of type T.

### extend\<T> HashSet\<T> <: Equatable\<HashSet\<T>>

```cangjie
extend<T> HashSet<T> <: Equatable<HashSet<T>>
```

Function: Extends the [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> type with the [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T>> interface, supporting equality operations.

Parent Types:

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T>>

#### operator func ==(HashSet\<T>)

```cangjie
public operator func ==(that: HashSet<T>): Bool
```

Function: Determines whether the current instance is equal to the specified [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> instance.

Two [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> instances are considered equal if they contain exactly the same elements.

Parameters:

- that: [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - The object to compare.

Returns:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if equal; otherwise, `false`.

#### operator func !=(HashSet\<T>)

```cangjie
public operator func !=(that: HashSet<T>): Bool
```

Function: Determines whether the current instance is not equal to the specified [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> instance.

Parameters:

- that: [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> - The object to compare.

Returns:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if not equal; otherwise, `false`.

### extend\<T> HashSet\<T> <: ToString where T <: ToString

```cangjie
extend<T> HashSet<T> <: ToString where T <: ToString
```

Function: Extends the [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> with the [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface, supporting string conversion operations.

Parent Types:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Function: Converts the current [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T> instance to a string.

The resulting string contains the string representation of each element in the [HashSet](./collection_package_class.md#class-hashsett-where-t--hashable--equatablet)\<T>, formatted as: "[elem1, elem2, elem3]".

Returns:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted string.

## class LinkedListNode\<T>

```cangjie
public class LinkedListNode<T>
```

Function: [LinkedListNode](collection_package_class.md#class-linkedlistnodet) represents a node in a [LinkedList](collection_package_class.md#class-linkedlistt).

Through [LinkedListNode](collection_package_class.md#class-linkedlistnodet), you can traverse a [LinkedList](collection_package_class.md#class-linkedlistt) forward or backward, as well as access and modify the node's value.

[LinkedListNode](collection_package_class.md#class-linkedlistnodet) instances can only be obtained via the 'nodeAt', 'firstNode', or 'lastNode' methods of the corresponding [LinkedList](collection_package_class.md#class-linkedlistt). If the node is removed from the [LinkedList](collection_package_class.md#class-linkedlistt), it becomes a dangling node, and any operation on it will throw an '[IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception)'.

### prop next

```cangjie
public prop next: Option<LinkedListNode<T>>
```

Function: Gets the next node of the current node, or returns None if there isn't one.

Type: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>>

Exceptions:

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - Thrown if the node does not belong to any linked list instance.

### prop prev

```cangjie
public prop prev: Option<LinkedListNode<T>>
```

Function: Gets the previous node of the current node, or returns None if there isn't one.

Type: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>>

Exceptions:

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - Thrown if the node does not belong to any linked list instance.

### prop value

```cangjie
public mut prop value: T
```

Function: Gets or modifies the value of the element.

Type: T

Exceptions:

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - Thrown if the node does not belong to any linked list instance.

## class LinkedList\<T>

```cangjie
public class LinkedList<T> <: Collection<T> {
    public init()
    public init(elements: Collection<T>)
    public init(elements: Array<T>)
    public init(size: Int64, initElement: (Int64)-> T)
}
```

Function: Implements a doubly linked list data structure.

A doubly linked list is a common data structure consisting of a sequence of nodes, where each node contains two pointers: one to the previous node and another to the next node. This structure allows bidirectional traversal from any node, either starting from the head node moving forward or from the tail node moving backward.

[LinkedList](collection_package_class.md#class-linkedlistt) does not support concurrent operations. Modifications to elements in the collection do not invalidate iterators, but adding or removing elements will invalidate them.

Parent Types:

- [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T>

### prop first

```cangjie
public prop first: ?T
```

Function: The value of the first element in the linked list, or None if the list is empty.

Type: ?T

### prop firstNode

```cangjie
public prop firstNode: ?LinkedListNode<T>
```

Function: Gets the node of the first element in the linked list.

Type: ?[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>

### prop last

```cangjie
public prop last: ?T
```

Function: The value of the last element in the linked list, or None if the list is empty.

Type: ?T

### prop lastNode

```cangjie
public prop lastNode: ?LinkedListNode<T>
```

Function: Gets the node of the last element in the linked list.

Type: ?[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>### prop size

```cangjie
public prop size: Int64
```

Function: The number of elements in the linked list.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init

```cangjie
public init()
```

Function: Constructs an empty linked list.

### init(Array\<T>)

```cangjie
public init(elements: Array<T>)
```

Function: Constructs a [LinkedList](collection_package_class.md#class-linkedlistt) instance containing elements from the specified array in traversal order.

Parameters:

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - The array of elements to be placed into this linked list.

### init(Collection\<T>)

```cangjie
public init(elements: Collection<T>)
```

Function: Constructs a linked list containing elements from the specified collection in the order returned by the collection's iterator.

Parameters:

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<T> - The collection of elements to be placed into this linked list.

### init(Int64, (Int64)-> T)

```cangjie
public init(size: Int64, initElement: (Int64)-> T)
```

Function: Creates a linked list with `size` elements, where the nth element satisfies the condition ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64))-> T.

Parameters:

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The number of elements to create in the linked list.
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) ->T - The initialization parameter for elements.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the specified linked list length is less than 0.

### func addLast(T)

```cangjie
public func addLast(element: T): LinkedListNode<T>
```

Function: Adds an element at the tail position of the linked list and returns the node of that element.

Parameters:

- element: T - The element to be added to the linked list.

Return Value:

- [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The node pointing to the element.

### func backward(LinkedListNode\<T>)

```cangjie
public func backward(mark: LinkedListNode<T>): Iterator<T>
```

Function: Obtains an iterator for all elements starting from the `mark` node to the head node of the corresponding linked list.

Parameters:

- mark: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The starting node of the elements.

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - The iterator for the corresponding elements.

Exceptions:

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - Thrown if the node does not belong to any linked list instance.

### func clear()

```cangjie
public func clear(): Unit
```

Function: Removes all elements from the linked list.

### func forward(LinkedListNode\<T>)

```cangjie
public func forward(mark: LinkedListNode<T>): Iterator<T>
```

Function: Obtains an iterator for all elements starting from the `mark` node to the tail node of the corresponding linked list.

Parameters:

- mark: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The starting node of the elements.

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - The iterator for the corresponding elements.

Exceptions:

- [IllegalStateException](../../core/core_package_api/core_package_exceptions.md#class-illegalstateexception) - Thrown if the node does not belong to any linked list instance.

### func addAfter(LinkedListNode\<T>,T)

```cangjie
public func addAfter(node: LinkedListNode<T>, element: T): LinkedListNode<T>
```

Function: Inserts an element after the specified node in the linked list and returns the node of that element.

Parameters:

- node: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The specified node.
- element: T - The element to be added to the linked list.

Return Value:

- [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The node pointing to the inserted element.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the specified node does not belong to this linked list.

### func addBefore(LinkedListNode\<T>,T)

```cangjie
public func addBefore(node: LinkedListNode<T>, element: T): LinkedListNode<T>
```

Function: Inserts an element before the specified node in the linked list and returns the node of that element.

Parameters:

- node: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The specified node.
- element: T - The element to be added to the linked list.

Return Value:

- [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The node pointing to the inserted element.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the specified node does not belong to this linked list.

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

Function: Returns whether this linked list is empty.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if this linked list contains no elements.

### func iterator()

```cangjie
public func iterator(): Iterator<T>
```

Function: Returns an iterator over the elements in this collection, in order from the first node to the last node of the linked list.

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<T> - An iterator over the elements in this collection.

### func nodeAt(Int64)

```cangjie
public func nodeAt(index: Int64): Option<LinkedListNode<T>>
```

Function: Gets the node of the element at the specified `index` in the linked list, with numbering starting from 0.

The time complexity of this function is O(n).

Parameters:

- index: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The index of the node to retrieve.

Return Value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<[LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T>> - The node at the specified index, or `None` if no such node exists.

### func removeFirst()

```cangjie
public func removeFirst() : ?T
```

Function: Removes the first element of the linked list and returns its value.

Return Value:

- ?T - The value of the removed element, or `None` if the linked list is empty.

### func removeLast()

```cangjie
public func removeLast() : ?T
```

Function: Removes the last element of the linked list and returns its value.

Return Value:

- ?T - The value of the removed element, or `None` if the linked list is empty.

### func addFirst(T)

```cangjie
public func addFirst(element: T): LinkedListNode<T>
```

Function: Inserts an element at the head position of the linked list and returns the node of that element.

Parameters:

- element: T - The element to be added to the linked list.

Return Value:

- [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The node pointing to the element.

### func remove(LinkedListNode\<T>)

```cangjie
public func remove(node: LinkedListNode<T>): T
```

Function: Removes the specified node from the linked list.

Parameters:

- node: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The node to be removed.

Return Value:

- T - The value of the removed node.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the specified node does not belong to this linked list.

### func removeIf((T)-> Bool)

```cangjie
public func removeIf(predicate: (T)-> Bool): Unit
```

Function: Removes all elements from this linked list that satisfy the given lambda expression or function.

Parameters:

- predicate: (T) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` for elements to be removed.

Exceptions:

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - Thrown when nodes in [LinkedList](./collection_package_class.md#class-linkedlistt) are added, removed, or modified within `predicate`.

### func reverse()

```cangjie
public func reverse(): Unit
```

Function: Reverses the order of elements in this linked list.

### func splitOff(LinkedListNode\<T>)

```cangjie
public func splitOff(node: LinkedListNode<T>): LinkedList<T>
```

Function: Splits the linked list into two linked lists starting from the specified `node`. If successful, `node` is no longer in the current linked list but becomes the first node in the new linked list.Parameters:

- node: [LinkedListNode](collection_package_class.md#class-linkedlistnodet)\<T> - The position to split at.

Return Value:

- [LinkedList](collection_package_class.md#class-linkedlistt)\<T> - The newly generated linked list after splitting the original list.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws this exception if the specified node does not belong to this linked list.

### func toArray()

```cangjie
public func toArray(): Array<T>
```

Function: Returns an array containing all elements in this linked list, with the same order as the linked list.

Return Value:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - An array of type T.

### extend\<T> LinkedList\<T> <: Equatable\<LinkedList\<T>> where T <: Equatable\<T>

```cangjie
extend<T> LinkedList<T> <: Equatable<LinkedList<T>> where T <: Equatable<T>
```

Function: Extends the [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[LinkedList](./collection_package_class.md#class-linkedlistt)\<T>> interface for the [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> type, supporting equality comparison operations.

Parent Types:

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[LinkedList](#class-linkedlistt)\<T>>

#### operator func ==(LinkedList\<T>)

```cangjie
public operator func ==(right: LinkedList<T>): Bool
```

Function: Determines whether the current instance is equal to the [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> instance pointed to by the parameter.

Two [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> instances are considered equal if they contain identical elements.

Parameters:

- right: [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> - The object to compare.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if equal, otherwise false.

#### operator func !=(LinkedList\<T>)

```cangjie
public operator func !=(right: LinkedList<T>): Bool
```

Function: Determines whether the current instance is not equal to the [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> instance pointed to by the parameter.

Parameters:

- right: [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> - The object to compare.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if not equal, otherwise false.

### extend\<T> LinkedList\<T> <: ToString where T <: ToString

```cangjie
extend<T> LinkedList<T> <: ToString where T <: ToString
```

Function: Extends the [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface for [LinkedList](./collection_package_class.md#class-linkedlistt)\<T>, supporting string conversion operations.

Parent Types:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Function: Converts the current [LinkedList](./collection_package_class.md#class-linkedlistt)\<T> instance to a string.

The string includes the string representation of each element in the [LinkedList](./collection_package_class.md#class-linkedlistt)\<T>, formatted as: "[elem1, elem2, elem3]".

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted string.

## class TreeMap\<K, V> where K <: Comparable\<K>

```cangjie
public class TreeMap<K, V> <: OrderedMap<K, V> where K <: Comparable<K> {
    public init()
    public init(elements: Collection<(K, V)>)
    public init(elements: Array<(K,V)>)
    public init(size: Int64, initElement: (Int64) -> (K, V))
}
```

Function: An implementation of the [OrderedMap](collection_package_interface.md#interface-orderedmapk-v) interface based on a balanced binary search tree.

The primary purpose of this class is to provide an ordered key-value storage structure that supports fast insertion, deletion, and lookup operations.

[TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) can be used in any scenario requiring ordered key-value storage, such as databases, caches, lookup tables, etc.

Parent Types:

- [OrderedMap](collection_package_interface.md#interface-orderedmapk-v)\<K, V>

### prop first

```cangjie
public prop first: ?(K, V)
```

Function: Gets the first element of the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

Return Value:

- ?(K, V) - If the first element exists, returns it wrapped in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont); otherwise, returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)>.None.

### prop last

```cangjie
public prop last: ?(K, V)
```

Function: Gets the last element of the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

Return Value:

- ?(K, V) - If the last element exists, returns it wrapped in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont); otherwise, returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)>.None.

### prop size

```cangjie
public prop size: Int64
```

Function: Returns the number of key-value pairs.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init()

```cangjie
public init()
```

Function: Constructs an empty [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

### init(Array\<(K,V)>)

```cangjie
public init(elements: Array<(K,V)>)
```

Function: Constructs a [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) from the given key-value pair array.

Elements are inserted into the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) in the order of `elements`. Since duplicate keys are not allowed in [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek), if duplicate keys exist in `elements`, the later key-value pair will overwrite the earlier one.

Parameters:

- elements: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<(K, V)> - The key-value pair array used to initialize this [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

### init(Collection\<(K, V)>)

```cangjie
public init(elements: Collection<(K, V)>)
```

Function: Constructs a [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) from the given key-value pair collection.

Elements are inserted into the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) in the iterator order of `elements`. Since duplicate keys are not allowed in [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek), if duplicate keys exist in `elements`, the later key-value pair (in iterator order) will overwrite the earlier one.

Parameters:

- elements: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<(K, V)> - The key-value pair collection used to initialize this [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

### init(Int64, (Int64) -> (K, V))

```cangjie
public init(size: Int64, initElement: (Int64) -> (K, V))
```

Function: Constructs a [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) using the given element count `size` and initialization function.

Parameters:

- size: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The number of elements.
- initElement: ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64)) -> (K, V) - The initialization function rule for this [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if `size` is less than 0.

### func add(K, V)

```cangjie
public func add(key: K, value: V): Option<V>
```

Function: Inserts a new key-value pair into the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek). For existing keys in the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek), the value will be replaced with the new value.

Parameters:

- key: K - The key to insert.
- value: V - The value to assign.

Return Value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V> - If the key existed before assignment, returns the old value wrapped in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont); otherwise, returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V>.None.

### func add(Collection\<(K, V)>)

```cangjie
public func add(all!: Collection<(K, V)>): Unit
```

Function: Inserts a new key-value pair collection into the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek). For existing keys in the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek), the values will be replaced with the new values.

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<(K, V)> - The key-value pair collection to add to the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

### func backward(K, Bool)

```cangjie
public func backward(mark: K, inclusive!: Bool = true): Iterator<(K, V)>
```

Function: Gets an iterator that traverses from the first node with a key less than or equal to `mark` in descending order to [first](./collection_package_class.md#prop-first-3). If the node's key equals `mark`, the inclusion of this node is determined by `inclusive!`.

Parameters:

- mark: K - The key used to determine the starting point.
- inclusive!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - When `mark` is the key of the first element in the iterator, specifies whether to include `mark` as the starting point. Defaults to `true`.

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<(K, V)> - The iterator for the corresponding elements.

### func clear()

```cangjie
public func clear(): Unit
```

Function: Clears all key-value pairs.

### func clone()

```cangjie
public func clone(): TreeMap<K, V>
```

Function: Clones the [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

Return Value:

- [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> - Returns a [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) instance.

### func contains(K)

```cangjie
public func contains(key: K): Bool
```

Function: Determines whether the map contains a mapping for the specified key.

Parameters:

- key: K - The key to check.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if the key exists, otherwise false.

### func contains(Collection\<K>)

```cangjie
public func contains(all!: Collection<K>): Bool
```

Function: Determines whether the map contains mappings for all keys in the specified collection.

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<K> - The collection of keys.

Return Value:- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if it exists; otherwise, returns false.

### func entryView(K)

```cangjie
public func entryView(k: K): MapEntryView<K, V>
```

Function: Returns an empty reference view if the specified key is not contained. If the key exists, returns a reference view of the corresponding element.

Parameters:

- k: K - The key of the key-value pair to be added.

Return Value:

- [MapEntryView](./collection_package_interface.md#interface-mapentryviewk-v)\<K, V> - A reference view.

### func forward(K, Bool)

```cangjie
public func forward(mark: K, inclusive!: Bool = true): Iterator<(K, V)>
```

Function: Obtains an iterator that traverses from the first node with a key greater than or equal to `mark` in ascending order until [last](./collection_package_class.md#prop-last-3). If the node's key equals `mark`, the inclusion of the corresponding node is determined by `inclusive!`.

Parameters:

- mark: K - The key used to determine the starting point.
- inclusive!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - When `mark` is the key of the iterator's first element, specifies whether to include `mark` as the starting point. Defaults to `true`.

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<(K, V)> - The iterator for the corresponding elements.

### func get(K)

```cangjie
public func get(key: K): ?V
```

Function: Returns the value mapped by the specified key.

Parameters:

- key: K - The specified key.

Return Value:

- ?V - If such a value exists, encapsulates it in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont) and returns it; otherwise, returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V>.None.

### func isEmpty()

```cangjie
public func isEmpty(): Bool
```

Function: Determines whether [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek) is empty.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if empty; otherwise, returns false.

### func iterator()

```cangjie
public func iterator(): Iterator<(K, V)>
```

Function: Returns an iterator for [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek), iterating in ascending order of Key values.

Return Value:

- [Iterator](../../core/core_package_api/core_package_classes.md#class-iteratort)\<(K, V)> - The iterator for [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

### func keys()

```cangjie
public func keys(): EquatableCollection<K>
```

Function: Returns all keys in [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek), storing them in a container.

Return Value:

- [EquatableCollection](collection_package_interface.md#interface-equatablecollectiont)\<K> - A collection containing all keys.

### func removeFirst()

```cangjie
public func removeFirst(): ?(K, V)
```

Function: Removes the first element of [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

Return Value:

- ?(K, V) - If the first element exists, removes it, encapsulates the element in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont), and returns it; otherwise, returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)>.None.

### func removeLast()

```cangjie
public func removeLast(): ?(K, V)
```

Function: Removes the last element of [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

Return Value:

- ?(K, V) - If the last element exists, removes it, encapsulates the element in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont), and returns it; otherwise, returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<(K, V)>.None.

### func remove(K)

```cangjie
public func remove(key: K): Option<V>
```

Function: Removes the mapping for the specified key from this map (if it exists).

Parameters:

- key: K - The key to be removed.

Return Value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<V> - The removed value is encapsulated in [Option](../../core/core_package_api/core_package_enums.md#enum-optiont). If the specified key does not exist in [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek), returns None.

### func remove(Collection\<K>)

```cangjie
public func remove(all!: Collection<K>): Unit
```

Function: Removes the mappings for the specified collection from this map (if they exist).

Parameters:

- all!: [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<K> - The collection of keys to be removed.

### func removeIf((K, V) -> Bool)

```cangjie
public func removeIf(predicate: (K, V) -> Bool): Unit
```

Function: Passes a lambda expression; if the condition is met, removes the corresponding key-value pair.

Parameters:

- predicate: (K, V) ->[Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - A lambda expression for evaluation.

Exceptions:

- [ConcurrentModificationException](./collection_package_exception.md#class-concurrentmodificationexception) - Thrown when `predicate` adds, deletes, or modifies key-value pairs within [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

### func values()

```cangjie
public func values(): Collection<V>
```

Function: Returns the values contained in [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek), storing all values in a container.

Return Value:

- [Collection](../../core/core_package_api/core_package_interfaces.md#interface-collectiont)\<V> - A collection containing all values.

### operator func \[](K, V)

```cangjie
public operator func [](key: K, value!: V): Unit
```

Function: Overloads the collection operator. If the key exists, the new value overwrites the old one; if the key does not exist, adds this key-value pair.

Parameters:

- key: K - The key for evaluation.
- value!: V - The value to be set.

### operator func \[](K)

```cangjie
public operator func [](key: K): V
```

Function: Overloads the collection operator. If the key exists, returns the corresponding value.

Parameters:

- key: K - The key for evaluation.

Return Value:

- V - The value corresponding to the key.

Exceptions:

- [NoneValueException](../../core/core_package_api/core_package_exceptions.md#class-nonevalueexception) - Thrown if the key does not exist in [HashMap](collection_package_class.md#class-hashmapk-v-where-k--hashable--equatablek).

### extend\<K, V> TreeMap\<K, V> <: Equatable\<TreeMap\<K, V>> where V <: Equatable\<V>

```cangjie
extend<K, V> TreeMap<K, V> <: Equatable<TreeMap<K, V>> where V <: Equatable<V>
```

Function: Extends the [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V>> interface for [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V>, supporting equality operations.

Parent Types:

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V>>

#### operator func ==(TreeMap\<K, V>)

```cangjie
public operator func ==(right: TreeMap<K, V>): Bool
```

Function: Determines whether the current instance is equal to the [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> instance pointed to by the parameter.

Two [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> instances are considered equal if they contain identical key-value pairs.

Parameters:

- right: [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> - The object to be compared.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if equal; otherwise, returns false.

#### operator func !=(TreeMap\<K, V>)

```cangjie
public operator func !=(right: TreeMap<K, V>): Bool
```

Function: Determines whether the current instance is not equal to the [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> instance pointed to by the parameter.

Parameters:

- right: [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> - The object to be compared.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if not equal; otherwise, returns false.

### extend\<K, V> TreeMap\<K, V> <: ToString where V <: ToString, K <: ToString & Comparable\<K>

```cangjie
extend<K, V> TreeMap<K, V> <: ToString where V <: ToString, K <: ToString & Comparable<K>
```

Function: Extends the [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface for [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V>, supporting string conversion operations.

Parent Types:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Function: Converts the current [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V> instance to a string.

The string includes the string representation of each key-value pair in [TreeMap](./collection_package_class.md#class-treemapk-v-where-k--comparablek)\<K, V>, formatted as: "[(k1, v1), (k2, v2), (k3, v3)]".

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The resulting string.

## class TreeSet\<T> where T <: Comparable\<T>

```cangjie
public class TreeSet<T> <: OrderedSet<T> where T <: Comparable<T> {
    public init()
    public init(elements: Collection<T>)
    public init(size: Int64, initElement: (Int64) -> T)
}
```

Function: An implementation of the [Set](collection_package_interface.md#interface-sett) interface based on [TreeMap](collection_package_class.md#class-treemapk-v-where-k--comparablek).

The primary purpose of this class is to provide an ordered element storage structure that supports fast insertion, deletion, and lookup of elements.

[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) can be used in any scenario requiring ordered element storage, such as databases, caches, lookup tables, etc.

Parent Types:

- [OrderedSet](collection_package_interface.md#interface-orderedsett)\<T>

### prop first

```cangjie
public prop first: ?T
```

Function: Retrieves the first element of [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet).public func subsetOf(set: ReadOnlySet<T>): Bool
```

Function: Determines whether this [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) is a subset of the specified [ReadOnlySet](collection_package_interface.md#interface-readonlysett).

Parameters:
- set: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The specified set to compare against.

Return Value:
- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if this [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) is a subset of the specified set; otherwise, returns `false`.

### func toArray()

```cangjie
public func toArray(): Array<T>
```

Function: Converts this [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) into an array.

Return Value:
- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - An array containing all elements of this [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet), sorted in ascending order.

### func toList()

```cangjie
public func toList(): List<T>
```

Function: Converts this [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) into a list.

Return Value:
- [List](collection_package_interface.md#interface-listt)\<T> - A list containing all elements of this [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet), sorted in ascending order.

### func toString()

```cangjie
public func toString(): String
```

Function: Returns a string representation of this [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet).

Return Value:
- [String](../../core/core_package_api/core_package_intrinsics.md#string) - A string representation of this set's elements in ascending order, enclosed in square brackets `[]`.

### func union(ReadOnlySet\<T>)

```cangjie
public func union(set: ReadOnlySet<T>): TreeSet<T>
```

Function: Returns a new [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) containing all distinct elements from both this set and the specified set.

Parameters:
- set: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The set to perform union with.

Return Value:
- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - A new set containing all elements from both sets.

### func intersection(ReadOnlySet\<T>)

```cangjie
public func intersection(set: ReadOnlySet<T>): TreeSet<T>
```

Function: Returns a new [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) containing only elements that exist in both this set and the specified set.

Parameters:
- set: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The set to perform intersection with.

Return Value:
- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - A new set containing only common elements.

### func difference(ReadOnlySet\<T>)

```cangjie
public func difference(set: ReadOnlySet<T>): TreeSet<T>
```

Function: Returns a new [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) containing elements that exist in this set but not in the specified set.

Parameters:
- set: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The set to compare against.

Return Value:
- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - A new set containing the difference elements.

### func symmetricDifference(ReadOnlySet\<T>)

```cangjie
public func symmetricDifference(set: ReadOnlySet<T>): TreeSet<T>
```

Function: Returns a new [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) containing elements that exist in either this set or the specified set, but not in both.

Parameters:
- set: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The set to perform symmetric difference with.

Return Value:
- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - A new set containing symmetric difference elements.
public func subsetOf(other: ReadOnlySet<T>): Bool
```

Function: Checks whether this set is a subset of another [ReadOnlySet](collection_package_interface.md#interface-readonlysett).

Parameters:

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The input set against which this function will determine if the current set is a subset.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if this [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet) is a subset of the specified [ReadOnlySet](collection_package_interface.md#interface-readonlysett); otherwise returns false.

### func toArray()

```cangjie
public func toArray(): Array<T>
```

Function: Returns an array containing all elements in the container.

Return Value:

- [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<T> - An array of type T.

### operator func &(ReadOnlySet\<T>)

```cangjie
public operator func &(other: ReadOnlySet<T>): TreeSet<T>
```

Function: Returns a new set containing the intersection of elements from both sets.

Parameters:

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The input set.

Return Value:

- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - A set of type T.

### operator func |(ReadOnlySet\<T>)

```cangjie
public operator func |(other: ReadOnlySet<T>): TreeSet<T>
```

Function: Returns a new set containing the union of elements from both sets.

Parameters:

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The input set.

Return Value:

- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - A set of type T.

### operator func -(ReadOnlySet\<T>)

```cangjie
public operator func -(other: ReadOnlySet<T>): TreeSet<T>
```

Function: Returns a new set containing the difference of elements between two sets.

Parameters:

- other: [ReadOnlySet](collection_package_interface.md#interface-readonlysett)\<T> - The input set.

Return Value:

- [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - A set of type T.

### extend\<T> TreeSet\<T> <: Equatable\<TreeSet\<T>>

```cangjie
extend<T> TreeSet<T> <: Equatable<TreeSet<T>>
```

Function: Extends the [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> type with the [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T>> interface, supporting equality operations.

Parent Type:

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T>>

#### operator func ==(TreeSet\<T>)

```cangjie
public operator func ==(that: TreeSet<T>): Bool
```

Function: Determines whether the current instance is equal to the parameter-specified [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> instance.

Two [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> instances are considered equal if they contain exactly the same elements.

Parameters:

- that: [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - The object to compare.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if equal; otherwise returns false.

#### operator func !=(TreeSet\<T>)

```cangjie
public operator func !=(that: TreeSet<T>): Bool
```

Function: Determines whether the current instance is not equal to the parameter-specified [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> instance.

Parameters:

- that: [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> - The object to compare.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns true if not equal; otherwise returns false.

### extend\<T> TreeSet\<T> <: ToString where T <: ToString

```cangjie
extend<T> TreeSet<T> <: ToString where T <: ToString
```

Function: Extends [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> with the [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring) interface, supporting string conversion operations.

Parent Type:

- [ToString](../../core/core_package_api/core_package_interfaces.md#interface-tostring)

#### func toString()

```cangjie
public func toString(): String
```

Function: Converts the current [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T> instance to a string.

The resulting string contains the string representation of each element in the [TreeSet](collection_package_class.md#class-treesett-where-t--comparablet)\<T>, formatted as: "[elem1, elem2, elem3]".

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted string.
```