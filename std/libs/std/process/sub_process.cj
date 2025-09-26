







package std.process

import std.collection.*
import std.fs.*
import std.io.*



public class SubProcess <: Process {
    var _stdIn: OutputStream
    var _stdOut: InputStream
    var _stdErr: InputStream

    init(
        pid: Int64,
        name: ?String,
        command: ?String,
        arguments: ?Array<String>,
        commandLine: ?Array<String>,
        workingDirectory: ?Path,
        environment: ?Map<String, String>,
        stdIn: OutputStream,
        stdOut: InputStream,
        stdErr: InputStream
    ) {
        super(pid, name, command, arguments, commandLine, workingDirectory, environment)
        this._stdIn = stdIn
        this._stdOut = stdOut
        this._stdErr = stdErr
    }

    @When[os == "Windows"]
    ~init() {
        if (this._handle != INVALID_HANDLE) {
            unsafe { CJ_OS_CloseProcessHandle(this._handle) }
        }
    }

    public prop stdInPipe: OutputStream {
        get() {
            this._stdIn
        }
    }
    public prop stdOutPipe: InputStream {
        get() {
            this._stdOut
        }
    }
    public prop stdErrPipe: InputStream {
        get() {
            this._stdErr
        }
    }

    @Deprecated[message: "Use `public prop stdErrPipe: InputStream` instead."]
    public prop stdErr: InputStream {
        get() {
            this._stdErr
        }
    }

    @Deprecated[message: "Use `public prop stdOutPipe: InputStream` instead."]
    public prop stdOut: InputStream {
        get() {
            this._stdOut
        }
    }

    @Deprecated[message: "Use `public prop stdInPipe: OutputStream` instead."]
    public prop stdIn: OutputStream {
        get() {
            this._stdIn
        }
    }






    /**
     * @throws TimeoutException
     * @throws ArithmeticException
     * @throws ProcessException
     */
    public func wait(timeout!: ?Duration = None): Int64 {
        let exitCode: Int64 = getWaitExitCode(timeout ?? Duration.Zero, Int32(this.pid), this._handle)
        closeStdStream()
        return exitCode
    }





    /**
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws TimeoutException
     * @throws ArithmeticException
     * @throws ProcessException
     */
    public func waitOutput(): (Int64, Array<Byte>, Array<Byte>) {
        let outStreamFuture: Future<Array<Byte>> = spawn {
            => try {
                let outByteArrStream: ByteBuffer = readToByteBuffer(this._stdOut)
                return readToEnd(outByteArrStream)
            } catch (_: ProcessException) {
                throw ProcessException("OutputStream is invalid, not allow to read.")
            }
        }

        let errStreamFuture: Future<Array<Byte>> = spawn {
            => try {
                let errByteArrStream: ByteBuffer = readToByteBuffer(this._stdErr)
                return readToEnd(errByteArrStream)
            } catch (_: ProcessException) {
                throw ProcessException("ErrorStream is invalid, not allow to read.")
            }
        }

        let outArr: Array<Byte> = outStreamFuture.get()
        let errArr: Array<Byte> = errStreamFuture.get()
        let exitCode: Int64 = getWaitExitCode(Duration.Zero, Int32(this.pid), this._handle)

        closeStdStream()
        return (exitCode, outArr, errArr)
    }

    /**
     * @throws ProcessException
     */
    func closeStdStream(): Unit {
        if (let Some(stdInStream) <- (this._stdIn as ProcessOutputStream)) {
            if (let Some(stdInPipeOutputStream) <- (stdInStream.outputStream as PipeOutputStream)) {
                try {
                    stdInPipeOutputStream.close()
                } finally {
                    stdInStream.outputStream = NullProcessStream()
                }
            }
        }

        if (let Some(stdOutStream) <- (this._stdOut as ProcessInputStream)) {
            if (let Some(stdOutPipeInputStream) <- (stdOutStream.inputStream as PipeInputStream)) {
                try {
                    stdOutPipeInputStream.close()
                } finally {
                    stdOutStream.inputStream = NullProcessStream()
                }
            }
        }

        if (let Some(stdErrStream) <- (this._stdErr as ProcessInputStream)) {
            if (let Some(stdErrPipeInputStream) <- (stdErrStream.inputStream as PipeInputStream)) {
                try {
                    stdErrPipeInputStream.close()
                } finally {
                    stdErrStream.inputStream = NullProcessStream()
                }
            }
        }
    }
}

@When[os == "Windows"]
func getWaitExitCode(timeout: Duration, pid: Int32, handle: IntNative): Int64 {
    let exitCode: Int64
    if (timeout > Duration.Zero) {
        let future: Future<CPointer<ExitInfo>> = spawn {
            => return unsafe { CJ_OS_WaitSubProcessExit(handle) }
        }
        var waitExitInfo_cp: CPointer<ExitInfo> = CPointer<ExitInfo>()
        try {
            waitExitInfo_cp = if (timeout >= MAX_TIMEOUT_DURATION) {
                future.get(MAX_TIMEOUT_DURATION)
            } else {
                future.get(timeout)
            }
            return parseExitInfoPointer(waitExitInfo_cp, pid)
        } finally {
            if (!waitExitInfo_cp.isNull()) {
                unsafe { LibC.free(waitExitInfo_cp) }
            }
        }
    }

    var waitExitInfo_cp: CPointer<ExitInfo> = CPointer<ExitInfo>()
    try {
        waitExitInfo_cp = unsafe { CJ_OS_WaitSubProcessExit(handle) }
        return parseExitInfoPointer(waitExitInfo_cp, pid)
    } finally {
        if (!waitExitInfo_cp.isNull()) {
            unsafe { LibC.free(waitExitInfo_cp) }
        }
    }
}

@When[os == "Windows"]
func parseExitInfoPointer(waitExitInfo_cp: CPointer<ExitInfo>, pid: Int32): Int64 {
    if (waitExitInfo_cp.isNull()) {
        throw ProcessException("Wait subProcess exception, pid: ${pid} not exist.")
    }
    let waitExitInfo: ExitInfo = unsafe { waitExitInfo_cp.read() }
    if (waitExitInfo.error) {
        throw ProcessException("Wait subProcess exception, pid: ${pid} not exist.")
    }
    return waitExitInfo.exitCode
}

/**
 * @throws ArithmeticException
 * @throws TimeoutException
 */
@When[os != "Windows"]
func getWaitExitCode(timeout: Duration, pid: Int32, handle: IntNative): Int64 {
    return if (timeout > Duration.Zero) {
        let future: Future<Int64> = spawn {
            => return unsafe { CJ_OS_WaitSubProcessExit(pid) }
        }

        if (timeout >= MAX_TIMEOUT_DURATION) {
            future.get(MAX_TIMEOUT_DURATION)
        } else {
            future.get(timeout)
        }
    } else {
        unsafe { CJ_OS_WaitSubProcessExit(pid) }
    }
}
