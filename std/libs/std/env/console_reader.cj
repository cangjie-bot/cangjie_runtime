










package std.env

import std.io.InputStream
import std.sync.*

const defaultCapacity: Int64 = 32


public class ConsoleReader <: InputStream {
    private static let mutex: Mutex = Mutex()
    private var buffer: Array<Byte> = Array<Byte>(defaultCapacity, repeat: 0) 
    private var endIndex: Int64 = 0
    private var startIndex: Int64 = 0
    /*
     * @noThrow
     */
    init() {}



    @OverflowWrapping
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     */
    public func read(): ?Rune {
        synchronized(mutex) {
            if (endIndex == startIndex && !readFromConsole()) {
                return None
            }

            let (rune, size): (Rune, Int64) = Rune.fromUtf8(buffer, startIndex)
            startIndex += size
            return rune
        }
    }

    
    /*
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func readln(): ?String {
        if (let Some(line) <- readUntil(r'\n')) {
            let size = line.size
            if (line.endsWith("\r\n")) {
                return line[..size - 2]
            } else if (line.endsWith('\n')) {
                return line[..size - 1]
            }
            return line
        }

        return None
    }

    
    /*
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func readToEnd(): ?String {
        return readUntil({_ => false})
    }



    /*
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func readUntil(ch: Rune): ?String {
        return readUntil({it => it == ch})
    }



    /*
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func readUntil(predicate: (Rune) -> Bool): ?String {
        let result: StringBuilder = StringBuilder()
        synchronized(mutex) {
            while (true) {
                if (startIndex >= endIndex && !readFromConsole()) {
                    break
                }

                if (let Some(byteOffset) <- findFirstOf(predicate)) {
                    unsafe { result.appendFromUtf8Unchecked(buffer[startIndex..byteOffset]) }
                    startIndex = byteOffset
                    break
                }

                unsafe { result.appendFromUtf8Unchecked(buffer[startIndex..endIndex]) }
                startIndex = this.endIndex
            }
        }

        return if (result.size == 0) {
            None
        } else {
            result.toString()
        }
    }


    /*
     * @throws IllegalSynchronizationStateException
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func read(arr: Array<Byte>): Int64 {
        let arraySize = arr.size
        synchronized(mutex) {
            while (arraySize > endIndex - startIndex) {
                if (!readFromConsole()) {
                    buffer.copyTo(arr, startIndex, 0, endIndex - startIndex)
                    let ret = endIndex - startIndex
                    startIndex = 0
                    endIndex = 0
                    return ret
                }
            }
            buffer.copyTo(arr, startIndex, 0, arraySize)
            startIndex += arraySize
        }
        return arraySize
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalMemoryException
     */
    private func readFromConsole(): Bool {
        let line: CPointer<StructureString> = unsafe { CJ_CONSOLE_Readline() }
        if (line.isNull()) {
            unsafe { CJ_CONSOLE_ClearstdInerr() }
            return false
        }

        unsafe {
            let ss = line.read()
            try {
                this.append(ss)
            } finally {
                LibC.free(ss.buffer)
                LibC.free(line)
            }
        }

        return true
    }


    /*
     * @noThrow
     */
    private func findFirstOf(predicate: (Rune) -> Bool): ?Int64 {
        var byteOffset = startIndex
        while (byteOffset < endIndex) {
            let (char, len): (Rune, Int64) = Rune.fromUtf8(buffer, byteOffset)
            byteOffset += len
            if (predicate(char)) {
                return byteOffset
            }
        }
        return None
    }

    @OverflowWrapping
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalMemoryException
     */
    unsafe func append(str: StructureString): Unit {
        let itemLen = Int64(str.length)
        this.reserve(itemLen)

        if (itemLen < 32) {
            for (i in 0..itemLen) {
                this.buffer[i + endIndex] = str.buffer.read(i)
            }
            this.endIndex += itemLen
            return
        }

        let data: CPointerHandle<UInt8> = acquireArrayRawData(this.buffer)
        let rc = memcpy_s(data.pointer + endIndex, UIntNative(buffer.size - endIndex), str.buffer,
            UIntNative(itemLen))
        releaseArrayRawData(data)
        if (rc != 0) {
            throw IllegalMemoryException("The memcpy_s failed with error code: ${rc}.")
        }
        this.endIndex += itemLen
    }

    @OverflowThrowing
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func reserve(addition: Int64): Unit {
        let rightRemain = this.buffer.size - this.endIndex
        if (rightRemain >= addition) {
            return
        }
        if (this.startIndex >= addition - rightRemain) {
            this.buffer.copyTo(this.buffer, startIndex, 0, this.endIndex - startIndex)
            this.endIndex -= startIndex
            this.startIndex = 0
            return
        }

        this.grow(this.buffer.size + addition)
    }

    @OverflowWrapping
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func grow(minCapacity: Int64): Unit {
        let oldCapacity = this.buffer.size
        var newCapacity = oldCapacity + (oldCapacity >> 1)
        if (newCapacity < minCapacity) {
            newCapacity = minCapacity
        }

        var itemData = Array<UInt8>(newCapacity, repeat: 0)
        this.buffer.copyTo(itemData, this.startIndex, 0, this.endIndex - this.startIndex)
        this.buffer = itemData
        this.endIndex = this.endIndex - this.startIndex
        this.startIndex = 0
    }
}
