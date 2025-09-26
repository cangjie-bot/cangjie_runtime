







package std.process

import std.collection.*
import std.fs.*
import std.io.*
import std.sync.*

const RTN_CODE_MIN_VAL: Int64 = -0x0000_0000_8000_0000
const RTN_CODE_MAX_VAL: Int64 = 0x0000_0000_7fff_ffff

const NULL_BYTE = "\0"
let mtx: Mutex = Mutex()

@When[backend == "cjnative"]
func getCommandLineArgsFromRuntime(): CPointer<CPointer<UInt8>> {
    unsafe {
        let argv = CJ_MRT_GetCommandLineArgs()
        return if (argv.isNull()) {
            argv
        } else {
            argv + 1
        }
    }
}


@Deprecated[message: "Use related global functions in the std.env instead."]
public class CurrentProcess <: Process {
    let _stdIn: InputStream = ProcessInputStream(FileDescriptor(getStdInHandle()))
    let _stdOut: OutputStream = ProcessOutputStream(FileDescriptor(getStdOutHandle()))
    let _stdErr: OutputStream = ProcessOutputStream(FileDescriptor(getStdErrHandle()))

    init(pid: Int64, name: ?String, command: ?String, arguments: ?Array<String>, commandLine: ?Array<String>,
        workingDirectory: ?Path, environment: ?Map<String, String>) {
        super(pid, name, command, arguments, commandLine, workingDirectory, environment)
    }

    @When[os == "Windows"]
    ~init() {
        if (this._handle != INVALID_HANDLE) {
            unsafe { CJ_OS_CloseProcessHandle(this._handle) }
        }
    }

    public prop stdErr: OutputStream {
        get() {
            this._stdErr
        }
    }

    public prop stdOut: OutputStream {
        get() {
            this._stdOut
        }
    }

    public prop stdIn: InputStream {
        get() {
            this._stdIn
        }
    }

        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
    public prop arguments: Array<String> {
        get() {
            this.getArgs()
        }
    }

    public prop homeDirectory: Path {
        get() {
            var homeDir: CString = unsafe { CJ_OS_HomeDir() }
            var dir: Path = Path(homeDir.toString())
            return dir
        }
    }

        /**
         * @throws IllegalMemoryException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         */
    public prop tempDirectory: Path {
        get() {
            var e: Option<String> = getTempDir(this.getEnv("TMPDIR"), this.getEnv("TMP"), this.getEnv("TEMP"),
                this.getEnv("TEMPDIR"))
            return Path(e ?? "/tmp")
        }
    }

    func transOp(opt1: Option<String>, opt2: Option<String>): Option<String> {
        match (opt1) {
            case Some(_) => opt1
            case None => opt2
        }
    }

    func getTempDir(opt1: Option<String>, opt2: Option<String>, opt3: Option<String>, opt4: Option<String>): Option<String> {
        transOp(transOp(transOp(opt1, opt2), opt3), opt4)
    }

    /**
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    public func getEnv(key: String): Option<String> {
        if (key.contains(NULL_BYTE)) {
            throw IllegalArgumentException("The path cannot contain null character!")
        }

        unsafe {
            let ck: CString = LibC.mallocCString(key)
            try {
                return synchronized(mtx) {
                    nativeGetEnv(ck)
                }
            } finally {
                LibC.free(ck)
            }
        }
    }

    /**
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    public func setEnv(k: String, v: String): Unit {
        if (k.contains(NULL_BYTE) || v.contains(NULL_BYTE)) {
            throw IllegalArgumentException("The path cannot contain null character!")
        }

        unsafe {
            try (ck = LibC.mallocCString(k).asResource(), cv = LibC.mallocCString(v).asResource()) {
                synchronized(mtx) {
                    nativeSetEnv(ck.value, cv.value, Int32(1))
                }
            }
        }
    }

    /**
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    public func removeEnv(k: String): Unit {
        if (k.contains(NULL_BYTE)) {
            throw IllegalArgumentException("The path cannot contain null character!")
        }

        unsafe {
            try (ck = LibC.mallocCString(k).asResource()) {
                synchronized(mtx) {
                    nativeRemoveEnv(ck.value)
                }
            }
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func getArgs(): Array<String> {
        let argv = getCommandLineArgsFromRuntime()
        if (argv.isNull()) {
            return Array<String>()
        }

        var argc: Int64 = 0
        while (true) {
            let cstr: CPointer<UInt8> = unsafe { argv.read(argc) }
            if (cstr.isNull()) {
                break
            }
            argc++
        }

        let args: Array<String> = Array<String>(argc, repeat: String())
        for (argIndex in 0..argc) {
            let cstr: CPointer<UInt8> = unsafe { argv.read(argIndex) }

            let cstrLen: Int64 = unsafe { Int64(strlen(cstr)) }
            let arg: Array<UInt8> = Array<UInt8>(cstrLen, repeat: 0)
            for (charIndex in 0..cstrLen) {
                arg[charIndex] = unsafe { UInt8(cstr.read(charIndex)) }
            }
            args[argIndex] = String.fromUtf8(arg)
        }
        return args
    }









    public func atExit(callback: () -> Unit): Unit {
        CJ_CORE_AddAtexitCallback(callback)
    }





    /**
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     */
    public func exit(code: Int64): Nothing {
        var c: Int64 = code
        if (c < RTN_CODE_MIN_VAL) {
            c = RTN_CODE_MIN_VAL
        }
        if (c > RTN_CODE_MAX_VAL) {
            c = RTN_CODE_MAX_VAL
        }
        CJ_CORE_ExecAtexitCallbacks()
        processExit(Int32(c))
    }









    /**
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     */
    protected func terminateAliveProcess(pid: Int32, force: Bool): Unit {
        let status: Int8 = unsafe { CJ_OS_GetProcessAliveStatus(Int32(pid), this._startTime) }
        if (status == PROCESS_STATUS_ALIVE) {
            CJ_CORE_ExecAtexitCallbacks()
            unsafe { CJ_OS_Terminate(Int32(pid), force) }
            return
        }

        if (status == PROCESS_STATUS_PID_REUSED) {
            throw ProcessException("Process pid \"${pid}\" has been reused, not allow kill the new process.")
        }

        throw ProcessException("Process pid \"${pid}\" not exist, not allow kill process.")
    }
}

/**
 * @throws ProcessException
 */
@When[backend == "cjnative"]
func processExit(exitCode: Int32): Nothing {
    unsafe {
        FiniCJRuntime()
        exit(exitCode)
    }

    throw ProcessException("Process is already closed.")
}
