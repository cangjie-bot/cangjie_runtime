










package std.io



public class BufferedInputStream<T> <: InputStream where T <: InputStream {
    var inputStream: T
    let inBuf: Array<Byte>
    var curPos: Int64 = 0
    var availLen: Int64 = 0




    /**
     * @throws IllegalArgumentException
     */
    public init(input: T) {
        this(input, DEFAULT_BUFFER_CAPACITY)
    }







    /**
     * @throws IllegalArgumentException
     */
    public init(input: T, capacity: Int64) {
        if (capacity <= 0) {
            throw IllegalArgumentException("Invalid capacity size: capacity = ${capacity}.")
        }
        inputStream = input
        inBuf = Array<Byte>(capacity, repeat: 0)
    }

    /**
     * @throws IllegalArgumentException
     */
    public init(input: T, buffer: Array<Byte>) {
        if (buffer.size == 0) {
            throw IllegalArgumentException("The buffer cannot be empty.")
        }
        inputStream = input
        inBuf = buffer
    }







    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func read(buffer: Array<Byte>): Int64 {
        if (availLen == -1) {
            return 0
        }

        var len = buffer.size
        if (len == 0) {
            throw IllegalArgumentException("The buffer cannot be empty: `buffer.size() = 0`!")
        }

        var count = 0
        while (len > 0) {
            if (availLen == 0) {
                fillInBuf()
                if (availLen == -1) {
                    break
                }
            }

            let copyLen = if (availLen <= len) {
                availLen
            } else {
                len
            }

            inBuf.copyTo(buffer, curPos, count, copyLen)
            curPos += copyLen
            availLen -= copyLen
            count += copyLen
            len -= copyLen
        }

        count
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    public func readByte(): ?Byte {
        if (availLen == -1) {
            return None
        }

        if (availLen == 0) {
            fillInBuf()
            if (availLen == -1) {
                return None
            }
        }

        availLen--
        let readByte = inBuf[curPos]
        curPos++

        readByte
    }





    public func reset(input: T): Unit {
        inputStream = input
        curPos = 0
        availLen = 0
    }

    func fillInBuf(): Unit {
        let readNum = inputStream.read(inBuf)
        if (readNum > 0) {
            curPos = 0
            availLen = readNum
        } else {
            availLen = -1
        }
    }
}

extend<T> BufferedInputStream<T> <: Resource where T <: Resource {


    public func close(): Unit {
        inputStream.close()
    }




    public func isClosed(): Bool {
        inputStream.isClosed()
    }
}

extend<T> BufferedInputStream<T> <: Seekable where T <: Seekable {






    public func seek(sp: SeekPosition): Int64 {
        let pos = inputStream.seek(sp)
        curPos = 0
        availLen = 0

        pos
    }


    public prop position: Int64 {
        get() {
            inputStream.seek(Current(0))
        }
    }


    public prop remainLength: Int64 {
        get() {
            let oldPos = inputStream.seek(Current(0))
            let length = inputStream.seek(End(0))
            if (length != oldPos) {
                inputStream.seek(Begin(oldPos))
            }

            length - oldPos
        }
    }


    public prop length: Int64 {
        get() {
            let oldPos = inputStream.seek(Current(0))
            let length = inputStream.seek(End(0))
            if (length != oldPos) {
                inputStream.seek(Begin(oldPos))
            }

            length
        }
    }
}
