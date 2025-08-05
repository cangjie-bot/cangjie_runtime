# Classes

## class AtomicBool

```cangjie
public class AtomicBool {
    public init(val: Bool)
}
```

Function: Provides atomic operation functions for the [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) type.

### init(Bool)

```cangjie
public init(val: Bool)
```

Function: Constructs an instance of atomic type [AtomicBool](sync_package_classes.md#class-atomicbool) encapsulating a [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) data type, with its internal data initialized to the value of parameter `val`.

Parameters:

- val: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The initial value of the atomic type.

### func compareAndSwap(Bool, Bool)

```cangjie
public func compareAndSwap(old: Bool, new: Bool): Bool
```

Function: CAS (Compare and Swap) operation using the [default memory ordering](sync_package_constants_vars.md#let-defaultmemoryorder-deprecated).

Compares the current atomic value with the value specified by parameter `old`. If equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write and returns `false`.

Parameters:

- old: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The value to compare with the current atomic type.
- new: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The value to write to the atomic type if the comparison is equal.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the compare-and-swap succeeds, otherwise `false`.

### func compareAndSwap(Bool, Bool, MemoryOrder, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func compareAndSwap(old: Bool, new: Bool, successOrder!: MemoryOrder, failureOrder!: MemoryOrder): Bool
```

Function: CAS operation using `successOrder` memory ordering on success and `failureOrder` memory ordering on failure.

Compares the current atomic value with the value specified by parameter `old`. If equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write and returns `false`.

> **Note:**
>
> Will be deprecated in future versions. Use [compareAndSwap(Bool, Bool)](#func-compareandswapbool-bool) instead.

Parameters:

- old: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The value to compare with the current atomic type.
- new: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The value to write to the atomic type if the comparison is equal.
- successOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the "read-modify-write" operation on CAS success.
- failureOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the "read" operation on CAS failure.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the compare-and-swap succeeds, otherwise `false`.

### func load()

```cangjie
public func load(): Bool
```

Function: Read operation using default memory ordering to read the atomic value.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): Bool
```

Function: Read operation using the memory ordering specified by parameter `memoryOrder` to read the atomic value.

> **Note:**
>
> Will be deprecated in future versions. Use [load()](#func-load) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the current operation.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The current value of the atomic type.

### func store(Bool)

```cangjie
public func store(val: Bool): Unit
```

Function: Write operation using default memory ordering to write the value specified by parameter `val` to the atomic type.

Parameters:

- val: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The value to write to the atomic type.

### func store(Bool, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: Bool, memoryOrder!: MemoryOrder): Unit
```

Function: Write operation using the memory ordering specified by parameter `memoryOrder` to write the value specified by parameter `val` to the atomic type.

> **Note:**
>
> Will be deprecated in future versions. Use [store(Bool)](#func-storebool) instead.

Parameters:

- val: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the current operation.

### func swap(Bool)

```cangjie
public func swap(val: Bool): Bool
```

Function: Swap operation using default memory ordering to write the value specified by parameter `val` to the atomic type and return the previous value.

Parameters:

- val: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The value to write to the atomic type.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - The value before writing.

### func swap(Bool, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: Bool, memoryOrder!: MemoryOrder): Bool
```memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the current operation.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the operation.

### func fetchOr(Int16)

```cangjie
public func fetchOr(val: Int16): Int16
```

Function: Bitwise OR operation using default memory ordering. Performs OR operation between the current atomic value and the value specified by parameter `val`, writes the result to the current atomic instance, and returns the value before the operation.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to perform OR operation with the atomic type.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the operation.

### func fetchOr(Int16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchOr(val: Int16, memoryOrder!: MemoryOrder): Int16
```

Function: Bitwise OR operation using the memory ordering specified by parameter `memoryOrder`. Performs OR operation between the current atomic value and the value specified by parameter `val`, writes the result to the current atomic instance, and returns the value before the operation.

> **Note:**
>
> Will be deprecated in future versions. Use [fetchOr(Int16)](#func-fetchorint16) instead.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to perform OR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the current operation.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the operation.

### func fetchXor(Int16)

```cangjie
public func fetchXor(val: Int16): Int16
```

Function: Bitwise XOR operation using default memory ordering. Performs XOR operation between the current atomic value and the value specified by parameter `val`, writes the result to the current atomic instance, and returns the value before the operation.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to perform XOR operation with the atomic type.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the operation.

### func fetchXor(Int16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchXor(val: Int16, memoryOrder!: MemoryOrder): Int16
```

Function: Bitwise XOR operation using the memory ordering specified by parameter `memoryOrder`. Performs XOR operation between the current atomic value and the value specified by parameter `val`, writes the result to the current atomic instance, and returns the value before the operation.

> **Note:**
>
> Will be deprecated in future versions. Use [fetchXor(Int16)](#func-fetchxorint16) instead.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to perform XOR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the current operation.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the operation.

### func load()

```cangjie
public func load(): Int16
```

Function: Load operation using default memory ordering. Returns the current value of the atomic type.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): Int16
```

Function: Load operation using the memory ordering specified by parameter `memoryOrder`. Returns the current value of the atomic type.

> **Note:**
>
> Will be deprecated in future versions. Use [load()](#func-load) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the current operation.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The current value of the atomic type.

### func store(Int16)

```cangjie
public func store(val: Int16)
```

Function: Store operation using default memory ordering. Writes the value specified by parameter `val` to the atomic type.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to write to the atomic type.

### func store(Int16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: Int16, memoryOrder!: MemoryOrder)
```

Function: Store operation using the memory ordering specified by parameter `memoryOrder`. Writes the value specified by parameter `val` to the atomic type.

> **Note:**
>
> Will be deprecated in future versions. Use [store(Int16)](#func-storeint16) instead.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the current operation.

### func swap(Int16)

```cangjie
public func swap(val: Int16): Int16
```

Function: Swap operation using default memory ordering. Writes the value specified by parameter `val` to the atomic type and returns the previous value.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to write to the atomic type.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before writing.

### func swap(Int16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: Int16, memoryOrder!: MemoryOrder): Int16
```

Function: Swap operation using the memory ordering specified by parameter `memoryOrder`. Writes the value specified by parameter `val` to the atomic type and returns the previous value.

> **Note:**
>
> Will be deprecated in future versions. Use [swap(Int16)](#func-swapint16) instead.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for the current operation.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before writing.Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The current value of the atomic type.

### func store(Int16)

```cangjie
public func store(val: Int16): void
```

Function: Write operation using default memory ordering to set the atomic type's value to `val`.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to be stored in the atomic type.

### func store(Int16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: Int16, memoryOrder!: MemoryOrder): void
```

Function: Write operation using the memory ordering specified by `memoryOrder` to set the atomic type's value to `val`.

> **Note:**
>
> Will be deprecated in future versions. Use [store(Int16)](#func-storeint16) instead.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to be stored in the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.

### func swap(Int16)

```cangjie
public func swap(val: Int16): Int16
```

Function: Exchange operation using default memory ordering to replace the atomic type's value with `val` and return the previous value.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The new value to be stored in the atomic type.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the exchange operation.

### func swap(Int16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: Int16, memoryOrder!: MemoryOrder): Int16
```

Function: Exchange operation using the memory ordering specified by `memoryOrder` to replace the atomic type's value with `val` and return the previous value.

> **Note:**
>
> Will be deprecated in future versions. Use [swap(Int16)](#func-swapint16) instead.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The new value to be stored in the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the exchange operation.- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The current value of the atomic type.

### func store(Int16)

```cangjie
public func store(val: Int16): Unit
```

Function: Performs a write operation using default memory ordering to store the value specified by parameter `val` into the atomic type.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to be written to the atomic type.

### func store(Int16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: Int16, memoryOrder!: MemoryOrder): Unit
```

Function: Performs a write operation using the specified `memoryOrder` to store the value specified by parameter `val` into the atomic type.

> **Note:**
>
> This will be deprecated in future versions. Use [store(Int16)](#func-storeint16) instead.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to be written to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.

### func swap(Int16)

```cangjie
public func swap(val: Int16): Int16
```

Function: Performs an atomic swap operation using default memory ordering to store the value specified by parameter `val` into the atomic type and returns the previous value.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to be written to the atomic type.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the swap operation.

### func swap(Int16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: Int16, memoryOrder!: MemoryOrder): Int16
```

Function: Performs an atomic swap operation using the specified `memoryOrder` to store the value specified by parameter `val` into the atomic type and returns the previous value.

> **Note:**
>
> This will be deprecated in future versions. Use [swap(Int16)](#func-swapint16) instead.

Parameters:

- val: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value to be written to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.

Return value:

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - The value before the swap operation.

## class AtomicInt32

```cangjie
public class AtomicInt32 {
    public init(val: Int32)
}
```

Function: Provides atomic operation capabilities for the [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) data type.

### init(Int32)

```cangjie
public init(val: Int32)
```

Function: Constructs an [AtomicInt32](sync_package_classes.md#class-atomicint32) instance encapsulating an [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) value, initializing its internal data with the value specified by parameter `val`.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - Initial value for the atomic type.

### func compareAndSwap(Int32, Int32)

```cangjie
public func compareAndSwap(old: Int32, new: Int32): Bool
```

Function: Performs a Compare-And-Swap (CAS) operation using default memory ordering.

Compares the atomic type's current value with parameter `old`. If equal, stores parameter `new` and returns `true`; otherwise, does not modify and returns `false`.

Parameters:

- old: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - Value to compare against the atomic type's current value.
- new: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - Value to store if the comparison succeeds.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the CAS operation succeeds, otherwise `false`.

### func compareAndSwap(Int32, Int32, MemoryOrder, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func compareAndSwap(old: Int32, new: Int32, successOrder!: MemoryOrder, failureOrder!: MemoryOrder): Bool
```

Function: Performs a CAS operation using `successOrder` for successful cases and `failureOrder` for failed cases.

Compares the atomic type's current value with parameter `old`. If equal, stores parameter `new` and returns `true`; otherwise, does not modify and returns `false`.

> **Note:**
>
> This will be deprecated in future versions. Use [compareAndSwap(Int32, Int32)](#func-compareandswapint32-int32) instead.

Parameters:

- old: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - Value to compare against the atomic type's current value.
- new: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - Value to store if the comparison succeeds.
- successOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for successful "read-modify-write" operations.
- failureOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering for failed "read" operations.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the CAS operation succeeds, otherwise `false`.

### func fetchAdd(Int32)

```cangjie
public func fetchAdd(val: Int32): Int32
```

Function: Performs an atomic addition operation between the atomic type's value and parameter `val` using default memory ordering. Stores the result and returns the value before addition.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - Value to be added to the atomic type.

Return value:Here's the professional translation of the provided Markdown content from Chinese to English, maintaining all structural elements and technical accuracy:

```markdown
- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before performing the addition.

### func fetchAdd(Int32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchAdd(val: Int32, memoryOrder!: MemoryOrder): Int32
```

Function: Atomically adds the specified value `val` to the atomic variable using the given memory ordering. Stores the result and returns the previous value.

> **Note:**
>
> This API will be deprecated in future releases. Use [fetchAdd(Int32)](#func-fetchaddint32) instead.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to add to the atomic variable.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering constraints for the operation.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value prior to the addition.

### func fetchAnd(Int32)

```cangjie
public func fetchAnd(val: Int32): Int32
```

Function: Atomically performs bitwise AND between the atomic variable and `val` using default memory ordering. Stores the result and returns the previous value.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to AND with the atomic variable.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the operation.

### func fetchAnd(Int32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchAnd(val: Int32, memoryOrder!: MemoryOrder): Int32
```

Function: Atomically performs bitwise AND between the atomic variable and `val` using specified memory ordering. Stores the result and returns the previous value.

> **Note:**
>
> This API will be deprecated in future releases. Use [fetchAnd(Int32)](#func-fetchandint32) instead.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to AND with the atomic variable.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering constraints for the operation.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the operation.

### func fetchOr(Int32)

```cangjie
public func fetchOr(val: Int32): Int32
```

Function: Atomically performs bitwise OR between the atomic variable and `val` using default memory ordering. Stores the result and returns the previous value.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to OR with the atomic variable.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the operation.

### func fetchOr(Int32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchOr(val: Int32, memoryOrder!: MemoryOrder): Int32
```

Function: Atomically performs bitwise OR between the atomic variable and `val` using specified memory ordering. Stores the result and returns the previous value.

> **Note:**
>
> This API will be deprecated in future releases. Use [fetchOr(Int32)](#func-fetchorint32) instead.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to OR with the atomic variable.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering constraints for the operation.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the operation.

### func fetchSub(Int32)

```cangjie
public func fetchSub(val: Int32): Int32
```

Function: Atomically subtracts `val` from the atomic variable using default memory ordering. Stores the result and returns the previous value.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to subtract from the atomic variable.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the operation.

### func fetchSub(Int32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchSub(val: Int32, memoryOrder!: MemoryOrder): Int32
```

Function: Atomically subtracts `val` from the atomic variable using specified memory ordering. Stores the result and returns the previous value.

> **Note:**
>
> This API will be deprecated in future releases. Use [fetchSub(Int32)](#func-fetchsubint32) instead.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to subtract from the atomic variable.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering constraints for the operation.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the operation.

### func fetchXor(Int32)

```cangjie
public func fetchXor(val: Int32): Int32
```

Function: Atomically performs bitwise XOR between the atomic variable and `val` using default memory ordering. Stores the result and returns the previous value.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to XOR with the atomic variable.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the operation.
```### func fetchXor(Int32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchXor(val: Int32, memoryOrder!: MemoryOrder): Int32
```

Function: Performs an atomic XOR operation on the current atomic type instance with the value specified by parameter `val`, using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the XOR operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchXor(Int32)](#func-fetchxorint32) instead.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to perform the XOR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the XOR operation.

### func load()

```cangjie
public func load(): Int32
```

Function: Performs a read operation, using the default memory ordering, to read the value of the atomic type.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): Int32
```

Function: Performs a read operation, using the memory ordering specified by parameter `memoryOrder`, to read the value of the atomic type.

> **Note:**
>
> This will be deprecated in future versions. Use [load()](#func-load-2) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The current value of the atomic type.

### func store(Int32)

```cangjie
public func store(val: Int32): Unit
```

Function: Performs a write operation, using the default memory ordering, to write the value specified by parameter `val` to the atomic type.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to be written to the atomic type.

### func store(Int32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: Int32, memoryOrder!: MemoryOrder): Unit
```

Function: Performs a write operation, using the memory ordering specified by parameter `memoryOrder`, to write the value specified by parameter `val` to the atomic type.

> **Note:**
>
> This will be deprecated in future versions. Use [store(Int32)](#func-storeint32) instead.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to be written to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

### func swap(Int32)

```cangjie
public func swap(val: Int32): Int32
```

Function: Performs an atomic swap operation, using the default memory ordering, to write the value specified by parameter `val` to the atomic type and returns the value before the write.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to be written to the atomic type.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the write.

### func swap(Int32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: Int32, memoryOrder!: MemoryOrder): Int32
```

Function: Performs an atomic swap operation, using the memory ordering specified by parameter `memoryOrder`, to write the value specified by parameter `val` to the atomic type and returns the value before the write.

> **Note:**
>
> This will be deprecated in future versions. Use [swap(Int32)](#func-swapint32) instead.

Parameters:

- val: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value to be written to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return value:

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - The value before the write.

## class AtomicInt64

```cangjie
public class AtomicInt64 {
    public init(val: Int64)
}
```

Function: Provides atomic operation functions for the [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) type.

### init(Int64)

```cangjie
public init(val: Int64)
```

Function: Constructs an instance of the atomic type [AtomicInt64](sync_package_classes.md#class-atomicint64) encapsulating a [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) data type, with its internal data initialized to the value specified by parameter `val`.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The initial value of the atomic type.

### func compareAndSwap(Int64, Int64)

```cangjie
public func compareAndSwap(old: Int64, new: Int64): Bool
```

Function: Performs a CAS (Compare-And-Swap) operation using the default memory ordering.```markdown
### func compareAndSwap(Int64, Int64) 

```cangjie
public func compareAndSwap(old: Int64, new: Int64): Bool
```

Function: Performs a CAS (Compare-And-Swap) operation using default memory ordering.

Compares the current value of the atomic type with the value specified by parameter `old`. If they are equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write the value and returns `false`.

Parameters:

- old: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to compare with the current atomic type.
- new: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to write to the atomic type if the comparison is successful.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the compare-and-swap operation succeeds, otherwise returns `false`.

### func compareAndSwap(Int64, Int64, MemoryOrder, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func compareAndSwap(old: Int64, new: Int64, successOrder!: MemoryOrder, failureOrder!: MemoryOrder): Bool
```

Function: Performs a CAS (Compare-And-Swap) operation. Uses the memory ordering specified by `successOrder` on success and `failureOrder` on failure.

Compares the current value of the atomic type with the value specified by parameter `old`. If equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write the value and returns `false`.

> **Note:**
>
> This will be deprecated in future versions. Use [compareAndSwap(Int64, Int64)](#func-compareandswapint64-int64) instead.

Parameters:

- old: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to compare with the current atomic type.
- new: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to write to the atomic type if the comparison succeeds.
- successOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the "read-modify-write" operation upon successful CAS.
- failureOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the "read" operation upon failed CAS.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the compare-and-swap operation succeeds, otherwise returns `false`.

### func fetchAdd(Int64)

```cangjie
public func fetchAdd(val: Int64): Int64
```

Function: Performs an addition operation between the atomic type's value and parameter `val` using default memory ordering. Writes the result to the current atomic type instance and returns the value before the addition.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to add to the atomic type.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the addition operation.

### func fetchAdd(Int64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchAdd(val: Int64, memoryOrder!: MemoryOrder): Int64
```

Function: Performs an addition operation between the atomic type's value and parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the addition.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchAdd(Int64)](#func-fetchaddint64) instead.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to add to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the addition operation.

### func fetchAnd(Int64)

```cangjie
public func fetchAnd(val: Int64): Int64
```

Function: Performs a bitwise AND operation between the current atomic type instance's value and parameter `val` using default memory ordering. Writes the result to the current atomic type instance and returns the value before the operation.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to perform bitwise AND with the atomic type.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the AND operation.

### func fetchAnd(Int64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchAnd(val: Int64, memoryOrder!: MemoryOrder): Int64
```

Function: Performs a bitwise AND operation between the current atomic type instance's value and parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchAnd(Int64)](#func-fetchandint64) instead.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to perform bitwise AND with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the AND operation.

### func fetchOr(Int64)

```cangjie
public func fetchOr(val: Int64): Int64
```

Function: Performs a bitwise OR operation between the current atomic type instance's value and parameter `val` using default memory ordering. Writes the result to the current atomic type instance and returns the value before the operation.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to perform bitwise OR with the atomic type.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the OR operation.

### func fetchOr(Int64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchOr(val: Int64, memoryOrder!: MemoryOrder): Int64
```

Function: Performs a bitwise OR operation between the current atomic type instance's value and parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchOr(Int64)](#func-fetchorint64) instead.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to perform bitwise OR with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the OR operation.
``````markdown
### func fetchSub(Int64)

```cangjie
public func fetchSub(val: Int64): Int64
```

Function: Performs a subtraction operation between the atomic type's value (as minuend) and parameter `val` (as subtrahend) using default memory ordering. Writes the result to the current atomic type instance and returns the value before the operation.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to subtract from the atomic type.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the subtraction operation.

### func fetchSub(Int64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchSub(val: Int64, memoryOrder!: MemoryOrder): Int64
```

Function: Performs a subtraction operation between the atomic type's value (as minuend) and parameter `val` (as subtrahend) using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchSub(Int64)](#func-fetchsubint64) instead.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to subtract from the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the subtraction operation.

### func fetchXor(Int64)

```cangjie
public func fetchXor(val: Int64): Int64
```

Function: Performs a bitwise XOR operation between the current atomic type instance's value and parameter `val` using default memory ordering. Writes the result to the current atomic type instance and returns the value before the operation.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to perform bitwise XOR with the atomic type.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the XOR operation.

### func fetchXor(Int64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchXor(val: Int64, memoryOrder!: MemoryOrder): Int64
```

Function: Performs a bitwise XOR operation between the current atomic type instance's value and parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchXor(Int64)](#func-fetchxorint64) instead.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to perform bitwise XOR with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the XOR operation.

### func load()

```cangjie
public func load(): Int64
```

Function: Performs a read operation on the atomic type's value using default memory ordering.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): Int64
```

Function: Performs a read operation on the atomic type's value using the memory ordering specified by `memoryOrder`.

> **Note:**
>
> This will be deprecated in future versions. Use [load()](#func-load) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The current value of the atomic type.

### func store(Int64)

```cangjie
public func store(val: Int64): Unit
```

Function: Performs a write operation, storing the value specified by parameter `val` into the atomic type using default memory ordering.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to write to the atomic type.

### func store(Int64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: Int64, memoryOrder!: MemoryOrder): Unit
```

Function: Performs a write operation, storing the value specified by parameter `val` into the atomic type using the memory ordering specified by `memoryOrder`.

> **Note:**
>
> This will be deprecated in future versions. Use [store(Int64)](#func-storeint64) instead.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

### func swap(Int64)

```cangjie
public func swap(val: Int64): Int64
```

Function: Performs a swap operation, storing the value specified by parameter `val` into the atomic type using default memory ordering, and returns the value before the write.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to write to the atomic type.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the write operation.
```### func swap(Int64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: Int64, memoryOrder!: MemoryOrder): Int64
```

Function: Performs a swap operation, storing the value specified by parameter `val` into the atomic type using the memory ordering specified by `memoryOrder`, and returns the value before the write.

> **Note:**
>
> This will be deprecated in future versions. Use [swap(Int64)](#func-swapint64) instead.

Parameters:

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before the write operation.

> **Note:**  
>  
> This feature will be deprecated in future versions. Use [swap(Int64)](#func-swapint64) instead.

Parameters:  

- val: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to be written to the atomic type.  
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering mode for the current operation.  

Return Value:  

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value before writing.  

Example:  

<!-- verify -->  
```cangjie  
import std.sync.*  

let count = AtomicInt64(1)  

main(): Int64 {  
    var val1 = 0  
    if (count.compareAndSwap(1, 2)) {  
        val1 = count.load()  
        println("count1 = ${val1}")  
    }  

    if (count.fetchAdd(2) == val1) {  
        var val2 = count.load()  
        println("count2 = ${val2}")  
    }  

    count.store(6)  
    var val3 = count.load()  
    println("count3 = ${val3}")  

    if (count.swap(8) == val3) {  
        var val4 = count.load()  
        println("count4 = ${val4}")  
    }  

    return 0  
}  
```  

Execution Result:  

```text  
count1 = 2  
count2 = 4  
count3 = 6  
count4 = 8  
```  

## class AtomicInt8  

```cangjie  
public class AtomicInt8 {  
    public init(val: Int8)  
}  
```  

Functionality: Provides atomic operation-related functions for the [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) data type.  

### init(Int8)  

```cangjie  
public init(val: Int8)  
```  

Functionality: Constructs an instance of the atomic type [AtomicInt8](sync_package_classes.md#class-atomicint8) encapsulating an [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) data type, with its internal data initialized to the value of parameter `val`.  

Parameters:  

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The initial value for the atomic type.  

### func compareAndSwap(Int8, Int8)  

```cangjie  
public func compareAndSwap(old: Int8, new: Int8): Bool  
```  

Functionality: Performs a CAS (Compare-And-Swap) operation using the default memory ordering.  

Compares the current value of the atomic type with the value specified by parameter `old`. If they are equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write the value and returns `false`.  

Parameters:  

- old: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to compare with the current atomic type.  
- new: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to write to the atomic type if the comparison succeeds.  

Return Value:  

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the compare-and-swap succeeds, otherwise returns `false`.  

### func compareAndSwap(Int8, Int8, MemoryOrder, MemoryOrder) <sup>(deprecated)</sup>  

```cangjie  
public func compareAndSwap(old: Int8, new: Int8, successOrder!: MemoryOrder, failureOrder!: MemoryOrder): Bool  
```  

Functionality: Performs a CAS operation using the memory ordering specified by `successOrder` on success and `failureOrder` on failure.  

Compares the current value of the atomic type with the value specified by parameter `old`. If they are equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write the value and returns `false`.  

> **Note:**  
>  
> This feature will be deprecated in future versions. Use [compareAndSwap(Int8, Int8)](#func-compareandswapint8-int8) instead.  

Parameters:  

- old: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to compare with the current atomic type.  
- new: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to write to the atomic type if the comparison succeeds.  
- successOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering mode for the "read-modify-write" operation upon successful CAS.  
- failureOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering mode for the "read" operation upon failed CAS.  

Return Value:  

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the compare-and-swap succeeds, otherwise returns `false`.  

### func fetchAdd(Int8)  

```cangjie  
public func fetchAdd(val: Int8): Int8  
```  

Functionality: Performs an addition operation between the atomic type's value and parameter `val` using the default memory ordering, writes the result to the current atomic type instance, and returns the value before the addition.  

Parameters:Here is the professional English translation of the provided Markdown content, maintaining all original structure and formatting:

```markdown
- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to add to the atomic type.

Return Value:

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the addition operation.

### func fetchAdd(Int8, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchAdd(val: Int8, memoryOrder!: MemoryOrder): Int8
```

Functionality: Performs an addition operation between the atomic type's value and parameter `val` using the memory ordering specified by `memoryOrder`, writes the result to the current atomic type instance, and returns the value before the addition.

> **Note:**
> 
> This feature will be deprecated in future versions. Use [fetchAdd(Int8)](#func-fetchaddint8) instead.

Parameters:

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to add to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering mode for the current operation.

Return Value:

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the addition operation.

### func fetchAnd(Int8)

```cangjie
public func fetchAnd(val: Int8): Int8
```

Functionality: Performs a bitwise AND operation between the current atomic type instance's value and parameter `val` using the default memory ordering, writes the result to the current atomic type instance, and returns the value before the operation.

Parameters:

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to perform the AND operation with the atomic type.

Return Value:

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the AND operation.

### func fetchAnd(Int8, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchAnd(val: Int8, memoryOrder!: MemoryOrder): Int8
```

Functionality: Performs a bitwise AND operation between the current atomic type instance's value and parameter `val` using the memory ordering specified by `memoryOrder`, writes the result to the current atomic type instance, and returns the value before the operation.

> **Note:**
> 
> This feature will be deprecated in future versions. Use [fetchAnd(Int8)](#func-fetchandint8) instead.

Parameters:

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to perform the AND operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering mode for the current operation.

Return Value:

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the AND operation.

### func fetchOr(Int8)

```cangjie
public func fetchOr(val: Int8): Int8
```

Functionality: Performs a bitwise OR operation between the current atomic type instance's value and parameter `val` using the default memory ordering, writes the result to the current atomic type instance, and returns the value before the operation.

Parameters:

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to perform the OR operation with the atomic type.

Return Value:

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the OR operation.

### func fetchOr(Int8, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchOr(val: Int8, memoryOrder!: MemoryOrder): Int8
```

Functionality: Performs a bitwise OR operation between the current atomic type instance's value and parameter `val` using the memory ordering specified by `memoryOrder`, writes the result to the current atomic type instance, and returns the value before the operation.

> **Note:**
> 
> This feature will be deprecated in future versions. Use [fetchOr(Int8)](#func-fetchorint8) instead.

Parameters:

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to perform the OR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering mode for the current operation.

Return Value:

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the OR operation.

### func fetchSub(Int8)

```cangjie
public func fetchSub(val: Int8): Int8
```

Functionality: Performs a subtraction operation using the atomic type's value as the minuend and parameter `val` as the subtrahend, with default memory ordering, writes the result to the current atomic type instance, and returns the value before the operation.

Parameters:

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to subtract from the atomic type.

Return Value:

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the subtraction operation.

### func fetchSub(Int8, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchSub(val: Int8, memoryOrder!: MemoryOrder): Int8
```

Functionality: Performs a subtraction operation using the atomic type's value as the minuend and parameter `val` as the subtrahend, with memory ordering specified by `memoryOrder`, writes the result to the current atomic type instance, and returns the value before the operation.

> **Note:**
> 
> This feature will be deprecated in future versions. Use [fetchSub(Int8)](#func-fetchsubint8) instead.

Parameters:

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to subtract from the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering mode for the current operation.

Return Value:

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the subtraction operation.

### func fetchXor(Int8)

```cangjie
public func fetchXor(val: Int8): Int8
```

Functionality: Performs a bitwise XOR operation between the current atomic type instance's value and parameter `val` using the default memory ordering, writes the result to the current atomic type instance, and returns the value before the operation.

Parameters:

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to perform the XOR operation with the atomic type.
``````markdown
Return Value:  

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the XOR operation.  

### func fetchXor(Int8, MemoryOrder) <sup>(deprecated)</sup>  

```cangjie  
public func fetchXor(val: Int8, memoryOrder!: MemoryOrder): Int8  
```  

Functionality: Performs a bitwise XOR operation between the current atomic type instance's value and parameter `val` using the memory ordering specified by `memoryOrder`, writes the result to the current atomic type instance, and returns the value before the operation.  

> **Note:**  
>  
> This feature will be deprecated in future versions. Use [fetchXor(Int8)](#func-fetchxorint8) instead.  

Parameters:  

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value to perform the XOR operation with the atomic type.  
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering mode for the current operation.  

Return Value:  

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - The value before the XOR operation.  

### func load()  

```cangjie  
public func load(): Int8  
```  

Function: Reads the atomic type's value using default memory ordering.  

Return Value:  

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - Current value of the atomic type.  

### func load(MemoryOrder) <sup>(deprecated)</sup>  

```cangjie  
public func load(memoryOrder!: MemoryOrder): Int8  
```  

Function: Reads the atomic type's value using specified memory ordering.  

> **Note:**  
>  
> Will be deprecated in future versions. Use [load()](#func-load) instead.  

Parameters:  

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the operation.  

Return Value:  

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - Current value of the atomic type.  

### func store(Int8)  

```cangjie  
public func store(val: Int8): Unit  
```  

Function: Writes to the atomic type using default memory ordering.  

Parameters:  

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - Value to be written.  

### func store(Int8, MemoryOrder) <sup>(deprecated)</sup>  

```cangjie  
public func store(val: Int8, memoryOrder!: MemoryOrder): Unit  
```  

Function: Writes to the atomic type using specified memory ordering.  

> **Note:**  
>  
> Will be deprecated in future versions. Use [store(Int8)](#func-storeint8) instead.  

Parameters:  

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - Value to be written.  
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode.  

### func swap(Int8)  

```cangjie  
public func swap(val: Int8): Int8  
```  

Function: Atomically swaps the value using default memory ordering.  

Parameters:  

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - New value to store.  

Return Value:  

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - Previous value.  

### func swap(Int8, MemoryOrder) <sup>(deprecated)</sup>  

```cangjie  
public func swap(val: Int8, memoryOrder!: MemoryOrder): Int8  
```  

Function: Atomically swaps the value using specified memory ordering.  

> **Note:**  
>  
> Will be deprecated in future versions. Use [swap(Int8)](#func-swapint8) instead.  

Parameters:  

- val: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - New value to store.  
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode.  

Return Value:  

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - Previous value.  

## class AtomicOptionReference\<T> where T <: Object  

```cangjie  
public class AtomicOptionReference<T> where T <: Object {  
    public init()  
    public init(val: Option<T>)  
}  
```  

Function: Provides atomic operations for reference types.  

The reference type must inherit from [Object](../../core/core_package_api/core_package_classes.md#class-object).  

### init()  

```cangjie  
public init()  
```  

Function: Constructs an empty [AtomicOptionReference](sync_package_classes.md#class-atomicoptionreferencet-where-t--object) instance.  

### init(Option\<T>)  
```cangjie  
public init(val: Option<T>)  
```  
```- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Value before writing.

```cangjie
public init(val: Option<T>)
```

Function: Constructs an atomic type [AtomicOptionReference](sync_package_classes.md#class-atomicoptionreferencet-where-t--object) instance encapsulating the [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> data type, with its internal data initialized to the value of parameter `val`.

Parameters:

- val: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Initial value of the atomic type.

### func compareAndSwap(Option\<T>, Option\<T>)

```cangjie
public func compareAndSwap(old: Option<T>, new: Option<T>): Bool
```

Function: Performs a CAS (Compare-And-Swap) operation using default memory ordering.

Compares the current value of the atomic type with the value specified by parameter `old`. If equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write and returns `false`.

Parameters:

- old: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Expected value to compare with the current atomic type value.
- new: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - New value to be written if comparison succeeds.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the swap operation succeeds, otherwise `false`.

### func compareAndSwap(Option\<T>, Option\<T>, MemoryOrder, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func compareAndSwap(old: Option<T>, new: Option<T>, successOrder!: MemoryOrder, failureOrder!: MemoryOrder): Bool
```

Function: Performs a CAS operation using `successOrder` memory ordering on success and `failureOrder` on failure.

Compares the current value of the atomic type with the value specified by parameter `old`. If equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write and returns `false`.

> **Note:**
>
> This method will be deprecated in future versions. Use [compareAndSwap(Option\<T>, Option\<T>)](#func-compareandswapoptiont-optiont) instead.

Parameters:

- old: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Expected value to compare with the current atomic type value.
- new: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - New value to be written if comparison succeeds.
- successOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for successful CAS operations (read-modify-write).
- failureOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for failed CAS operations (read).

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the swap operation succeeds, otherwise `false`.

### func load()

```cangjie
public func load(): Option<T>
```

Function: Performs a read operation using default memory ordering, retrieving the current value of the atomic type.

Return value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): Option<T>
```

Function: Performs a read operation using the specified memory ordering, retrieving the current value of the atomic type.

> **Note:**
>
> This method will be deprecated in future versions. Use [load()](#func-load-5) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the read operation.

Return value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Current value of the atomic type.

### func store(Option\<T>)

```cangjie
public func store(val: Option<T>): Unit
```

Function: Performs a write operation using default memory ordering, setting the atomic type's value to the specified parameter `val`.

Parameters:

- val: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Value to be written to the atomic type.

### func store(Option\<T>, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: Option<T>, memoryOrder!: MemoryOrder): Unit
```

Function: Performs a write operation using the specified memory ordering, setting the atomic type's value to the specified parameter `val`.

> **Note:**
>
> This method will be deprecated in future versions. Use [store(Option\<T>)](#func-storeoptiont) instead.

Parameters:

- val: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Value to be written to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the write operation.

### func swap(Option\<T>)

```cangjie
public func swap(val: Option<T>): Option<T>
```

Function: Performs an atomic swap operation using default memory ordering, replacing the current value with `val` and returning the previous value.

Parameters:

- val: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - New value to be written to the atomic type.

Return value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Previous value before the swap operation.

### func swap(Option\<T>, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: Option<T>, memoryOrder!: MemoryOrder): Option<T>
```

Function: Performs an atomic swap operation using the specified memory ordering, replacing the current value with `val` and returning the previous value.

> **Note:**
>
> This method will be deprecated in future versions. Use [swap(Option\<T>)](#func-swapoptiont) instead.

Parameters:

- val: [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - New value to be written to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the swap operation.

Return value:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<T> - Previous value before the swap operation.public func swap(val: T, memoryOrder!: MemoryOrder): T
```

Function: Swap operation using the specified `memoryOrder` to write the value specified by `val` to the atomic type and return the previous value.

> **Note:**
>
> This will be deprecated in future versions. Use [swap(T)](#func-swapt) instead.

Parameters:

- val: T - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the current operation.

Return Value:

- T - The previous value before writing.- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform AND with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the current operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the AND operation.

### func fetchOr(UInt16)

```cangjie
public func fetchOr(val: UInt16): UInt16
```

Function: Bitwise OR operation using the default memory ordering. Performs OR with `val` on the atomic type, writes the result, and returns the value before the operation.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform OR with the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the OR operation.

### func fetchOr(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchOr(val: UInt16, memoryOrder!: MemoryOrder): UInt16
```

Function: Bitwise OR operation using the specified `memoryOrder`. Performs OR with `val` on the atomic type, writes the result, and returns the value before the operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchOr(UInt16)](#func-fetchoruint16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform OR with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the current operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the OR operation.

### func fetchXor(UInt16)

```cangjie
public func fetchXor(val: UInt16): UInt16
```

Function: Bitwise XOR operation using the default memory ordering. Performs XOR with `val` on the atomic type, writes the result, and returns the value before the operation.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform XOR with the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the XOR operation.

### func fetchXor(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchXor(val: UInt16, memoryOrder!: MemoryOrder): UInt16
```

Function: Bitwise XOR operation using the specified `memoryOrder`. Performs XOR with `val` on the atomic type, writes the result, and returns the value before the operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchXor(UInt16)](#func-fetchxoruint16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform XOR with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the current operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the XOR operation.

### func load()

```cangjie
public func load(): UInt16
```

Function: Load operation using the default memory ordering. Returns the current value of the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): UInt16
```

Function: Load operation using the specified `memoryOrder`. Returns the current value of the atomic type.

> **Note:**
>
> This will be deprecated in future versions. Use [load()](#func-load) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the current operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The current value of the atomic type.

### func store(UInt16)

```cangjie
public func store(val: UInt16)
```

Function: Store operation using the default memory ordering. Writes the value specified by `val` to the atomic type.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to write to the atomic type.

### func store(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: UInt16, memoryOrder!: MemoryOrder)
```

Function: Store operation using the specified `memoryOrder`. Writes the value specified by `val` to the atomic type.

> **Note:**
>
> This will be deprecated in future versions. Use [store(UInt16)](#func-storeuint16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the current operation.

### func swap(UInt16)

```cangjie
public func swap(val: UInt16): UInt16
```

Function: Swap operation using the default memory ordering. Writes the value specified by `val` to the atomic type and returns the previous value.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to write to the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The previous value before writing.

### func swap(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: UInt16, memoryOrder!: MemoryOrder): UInt16
```

Function: Swap operation using the specified `memoryOrder`. Writes the value specified by `val` to the atomic type and returns the previous value.

> **Note:**
>
> This will be deprecated in future versions. Use [swap(UInt16)](#func-swapuInt16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the current operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The previous value before writing.```markdown
- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform AND with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the current operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the AND operation.

### func fetchOr(UInt16)

```cangjie
public func fetchOr(val: UInt16): UInt16
```

Function: Bitwise OR operation using the default memory ordering. Performs OR with `val` on the atomic type, writes the result, and returns the value before the operation.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform OR with the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the OR operation.
```

### func fetchOr(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchOr(val: UInt16, memoryOrder!: MemoryOrder): UInt16
```

Function: Performs a bitwise OR operation between the current atomic type instance's value and the parameter `val`, using the memory ordering specified by `memoryOrder`. Writes the result back to the current atomic type instance and returns the value before the OR operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchOr(UInt16)](#func-fetchoruint16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform the OR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the OR operation was performed.

### func fetchSub(UInt16)

```cangjie
public func fetchSub(val: UInt16): UInt16
```

Function: Performs a subtraction operation using the default memory ordering, where the atomic type's value is the minuend and the parameter `val` is the subtrahend. Writes the result back to the current atomic type instance and returns the value before the subtraction.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to subtract from the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the subtraction operation was performed.

### func fetchSub(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchSub(val: UInt16, memoryOrder!: MemoryOrder): UInt16
```

Function: Performs a subtraction operation using the memory ordering specified by `memoryOrder`, where the atomic type's value is the minuend and the parameter `val` is the subtrahend. Writes the result back to the current atomic type instance and returns the value before the subtraction.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchSub(UInt16)](#func-fetchsubuint16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to subtract from the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the subtraction operation was performed.

### func fetchXor(UInt16)

```cangjie
public func fetchXor(val: UInt16): UInt16
```

Function: Performs a bitwise XOR operation between the current atomic type instance's value and the parameter `val`, using the default memory ordering. Writes the result back to the current atomic type instance and returns the value before the XOR operation.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform the XOR operation with the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the XOR operation was performed.

### func fetchXor(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchXor(val: UInt16, memoryOrder!: MemoryOrder): UInt16
```

Function: Performs a bitwise XOR operation between the current atomic type instance's value and the parameter `val`, using the memory ordering specified by `memoryOrder`. Writes the result back to the current atomic type instance and returns the value before the XOR operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchXor(UInt16)](#func-fetchxoruint16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to perform the XOR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the XOR operation was performed.

### func load()

```cangjie
public func load(): UInt16
```

Function: Performs a read operation using the default memory ordering, retrieving the value of the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): UInt16
```

Function: Performs a read operation using the memory ordering specified by `memoryOrder`, retrieving the value of the atomic type.

> **Note:**
>
> This will be deprecated in future versions. Use [load()](#func-load-7) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The current value of the atomic type.
``````markdown
### func store(UInt16)

```cangjie
public func store(val: UInt16): Unit
```

Function: Performs a write operation using the default memory ordering, storing the value specified by `val` into the atomic type.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to store in the atomic type.

### func store(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: UInt16, memoryOrder!: MemoryOrder): Unit
```

Function: Performs a write operation using the memory ordering specified by `memoryOrder`, storing the value specified by `val` into the atomic type.

> **Note:**
>
> This will be deprecated in future versions. Use [store(UInt16)](#func-storeuint16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to store in the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

### func swap(UInt16)

```cangjie
public func swap(val: UInt16): UInt16
```

Function: Performs an exchange operation using the default memory ordering, storing the value specified by `val` into the atomic type and returning the previous value.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to store in the atomic type.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the exchange operation was performed.

### func swap(UInt16, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: UInt16, memoryOrder!: MemoryOrder): UInt16
```

Function: Performs an exchange operation using the memory ordering specified by `memoryOrder`, storing the value specified by `val` into the atomic type and returning the previous value.

> **Note:**
>
> This will be deprecated in future versions. Use [swap(UInt16)](#func-swapuint16) instead.

Parameters:

- val: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value to store in the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - The value before the exchange operation was performed.

## class AtomicUInt32

```cangjie
public class AtomicUInt32 {
    public init(val: UInt32)
}
```

Function: Provides atomic operations for the [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) data type.

### init(UInt32)

```cangjie
public init(val: UInt32)
```

Function: Constructs an instance of the atomic type [AtomicUInt32](sync_package_classes.md#class-atomicuint32) encapsulating a [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) data type, with its internal data initialized to the value specified by `val`.

Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The initial value of the atomic type.

### func compareAndSwap(UInt32, UInt32)

```cangjie
public func compareAndSwap(old: UInt32, new: UInt32): Bool
```

Function: Performs a Compare-And-Swap (CAS) operation using the default memory ordering.

Compares the current value of the atomic type with the value specified by `old`. If they are equal, writes the value specified by `new` and returns `true`; otherwise, does not write the value and returns `false`.

Parameters:

- old: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to compare with the current atomic type.
- new: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to write to the atomic type if the comparison succeeds.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the swap was successful, otherwise `false`.

### func compareAndSwap(UInt32, UInt32, MemoryOrder, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func compareAndSwap(old: UInt32, new: UInt32, successOrder!: MemoryOrder, failureOrder!: MemoryOrder): Bool
```

Function: Performs a Compare-And-Swap (CAS) operation, using `successOrder` for memory ordering if successful and `failureOrder` if unsuccessful.

Compares the current value of the atomic type with the value specified by `old`. If they are equal, writes the value specified by `new` and returns `true`; otherwise, does not write the value and returns `false`.

> **Note:**
>
> This will be deprecated in future versions. Use [compareAndSwap(UInt32, UInt32)](#func-compareandswapuint32-uint32) instead.

Parameters:

- old: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to compare with the current atomic type.
- new: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to write to the atomic type if the comparison succeeds.
- successOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the "read-modify-write" operation if successful.
- failureOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the "read" operation if unsuccessful.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the swap was successful, otherwise `false`.

### func fetchAdd(UInt32)

```cangjie
public func fetchAdd(val: UInt32): UInt32
```

Function: Performs an addition operation using the default memory ordering, adding the value specified by `val` to the atomic type's value. Writes the result back to the current atomic type instance and returns the value before the addition.

Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to add to the atomic type.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value before the addition operation was performed.

### func fetchAdd(UInt32, MemoryOrder) <sup>(deprecated)</sup>
```Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to perform the XOR operation with the atomic type.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value before performing the XOR operation.

### func fetchXor(UInt32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchXor(val: UInt32, memoryOrder!: MemoryOrder): UInt32
```

Function: Performs a bitwise XOR operation between the current atomic type instance's value and the parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the XOR operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchXor(UInt32)](#func-fetchxoruint32) instead.

Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to perform the XOR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value before performing the XOR operation.Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to perform the XOR operation with the atomic type.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value before performing the XOR operation.

### func fetchXor(UInt32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchXor(val: UInt32, memoryOrder!: MemoryOrder): UInt32
```

Function: Performs a bitwise XOR operation between the current atomic type instance's value and the parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the XOR operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchXor(UInt32)](#func-fetchxoruint32) instead.

Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to perform the XOR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value before performing the XOR operation.

### func load()

```cangjie
public func load(): UInt32
```

Function: Read operation using default memory ordering to read the atomic type's value.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): UInt32
```

Function: Read operation using the memory ordering specified by `memoryOrder` to read the atomic type's value.

> **Note:**
>
> This will be deprecated in future versions. Use [load()](#func-load-8) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The current value of the atomic type.

### func store(UInt32)

```cangjie
public func store(val: UInt32): Unit
```

Function: Write operation using default memory ordering to write the value specified by `val` to the atomic type.

Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to write to the atomic type.

### func store(UInt32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: UInt32, memoryOrder!: MemoryOrder): Unit
```

Function: Write operation using the memory ordering specified by `memoryOrder` to write the value specified by `val` to the atomic type.

> **Note:**
>
> This will be deprecated in future versions. Use [store(UInt32)](#func-storeuint32) instead.

Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

### func swap(UInt32)

```cangjie
public func swap(val: UInt32): UInt32
```

Function: Swap operation using default memory ordering to write the value specified by `val` to the atomic type and return the previous value.

Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to write to the atomic type.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value before the write operation.

### func swap(UInt32, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: UInt32, memoryOrder!: MemoryOrder): UInt32
```

Function: Swap operation using the memory ordering specified by `memoryOrder` to write the value specified by `val` to the atomic type and return the previous value.

> **Note:**
>
> This will be deprecated in future versions. Use [swap(UInt32)](#func-swapuint32) instead.

Parameters:

- val: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for this operation.

Return Value:

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - The value before the write operation.

## class AtomicUInt64

```cangjie
public class AtomicUInt64 {
    public init(val: UInt64)
}
```

Function: Provides atomic operations for the [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) data type.

### init(UInt64)

```cangjie
public init(val: UInt64)
```

Function: Constructs an instance of the atomic type [AtomicUInt64](sync_package_classes.md#class-atomicuint64) encapsulating a [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) data type, with its internal data initialized to the value of parameter `val`.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The initial value of the atomic type.

### func compareAndSwap(UInt64, UInt64)```cangjie
public func compareAndSwap(old: UInt64, new: UInt64): Bool
```

Function: CAS (Compare-And-Swap) operation using default memory ordering.

Compares the current atomic type's value with the value specified by parameter `old`. If they are equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write and returns `false`.

Parameters:

- old: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to compare with the current atomic type.
- new: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to write to the atomic type if the comparison succeeds.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the swap was successful, otherwise `false`.

### func compareAndSwap(UInt64, UInt64, MemoryOrder, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func compareAndSwap(old: UInt64, new: UInt64, successOrder!: MemoryOrder, failureOrder!: MemoryOrder): Bool
```

Function: CAS (Compare-And-Swap) operation using `successOrder` memory ordering if successful and `failureOrder` if failed.

Compares the current atomic type's value with the value specified by parameter `old`. If they are equal, writes the value specified by parameter `new` and returns `true`; otherwise, does not write and returns `false`.

> **Note:**
>
> This will be deprecated in future versions. Use [compareAndSwap(UInt64, UInt64)](#func-compareandswapuint64-uint64) instead.

Parameters:

- old: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to compare with the current atomic type.
- new: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to write to the atomic type if the comparison succeeds.
- successOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering if the operation succeeds.
- failureOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering if the operation fails.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the swap was successful, otherwise `false`.- old: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to compare with the current atomic type.
- new: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to write to the atomic type if the comparison succeeds.
- successOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the "read-modify-write" operation when the CAS operation succeeds.
- failureOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the "read" operation when the CAS operation fails.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the compare-and-swap succeeds, otherwise returns `false`.

### func fetchAdd(UInt64)

```cangjie
public func fetchAdd(val: UInt64): UInt64
```

Function: Performs an addition operation between the atomic type's value and the parameter `val` using the default memory ordering. Writes the result to the current atomic type instance and returns the value before the addition.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to add to the atomic type.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the addition operation.

### func fetchAdd(UInt64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchAdd(val: UInt64, memoryOrder!: MemoryOrder): UInt64
```

Function: Performs an addition operation between the atomic type's value and the parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the addition.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchAdd(UInt64)](#func-fetchadduint64) instead.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to add to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the addition operation.

### func fetchAnd(UInt64)

```cangjie
public func fetchAnd(val: UInt64): UInt64
```

Function: Performs a bitwise AND operation between the current atomic type instance's value and the parameter `val` using the default memory ordering. Writes the result to the current atomic type instance and returns the value before the AND operation.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to perform the AND operation with the atomic type.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the AND operation.

### func fetchAnd(UInt64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchAnd(val: UInt64, memoryOrder!: MemoryOrder): UInt64
```

Function: Performs a bitwise AND operation between the current atomic type instance's value and the parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the AND operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchAnd(UInt64)](#func-fetchanduint64) instead.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to perform the AND operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the AND operation.

### func fetchOr(UInt64)

```cangjie
public func fetchOr(val: UInt64): UInt64
```

Function: Performs a bitwise OR operation between the current atomic type instance's value and the parameter `val` using the default memory ordering. Writes the result to the current atomic type instance and returns the value before the OR operation.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to perform the OR operation with the atomic type.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the OR operation.

### func fetchOr(UInt64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchOr(val: UInt64, memoryOrder!: MemoryOrder): UInt64
```

Function: Performs a bitwise OR operation between the current atomic type instance's value and the parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the OR operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchOr(UInt64)](#func-fetchoruint64) instead.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to perform the OR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the OR operation.> This will be deprecated in future versions. Use [fetchOr(UInt64)](#func-fetchoruint64) instead.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to perform the OR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the OR operation.

### func fetchSub(UInt64)

```cangjie
public func fetchSub(val: UInt64): UInt64
```

Function: Performs a subtraction operation between the atomic type's value (as the minuend) and the parameter `val` (as the subtrahend) using the default memory ordering. Writes the result to the current atomic type instance and returns the value before the subtraction.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to subtract from the atomic type.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the subtraction operation.

### func fetchSub(UInt64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchSub(val: UInt64, memoryOrder!: MemoryOrder): UInt64
```

Function: Performs a subtraction operation between the atomic type's value (as the minuend) and the parameter `val` (as the subtrahend) using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the subtraction.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchSub(UInt64)](#func-fetchsubuint64) instead.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to subtract from the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the subtraction operation.

### func fetchXor(UInt64)

```cangjie
public func fetchXor(val: UInt64): UInt64
```

Function: Performs a bitwise XOR operation between the current atomic type instance's value and the parameter `val` using the default memory ordering. Writes the result to the current atomic type instance and returns the value before the XOR operation.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to perform the XOR operation with the atomic type.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the XOR operation.

### func fetchXor(UInt64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func fetchXor(val: UInt64, memoryOrder!: MemoryOrder): UInt64
```

Function: Performs a bitwise XOR operation between the current atomic type instance's value and the parameter `val` using the memory ordering specified by `memoryOrder`. Writes the result to the current atomic type instance and returns the value before the XOR operation.

> **Note:**
>
> This will be deprecated in future versions. Use [fetchXor(UInt64)](#func-fetchxoruint64) instead.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to perform the XOR operation with the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the XOR operation.

### func load()

```cangjie
public func load(): UInt64
```

Function: Performs a read operation on the atomic type's value using the default memory ordering.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The current value of the atomic type.

### func load(MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func load(memoryOrder!: MemoryOrder): UInt64
```

Function: Performs a read operation on the atomic type's value using the memory ordering specified by `memoryOrder`.

> **Note:**
>
> This will be deprecated in future versions. Use [load()](#func-load-9) instead.

Parameters:

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The current value of the atomic type.

### func store(UInt64)

```cangjie
public func store(val: UInt64): Unit
```

Function: Performs a write operation, storing the value specified by `val` into the atomic type using the default memory ordering.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to write to the atomic type.

### func store(UInt64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func store(val: UInt64, memoryOrder!: MemoryOrder): Unit
```

Function: Performs a write operation, storing the value specified by `val` into the atomic type using the memory ordering specified by `memoryOrder`.

> **Note:**
>
> This will be deprecated in future versions. Use [store(UInt64)](#func-storeuint64) instead.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

### func swap(UInt64)

```cangjie
public func swap(val: UInt64): UInt64
``````markdown
Function: Performs a swap operation, storing the value specified by `val` into the atomic type using the default memory ordering, and returns the value before the swap.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to write to the atomic type.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the swap.

### func swap(UInt64, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: UInt64, memoryOrder!: MemoryOrder): UInt64
```

Function: Performs a swap operation, storing the value specified by `val` into the atomic type using the memory ordering specified by `memoryOrder`, and returns the value before the swap.

> **Note:**
>
> This will be deprecated in future versions. Use [swap(UInt64)](#func-swapuint64) instead.

Parameters:

- val: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value to write to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - The memory ordering for the operation.

Return Value:

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - The value before the swap.

## class AtomicUInt8

```cangjie
public class AtomicUInt8 {
    public init(val: UInt8)
}
```

- val: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - Value to be written to the atomic type.  
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.  

### func swap(UInt8)  

```cangjie  
public func swap(val: UInt8): UInt8  
```  

Function: Performs an atomic swap operation using the default memory ordering. Replaces the current value of the atomic type with the value specified by parameter `val`, and returns the original value.  

Parameters:  

- val: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The new value to be stored in the atomic type.  

Return Value:  

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The original value before the swap operation.  

### func swap(UInt8, MemoryOrder) <sup>(deprecated)</sup>  

```cangjie  
public func swap(val: UInt8, memoryOrder!: MemoryOrder): UInt8  
```  

Function: Performs an atomic swap operation using the memory ordering specified by parameter `memoryOrder`. Replaces the current value of the atomic type with the value specified by parameter `val`, and returns the original value.  

> **Note:**  
>  
> This will be deprecated in future versions. Use [swap(UInt8)](#func-swapuint8) instead.  

Parameters:  

- val: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The new value to be stored in the atomic type.  
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.  

Return Value:  

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The original value before the swap operation.  

### func getAndSet(UInt8)  

```cangjie  
public func getAndSet(val: UInt8): UInt8  
```  

Function: Atomically sets the atomic type to the value specified by parameter `val` and returns the previous value, using the default memory ordering.  

Parameters:  

- val: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The new value to be stored in the atomic type.  

Return Value:  

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The original value before the operation.  

### func getAndSet(UInt8, MemoryOrder) <sup>(deprecated)</sup>  

```cangjie  
public func getAndSet(val: UInt8, memoryOrder!: MemoryOrder): UInt8  
```  

Function: Atomically sets the atomic type to the value specified by parameter `val` and returns the previous value, using the memory ordering specified by parameter `memoryOrder`.  

> **Note:**  
>  
> This will be deprecated in future versions. Use [getAndSet(UInt8)](#func-getandsetuint8) instead.  

Parameters:  

- val: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The new value to be stored in the atomic type.  
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.  

Return Value:  

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The original value before the operation.  

### func getAndIncrement()  

```cangjie  
public func getAndIncrement(): UInt8  
```  

Function: Atomically increments the current value of the atomic type by 1 and returns the previous value, using the default memory ordering.  

Return Value:  

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The original value before the increment operation.  

### func getAndIncrement(MemoryOrder) <sup>(deprecated)</sup>  

```cangjie  
public func getAndIncrement(memoryOrder!: MemoryOrder): UInt8  
```  

Function: Atomically increments the current value of the atomic type by 1 and returns the previous value, using the memory ordering specified by parameter `memoryOrder`.  

> **Note:**  
>  
> This will be deprecated in future versions. Use [getAndIncrement()](#func-getandincrement) instead.  

Parameters:  

- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.  

Return Value:  

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The original value before the increment operation.  

### func getAndDecrement()  
``````markdown
- val: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The value to be written to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.

### func swap(UInt8)

```cangjie
public func swap(val: UInt8): UInt8
```

Function: Atomically swaps the current value with the specified value using default memory ordering, writes the parameter `val` to the atomic type, and returns the pre-swap value.

Parameters:

- val: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The value to be written to the atomic type.

Return Value:

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The original value before the swap operation.

### func swap(UInt8, MemoryOrder) <sup>(deprecated)</sup>

```cangjie
public func swap(val: UInt8, memoryOrder!: MemoryOrder): UInt8
```

Function: Atomically swaps the current value with the specified value using the memory ordering defined by parameter `memoryOrder`, writes the parameter `val` to the atomic type, and returns the pre-swap value.

> **Note:**  
>  
> This will be deprecated in future versions. Use [swap(UInt8)](#func-swapuint8) instead.

Parameters:

- val: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The value to be written to the atomic type.
- memoryOrder!: [MemoryOrder <sup>(deprecated)</sup>](sync_package_enums.md#enum-memoryorder-deprecated) - Memory ordering mode for the current operation.

Return Value:

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - The original value before the swap operation.

## class Barrier

```cangjie
public class Barrier {
    public init(count: Int64)
}
```

Function: Provides synchronization mechanism for coordinating multiple threads to reach a designated program point.

Threads arriving first at the program point will block until all participating threads have reached the barrier, after which they proceed concurrently.

### init(Int64)

```cangjie
public init(count: Int64)
```public func notify(condition: ConditionID): Unit
```

Function: Wakes up one thread waiting on the specified condition queue.

Parameters:

- condition: [ConditionID](sync_package_structs.md#struct-conditionid-deprecated) - The condition queue identifier.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if the current thread does not hold the mutex.

### func notifyAll(ConditionID)

```cangjie
public func notifyAll(condition: ConditionID): Unit
```

Function: Wakes up all threads waiting on the specified condition queue.

Parameters:

- condition: [ConditionID](sync_package_structs.md#struct-conditionid-deprecated) - The condition queue identifier.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if the current thread does not hold the mutex.

### func wait(ConditionID, Duration)

```cangjie
public func wait(condition: ConditionID, timeout!: Duration = Duration.Max): Bool
```

Function: Suspends the current thread on the specified condition queue until the corresponding `notify` function is called or the suspension time exceeds `timeout`.

> **Explanation:**
>
> The thread releases the associated mutex lock when entering the wait state and reacquires it upon being awakened.

Parameters:

- condition: [ConditionID](sync_package_structs.md#struct-conditionid-deprecated) - The condition queue identifier.
- timeout!: [Duration](../../core/core_package_api/core_package_structs.md#struct-duration) - The suspension duration, with a default value of [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max).

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if awakened by another thread; returns `false` if it times out.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if `timeout` is less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero).
- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if the current thread does not hold the mutex.```markdown
public func notify(condID: ConditionID): Unit
```

Function: Wakes up a thread waiting on the specified condition variable (if any).

Parameters:

- condID: [ConditionID](sync_package_structs.md#struct-conditionid-deprecated) - The condition variable.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if the current thread does not hold the mutex or if `condID` was not created by this [MultiConditionMonitor <sup>(deprecated)<sup>](sync_package_classes.md#class-multiconditionmonitor-deprecated) instance via the `newCondition` function.

### func notifyAll(ConditionID)

```cangjie
public func notifyAll(condID: ConditionID): Unit
```

Function: Wakes up all threads waiting on the specified condition variable (if any).

Parameters:

- condID: [ConditionID](sync_package_structs.md#struct-conditionid-deprecated) - The condition variable.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if the current thread does not hold the mutex or if `condID` was not created by this [MultiConditionMonitor <sup>(deprecated)<sup>](sync_package_classes.md#class-multiconditionmonitor-deprecated) instance via the `newCondition` function.

### func wait(ConditionID, Duration)

```cangjie
public func wait(condID: ConditionID, timeout!: Duration = Duration.Max): Bool
```

Function: Suspends the current thread until the corresponding `notify` function is called.

> **Explanation:**
>
> The thread releases the associated mutex lock when entering the wait state and reacquires it upon being awakened.

Parameters:

- condID: [ConditionID](sync_package_structs.md#struct-conditionid-deprecated) - The condition variable.
- timeout!: [Duration](../../core/core_package_api/core_package_structs.md#struct-duration) - The suspension duration, with a default value of [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max).

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the condition variable specified by this [Monitor <sup>(deprecated)<sup>](sync_package_classes.md#class-monitor-deprecated) is awakened by another thread; returns `false` if it times out.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if the current thread does not hold the mutex, the suspension time exceeds `timeout`, or `condID` was not created by this [MultiConditionMonitor <sup>(deprecated)<sup>](sync_package_classes.md#class-multiconditionmonitor-deprecated) instance via the `newCondition` function.
- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if `timeout` is less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero).

## class Mutex

```cangjie
public class Mutex <: UniqueLock {
    public init()
}
```

Function: Provides functionality related to reentrant mutex locks.

A reentrant mutex lock protects critical sections, ensuring that at most one thread can execute the critical section code at any given time. When a thread attempts to acquire a lock held by another thread, it is blocked until the lock is released. Reentrancy means that a thread can acquire the lock multiple times.

> **Notes:**
>
> - The lock must be acquired before accessing shared data.
> - The lock must be released after processing shared data so that other threads can acquire it.

Parent Types:

- [UniqueLock](./sync_package_interfaces.md#interface-uniquelock)

### init()

```cangjie
public init()
```

Function: Creates a reentrant mutex lock.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if a system error occurs.

### func condition()

```cangjie
public func condition(): Condition
```

Function: Creates a [Condition](./sync_package_interfaces.md#interface-condition) associated with this [Mutex](#class-mutex).

Can be used to implement concurrent primitives with "single Lock multiple wait queues".

Return value:

- [Condition](./sync_package_interfaces.md#interface-condition) - The created [Condition](./sync_package_interfaces.md#interface-condition) instance associated with this [Mutex](#class-mutex).

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Throws an exception if the current thread does not hold this mutex.

### func lock()

```cangjie
public func lock(): Unit
```

Function: Locks the mutex. If the mutex is already locked, blocks.

### func tryLock()

```cangjie
public func tryLock(): Bool
```

Function: Attempts to lock the mutex.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `false` if the mutex is already locked; otherwise, locks the mutex and returns `true`.

### func unlock

```cangjie
public func unlock(): Unit
```

Function: Unlocks the mutex.

If the mutex has been locked N times recursively, this function must be called N times to fully unlock it. Once the mutex is fully unlocked, if other threads are blocked on this lock, one of them will be awakened.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Throws an exception if the current thread does not hold this mutex.

## class ReadWriteLock

```cangjie
public class ReadWriteLock {
    public init(fair!: Bool = false)
}
```

Function: Provides reentrant read-write lock functionality.

The difference from ordinary mutex locks is that a read-write lock carries two mutex locks: a "read lock" and a "write lock," and it allows multiple threads to hold the read lock simultaneously.
```Special properties of read-write locks:

- Write exclusivity: Only one thread can hold the write lock. When a thread holds the write lock, other threads attempting to acquire the lock (read or write) will be blocked.
- Read concurrency: Allows multiple threads to hold the read lock simultaneously. When a thread holds the read lock, other threads can still acquire the read lock. However, other threads attempting to acquire the write lock will be blocked.
- Reentrancy: A thread can acquire the lock multiple times.
    - When a thread already holds the write lock, it can continue to acquire the write lock or read lock. The lock is fully released only when unlock operations match the number of lock operations.
    - When a thread already holds the read lock, it can continue to acquire the read lock. The lock is fully released only when unlock operations match the number of lock operations. Note: Acquiring a write lock while holding a read lock is not allowed and will throw an exception.
- Lock downgrade: A thread can transition from "holding the write lock" to "holding the read lock" by first acquiring the read lock and then releasing the write lock, after which it holds only the read lock.
- Read-write fairness: Read-write locks support two modes: "fair" and "unfair."
    - In unfair mode, the read-write lock makes no guarantees about the order in which threads acquire the lock.
    - In fair mode, when a thread attempts to acquire the read lock (and does not already hold it), if the write lock is held or there are threads waiting for the write lock, the current thread cannot acquire the read lock and will wait.
    - In fair mode, releasing the write lock will prioritize waking up all waiting read threads, and releasing the read lock will prioritize waking up one waiting write thread. If multiple threads are waiting for the write lock, the order in which they are awakened is not guaranteed.

### prop readLock

```cangjie
public prop readLock: Lock
```

Function: Gets the read lock.

Type: [Lock](./sync_package_interfaces.md#interface-lock)

### prop writeLock

```cangjie
public prop writeLock: UniqueLock
```

Function: Gets the write lock.

Type: [UniqueLock](./sync_package_interfaces.md#interface-uniquelock)

### init(Bool)

```cangjie
public init(fair!: Bool = false)
```

Function: Constructs a read-write lock.

Parameters:

- fair!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Whether the read-write lock is in fair mode. Default is `false`, meaning an "unfair" read-write lock is constructed.

### func isFair()

```cangjie
public func isFair(): Bool
```

Function: Checks whether the read-write lock is in "fair" mode.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - `true` indicates "fair" mode; otherwise, it indicates "unfair" mode.

## class ReentrantMutex <sup>(deprecated)<sup>

```cangjie
public open class ReentrantMutex <: IReentrantMutex {
    public init()
}
```

Function: Provides reentrant lock functionality.

A reentrant mutex protects critical sections, ensuring that only one thread can execute the critical section code at any time. When a thread attempts to acquire a lock held by another thread, it will block until the lock is released. Reentrancy means a thread can acquire the lock multiple times.

> **Note:**
>
> - Will be deprecated in future versions. Use [Mutex](#class-mutex) instead.
> - [ReentrantMutex <sup>(deprecated)<sup>](sync_package_classes.md#class-reentrantmutex-deprecated) is a built-in mutex lock. Developers must ensure they do not inherit from it.
> - Before accessing shared data, the lock must be acquired.
> - After processing shared data, the lock must be released to allow other threads to acquire it.

Parent types:

- [IReentrantMutex <sup>(deprecated)<sup>](sync_package_interfaces.md#interface-ireentrantmutex-deprecated)

### init()

```cangjie
public init()
```

Function: Creates a reentrant mutex.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Throws an exception if a system error occurs.

### func lock()

```cangjie
public open func lock(): Unit
```

Function: Locks the mutex. If the mutex is already locked, blocks.

### func tryLock()

```cangjie
public open func tryLock(): Bool
```

Function: Attempts to lock the mutex.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `false` if the mutex is already locked; otherwise, locks the mutex and returns `true`.

### func unlock

```cangjie
public open func unlock(): Unit
```

Function: Unlocks the mutex.

If the mutex has been locked N times recursively, this function must be called N times to fully unlock it. Once the mutex is fully unlocked, if other threads are blocked on this lock, one of them will be awakened.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Throws an exception if the current thread does not hold this mutex.

## class ReentrantReadMutex <sup>(deprecated)<sup>

```cangjie
public class ReentrantReadMutex <: ReentrantMutex
```

Function: Provides the read lock type in a reentrant read-write lock.

> **Note:**
>
> Will be deprecated in future versions. Use [Lock](./sync_package_interfaces.md#interface-lock) instead.

Parent types:

- [ReentrantMutex <sup>(deprecated)<sup>](#class-reentrantmutex-deprecated)

### func lock()

```cangjie
public func lock(): Unit
```

Function: Acquires the read lock.```markdown
> **Note:**
>
> - In fair mode, if no other thread holds or is waiting for the write lock, or if the current thread already holds the read lock, the read lock is acquired immediately; otherwise, the current thread waits.
> - In unfair mode, if no other thread holds or is waiting for the write lock, the read lock is acquired immediately; if another thread holds the write lock, the current thread waits; otherwise, whether the thread can acquire the read lock immediately is not guaranteed.
> - Multiple threads can hold the read lock simultaneously, and a thread can acquire the read lock multiple times. If a thread holds the write lock, it can still acquire the read lock.

### func tryLock()

```cangjie
public func tryLock(): Bool
```

Function: Attempts to acquire the read lock. This method does not follow fair mode when acquiring the read lock.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the read lock is acquired successfully; otherwise, returns `false`.

### func unlock()

```cangjie
public func unlock(): Unit
```

Function: Releases the read lock. If a thread has acquired the read lock multiple times, the read lock is released only when the number of unlock operations matches the number of lock operations. If the read lock is released and there are threads waiting for the write lock, one of them will be awakened.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Throws an exception if the current thread does not hold the read lock.

## class ReentrantReadWriteMutex <sup>(deprecated)<sup>

```cangjie
public class ReentrantReadWriteMutex {
    public init(mode!: ReadWriteMutexMode = ReadWriteMutexMode.Unfair)
}
```

Function: Provides reentrant read-write lock functionality.

The difference from ordinary mutex locks is that a read-write lock carries two mutex locks: a "read lock" and a "write lock," and it allows multiple threads to hold the read lock simultaneously.

> **Note:**
>
> Will be deprecated in future versions. Use [ReadWriteLock](#class-readwritelock) instead.

Special properties of read-write locks:

- Write exclusivity: Only one thread can hold the write lock. When a thread holds the write lock, other threads attempting to acquire the lock (read or write) will be blocked.
- Read concurrency: Allows multiple threads to hold the read lock simultaneously. When a thread holds the read lock, other threads can still acquire the read lock. However, other threads attempting to acquire the write lock will be blocked.
- Reentrancy: A thread can acquire the lock multiple times.
    - When a thread already holds the write lock, it can continue to acquire the write lock or read lock. The lock is fully released only when unlock operations match the number of lock operations.
    - When a thread already holds the read lock, it can continue to acquire the read lock. The lock is fully released only when unlock operations match the number of lock operations. Note: Acquiring a write lock while holding a read lock is not allowed and will throw an exception.
- Lock downgrade: A thread can transition from "holding the write lock" to "holding the read lock" by first acquiring the read lock and then releasing the write lock, after which it holds only the read lock.
- Read-write fairness: Read-write locks support two modes: "fair" and "unfair."
    - In unfair mode, the read-write lock makes no guarantees about the order in which threads acquire the lock.
    - In fair mode, when a thread attempts to acquire the read lock (and does not already hold it), if the write lock is held or there are threads waiting for the write lock, the current thread cannot acquire the read lock and will wait.
    - In fair mode, releasing the write lock will prioritize waking up all waiting read threads, and releasing the read lock will prioritize waking up one waiting write thread. If multiple threads are waiting for the write lock, the order in which they are awakened is not guaranteed.

### prop readMutex

```cangjie
public prop readMutex: ReentrantReadMutex
```

Function: Gets the read lock.

Type: [ReentrantReadMutex <sup>(deprecated)<sup>](sync_package_classes.md#class-reentrantreadmutex-deprecated)

### prop writeMutex

```cangjie
public prop writeMutex: ReentrantWriteMutex
```

Function: Gets the write lock.

Type: [ReentrantWriteMutex <sup>(deprecated)<sup>](sync_package_classes.md#class-reentrantwritemutex-deprecated)

### init(ReadWriteMutexMode)

```cangjie
public init(mode!: ReadWriteMutexMode = ReadWriteMutexMode.Unfair)
```

Function: Constructs a read-write lock.Parameters:

- mode!: [ReadWriteMutexMode <sup>(deprecated)<sup>](sync_package_enums.md#enum-readwritemutexmode-deprecated) - Read-write lock mode, default value is `Unfair`, which constructs an "unfair" read-write lock.

## class ReentrantWriteMutex <sup>(deprecated)<sup>

```cangjie
public class ReentrantWriteMutex <: ReentrantMutex
```

Function: Provides the write lock type in a reentrant read-write lock.

> **Note:**
>
> Will be deprecated in future versions. Use [UniqueLock](./sync_package_interfaces.md#interface-uniquelock) instead.

Parent Types:

- [ReentrantMutex <sup>(deprecated)<sup>](#class-reentrantmutex-deprecated)

### func lock()

```cangjie
public func lock(): Unit
```

Function: Acquires the write lock. Only a single thread can hold the write lock, and this thread can repeatedly acquire it. If another thread holds either a write lock or read lock, the current thread enters a waiting state.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if the current thread already holds a read lock.

### func tryLock()

```cangjie
public func tryLock(): Bool
```

Function: Attempts to acquire the write lock. This method does not follow fair mode when acquiring the write lock.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the write lock is successfully acquired; otherwise, returns `false`.

### func unlock()

```cangjie
public func unlock(): Unit
```

Function: Releases the write lock.

> **Note:**
>
> - If a thread has acquired the read lock multiple times, the read lock is only released when the number of release operations matches the number of acquisition operations. If the read lock is released and there are threads waiting for the write lock, one of them is awakened.
> - In fair mode, if the write lock is released and there are threads waiting for the read lock, these waiting threads are awakened first. If no threads are waiting for the read lock but there are threads waiting for the write lock, one of them is awakened.
> - In unfair mode, if the write lock is released, there is no guarantee whether threads waiting for the write lock or those waiting for the read lock will be awakened first; this is left to the implementation.

Exceptions:

- [IllegalSynchronizationStateException](sync_package_exceptions.md#class-illegalsynchronizationstateexception) - Thrown if the current thread does not hold the write lock.

## class Semaphore
``````cangjie
public class Semaphore {
    public init(count: Int64)
}
```

Function: Provides semaphore-related functionality.

[Semaphore](sync_package_classes.md#class-semaphore) can be viewed as a [Monitor <sup>(deprecated)<sup>](sync_package_classes.md#class-monitor-deprecated) with a counter, commonly used to control the number of threads accessing shared resources concurrently.

### prop count

```cangjie
public prop count: Int64
```

Function: Returns the current value of the internal counter.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init(Int64)

```cangjie
public init(count: Int64)
```

Function: Creates a [Semaphore](sync_package_classes.md#class-semaphore) object and initializes the value of the internal counter.

Parameters:

- [count](../../collection/collection_package_api/collection_package_function.md#func-counttiterablet): [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - Initial value of the counter, range [0, [Int64](../../core/core_package_api/core_package_intrinsics.md#int64).Max].

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the parameter [count](../../collection/collection_package_api/collection_package_function.md#func-counttiterablet) is negative.

### func acquire(Int64)

```cangjie
public func acquire(amount!: Int64 = 1): Unit
```

Function: Acquires the specified value from the [Semaphore](sync_package_classes.md#class-semaphore) object.

If the current counter value is less than the requested amount, the current thread is blocked until the required amount is available.

Parameters:

- amount!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to acquire from the internal counter, default is 1.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the parameter `amount` is negative or exceeds the initial value.

### func release(Int64)

```cangjie
public func release(amount!: Int64 = 1): Unit
```

Function: Releases the specified value to the [Semaphore](sync_package_classes.md#class-semaphore) object.

If the internal counter, after adding the released value, can satisfy any threads blocked on the [Semaphore](sync_package_classes.md#class-semaphore) object, those threads are awakened. The internal counter value will not exceed the initial value; if the counter value after addition would exceed the initial value, it is set to the initial value. All operations before calling `release` happen before operations after calling `acquire/tryAcquire`.

Parameters:

- amount!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to release to the internal counter, default is 1.

Return Value:

- [Unit](../../core/core_package_api/core_package_intrinsics.md#unit) - Returns `false` if the current counter value is less than the requested amount; otherwise, returns `true`.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the parameter `amount` is negative or exceeds the initial value.

### func tryAcquire(Int64)

```cangjie
public func tryAcquire(amount!: Int64 = 1): Bool
```

Function: Attempts to acquire the specified value from the [Semaphore](sync_package_classes.md#class-semaphore) object.

This method does not block the thread. If multiple threads concurrently perform acquisition operations, the order of acquisition is not guaranteed.

Parameters:

- amount!: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The value to acquire from the internal counter, default is 1.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `false` if the current counter value is less than the requested amount; otherwise, returns `true`.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the parameter `amount` is negative or exceeds the initial value.

## class SyncCounter

```cangjie
public class SyncCounter {
    public init(count: Int64)
}
```

Function: Provides countdown counter functionality.

Threads can wait for the counter to reach zero.

### prop count

```cangjie
public prop count: Int64
```

Function: Gets the current value of the counter.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### init(Int64)

```cangjie
public init(count: Int64)
```

Function: Creates a countdown counter.

Parameters:

- [count](../../collection/collection_package_api/collection_package_function.md#func-counttiterablet): [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - Initial value of the countdown counter.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if the parameter [count](../../collection/collection_package_api/collection_package_function.md#func-counttiterablet) is negative.

### func dec()

```cangjie
public func dec(): Unit
```

Function: Decrements the counter by one.

If the counter reaches zero, all waiting threads are awakened. If the counter is already zero, the value remains unchanged.

### func waitUntilZero(Duration)

```cangjie
public func waitUntilZero(timeout!: Duration = Duration.Max): Unit
``````markdown
```

Function: The current thread waits until the counter reaches zero or the waiting time exceeds `timeout`.

Parameters:

- timeout!: [Duration](../../core/core_package_api/core_package_structs.md#struct-duration) - Maximum duration to wait while blocked, default value is [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max).

## class Timer

```cangjie
public class Timer <: Equatable<Timer> & Hashable
```

Function: Provides timer functionality.

Used to execute a specified task once or multiple times at a specified time or after a specified interval.

> **Note:**
>
> - [Timer](sync_package_classes.md#class-timer) implicitly includes a `spawn` operation, meaning each [Timer](sync_package_classes.md#class-timer) creates a thread to execute the Task associated with it.
> - Each [Timer](sync_package_classes.md#class-timer) can only bind one Task during initialization. After initialization, the associated Task cannot be reset.
> - The lifecycle of a [Timer](sync_package_classes.md#class-timer) ends only when the associated Task completes or the [Timer](sync_package_classes.md#class-timer) is actively canceled using the `cancel` interface. After this, it can be garbage collected by [GC](../../runtime/runtime_package_api/runtime_package_funcs.md#func-gcbool). In other words, before the associated Task completes or the [Timer](sync_package_classes.md#class-timer) is canceled, the [Timer](sync_package_classes.md#class-timer) instance will not be garbage collected, ensuring the Task can be executed normally.
> - When the system is busy, the Task's trigger time may be affected. [Timer](sync_package_classes.md#class-timer) does not guarantee that the Task will be triggered exactly on time. It ensures the Task's trigger time is less than or equal to the current time.
> - [Timer](sync_package_classes.md#class-timer) does not actively catch exceptions thrown by the associated Task. If the Task throws an uncaught exception, the [Timer](sync_package_classes.md#class-timer) becomes invalid.
> - [Timer](sync_package_classes.md#class-timer) is typically divided into one-shot timers and recurring timers. A one-shot timer's Task executes only once, while a recurring timer's Task executes at specified intervals until canceled or the end condition specified during creation is met.

Parent Types:

- [Equatable](../../core/core_package_api/core_package_interfaces.md#interface-equatablet)\<[Timer](#class-timer)>
- [Hashable](../../core/core_package_api/core_package_interfaces.md#interface-hashable)

### static func after(Duration, ()->Option\<Duration>)

```cangjie
public static func after(delay: Duration, task: () -> Option<Duration>): Timer
```

Function: Initializes a [Timer](sync_package_classes.md#class-timer). The number of times the associated Task is scheduled depends on its return value. If the first trigger time is earlier than the current time, the Task is executed immediately. If the Task returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont).None, the [Timer](sync_package_classes.md#class-timer) becomes invalid and stops scheduling the Task. If the Task returns [Option](../../core/core_package_api/core_package_enums.md#enum-optiont).Some(v) and `v` is greater than [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), the minimum interval before the next execution is set to `v`. Otherwise, the Task is scheduled for immediate execution again.

Parameters:

- delay: [Duration](../../core/core_package_api/core_package_structs.md#struct-duration) - Time interval from now until the first execution of the Task.
- task: () ->[Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<[Duration](../../core/core_package_api/core_package_structs.md#struct-duration)> - The Task to be scheduled by this [Timer](sync_package_classes.md#class-timer).

Return Value:

- [Timer](sync_package_classes.md#class-timer) - A [Timer](sync_package_classes.md#class-timer) instance.

### static func once(Duration, ()->Unit)

```cangjie
public static func once(delay: Duration, task: ()->Unit): Timer
```

Function: Sets and starts a one-shot timer task, returning the [Timer](sync_package_classes.md#class-timer) object instance controlling this task.

Parameters:

- delay: [Duration](../../core/core_package_api/core_package_structs.md#struct-duration) - Time interval from now until the Task is executed. Range: [[Duration.Min](../../core/core_package_api/core_package_structs.md#static-const-min), [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max)]. If less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), the Task is executed immediately.
- task: ()->Unit - The task to be executed.

Return Value:

- [Timer](sync_package_classes.md#class-timer) - The created object instance.

Example:

```cangjie
import std.time.MonoTime

main() {
    let start = MonoTime.now()
    Timer.once(Duration.second, {=>
        println("Tick at: ${MonoTime.now() - start}")
    })

    sleep(Duration.second * 2)
    0
}
```

Output:

```text
Tick at: 1s2ms74us551ns
```

### static func repeat(Duration, Duration, ()->Unit, CatchupStyle)

```cangjie
public static func repeat(delay: Duration, interval: Duration, task: ()->Unit, style!: CatchupStyle = Burst): Timer
```

Function: Sets up and starts a recurring timer task, returning a [Timer](sync_package_classes.md#class-timer) object instance that controls this task.

Parameters:

- delay: [Duration](../../core/core_package_api/core_package_structs.md#struct-duration) - The time interval from now until the Task is executed. Valid range: [[Duration.Min](../../core/core_package_api/core_package_structs.md#static-const-min), [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max)]. If less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), the Task will be executed immediately.
- interval: [Duration](../../../std/core/core_package_api/core_package_structs.md#struct-duration) - The time interval between two Task executions. Valid range: ([Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max)].
- task: ()->Unit - The task to be executed periodically.
- style!: [CatchupStyle](./sync_package_enums.md#enum-catchupstyle) - The catch-up strategy, defaulting to Burst. When Task execution takes too long, subsequent task execution times may be delayed. Different catch-up strategies suit different scenarios. See [CatchupStyle](sync_package_enums.md#enum-catchupstyle) for details.

Return value:

- [Timer](sync_package_classes.md#class-timer) - The created object instance.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when `interval` is less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero).

Example:

```cangjie
import std.sync.{Timer}
import std.time.{MonoTime}

main() {
    let start = MonoTime.now()
    let timer = Timer.repeat(Duration.second, Duration.second, {=>
        println("Tick at: ${MonoTime.now() - start}")
    })

    sleep(Duration.second * 5)
    timer.cancel()

    0
}
```

Execution result:

```text
Tick at: 1s2ms72us188ns
Tick at: 2s4ms185us160ns
Tick at: 3s6ms275us464ns
Tick at: 4s8ms18us399ns
Tick at: 5s9ms621us394ns
```

### static func repeatDuring(Duration, Duration, Duration, ()->Unit, CatchupStyle)

```cangjie
public static func repeatDuring(period: Duration, delay: Duration, interval: Duration, task: () -> Unit, style!: CatchupStyle = Burst): Timer
```

Function: Sets up and starts a recurring timer task with a specified maximum duration for the repetition period, returning a [Timer](sync_package_classes.md#class-timer) object instance that controls this task.

Parameters:

- period: [Duration](../../../std/core/core_package_api/core_package_structs.md#struct-duration) - The maximum duration of the repetition period, starting after the delay. Valid range: ([Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max)].
``````markdown
- delay: [Duration](../../../std/core/core_package_api/core_package_structs.md#struct-duration) - The time interval from now until the Task is executed. Valid range: [Duration.Min, [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max)]. If less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), the Task will be executed immediately.
- interval: [Duration](../../../std/core/core_package_api/core_package_structs.md#struct-duration) - The time interval between two Task executions. Valid range: ([Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max)].
- task: ()->Unit - The task to be executed periodically.
- style!: [CatchupStyle](./sync_package_enums.md#enum-catchupstyle) - The catch-up strategy, defaulting to Burst. When Task execution takes too long, subsequent task execution times may be delayed. Different catch-up strategies suit different scenarios. See [CatchupStyle](sync_package_enums.md#enum-catchupstyle) for details.

Return value:

- [Timer](sync_package_classes.md#class-timer) - The created object instance.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception): Thrown when period is less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero) or interval is less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero).

Example:

```cangjie
import std.sync.{Timer}
import std.time.{MonoTime}

main() {
    let start = MonoTime.now()
    Timer.repeatDuring(Duration.second * 5, Duration.second, Duration.second, {=>
        println("Tick at: ${MonoTime.now() - start}")
    })

    sleep(Duration.second * 7)
    0
}
```

Execution result:

```text
Tick at: 1s2ms372us626ns
Tick at: 2s4ms714us879ns
Tick at: 3s6ms769us623ns
Tick at: 4s8ms780us235ns
Tick at: 5s660us104ns
Tick at: 6s3ms257us508ns
```

### static func repeatTimes(Int64, Duration, Duration, ()->Unit, CatchupStyle)

```cangjie
public static func repeatTimes(count: Int64, delay: Duration, interval: Duration, task: () -> Unit, style!: CatchupStyle = Burst): Timer
```

Function: Sets up and starts a recurring timer task with a specified maximum execution count for the Task, returning a [Timer](sync_package_classes.md#class-timer) object instance that controls this task.

Parameters:

- count: [Int64](../../../std/core/core_package_api/core_package_intrinsics.md#int64) - The maximum execution count for the Task. Valid range: (0, [Int64](../../core/core_package_api/core_package_intrinsics.md#int64).Max].
- delay: [Duration](../../../std/core/core_package_api/core_package_structs.md#struct-duration) - The time interval from now until the Task is executed. Valid range: [Duration.Min, [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max)]. If less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), the Task will be executed immediately.
- interval: [Duration](../../../std/core/core_package_api/core_package_structs.md#struct-duration) - The time interval between two Task executions. Valid range: ([Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero), [Duration.Max](../../core/core_package_api/core_package_structs.md#static-const-max)].
- task: ()->Unit - The task to be executed periodically.
- style!: [CatchupStyle](./sync_package_enums.md#enum-catchupstyle) - The catch-up strategy, defaulting to Burst. When Task execution takes too long, subsequent task execution times may be delayed. Different catch-up strategies suit different scenarios. See [CatchupStyle](sync_package_enums.md#enum-catchupstyle) for details.

Return value:

- [Timer](sync_package_classes.md#class-timer) - The created object instance.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when [count](../../collection/collection_package_api/collection_package_function.md#func-counttiterablet) <= 0 or interval is less than or equal to [Duration.Zero](../../core/core_package_api/core_package_structs.md#static-const-zero).

Example:

```cangjie
import std.sync.{Timer}
import std.time.{MonoTime}

main() {
    let start = MonoTime.now()
    Timer.repeatTimes(3, Duration.second, Duration.second, {=>
        println("Tick at: ${MonoTime.now() - start}")
    })

    sleep(Duration.second * 4)
    0
}
```

Execution result:

```text
Tick at: 1s2ms855us251ns
Tick at: 2s5ms390us18ns
Tick at: 3s7ms935us552ns
```

### func cancel()

```cangjie
public func cancel(): Unit
```

Function: Cancels this [Timer](sync_package_classes.md#class-timer). The associated Task will no longer be scheduled for execution.

If the associated Task is currently executing when this function is called, the current execution will not be interrupted. This function does not block the current thread. Calling this function multiple times is equivalent to calling it once.

### func hashCode()

```cangjie
public func hashCode(): Int64
```

Function: Gets the hash value of the [Timer](sync_package_classes.md#class-timer) object.

Return value:

- [Int64](../../../std/core/core_package_api/core_package_intrinsics.md#int64) - The object's hash value.

### operator func !=(Timer)

```cangjie
public operator func !=(rhs: Timer): Bool
```

Function: Determines whether the current [Timer](sync_package_classes.md#class-timer) and the [Timer](sync_package_classes.md#class-timer) specified by the parameter `rhs` are not the same instance.

Parameters:

- rhs: [Timer](#class-timer) - Another [Timer](#class-timer) object to compare.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the two [Timer](sync_package_classes.md#class-timer) instances are not the same, otherwise returns `false`.

### operator func ==(Timer)

```cangjie
public operator func ==(rhs: Timer): Bool
```

Function: Determines whether the current [Timer](sync_package_classes.md#class-timer) and the [Timer](sync_package_classes.md#class-timer) specified by the parameter `rhs` are the same instance.

Parameters:

- rhs: [Timer](#class-timer) - Another [Timer](#class-timer) object to compare.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the two [Timer](sync_package_classes.md#class-timer) instances are the same, otherwise returns `false`.
```