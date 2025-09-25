







package std.io

@FastNative
foreign func CJ_CORE_IndexOfByte(orgStr: CPointer<UInt8>, orgSize: Int64, pat: UInt8): Int64

@FastNative
foreign func CJ_CORE_IndexOfString(
    orgStr: CPointer<UInt8>,
    subStr: CPointer<UInt8>,
    orgSize: Int64,
    subSize: Int64,
    start: Int64
): Int64



public class ByteBuffer <: IOStream & Seekable {
    var myData: Array<Byte>
    var start: Int64
    var _length: Int64

    private static const DEFAULT_CAPACITY: Int64 = 32


    /*
     * @throws IllegalArgumentException
     */
    public init() {
        this(DEFAULT_CAPACITY)
    }






    /*
     * @throws IllegalArgumentException
     */
    public init(capacity: Int64) {
        if (capacity < 0) {
            throw IllegalArgumentException("The capacity must be greater than or equal to 0: ${capacity}.")
        }
        this.myData = Array<Byte>(capacity, repeat: 0)
        this.start = 0
        this._length = 0
    }

    /*
     * @noThrow
     */
    public init(source: Array<Byte>) {
        this.myData = source
        this.start = 0
        this._length = source.size
    }

    /*
     * @noThrow
     */
    private init(bytes: Array<Byte>, start: Int64, length: Int64) {
        this.myData = bytes
        this.start = start
        this._length = length
    }


    public prop capacity: Int64 {
        /*
         * @noThrow
         */
        get() {
            return myData.size
        }
    }


    /*
     * @noThrow
     */
    public func clone(): ByteBuffer {
        let itemDats = myData.clone()
        return ByteBuffer(itemDats, start, _length)
    }


    /*
     * @throws IndexOutOfBoundsException
     */
    public func clear(): Unit {
        for (i in 0..(start + _length)) {
            myData[i] = 0
        }
        start = 0
        _length = 0
    }


    /*
     * @throws IndexOutOfBoundsException
     */
    public func bytes(): Array<Byte> {
        return myData.slice(start, _length)
    }







    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func read(buffer: Array<Byte>): Int64 {
        if (_length == 0) {
            return 0
        }
        let bufSize = buffer.size
        if (bufSize == 0) {
            throw IllegalArgumentException("The buffer is empty.")
        }
        let len = if (_length > bufSize) {
            bufSize
        } else {
            _length
        }
        myData.copyTo(buffer, start, 0, len)
        start += len
        _length -= len
        return len
    }






    /*
     * @throws IndexOutOfBoundsException
     */
    public func readByte(): ?Byte {
        if (_length == 0) {
            return None
        }
        let byteValue = myData[start]
        start++
        _length--
        return byteValue
    }




    @OverflowWrapping
    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func write(buffer: Array<Byte>): Unit {
        let bufSize = buffer.size
        reserve(bufSize)
        if (_length >= 0) {
            buffer.copyTo(myData, 0, start + _length, bufSize)
            _length += bufSize
        } else {
            buffer.copyTo(myData, 0, start, bufSize)
            _length = bufSize
        }
    }




    @OverflowWrapping
    /*
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     */
    public func writeByte(v: Byte): Unit {
        reserve(1)
        if (_length >= 0) {
            myData[start + _length] = v
            _length++
        } else {
            myData[start] = v
            _length = 1
        }
    }

    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func setLength(length: Int64): Unit {
        if (length < 0) {
            throw IllegalArgumentException("The length must be greater than or equal to 0.")
        }

        let size = myData.size

        if (length > size) {
            reserve(length - size)
        } else {
            myData[length..size].fill(0)
            if (start > length) {
                start = length
            }
        }

        _length = length - start
    }







    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func reserve(addition: Int64): Unit {
        if (addition < 0) {
            throw IllegalArgumentException("The additional must be greater than or equal to 0.")
        }

        if (_length >= 0 && myData.size - start - _length >= addition) {
            return
        }

        if (_length < 0 && myData.size - start >= addition) {
            return
        }

        let growSize = if (_length >= 0) {
            checkGrowSize(myData.size, addition)
        } else {
            checkGrowSize(this.start, addition)
        }

        grow(growSize)
    }










    /*
     * @throws IOException
     */
    public func seek(sp: SeekPosition): Int64 {
        let pos: Int64 = match (sp) {
            case Current(offset) => this.start + offset
            case Begin(offset) => offset
            case End(offset) => this.start + this._length + offset
        }

        if (pos < 0) {
            throw IOException("Can't move the position before the beginning of the stream.")
        }

        this._length += this.start - pos
        this.start = pos

        this.start
    }

    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func grow(minCapacity: Int64): Unit {
        let oldCapacity = myData.size
        var newCapacity = checkGrowSize(oldCapacity, (oldCapacity >> 1))
        if (newCapacity < minCapacity) {
            newCapacity = minCapacity
        }

        let itemData = Array<Byte>(newCapacity, repeat: 0)
        myData.copyTo(itemData, 0, 0, start + _length)
        myData = itemData
    }

    /*
     * @throws OverflowException
     */
    private func checkGrowSize(oldSize: Int64, addition: Int64): Int64 {
        try {
            return oldSize + addition
        } catch (_: OverflowException) {
            throw OverflowException(
                "The maximum value for capacity expansion cannot exceed the maximum value of Int64.")
        }
    }
}
