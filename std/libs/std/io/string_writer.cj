










package std.io

@FastNative
foreign func memcpy_s(dest: CPointer<UInt8>, destMax: UIntNative, src: CPointer<UInt8>, count: UIntNative): Int32

@FastNative
foreign func CJ_BUFFER_Int64ToCPointer(num: Int64, buf: CPointer<UInt8>, destMax: Int64): Int64

@FastNative
foreign func CJ_BUFFER_UInt64ToCPointer(num: UInt64, buf: CPointer<UInt8>, destMax: Int64): Int64

@FastNative
foreign func CJ_BUFFER_Float64ToCPointer(num: Float64, buf: CPointer<UInt8>, destMax: Int64): Int64

@FastNative
foreign func CJ_CORE_Float64ToCPointer(num: Float64): CPointer<UInt8>

@FastNative
foreign func strlen(str: CPointer<UInt8>): UIntNative



public class StringWriter<T> where T <: OutputStream {
    var outputBOS: BufferedOutputStream<T>


    /*
     * @throws IllegalArgumentException
     */
    public init(output: T) {
        outputBOS = BufferedOutputStream(output)
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func flush(): Unit {
        this.outputBOS.flush()
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func write(v: String): Unit {
        if (v.isEmpty()) {
            return
        }
        this.outputBOS.write(unsafe { v.rawData() })
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func write<T>(v: T): Unit where T <: ToString {
        write(v.toString())
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func write(v: Bool): Unit {
        this.outputBOS.write(if (v) {
            "true".toArray()
        } else {
            "false".toArray()
        })
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: Int8): Unit {
        write(Int64(v))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: Int16): Unit {
        write(Int64(v))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: Int32): Unit {
        write(Int64(v))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: Int64): Unit {
        var cnt: Int64 = if (v >= 0 && v < 10) {
            1
        } else {
            21
        }
        ensureEnoughOutBuf(cnt)

        var res: Int64 = 0
        unsafe {
            let cp = acquireArrayRawData(outputBOS.outBuf)
            res = CJ_BUFFER_Int64ToCPointer(v, cp.pointer + outputBOS.curPos, cnt)
            releaseArrayRawData(cp)
        }

        if (res < 0) {
            throw IOException("Error writing digit ${v}!")
        }
        outputBOS.curPos += res
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    private func ensureEnoughOutBuf(dataSize: Int64): Unit {
        if (dataSize > (outputBOS.outBuf.size - outputBOS.curPos)) {
            outputBOS.flushOutBuf()
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: UInt8): Unit {
        write(UInt64(v))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: UInt16): Unit {
        write(UInt64(v))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: UInt32): Unit {
        write(UInt64(v))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: UInt64): Unit {
        var cnt: Int64 = if (v >= 0 && v < 10) {
            1
        } else {
            21
        }
        ensureEnoughOutBuf(cnt)
        var res: Int64 = 0
        unsafe {
            let cp = acquireArrayRawData(outputBOS.outBuf)
            res = CJ_BUFFER_UInt64ToCPointer(v, cp.pointer + outputBOS.curPos, cnt)
            releaseArrayRawData(cp)
        }
        if (res < 0) {
            throw IOException("Error writing digit ${v}!")
        }
        outputBOS.curPos += res
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: Float16): Unit {
        write(Float64(v))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: Float32): Unit {
        write(Float64(v))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IOException
     */
    public func write(v: Float64): Unit {
        var res: Int64 = 0
        unsafe {
            let p: CPointer<UInt8> = CJ_CORE_Float64ToCPointer(v)
            if (p.isNull()) {
                throw IOException()
            }
            let cpSize = Int64(strlen(p)) + 1
            LibC.free(p)
            ensureEnoughOutBuf(cpSize)

            let cp = acquireArrayRawData(this.outputBOS.outBuf)
            res = CJ_BUFFER_Float64ToCPointer(v, cp.pointer + this.outputBOS.curPos, cpSize)
            releaseArrayRawData(cp)
        }

        if (res < 0) {
            throw IOException("Error writing digit ${v}!")
        }

        this.outputBOS.curPos += res
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func write(v: Rune): Unit {
        ensureEnoughOutBuf(6)
        var res: Int64 = Rune.intoUtf8Array(v, this.outputBOS.outBuf, this.outputBOS.curPos)
        this.outputBOS.curPos += res
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func writeln(): Unit {
        ensureEnoughOutBuf(1)
        this.outputBOS.outBuf[this.outputBOS.curPos] = b'\n'
        this.outputBOS.curPos += 1
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: String): Unit {
        write(v)
        writeln()
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func writeln<T>(v: T): Unit where T <: ToString {
        write(v.toString())
        writeln()
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func writeln(v: Bool): Unit {
        this.outputBOS.write(if (v) {
            "true\n".toArray()
        } else {
            "false\n".toArray()
        })
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: Int8): Unit {
        writeln(Int64(v))
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: Int16): Unit {
        writeln(Int64(v))
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: Int32): Unit {
        writeln(Int64(v))
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: Int64): Unit {
        write(v)
        writeln()
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: UInt8): Unit {
        writeln(UInt64(v))
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: UInt16): Unit {
        writeln(UInt64(v))
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: UInt32): Unit {
        writeln(UInt64(v))
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: UInt64): Unit {
        write(v)
        writeln()
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: Float16): Unit {
        writeln(Float64(v))
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: Float32): Unit {
        writeln(Float64(v))
    }

    /*
     * @throws IOException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: Float64): Unit {
        write(v)
        writeln()
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: Rune): Unit {
        write(v)
        writeln()
    }
}

extend<T> StringWriter<T> <: Resource where T <: Resource {


    /*
     * @throws IndexOutOfBoundsException
     */
    public func close(): Unit {
        outputBOS.close()
    }




    /*
     * @noThrow
     */
    public func isClosed(): Bool {
        outputBOS.isClosed()
    }
}

extend<T> StringWriter<T> <: Seekable where T <: Seekable {






    /*
     * @throws IndexOutOfBoundsException
     */
    public func seek(sp: SeekPosition): Int64 {
        outputBOS.seek(sp)
    }
}
