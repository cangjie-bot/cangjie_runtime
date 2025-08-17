# 接口

## interface ArbitraryRange\<T>

```cangjie
public interface ArbitraryRange<T> where T <: Arbitrary<T> & Comparable<T> {
    static func min(): T
    static func max(): T
    static func arbitraryRange(random: RandomSource, min: T, max: T): Generator<T>
}
```

功能：接口为不同类型提供可以在一定范围内生成值的方法。

### func arbitraryRange(RandomSource, T, T)

```cangjie
func arbitraryRange(random: RandomSource, min: T, max: T): c<T>
```

功能：返回在范围内生成的值。

参数：

- random:[RandomSource](../unittest_prop_test_package_api/unittest_prop_test_package_interfaces.md#interface-randomsource) - 随机数源。
- min: T - 可生成范围的最小值。
- max: T - 可生成范围的最大值。

返回值：

- [Generator](../../unittest_prop_test/unittest_prop_test_package_api/unittest_prop_test_package_interfaces.md#interface-generatort)\<T> - 生成器。

### func max()

```cangjie
func max(): T
```

功能：返回最大值。

返回值：

- T - 最大值。

### func min()

```cangjie
func min(): T
```

功能：返回最小值。

返回值：

- T - 最小值。

## interface Arbitrary\<T>

```cangjie
public interface Arbitrary<T> {
    static func arbitrary(random: RandomSource): Generator<T>
}
```

功能：生成 T 类型随机值的接口。

### static func arbitrary(RandomSource)

```cangjie
static func arbitrary(random: RandomSource): Generator<T>
```

功能：获取生成 T 类型随机值生成器。

参数：

- random: [RandomSource](../../unittest_prop_test/unittest_prop_test_package_api/unittest_prop_test_package_interfaces.md#interface-randomsource) - 随机数。

返回值：

- [Generator](../../unittest_prop_test/unittest_prop_test_package_api/unittest_prop_test_package_interfaces.md#interface-generatort)\<T> - 生成 T 类型随机值生成器。

## interface Generator\<T>

```cangjie
public interface Generator<T> {
    func next(): T
}
```

功能：生成器生成 T 类型的值。

### func next()

```cangjie
func next(): T
```

功能：获取生成出来的 T 类型的值。

返回值：

- T - 生成的 T 类型的值。

## interface IndexAccess

```cangjie
public interface IndexAccess {
    func getElementAsAny(index: Int64): ?Any
}
```

功能：通过索引访问元组元素的实用程序接口。

### func getElementAsAny(Int64)

```cangjie
func getElementAsAny(index: Int64): ?Any
```

功能：通过索引访问元组元素。

参数：

- index: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 索引值。

返回值：

- ?[Any](../../core/core_package_api/core_package_interfaces.md#interface-any) - 元素值。若未获取到则为 `None` 。

## interface RandomSource

```cangjie
public interface RandomSource {
    func nextBool(): Bool
    func nextInt8(): Int8
    func nextInt16(): Int16
    func nextInt32(): Int32
    func nextInt64(): Int64
    func nextInt8(max: Int8): Int8
    func nextInt16(max: Int16): Int16
    func nextInt32(max: Int32): Int32
    func nextInt64(max: Int64): Int64
    func nextUInt8(): UInt8
    func nextUInt16(): UInt16
    func nextUInt32(): UInt32
    func nextUInt64(): UInt64
    func nextUInt8(max: UInt8): UInt8
    func nextUInt16(max: UInt16): UInt16
    func nextUInt32(max: UInt32): UInt32
    func nextUInt64(max: UInt64): UInt64
    func nextFloat16(): Float16
    func nextFloat32(): Float32
    func nextFloat64(): Float64
    func nextGaussianFloat64(mean!: Float64, sigma!: Float64): Float64
    func nextIntNative(): IntNative
    func nextUIntNative(): UIntNative

    func suggestUInt8(): UInt8
    func suggestUInt16(): UInt16
    func suggestUInt32(): UInt32
    func suggestUInt64(): UInt64
    func suggestUIntNative(): UIntNative
    func suggestInt8(): Int8
    func suggestInt16(): Int16
    func suggestInt32(): Int32
    func suggestInt64(): Int64
    func suggestIntNative(): IntNative
    func suggestFloat16(): Float16
    func suggestFloat32(): Float32
    func suggestFloat64(): Float64
    func suggestBool(): Bool
    func suggestRune(): Rune

    func suggestInt64(l: Int64, r: Int64): Int64
    func suggestUInt64(l: UInt64, r: UInt64): UInt64
    func suggestInt32(l: Int32, r: Int32): Int32
    func suggestUInt32(l: UInt32, r: UInt32): UInt32
    func suggestInt16(l: Int16, r: Int16): Int16
    func suggestUInt16(l: UInt16, r: UInt16): UInt16
    func suggestInt8(l: Int8, r: Int8): Int8
    func suggestUInt8(l: UInt8, r: UInt8): UInt8
    func suggestIntNative(l: IntNative, r: IntNative): IntNative
    func suggestUIntNative(l: UIntNative, r: UIntNative): UIntNative
    func suggestFloat64(l: Float64, r: Float64): Float64
    func suggestFloat32(l: Float32, r: Float32): Float32
    func suggestFloat16(l: Float16, r: Float16): Float16
}
```

功能：提供 [Arbitrary](#interface-arbitraryt) 所需的随机生成基础类型数据的能力。

### func nextBool()

```cangjie
public open func nextBool(): Bool
```

功能：获取一个布尔类型的伪随机值。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 一个 [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) 类型的伪随机数。

### func nextFloat16()

```cangjie
public open func nextFloat16(): Float16
```

功能：获取一个 [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) 类型的伪随机数，其范围为 [0.0, 1.0)。

返回值：

- [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) - 一个 [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) 类型的伪随机数。

### func nextFloat32()

```cangjie
public open func nextFloat32(): Float32
```

功能：获取一个 [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) 类型的伪随机数，其范围为 [0.0, 1.0)。

返回值：

- [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) - 一个 [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) 类型的伪随机数。

### func nextFloat64()

```cangjie
public open func nextFloat64(): Float64
```

功能：获取一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型的伪随机数，其范围为 [0.0, 1.0)。

返回值：

- [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) - 一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型的伪随机数。

### func nextGaussianFloat64(Float64, Float64)

```cangjie
public func nextGaussianFloat64(mean!: Float64 = 0.0, sigma!: Float64 = 1.0): Float64
```

功能：获取一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型的符合指定均值与标准差的高斯分布的随机数。

默认获取一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型且符合均值为 0.0 标准差为 1.0 的高斯分布的随机数。其中均值是期望值，可解释为位置参数，决定了分布的位置，标准差可解释为尺度参数，决定了分布的幅度。此函数调用了函数 `nextGaussianFloat64Implement` 得到返回值，所以当子类继承 [Random](../../random/random_package_api/random_package_classes.md#class-random) 并覆写 `nextGaussianFloat64Implement` 函数时，调用子类的该函数将会返回覆写的函数的返回值。

参数：

- mean!: [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) - 均值，默认值 0.0。
- sigma!: [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) - 标准差，默认值 1.0。

返回值：

- [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) - 一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型的随机数。

### func nextInt16()

```cangjie
public open func nextInt16(): Int16
```

功能：获取一个 [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) 类型的伪随机数。

返回值：

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - 一个 [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) 类型的伪随机数。

### func nextInt16(Int16)

```cangjie
public open func nextInt16(upper: Int16): Int16
```

功能：获取一个范围在 [0, `upper`) 的 [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) 类型的伪随机数。

参数：

- upper: [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - 表示生成的伪随机数范围上界（不包括 `upper`），取值范围 (0, [Int16](../../core/core_package_api/core_package_intrinsics.md#int16).Max]。

返回值：

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - 一个 [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) 类型的伪随机数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 `upper` 小于等于 0，抛出异常。

### func nextInt32()

```cangjie
public open func nextInt32(): Int32
```

功能：获取一个 [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) 类型的伪随机数。

返回值：

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - 一个 [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) 类型的伪随机数。

### func nextInt32(Int32)

```cangjie
public open func nextInt32(upper: Int32): Int32
```

功能：获取一个范围在 [0, `upper`) 的 [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) 类型的伪随机数。

参数：

- upper: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - 表示生成的伪随机数范围上界（不包括 `upper`），取值范围 (0, [Int32](../../core/core_package_api/core_package_intrinsics.md#int32).Max]。

返回值：

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - 一个 [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) 类型的伪随机数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 `upper` 小于等于 0，抛出异常。

### func nextInt64()

```cangjie
public open func nextInt64(): Int64
```

功能：获取一个 [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) 类型的伪随机数。

返回值：

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 一个 [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) 类型的伪随机数。

### func nextInt64(Int64)

```cangjie
public open func nextInt64(upper: Int64): Int64
```

功能：获取一个范围在 [0, `upper`) 的 [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) 类型的伪随机数。

参数：

- upper: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 生成的伪随机数范围上界（不包括 `upper`），取值范围 (0, [Int64](../../core/core_package_api/core_package_intrinsics.md#int64).Max]。

返回值：

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 一个 [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) 类型的伪随机数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 `upper` 小于等于 0，抛出异常。

### func nextInt8()

```cangjie
public open func nextInt8(): Int8
```

功能：获取一个 [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) 类型的伪随机数。

返回值：

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - 一个 [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) 类型的伪随机数。

### func nextInt8(Int8)

```cangjie
public open func nextInt8(upper: Int8): Int8
```

功能：获取一个范围在 [0, `upper`) 的 [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) 类型的伪随机数。

参数：

- upper: [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - 生成的伪随机数范围上界（不包括 `upper`），取值范围 (0, [Int8](../../core/core_package_api/core_package_intrinsics.md#int8).Max]。

返回值：

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - 一个 [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) 类型的伪随机数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 `upper` 小于等于 0，抛出异常。

### func nextIntNative()

```cangjie
public func nextIntNative(): IntNative
```

功能：获取一个 [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) 类型的伪随机数。

返回值：

- [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) - 一个 [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) 类型的伪随机数。

### func nextUInt16()

```cangjie
public open func nextUInt16(): UInt16
```

功能：获取一个 [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) 类型的伪随机数。

返回值：

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - 一个 [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) 类型的伪随机数。

### func nextUInt16(UInt16)

```cangjie
public open func nextUInt16(upper: UInt16): UInt16
```

功能：获取一个范围在 [0, `upper`) 的 [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) 类型的伪随机数。

参数：

- upper: [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - 生成的伪随机数范围上界（不包括 `upper`），取值范围 (0, [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16).Max]。

返回值：

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - 一个 [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) 类型的伪随机数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 `upper` 等于 0，抛出异常。

### func nextUInt32()

```cangjie
public open func nextUInt32(): UInt32
```

功能：获取一个 [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) 类型的伪随机数。

返回值：

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - 一个 [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) 类型的伪随机数。

### func nextUInt32(UInt32)

```cangjie
public open func nextUInt32(upper: UInt32): UInt32
```

功能：获取一个范围在 [0, `upper`) 的 [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) 类型的伪随机数。

参数：

- upper: [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - 生成的伪随机数范围上界（不包括 `upper`），取值范围 (0, [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32).Max]。

返回值：

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - 一个 [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) 类型的伪随机数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 `upper` 等于 0，抛出异常。

### func nextUInt64()

```cangjie
public open func nextUInt64(): UInt64
```

功能：获取一个 [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) 类型的伪随机数。

返回值：

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - 一个 [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) 类型的伪随机数。

### func nextUInt64(UInt64)

```cangjie
public open func nextUInt64(upper: UInt64): UInt64
```

功能：获取一个范围在 [0, `upper`) 的 [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) 类型的伪随机数。

参数：

- upper: [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - 生成的伪随机数范围上界（不包括 `upper`），取值范围 (0, [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64).Max]。

返回值：

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - 一个 [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) 类型的伪随机数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 `upper` 等于 0，抛出异常。

### func nextUInt8()

```cangjie
public open func nextUInt8(): UInt8
```

功能：获取一个 [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) 类型的伪随机数。

返回值：

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - 一个 [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) 类型的伪随机数。

### func nextUInt8(UInt8)

```cangjie
public open func nextUInt8(upper: UInt8): UInt8
```

功能：获取一个范围在 [0, `upper`) 的 [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) 类型的伪随机数。

参数：

- upper: [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - 生成的伪随机数范围上界（不包括 `upper`），取值范围 (0, [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8).Max]。

返回值：

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - 一个 [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) 类型的伪随机数。

异常：

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - 如果 `upper` 等于 0，抛出异常。

### func nextUIntNative()

```cangjie
public func nextUIntNative(): UIntNative
```

功能：获取一个 [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) 类型的伪随机数。

返回值：

- [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) - 一个 [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) 类型的伪随机数。

### func suggestBool()

```cangjie
public open func suggestBool(): Bool
```

功能：获取一个布尔类型的伪随机值。

返回值：

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - 一个 [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) 类型的伪随机数。

### func suggestRune()

```cangjie
public open func suggestRune(): Rune
```

功能：获取一个 [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) 类型的伪随机值。

返回值：

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - 一个 [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) 类型的伪随机数。

### func suggestFloat16()

```cangjie
public open func suggestFloat16(): Float16
```

功能：获取一个 [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) 类型的伪随机数，其范围为 [0.0, 1.0)。

返回值：

- [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) - 一个 [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) 类型的伪随机数。

### func suggestFloat32()

```cangjie
public open func suggestFloat32(): Float32
```

功能：获取一个 [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) 类型的伪随机数，其范围为 [0.0, 1.0)。

返回值：

- [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) - 一个 [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) 类型的伪随机数。

### func suggestFloat64()

```cangjie
public open func suggestFloat64(): Float64
```

功能：获取一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型的伪随机数，其范围为 [0.0, 1.0)。

返回值：

- [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) - 一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型的伪随机数。

### func suggestInt16()

```cangjie
public open func suggestInt16(): Int16
```

功能：获取一个 [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) 类型的伪随机数。

返回值：

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - 一个 [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) 类型的伪随机数。

### func suggestInt32()

```cangjie
public open func suggestInt32(): Int32
```

功能：获取一个 [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) 类型的伪随机数。

返回值：

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - 一个 [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) 类型的伪随机数。

### func suggestInt64()

```cangjie
public open func suggestInt64(): Int64
```

功能：获取一个 [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) 类型的伪随机数。

返回值：

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 一个 [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) 类型的伪随机数。

### func suggestInt8()

```cangjie
public open func suggestInt8(): Int8
```

功能：获取一个 [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) 类型的伪随机数。

返回值：

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - 一个 [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) 类型的伪随机数。

### func suggestIntNative()

```cangjie
public func suggestIntNative(): IntNative
```

功能：获取一个 [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) 类型的伪随机数。

返回值：

- [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) - 一个 [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) 类型的伪随机数。

### func suggestUInt16()

```cangjie
public open func suggestUInt16(): UInt16
```

功能：获取一个 [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) 类型的伪随机数。

返回值：

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - 一个 [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) 类型的伪随机数。

### func suggestUInt32()

```cangjie
public open func suggestUInt32(): UInt32
```

功能：获取一个 [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) 类型的伪随机数。

返回值：

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - 一个 [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) 类型的伪随机数。

### func suggestUInt64()

```cangjie
public open func suggestUInt64(): UInt64
```

功能：获取一个 [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) 类型的伪随机数。

返回值：

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - 一个 [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) 类型的伪随机数。

### func suggestUInt8()

```cangjie
public open func suggestUInt8(): UInt8
```

功能：获取一个 [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) 类型的伪随机数。

返回值：

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - 一个 [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) 类型的伪随机数。

### func suggestUIntNative()

```cangjie
public func suggestUIntNative(): UIntNative
```

功能：获取一个 [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) 类型的伪随机数。

返回值：

- [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) - 一个 [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) 类型的伪随机数。

### func suggestInt64(Int64, Int64)

```cangjie
func suggestInt64(l: Int64, r: Int64): Int64
```

功能：获取一个 [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) 类型的伪随机数。

参数：

- l: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 可生成范围的最小值。
- r: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 可生成范围的最大值。

返回值：

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - 一个 [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) 类型的伪随机数。

### func suggestUInt64(UInt64, UInt64)

```cangjie
func suggestUInt64(l: UInt64, r: UInt64): UInt64
```

功能：获取一个 [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64)  类型的伪随机数。

参数：

- l: UInt64 - 可生成范围的最小值。
- r: UInt64 - 可生成范围的最大值。

返回值：

- [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) - 一个 [UInt64](../../core/core_package_api/core_package_intrinsics.md#uint64) 类型的伪随机数。

### func suggestInt32(Int32, Int32)

```cangjie
func suggestInt32(l: Int32, r: Int32): Int32
```

功能：获取一个 [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) 类型的伪随机数。

参数：

- l: Int32 - 可生成范围的最小值。
- r: Int32 - 可生成范围的最大值。

返回值：

- [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - 一个 [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) 类型的伪随机数。

### func suggestUInt32(UInt32, UInt32)

```cangjie
func suggestUInt32(UInt32, UInt32): UInt32
```

功能：获取一个 [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) 类型的伪随机数。

参数：

- l: UInt32 - 可生成范围的最小值。
- r: UInt32 - 可生成范围的最大值。

返回值：

- [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) - 一个 [UInt32](../../core/core_package_api/core_package_intrinsics.md#uint32) 类型的伪随机数。

### func suggestInt16(Int16, Int16)

```cangjie
func suggestInt16(l: Int16, r: Int16): Int16
```

功能：获取一个 [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) 类型的伪随机数。

参数：

- l: Int16 - 可生成范围的最小值。
- r: Int16 - 可生成范围的最大值。

返回值：

- [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) - 一个 [Int16](../../core/core_package_api/core_package_intrinsics.md#int16) 类型的伪随机数。

### func suggestUInt16(UInt16, UInt16): UInt16

```cangjie
func suggestUInt16(l: UInt16, r: UInt16): UInt16
```

功能：获取一个 [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) 类型的伪随机数。

参数：

- l: UInt16 - 可生成范围的最小值。
- r: UInt16 - 可生成范围的最大值。

返回值：

- [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) - 一个 [UInt16](../../core/core_package_api/core_package_intrinsics.md#uint16) 类型的伪随机数。

### func suggestInt8(Int8, Int8): Int8

```cangjie
func suggestInt8(l: Int8, r: Int8): Int8
```

功能：获取一个 [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) 类型的伪随机数。

参数：

- l: Int8 - 可生成范围的最小值。
- r: Int8 - 可生成范围的最大值。

返回值：

- [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) - 一个 [Int8](../../core/core_package_api/core_package_intrinsics.md#int8) 类型的伪随机数。

### func suggestUInt8(UInt8, UInt8): UInt8

```cangjie
func suggestUInt8(l: UInt8, r: UInt8): UInt8
```

功能：获取一个 [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) 类型的伪随机数。

参数：

- l: UInt8 - 可生成范围的最小值。
- r: UInt8 - 可生成范围的最大值。

返回值：

- [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) - 一个 [UInt8](../../core/core_package_api/core_package_intrinsics.md#uint8) 类型的伪随机数。

### func suggestIntNative(IntNative, IntNative): IntNative

```cangjie
func suggestIntNative(l: IntNative, r: IntNative): IntNative
```

功能：获取一个 [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) 类型的伪随机数。

参数：

- l: IntNative - 可生成范围的最小值。
- l: IntNative - 可生成范围的最大值。

返回值：

- [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) - 一个 [IntNative](../../core/core_package_api/core_package_intrinsics.md#intnative) 类型的伪随机数。

### func suggestUIntNative(UIntNative, UIntNative): UIntNative

```cangjie
func suggestUIntNative(l: UIntNative, r: UIntNative): UIntNative
```

功能：获取一个 [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) 类型的伪随机数。

参数：

- l: UIntNative - 可生成范围的最小值。
- l: UIntNative - 可生成范围的最大值。

返回值：

- [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) - 一个 [UIntNative](../../core/core_package_api/core_package_intrinsics.md#uintnative) 类型的伪随机数。

### func suggestFloat64(Float64, Float64): Float64

```cangjie
func suggestFloat64(l: Float64, r: Float64): Float64
```

功能：获取一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型的伪随机数。

参数：

- l: Float64 - 可生成范围的最小值。
- l: Float64 - 可生成范围的最大值。

返回值：

- [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) - 一个 [Float64](../../core/core_package_api/core_package_intrinsics.md#float64) 类型的伪随机数。

### func suggestFloat32(Float32, Float32): Float32

```cangjie
func suggestFloat32(l: Float32, r: Float32): Float32
```

功能：获取一个 [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) 类型的伪随机数。

参数：

- l: Float32 - 可生成范围的最小值。
- l: Float32 - 可生成范围的最大值。

返回值：

- [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) - 一个 [Float32](../../core/core_package_api/core_package_intrinsics.md#float32) 类型的伪随机数。

### func suggestFloat16(Float16, Float16): Float16

```cangjie
func suggestFloat16(l: Float16, r: Float16): Float16
```

功能：获取一个 [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) 类型的伪随机数。

参数：

- l: Float16 - 可生成范围的最小值。
- l: Float16 - 可生成范围的最大值。

返回值：

- [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) - 一个 [Float16](../../core/core_package_api/core_package_intrinsics.md#float16) 类型的伪随机数。

## interface Shrink\<T>

```cangjie
public interface Shrink<T> {
    func shrink(): Iterable<T>
}
```

功能：将 T 类型的值缩减到多个“更小”的值。

### func shrink()

```cangjie
func shrink(): Iterable<T>
```

功能：将该值缩小为一组可能的“较小”值。

返回值：

- [Iterable](../../core/core_package_api/core_package_interfaces.md#interface-iterablee)\<T> - 一组可能的“较小”值的迭代器。