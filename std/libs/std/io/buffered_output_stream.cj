










package std.io



public class BufferedOutputStream<T> <: OutputStream where T <: OutputStream {
    var outputStream: T
    var outBuf: Array<Byte>
    var curPos: Int64





    /**
     * @throws IllegalArgumentException
     */
    public init(output: T) {
        this(output, DEFAULT_BUFFER_CAPACITY)
    }

    /**
     * @throws IllegalArgumentException
     */
    public init(output: T, buffer: Array<Byte>) {
        if (buffer.size == 0) {
            throw IllegalArgumentException("The buffer cannot be empty.")
        }

        outputStream = output
        outBuf = buffer
        curPos = 0
    }







    /**
     * @throws IllegalArgumentException
     */
    public init(output: T, capacity: Int64) {
        if (capacity <= 0) {
            throw IllegalArgumentException("Invalid capacity size: capacity = ${capacity}.")
        }

        outputStream = output
        outBuf = Array<Byte>(capacity, repeat: 0)
        curPos = 0
    }




    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func write(buffer: Array<Byte>): Unit {
        let len = buffer.size
        if (len == 0) {
            return
        }

        let outBufSize = outBuf.size
        if (len >= outBufSize) {
            flushOutBuf()
            outputStream.write(buffer)
            return
        }

        if (len > outBufSize - curPos) {
            flushOutBuf()
        }
        buffer.copyTo(outBuf, 0, curPos, len)
        curPos += len
    }




    /**
     * @throws IndexOutOfBoundsException
     */
    public func writeByte(v: Byte): Unit {
        let outBufSize = outBuf.size
        if (curPos == outBufSize) {
            flushOutBuf()
        }
        outBuf[curPos] = v
        curPos++
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func flushOutBuf(): Unit {
        if (curPos > 0) {
            outputStream.write(outBuf.slice(0, curPos))
            curPos = 0
        }
    }


    /**
     * @throws IndexOutOfBoundsException
     */
    public func flush(): Unit {
        flushOutBuf()
        outputStream.flush()
    }





    /**
     * @throws IndexOutOfBoundsException
     */
    public func reset(output: T): Unit {
        flush()
        outputStream = output
        curPos = 0
    }
}

extend<T> BufferedOutputStream<T> <: Resource where T <: Resource {


    /**
     * @throws IndexOutOfBoundsException
     */
    public func close(): Unit {
        if (!isClosed()) {
            flush()
            outputStream.close()
        }
    }




    public func isClosed(): Bool {
        outputStream.isClosed()
    }
}

extend<T> BufferedOutputStream<T> <: Seekable where T <: Seekable {






    /**
     * @throws IndexOutOfBoundsException
     */
    public func seek(sp: SeekPosition): Int64 {
        this.flush()
        outputStream.seek(sp)
    }


    public prop position: Int64 {
        get() {
            outputStream.seek(Current(0))
        }
    }


    public prop remainLength: Int64 {
        get() {
            let oldPos = outputStream.seek(Current(0))
            let length = outputStream.seek(End(0))
            if (length != oldPos) {
                outputStream.seek(Begin(oldPos))
            }

            length - oldPos
        }
    }


    public prop length: Int64 {
        get() {
            let oldPos = outputStream.seek(Current(0))
            let length = outputStream.seek(End(0))
            if (length != oldPos) {
                outputStream.seek(Begin(oldPos))
            }

            length
        }
    }
}
