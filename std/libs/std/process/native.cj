







package std.process

@C
struct ProcessInfo {
    let command: CString = CString(CPointer())
    let commandLine: CPointer<CString> = CPointer<CString>()
    let arguments: CPointer<CString> = CPointer<CString>()
    let workingDirectory: CString = CString(CPointer())
    let environment: CPointer<CString> = CPointer<CString>()
}

foreign {
    func CJ_OS_GetProcessHandle(pid: Int32): IntNative

    func CJ_OS_CloseProcessHandle(handle: IntNative): Unit

    func CJ_OS_GetProcessInfoByPid(pid: Int32): CPointer<ProcessInfo>

    func CJ_OS_Terminate(pid: Int32, force: Bool): Int32

    func CJ_OS_GetCurrentPid(): Int32

    func CJ_OS_FreeProcessInfo(processInfo_cp: CPointer<ProcessInfo>): Unit

    func CJ_OS_FreeProcessRtnData(processRtnData_cp: CPointer<ProcessRtnData>): Unit

    func CJ_OS_CreateProcessStartInfo(): CPointer<ProcessStartInfo>

    func CJ_OS_FreeProcessStartInfo(startInfo: CPointer<ProcessStartInfo>): Unit

    func CJ_OS_GetStartTimeFromUnixEpoch(pid: Int32): Int64

    func CJ_OS_GetUserTime(pid: Int32): Int64

    func CJ_OS_GetSystemTime(pid: Int32): Int64

    func CJ_OS_GetProcessAliveStatus(pid: Int32, lastStartTime: Int64): Int8










    @FastNative
    func exit(status: Int32): Unit
}

@When[backend == "cjnative"]
foreign func FiniCJRuntime(): Int64

@When[os != "Windows"]
foreign {
    func CJ_OS_StartProcess(startInfo: CPointer<ProcessStartInfo>): CPointer<ProcessRtnData>

    func CJ_OS_WaitSubProcessExit(pid: Int32): Int64
    func CJ_OS_CloseFile(fd: IntNative): Int64

    func CJ_OS_FileRead(fd: IntNative, buffer: CPointer<Byte>, maxLen: UIntNative): Int64

    func CJ_OS_FileWrite(fd: IntNative, buffer: CPointer<Byte>, maxLen: UIntNative): Bool

    func getenv(name: CString): CString

    func setenv(name: CString, value: CString, overwrite: Int32): Int32

    func unsetenv(name: CString): Int32
}

@When[os != "Windows" && os != "macOS"]
foreign func CJ_OS_GetStartTimeFromBoot(pid: Int32): Int64

@When[os != "Windows"]
@C
struct ProcessStartInfo {
    let _command: CString
    let _arguments: CPointer<CString>
    let _arguments_size: UIntNative
    let _workingDirectory: CString
    let _environment: CPointer<CString>
    let _environment_size: UIntNative
    let _stdIn: IntNative
    let _stdOut: IntNative
    let _stdErr: IntNative

    /*
     * @noThrow
     */
    init(command: CString, arguments: CPointer<CString>, arguments_size: UIntNative, workingDirectory: CString,
        environment: CPointer<CString>, environment_size: UIntNative, stdIn: IntNative, stdOut: IntNative,
        stdErr: IntNative) {
        this._command = command
        this._arguments = arguments
        this._arguments_size = arguments_size
        this._workingDirectory = workingDirectory
        this._environment = environment
        this._environment_size = environment_size
        this._stdIn = stdIn
        this._stdOut = stdOut
        this._stdErr = stdErr
    }
}

@When[os != "Windows"]
@C
struct ProcessRtnData {
    let pid: Int32 = -1
    let stdInHandle: IntNative = INVALID_HANDLE
    let stdOutHandle: IntNative = INVALID_HANDLE
    let stdErrHandle: IntNative = INVALID_HANDLE
    let errCode: Int32 = -1
    let errMessage: CString = CString(CPointer<UInt8>())
}

@When[os == "Windows"]
foreign {
    func CJ_OS_StartProcess(startInfo: CPointer<ProcessStartInfo>): CPointer<ProcessRtnData>

    func CJ_OS_WaitSubProcessExit(handle: IntNative): CPointer<ExitInfo>
    func CJ_OS_GetSystemDirectory(): CString

    func CJ_OS_GetWindowsDirectory(): CString
    func CJ_OS_CloseFile(fd: IntNative): Int64

    func CJ_OS_FileRead(fd: IntNative, buffer: CPointer<Byte>, maxLen: UIntNative): Int64

    func CJ_OS_FileWrite(fd: IntNative, buffer: CPointer<Byte>, maxLen: UIntNative): Bool

    func CJ_OS_GetStdHandle(fd: IntNative): IntNative

    func CJ_OS_OpenFile(): IntNative

    func CJ_OS_GetNulFileHandle(): IntNative

    func CJ_OS_GetEnvVal(envName: CString): CString

    func CJ_OS_SetEnvEntry(envEntry: CString): Int32
}

@When[os == "Windows"]
@C
struct ProcessStartInfo {
    let _programName: CString
    let _commandLine: CString
    let _workingDirectory: CString
    let _environment: CString
    let _stdIn: IntNative
    let _stdOut: IntNative
    let _stdErr: IntNative

    init(programName: CString, commandLine: CString, workingDirectory: CString, environment: CString, stdIn: IntNative,
        stdOut: IntNative, stdErr: IntNative) {
        this._programName = programName
        this._commandLine = commandLine
        this._workingDirectory = workingDirectory
        this._environment = environment
        this._stdIn = stdIn
        this._stdOut = stdOut
        this._stdErr = stdErr
    }
}

@When[os == "Windows"]
@C
struct ProcessRtnData {
    let pid: Int32 = -1
    let handle: IntNative = INVALID_HANDLE
    let stdInHandle: IntNative = INVALID_HANDLE
    let stdOutHandle: IntNative = INVALID_HANDLE
    let stdErrHandle: IntNative = INVALID_HANDLE
    let errCode: Int32 = 0
    let errMessage: CString = CString(CPointer<UInt8>())
}

@When[os == "Windows"]
@C
struct ExitInfo {
    let exitCode: Int64 = -1
    let error: Bool = false
}

foreign func CJ_OS_HomeDir(): CString

@When[os == "Windows"]
func nativeGetEnv(name: CString): Option<String> {
    var res: CString = unsafe { CJ_OS_GetEnvVal(name) }
    if (res.isNull()) {
        return None
    }
    try {
        return res.toString()
    } finally {
        unsafe { LibC.free(res) }
    }
}

@When[os != "Windows"]
/*
 * @noThrow
 */
func nativeGetEnv(name: CString): Option<String> {
    if (name.isNull()) {
        return None
    }

    var res: CString = unsafe { getenv(name) }
    if (res.isNull()) {
        return None
    } else {
        var resStr: String = res.toString()
        return resStr
    }
}

@When[os != "Windows"]
/*
 * @noThrow
 */
func nativeSetEnv(name: CString, value: CString, overwrite: Int32): Int32 {
    return unsafe { setenv(name, value, overwrite) }
}

@When[os == "Windows"]
func nativeSetEnv(name: CString, value: CString, _: Int32): Int32 {
    var envstr: CString = unsafe { LibC.mallocCString(name.toString() + "=" + value.toString()) }
    let ret = unsafe { CJ_OS_SetEnvEntry(envstr) }
    unsafe { LibC.free(envstr) }
    return ret
}

@When[os != "Windows"]
/*
 * @noThrow
 */
func nativeRemoveEnv(name: CString): Int32 {
    return unsafe { unsetenv(name) }
}

@When[os == "Windows"]
func nativeRemoveEnv(name: CString): Int32 {
    var envstr: CString = unsafe { LibC.mallocCString(name.toString() + "=") }
    let ret = unsafe { CJ_OS_SetEnvEntry(envstr) }
    unsafe { LibC.free(envstr) }
    return ret
}

@When[backend == "cjnative"]
@FastNative
foreign func CJ_MRT_GetCommandLineArgs(): CPointer<CPointer<UInt8>>

@FastNative
foreign func strlen(str: CPointer<UInt8>): UIntNative
