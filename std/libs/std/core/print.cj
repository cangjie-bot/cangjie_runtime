







package std.core

/**
 * @throws OutOfMemoryError
 */
@Frozen
public func print(str: String, flush!: Bool = false): Unit {
    unsafe {
        var cp = acquireArrayRawData(str.rawData())
        let ret = CJ_CORE_PrintUTF8(cp.pointer, str.size, false, flush)
        releaseArrayRawData(cp)
        if (ret == -1) {
            throw OutOfMemoryError()
        }
    }
}

@Frozen
public func println(): Unit {
    unsafe {
        CJ_CORE_PrintChar(UInt32(r'\n'), false, false)
    }
}

/**
 * @throws OutOfMemoryError
 */
@Frozen
public func println(str: String): Unit {
    unsafe {
        var cp = acquireArrayRawData(str.rawData())
        let ret = CJ_CORE_PrintUTF8(cp.pointer, str.size, true, false)
        releaseArrayRawData(cp)
        if (ret == -1) {
            throw OutOfMemoryError()
        }
    }
}

/**
 * @throws OutOfMemoryError
 */
@Frozen
public func eprint(str: String, flush!: Bool = true): Unit {
    unsafe {
        var cp = acquireArrayRawData(str.rawData())
        let ret = CJ_CORE_ErrorPrintUTF8(cp.pointer, str.size, false, flush)
        releaseArrayRawData(cp)
        if (ret == -1) {
            throw OutOfMemoryError()
        }
    }
}

/**
 * @throws OutOfMemoryError
 */
@Frozen
public func eprintln(str: String): Unit {
    unsafe {
        var cp = acquireArrayRawData(str.rawData())
        let ret = CJ_CORE_ErrorPrintUTF8(cp.pointer, str.size, true, true)
        releaseArrayRawData(cp)
        if (ret == -1) {
            throw OutOfMemoryError()
        }
    }
}

/**
 * @throws OutOfMemoryError
 */
@Frozen
public func eprint<T>(arg: T, flush!: Bool = false): Unit where T <: ToString {
    eprint(arg.toString(), flush: flush)
}

/**
 * @throws OutOfMemoryError
 */
@Frozen
public func eprintln<T>(arg: T): Unit where T <: ToString {
    eprintln(arg.toString())
}

/**
 * @throws OutOfMemoryError
 */
@Frozen
public func print<T>(arg: T, flush!: Bool = false): Unit where T <: ToString {
    print(arg.toString(), flush: flush)
}

/**
 * @throws OutOfMemoryError
 */
@Frozen
public func println<T>(arg: T): Unit where T <: ToString {
    println(arg.toString())
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
public func readln(): String {
    let ln = readFromConsole()
    if (ln.endsWith("\r\n")) {
        return ln[..ln.size - 2]
    } else if (ln.endsWith('\n')) {
        return ln[..ln.size - 1]
    }
    return ln
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
private func readFromConsole(): String {
    let build: StringBuilder = StringBuilder()
    let line: CPointer<StructureString> = unsafe { CJ_CONSOLE_Readline() }
    if (line.isNull()) {
        unsafe { CJ_CONSOLE_ClearstdInerr() }
        return build.toString()
    }
    let str = unsafe { line.read() }
    var itemLen = Int64(str.length)
    try {
        var buffer: Array<Byte> = Array<Byte>(itemLen, repeat: 0)
        var i: Int64 = 0
        while (i < itemLen) {
            var c = unsafe { str.buffer.read(i) }
            buffer[i] = c
            i++
        }
        build.appendFromUtf8(buffer)
    } finally {
        unsafe {
            LibC.free(str.buffer)
            LibC.free(line)
        }
    }
    return build.toString()
}







@Frozen
public func print(b: Bool, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintBool(b, false, flush) }
}

@Frozen
public func println(b: Bool): Unit {
    unsafe { CJ_CORE_PrintBool(b, true, false) }
}

@Frozen
public func print(c: Rune, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintChar(UInt32(c), false, flush) }
}

@Frozen
public func println(c: Rune): Unit {
    unsafe { CJ_CORE_PrintChar(UInt32(c), true, false) }
}

@Frozen
public func print(f: Float16, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintFloat(Float64(f), false, flush) }
}

@Frozen
public func println(f: Float16): Unit {
    unsafe { CJ_CORE_PrintFloat(Float64(f), true, false) }
}

@Frozen
public func print(f: Float32, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintFloat(Float64(f), false, flush) }
}

@Frozen
public func println(f: Float32): Unit {
    unsafe { CJ_CORE_PrintFloat(Float64(f), true, false) }
}

@Frozen
public func print(f: Float64, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintFloat(f, false, flush) }
}

@Frozen
public func println(f: Float64): Unit {
    unsafe { CJ_CORE_PrintFloat(f, true, false) }
}

@Frozen
public func print(i: Int8, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintSigned(Int64(i), false, flush) }
}

@Frozen
public func print(i: Int16, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintSigned(Int64(i), false, flush) }
}

@Frozen
public func print(i: Int32, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintSigned(Int64(i), false, flush) }
}

@Frozen
public func print(i: Int64, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintSigned(i, false, flush) }
}

@Frozen
public func print(i: UInt8, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintUnsigned(UInt64(i), false, flush) }
}

@Frozen
public func print(i: UInt16, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintUnsigned(UInt64(i), false, flush) }
}

@Frozen
public func print(i: UInt32, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintUnsigned(UInt64(i), false, flush) }
}

@Frozen
public func print(i: UInt64, flush!: Bool = false): Unit {
    unsafe { CJ_CORE_PrintUnsigned(i, false, flush) }
}

@Frozen
public func println(i: Int8): Unit {
    unsafe { CJ_CORE_PrintSigned(Int64(i), true, false) }
}

@Frozen
public func println(i: Int16): Unit {
    unsafe { CJ_CORE_PrintSigned(Int64(i), true, false) }
}

@Frozen
public func println(i: Int32): Unit {
    unsafe { CJ_CORE_PrintSigned(Int64(i), true, false) }
}

@Frozen
public func println(i: Int64): Unit {
    unsafe { CJ_CORE_PrintSigned(i, true, false) }
}

@Frozen
public func println(i: UInt8): Unit {
    unsafe { CJ_CORE_PrintUnsigned(UInt64(i), true, false) }
}

@Frozen
public func println(i: UInt16): Unit {
    unsafe { CJ_CORE_PrintUnsigned(UInt64(i), true, false) }
}

@Frozen
public func println(i: UInt32): Unit {
    unsafe { CJ_CORE_PrintUnsigned(UInt64(i), true, false) }
}

@Frozen
public func println(i: UInt64): Unit {
    unsafe { CJ_CORE_PrintUnsigned(i, true, false) }
}
