










package std.console

import std.io.OutputStream
import std.sync.*

foreign func CJ_CONSOLE_Write(fd: Int32, c: CPointer<UInt8>, len: Int64, newLine: Bool): Unit

foreign func CJ_CONSOLE_Flush(fd: Int32): Unit

@Deprecated[message: "This class migrate to the std.env."]
public class ConsoleWriter <: OutputStream {
    private let mutex: ReentrantMutex = ReentrantMutex()

    
    private let bufferSize: Int64 = 512

    
    private let buffer_: Array<UInt8> = Array<UInt8>(this.bufferSize, repeat: 0)

    private let fd_: Int32


    init(fd: Int32) {
        this.fd_ = fd
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func flush(): Unit {
        synchronized(mutex) {
            unsafe { CJ_CONSOLE_Flush(this.fd_) }
        }
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func write(buffer: Array<Byte>): Unit {
        synchronized(mutex) {
            directWrite(buffer, buffer.size)
        }
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(buffer: Array<Byte>): Unit {
        synchronized(mutex) {
            directWrite(buffer, buffer.size, newline: true)
        }
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: String): Unit {
        if (v.isEmpty()) {
            return
        }
        write(unsafe { v.rawData() })
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func write<T>(v: T): Unit where T <: ToString {
        write(v.toString())
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Bool): Unit {
        write(if (v) {
            "true"
        } else {
            "false"
        })
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Int8): Unit {
        write(Int64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Int16): Unit {
        write(Int64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Int32): Unit {
        write(Int64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Int64): Unit {
        writeInt64(v, newline: false)
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func write(v: UInt8): Unit {
        write(UInt64(v))
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func write(v: UInt16): Unit {
        write(UInt64(v))
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func write(v: UInt32): Unit {
        write(UInt64(v))
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func write(v: UInt64): Unit {
        writeUInt64(v, newline: false)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Float16): Unit {
        write(Float64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Float32): Unit {
        write(Float64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Float64): Unit {
        writeFloat64(v, newline: false)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public func write(v: Rune): Unit {
        var itemBytes: Array<UInt8> = Array<UInt8>(6, repeat: 0)
        let len = Rune.intoUtf8Array(v, itemBytes, 0)
        write(itemBytes[..len])
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: String): Unit {
        writeln(unsafe { v.rawData() })
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func writeln<T>(v: T): Unit where T <: ToString {
        writeln(v.toString())
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Bool): Unit {
        writeln(if (v) {
            "true"
        } else {
            "false"
        })
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Int8): Unit {
        writeln(Int64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Int16): Unit {
        writeln(Int64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Int32): Unit {
        writeln(Int64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Int64): Unit {
        writeInt64(v, newline: true)
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: UInt8): Unit {
        writeln(UInt64(v))
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: UInt16): Unit {
        writeln(UInt64(v))
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: UInt32): Unit {
        writeln(UInt64(v))
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    public func writeln(v: UInt64): Unit {
        writeUInt64(v, newline: true)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Float16): Unit {
        writeln(Float64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Float32): Unit {
        writeln(Float64(v))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Float64): Unit {
        writeFloat64(v, newline: true)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public func writeln(v: Rune): Unit {
        var itemBytes: Array<UInt8> = Array<UInt8>(6, repeat: 0)
        let len = Rune.intoUtf8Array(v, itemBytes, 0)
        writeln(itemBytes[..len])
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    private func writeInt64(v: Int64, newline!: Bool = false): Unit {
        synchronized(mutex) {
            var writePos: Int64
            unsafe {
                let cp = acquireArrayRawData(this.buffer_)
                writePos = CJ_BUFFER_Int64ToCPointer(v, cp.pointer, this.bufferSize)
                releaseArrayRawData(cp)
            }
            if (newline) {
                this.buffer_[writePos] = b'\n'
                writePos++
            }
            directWrite(this.buffer_, writePos)
        }
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     */
    private func writeUInt64(v: UInt64, newline!: Bool = false): Unit {
        synchronized(mutex) {
            var writePos: Int64
            unsafe {
                let cp = acquireArrayRawData(this.buffer_)
                writePos = CJ_BUFFER_UInt64ToCPointer(v, cp.pointer, this.bufferSize)
                releaseArrayRawData(cp)
            }
            if (newline) {
                this.buffer_[writePos] = b'\n'
                writePos++
            }
            directWrite(this.buffer_, writePos)
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    private func writeFloat64(v: Float64, newline!: Bool = false): Unit {
        synchronized(mutex) {
            var writePos: Int64
            unsafe {
                let cp = acquireArrayRawData(this.buffer_)
                writePos = CJ_BUFFER_Float64ToCPointer(v, cp.pointer, this.bufferSize)
                releaseArrayRawData(cp)
            }
            if (newline) {
                this.buffer_[writePos] = b'\n'
                writePos++
            }
            directWrite(this.buffer_, writePos)
        }
    }










    private func directWrite(arr: Array<UInt8>, cnt: Int64, newline!: Bool = false): Int64 {
        unsafe {
            var pos: Int64 = 0
            var ptr = acquireArrayRawData(arr)

            while (cnt - pos >= Int64(Int32.Max)) {
                CJ_CONSOLE_Write(this.fd_, ptr.pointer + pos, Int64(Int32.Max), false)
                pos += Int64(Int32.Max)
            }

            CJ_CONSOLE_Write(this.fd_, ptr.pointer + pos, cnt - pos, newline)
            releaseArrayRawData(ptr)
        }
        return cnt
    }
}
