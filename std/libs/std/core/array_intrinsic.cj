







package std.core


@Intrinsic
/*
 * @noThrow
 */
func acquireRawData<T>(rawArr: RawArray<T>): CPointer<T> where T <: CType

@Intrinsic
/*
 * @noThrow
 */
func releaseRawData<T>(rawArr: RawArray<T>, ptr: CPointer<T>): Unit where T <: CType

@Intrinsic
/*
 * @noThrow
 */
func intrinsicBuiltInCopyTo<T>(src: RawArray<T>, dst: RawArray<T>, srcStart: Int64, dstStart: Int64, copyLen: Int64): Unit

@Intrinsic
/*
 * @noThrow
 */
func arrayGet<T>(rawArr: RawArray<T>, index: Int64): T

@Intrinsic
/*
 * @noThrow
 */
func arraySet<T>(rawArr: RawArray<T>, index: Int64, element: T): Unit

@Intrinsic
/*
 * @noThrow
 */
func arrayGetUnchecked<T>(rawArr: RawArray<T>, index: Int64): T

@Intrinsic
/*
 * @noThrow
 */
func arraySetUnchecked<T>(rawArr: RawArray<T>, index: Int64, element: T): Unit

@Intrinsic
/*
 * @noThrow
 */
func arraySize<T>(rawArr: RawArray<T>): Int64

@Intrinsic
/*
 * @noThrow
 */
func arrayClone<T>(rawArr: RawArray<T>): RawArray<T>
