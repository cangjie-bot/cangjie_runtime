







package std.core

@Intrinsic
/*
 * @noThrow
 */
func getPointerAddress<T>(c: CPointer<T>): UIntNative where T <: CType

@Intrinsic
/*
 * @noThrow
 */
func readPointer<T>(c: CPointer<T>, idx: Int64): T where T <: CType

@Intrinsic
/*
 * @noThrow
 */
func writePointer<T>(c: CPointer<T>, idx: Int64, value: T): Unit where T <: CType

@Intrinsic
/*
 * @noThrow
 */
func addPointer<T>(c: CPointer<T>, offset: Int64): CPointer<T> where T <: CType

extend<T> CPointer<T> {
    /*
     * @noThrow
     */
    public func isNull(): Bool {
        return getPointerAddress<T>(this) == 0
    }

    /*
     * @noThrow
     */
    public func isNotNull(): Bool {
        return !isNull()
    }

    /*
     * @noThrow
     */
    public func toUIntNative(): UIntNative {
        return getPointerAddress<T>(this)
    }

    @Frozen
    /*
     * @noThrow
     */
    public unsafe func read(): T {
        return read(0)
    }

    @Frozen
    /*
     * @noThrow
     */
    public unsafe func write(value: T): Unit {
        write(0, value)
    }



    @Frozen
    /*
     * @noThrow
     */
    public unsafe func read(idx: Int64): T {
        return readPointer<T>(this, idx)
    }



    @Frozen
    /*
     * @noThrow
     */
    public unsafe func write(idx: Int64, value: T): Unit {
        writePointer<T>(this, idx, value)
    }

    /*
     * @noThrow
     */
    public unsafe operator func +(offset: Int64): CPointer<T> {
        return addPointer<T>(this, offset)
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    public unsafe operator func -(offset: Int64): CPointer<T> {
        return addPointer<T>(this, (-1) * offset)
    }

    /*
     * @noThrow
     */
    public func asResource(): CPointerResource<T> {
        return CPointerResource(this)
    }
}

public struct CPointerResource<T> <: Resource where T <: CType {
    public let value: CPointer<T>
    private let isFree: Box<Bool> = Box(false)

    /*
     * @noThrow
     */
    init(p: CPointer<T>) {
        this.value = p
    }

    /*
     * @noThrow
     */
    public func isClosed(): Bool {
        return isFree.value
    }

    /*
     * @noThrow
     */
    public func close(): Unit {
        if (isFree.value) {
            return
        }
        unsafe { LibC.free<T>(value) }
        isFree.value = true
    }
}
