







package std.process

import std.fs.*
import std.collection.*
import std.io.*
import std.time.*

const MAX_TIMEOUT_NS: Int64 = 0x7FFF_FFFF_FFFF_FFFF
const PROCESS_STATUS_ALIVE: Int8 = 0
const PROCESS_STATUS_NOT_EXIST: Int8 = -1
const PROCESS_STATUS_PID_REUSED: Int8 = -2
const TIME_SECOND_TO_MILLISECOND: Int64 = 1000
const TIME_MILLISECOND_TO_NANOSECOND: Int64 = 1_000_000
let MAX_TIMEOUT_DURATION: Duration = Duration.nanosecond * MAX_TIMEOUT_NS

public open class Process {
    var _pid: Int64 = -1
    var _handle: IntNative = INVALID_HANDLE
    var _name: ?String = ""
    var _command: ?String = ""
    var _arguments: ?Array<String> = Array<String>()
    var _commandLine: ?Array<String> = Array<String>()
    var _workingDirectory: ?Path = Path("")
    var _environment: ?Map<String, String> = HashMap<String, String>()
    var _startTimeSinceUnixEpoch: Int64 = 0
    var _startTime: Int64 = 0












    /*
     * @noThrow
     */
    init(pid: Int64, name: ?String, command: ?String, arguments: ?Array<String>, commandLine: ?Array<String>,
        workingDirectory: ?Path, environment: ?Map<String, String>) {
        this._pid = pid
        this._name = name
        this._command = command
        this._arguments = arguments
        this._commandLine = commandLine
        this._workingDirectory = workingDirectory
        this._environment = environment
        this._startTimeSinceUnixEpoch = unsafe { CJ_OS_GetStartTimeFromUnixEpoch(Int32(pid)) }
        this._startTime = getProcessStartTime(Int32(pid))
    }



    @Deprecated[message: "CurrentProcess has been marked as deprecated, use related global functions in the std.env instead."]
    public static prop current: CurrentProcess {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ProcessException
         */
        get() {
            return buildCurrentProcess()
        }
    }

    public prop pid: Int64 {
        /*
         * @noThrow
         */
        get() {
            this._pid
        }
    }

    public prop name: String {
        /*
         * @throws ProcessException
         */
        get() {
            this._name ?? throw ProcessException("Can not get process name.")
        }
    }

    public prop command: String {
        /*
         * @throws ProcessException
         */
        get() {
            this._command ?? throw ProcessException("Can not get process command.")
        }
    }
    public prop startTime: DateTime {
        /*
         * @throws IndexOutOfBoundsException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         */
        get() {
            return if (this._startTimeSinceUnixEpoch == -1) {
                DateTime.UnixEpoch
            } else {
                let second = this._startTimeSinceUnixEpoch / TIME_SECOND_TO_MILLISECOND
                let nanosecond = (this._startTimeSinceUnixEpoch - (second * TIME_SECOND_TO_MILLISECOND)) *
                    TIME_MILLISECOND_TO_NANOSECOND
                DateTime.ofEpoch(second: second, nanosecond: nanosecond)
            }
        }
    }
    public prop systemTime: Duration {
        /*
         * @noThrow
         */
        get() {
            return unsafe { CJ_OS_GetSystemTime(Int32(this._pid)) } * Duration.millisecond
        }
    }
    public prop userTime: Duration {
        /*
         * @noThrow
         */
        get() {
            return unsafe { CJ_OS_GetUserTime(Int32(this._pid)) } * Duration.millisecond
        }
    }

    @Deprecated
    public open prop arguments: Array<String> {
        /*
         * @throws ProcessException
         */
        get() {
            this._arguments ?? throw ProcessException("Can not get process arguments.")
        }
    }

    @Deprecated[message: "Use global function `public func getCommandLine(): Array<String>` in std.env instead."]
    public prop commandLine: Array<String> {
        /*
         * @throws ProcessException
         */
        get() {
            this._commandLine ?? throw ProcessException("Can not get process commandLine.")
        }
    }

    @Deprecated[message: "Use global function `public func getHomeDirectory(): Path` in std.env instead."]
    public prop workingDirectory: Path {
        /*
         * @throws ProcessException
         */
        get() {
            this._workingDirectory ?? throw ProcessException("Can not get process workingDirectory.")
        }
    }

    @Deprecated[message: "Use global function `public func getVariables(): Array<(String, String)>` in std.env instead."]
    public prop environment: Map<String, String> {
        /*
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ProcessException
         */
        get() {
            this.getEnvironments() ?? throw ProcessException("Can not get process environment.")
        }
    }




    @Deprecated[message: "Use global function `public func findProcess(pid: Int64): Process` instead."]
    /*
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     * @throws IllegalArgumentException
     */
    public static func of(pid: Int64): Process {
        if (pid > Int64(Int32.Max) || pid < 0) {
            throw IllegalArgumentException("Invaild pid: \"${pid}\", can not get process.")
        }

        return buildProcess(Int32(pid))
    }












    @Deprecated[message: "Use global function `public func launch(command: String, arguments: Array<String>, workingDirectory!: ?Path = None, environment!: ?Map<String, String> = None, stdIn!: ProcessRedirect = Inherit, stdOut!: ProcessRedirect = Inherit, stdErr!: ProcessRedirect = Inherit): SubProcess` instead."]
    /*
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalMemoryException
     * @throws FSException
     * @throws ProcessException
     * @throws IllegalArgumentException
     */
    public static func start(command: String, arguments: Array<String>, workingDirectory!: ?Path = None,
        environment!: ?Map<String, String> = None, stdIn!: ProcessRedirect = Inherit,
        stdOut!: ProcessRedirect = Inherit, stdErr!: ProcessRedirect = Inherit): SubProcess {
        var std_redirects: Array<ProcessRedirect> = [stdIn, stdOut, stdErr]
        if (command.contains("\0")) {
            throw IllegalArgumentException("Command \"${command}\" cannot contains null character.")
        }

        for (arg in arguments) {
            if (arg.contains("\0")) {
                throw IllegalArgumentException("Argument \"${arg}\" cannot contains null character.")
            }
        }

        if (let Some(envMap) <- environment) {
            for (envEntry in envMap) {
                if (envEntry[0].contains("\0") || envEntry[0].contains("=") || envEntry[1].contains("\0")) {
                    throw IllegalArgumentException(
                        "Environment \"${envEntry[0]}\" entry cannot contains invalid character.")
                }
            }
        }

        if (let Some(dir) <- workingDirectory) {
            try {
                if (!FileInfo(dir).isDirectory()) {
                    throw IllegalArgumentException("WorkingDirectory \"${dir}\" must be directory.")
                }
            } catch (_: FSException) {
                throw IllegalArgumentException("WorkingDirectory \"${dir}\" not exist in the file system.")
            }
        }

        if (getNulFileHandle().isNone() && hasDiscardMode(std_redirects)) {
            throw IllegalArgumentException("Failed to open null file, can not redirect stdio to discard mode.")
        }
        let workingDir_c: CString = match (workingDirectory) {
            case Some(dir) => unsafe { LibC.mallocCString(dir.toString()) }
            case _ => CString(CPointer())
        }

        return try {
            buildSubProcess(command, arguments, workingDir_c, environment, std_redirects)
        } finally {
            unsafe {
                workingDir_c.asResource().close()
            }
        }
    }



    @Deprecated[message: "Use global function `public func execute(command: String, arguments: Array<String>, workingDirectory!: ?Path = None, environment!: ?Map<String, String> = None, stdIn!: ProcessRedirect = Inherit, stdOut!: ProcessRedirect = Inherit, stdErr!: ProcessRedirect = Inherit, timeout!: ?Duration = None): Int64` instead."]
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws TimeoutException
     * @throws FSException
     * @throws ArithmeticException
     * @throws ProcessException
     */
    public static func run(command: String, arguments: Array<String>, 
            workingDirectory!: ?Path = None, 
            environment!: ?Map<String, String> = None, 
            stdIn!: ProcessRedirect = Inherit, 
            stdOut!: ProcessRedirect = Inherit, 
            stdErr!: ProcessRedirect = Inherit, 
            timeout!: ?Duration = None): Int64 {
        let subProcess: SubProcess = start(command, arguments, 
                workingDirectory: workingDirectory, environment: environment, 
                stdIn: stdIn, stdOut: stdOut, stdErr: stdErr)
        return subProcess.wait(timeout: timeout)
    }



    @Deprecated[message: "Use global function `public func executeWithOutput(command: String, arguments: Array<String>, workingDirectory!: ?Path = None, environment!: ?Map<String, String> = None, stdIn!: ProcessRedirect = Inherit, stdOut!: ProcessRedirect = Pipe, stdErr!: ProcessRedirect = Pipe): (Int64, Array<Byte>, Array<Byte>)` instead."]
    /*
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws TimeoutException
     * @throws FSException
     * @throws ArithmeticException
     * @throws ProcessException
     */
    public static func runOutput(command: String, arguments: Array<String>, workingDirectory!: ?Path = None,
        environment!: ?Map<String, String> = None, stdIn!: ProcessRedirect = Inherit, stdOut!: ProcessRedirect = Pipe,
        stdErr!: ProcessRedirect = Pipe): (Int64, Array<Byte>, Array<Byte>) {
        let subProcess: SubProcess = start(command, arguments, workingDirectory: workingDirectory,
            environment: environment, stdIn: stdIn, stdOut: stdOut, stdErr: stdErr)
        return subProcess.waitOutput()
    }




    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     */
    static func buildCurrentProcess(): CurrentProcess {
        let current_pid: Int32 = unsafe { CJ_OS_GetCurrentPid() }
        let processInfo_cp: CPointer<ProcessInfo> = unsafe { CJ_OS_GetProcessInfoByPid(current_pid) }
        if (processInfo_cp.isNull()) {
            throw ProcessException("Initialize current process failed.")
        }

        let processInfo: ProcessInfo = unsafe { processInfo_cp.read() }
        try {
            let (command, name, workDirPath, arguments, commandLine, environments) = getProcessInfo(processInfo)
            let process = CurrentProcess(Int64(current_pid), name, command, arguments, commandLine, workDirPath,
                environments)
            process._handle = unsafe { CJ_OS_GetProcessHandle(current_pid) }
            return process
        } finally {
            unsafe { CJ_OS_FreeProcessInfo(processInfo_cp) }
        }
    }






    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     */
    static func buildProcess(pid: Int32): Process {
        let processInfo_cp: CPointer<ProcessInfo> = unsafe { CJ_OS_GetProcessInfoByPid(pid) }
        if (processInfo_cp.isNull()) {
            throw ProcessException("Process \"${pid}\" not alive, can not get process.")
        }
        let processInfo: ProcessInfo = unsafe { processInfo_cp.read() }
        try {
            let (command, name, workDirPath, arguments, commandLine, environments) = getProcessInfo(processInfo)
            let process = PidProcess(Int64(pid), name, command, arguments, commandLine, workDirPath, environments)
            process._handle = unsafe { CJ_OS_GetProcessHandle(pid) }
            return process
        } finally {
            unsafe { CJ_OS_FreeProcessInfo(processInfo_cp) }
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func getEnvironments(): ?Map<String, String> {
        let processInfoC: CPointer<ProcessInfo> = unsafe { CJ_OS_GetProcessInfoByPid(Int32(this._pid)) }
        if (processInfoC.isNull()) {
            return None
        }

        try {
            let processInfo: ProcessInfo = unsafe { processInfoC.read() }
            return getEnvirments(processInfo.environment)
        } finally {
            unsafe { CJ_OS_FreeProcessInfo(processInfoC) }
        }
    }

    /*
     * @noThrow
     */
    public func isAlive(): Bool {
        return unsafe { CJ_OS_GetProcessAliveStatus(Int32(this._pid), this._startTime) == PROCESS_STATUS_ALIVE }
    }











    /*
     * @throws ProcessException
     * @throws IllegalArgumentException
     */
    public func terminate(force!: Bool = false): Unit {
        if (this._pid > Int64(Int32.Max) || this._pid < 0) {
            throw IllegalArgumentException("Invaild pid, \"${this._pid}\".")
        }

        terminateAliveProcess(Int32(this._pid), force)
    }









    /*
     * @throws ProcessException
     */
    protected open func terminateAliveProcess(pid: Int32, force: Bool): Unit {
        let processStatus: Int8 = unsafe { CJ_OS_GetProcessAliveStatus(pid, this._startTime) }
        if (processStatus == PROCESS_STATUS_ALIVE) {
            unsafe { CJ_OS_Terminate(Int32(pid), force) }
            return
        }

        if (processStatus == PROCESS_STATUS_PID_REUSED) {
            throw ProcessException("Process pid \"${pid}\" has been reused, not allow kill the new process.")
        }

        throw ProcessException("Process pid \"${pid}\" not exist, not allow kill process.")
    }

    /*
     * @noThrow
     */
    static func hasDiscardMode(std_redirects: Array<ProcessRedirect>): Bool {
        for (stdio in std_redirects) {
            if (let ProcessRedirect.Discard <- stdio) {
                return true
            }
        }
        return false
    }
}

class PidProcess <: Process {
    /*
     * @noThrow
     */
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
}






public enum ProcessRedirect {
    | Inherit
    | Pipe
      /*
       * @noThrow
       */
    | FromFile(File)
    | Discard
}

enum StdIO {
    | StdIn
    | StdOut
    | StdErr
}

@When[os == "Windows" || os == "macOS"]
func getProcessStartTime(pid: Int32): Int64 {
    return unsafe { CJ_OS_GetStartTimeFromUnixEpoch(pid) }
}

@When[os != "Windows" && os != "macOS"] 
/*
 * @noThrow
 */
func getProcessStartTime(pid: Int32): Int64 {
    return unsafe { CJ_OS_GetStartTimeFromBoot(pid) }
}

/*
 * @throws OutOfMemoryError
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func getProcessInfo(processInfo: ProcessInfo): (Option<String>, Option<String>, Option<Path>, Option<Array<String>>, 
    Option<Array<String>>, Option<Map<String, String>>) {
    let command: ?String = cStringToOption(processInfo.command)
    let name: ?String = getNameFromCommand(command)
    let workDir: ?String = cStringToOption(processInfo.workingDirectory)
    let workDirPath: ?Path = match (workDir) {
        case Some(dir) => Path(dir)
        case _ => None
    }
    let arguments: ?Array<String> = cpointerToArray(processInfo.arguments)
    let commandLine: ?Array<String> = cpointerToArray(processInfo.commandLine)
    let environments: ?Map<String, String> = getEnvirments(processInfo.environment)
    return (command, name, workDirPath, arguments, commandLine, environments)
}

@When[os == "Windows"]
func getExecutablePath(cmdPath: String): ?Path {
    return try {
        let info: FileInfo = FileInfo(cmdPath)
        if (info.canExecute()) {
            info.path
        } else {
            None
        }
    } catch (_: FSException) {
        None
    }
}

@When[os == "Windows"]
func searchExecutableInPaths(command: String, paths: String): ?Path {
    for (path in paths.split(";")) {
        if (let Some(cmd) <- getExecutablePath("${path}\\${command}")) {
            return cmd
        }
    }
    return None
}

@When[os == "Windows"]
func searchExecutableInSystemDirectory(command: String): ?Path {
    try (dir = unsafe { CJ_OS_GetSystemDirectory().asResource() }) {
        if (dir.value.isNull()) {
            return None
        } else {
            return getExecutablePath("${dir.value}\\${command}")
        }
    }
    return None
}

@When[os == "Windows"]
func searchExecutableInWindowsDirectory(command: String): ?Path {
    try (dir = unsafe { CJ_OS_GetWindowsDirectory().asResource() }) {
        return if (dir.value.isNull()) {
            None
        } else {
            getExecutablePath("${dir.value}\\${command}")
        }
    }
    return None
}











@When[os == "Windows"]
func resolveExecutable(command: String, environment: ?Map<String, String>, workingDir: CString): ?Path {
    if (command.size == 0) {
        throw ProcessException("Created process failed, errMessage: \"The parameter is incorrect.\".")
    }

    let has_exe_extention = command.toAsciiLower().endsWith(".exe")
    if (command.contains(":") || command.contains("\\") || command.contains("/")) {
        return if (has_exe_extention) {
            getExecutablePath(command)
        } else {
            getExecutablePath("${command}.exe")
        }
    }
    var newCommand = command
    if (!has_exe_extention) {
        newCommand += ".exe"
    }

    if (let Some(envs) <- environment) {
        if (envs.contains("Path")) {
            if (let Some(path) <- searchExecutableInPaths(newCommand, envs["Path"])) {
                return path
            }
        }
    }

    if (let Some(path) <- getExecutablePath("${workingDir}\\${newCommand}")) {
        return path
    }

    if (let Some(path) <- searchExecutableInSystemDirectory(newCommand)) {
        return path
    }

    if (let Some(path) <- searchExecutableInWindowsDirectory(newCommand)) {
        return path
    }

    try (cStr = unsafe { LibC.mallocCString("Path").asResource() }) {
        let envs: String = nativeGetEnv(cStr.value) ?? ""
        if (let Some(path) <- searchExecutableInPaths(newCommand, envs)) {
            return path
        }
    }

    return None
}

@When[os == "Windows"]
func checkCommandLineLength(command: String, arguments: Array<String>) {
    var length: Int64 = command.size
    let maxLength = Int64(Int16.Max - 1)
    if (length >= maxLength) {
        throw ProcessException("Created process failed, errMessage: \"The filename or extension is too long.\".")
    }

    for (arg in arguments) {
        length += arg.size
        if (length >= maxLength) {
            throw ProcessException("Created process failed, errMessage: \"The filename or extension is too long.\".")
        }
    }
}

@When[os == "Windows"]
func buildSubProcess(command: String, arguments: Array<String>, workingDir_c: CString, environment: ?Map<String, String>,
    std_redirects: Array<ProcessRedirect>): SubProcess {
    checkCommandLineLength(command, arguments)
    let program = match (resolveExecutable(command, environment, workingDir_c)) {
        case Some(programe) => programe.toString()
        case _ => throw ProcessException(
            "Created process failed, errMessage: \"The system cannot find the file specified.\".")
    }
    let subProcess: SubProcess
    var processRtnData_cp: CPointer<ProcessRtnData> = CPointer<ProcessRtnData>()
    var processInfo_cp: CPointer<ProcessInfo> = CPointer<ProcessInfo>()
    var processStartInfo_cp: CPointer<ProcessStartInfo> = CPointer<ProcessStartInfo>()
    var commandLine_c: CStringResource = CString(CPointer()).asResource()
    var envBlock_c: CStringResource = CString(CPointer()).asResource()
    var program_c: CStringResource = CString(CPointer()).asResource()

    try {
        program_c = unsafe { LibC.mallocCString(program).asResource() }
        commandLine_c = buildCommandLine(command, arguments)
        envBlock_c = createEnvironmentBlock(environment)
        let stdIn_fd = matchRedirectFileHandle(std_redirects[0], StdIO.StdIn)
        let stdOut_fd = matchRedirectFileHandle(std_redirects[1], StdIO.StdOut)
        let stdErr_fd = matchRedirectFileHandle(std_redirects[2], StdIO.StdErr)
        let processStartInfo: ProcessStartInfo = ProcessStartInfo(program_c.value, commandLine_c.value, workingDir_c,
            envBlock_c.value, stdIn_fd, stdOut_fd, stdErr_fd)
        processStartInfo_cp = unsafe { CJ_OS_CreateProcessStartInfo() }
        unsafe { processStartInfo_cp.write(processStartInfo) }
        processRtnData_cp = unsafe { CJ_OS_StartProcess(processStartInfo_cp) }
        if (processRtnData_cp.isNull()) {
            throw ProcessException("Created process failed.")
        }

        let processRtnData = unsafe { processRtnData_cp.read() }
        if (processRtnData.errCode != 0) {
            throw ProcessException("Created process failed, errMessage: \"${processRtnData.errMessage}\".")
        }

        processInfo_cp = unsafe { CJ_OS_GetProcessInfoByPid(processRtnData.pid) }
        if (processInfo_cp.isNull()) {
            throw ProcessException("Created process failed.")
        }
        let processInfo = unsafe { processInfo_cp.read() }
        let pid: Int32 = processRtnData.pid
        let (commandInfo, name, workDirPath, argumentsInfo, commandLine, environments) = getProcessInfo(processInfo)
        let (stdInStream, stdOutStream, stdErrStream) = initStdStream(processRtnData)
        subProcess = SubProcess(Int64(pid), name, commandInfo, argumentsInfo, commandLine, workDirPath, environments,
            stdInStream, stdOutStream, stdErrStream)
        subProcess._handle = processRtnData.handle
    } finally {
        if (!program_c.isClosed()) {
            program_c.close()
        }
        if (!commandLine_c.isClosed()) {
            commandLine_c.close()
        }
        if (!envBlock_c.isClosed()) {
            envBlock_c.close()
        }
        unsafe {
            CJ_OS_FreeProcessInfo(processInfo_cp)
            CJ_OS_FreeProcessRtnData(processRtnData_cp)
            CJ_OS_FreeProcessStartInfo(processStartInfo_cp)
        }
    }

    return subProcess
}
@When[os == "Windows"]
func buildCommandLine(command: String, arguments: Array<String>): CStringResource {
    let cmdLineBuilder: StringBuilder = StringBuilder()
    let escapeCommand = escapeArgument(command)
    cmdLineBuilder.append(escapeCommand)
    for (arg in arguments) {
        cmdLineBuilder.append(r' ')
        cmdLineBuilder.append(escapeArgument(arg))
    }

    return unsafe { LibC.mallocCString(cmdLineBuilder.toString()).asResource() }
}

@When[os == "Windows"]
func escapeArgument(arg: String): String {
    if (arg.size == 0) {
        return ""
    }

    var needBackslash: Bool = false
    var hasSpace: Bool = false
    let argRuneArr: Array<Rune> = arg.toRuneArray()
    for (argRune in argRuneArr) {
        if (argRune == r'"' || argRune == r'\\') {
            needBackslash = true
        }

        if (argRune == r' ' || argRune == r'\t') {
            hasSpace = true
        }
    }

    if (!needBackslash && !hasSpace) {
        return arg
    }

    if (!needBackslash && hasSpace) {
        let sb = StringBuilder(r'"')
        sb.append(arg)
        sb.append(r'"')
        return sb.toString()
    }

    var escapeArgBuilder: StringBuilder = StringBuilder()
    var slashCount = 0
    for (argRune in argRuneArr) {
        match (argRune) {
            case r'\\' => slashCount++
            case r'"' =>
                while (slashCount > 0) {
                    escapeArgBuilder.append(r'\\')
                    slashCount--
                }
                escapeArgBuilder.append(r'\\')
            case _ => slashCount = 0
        }
        escapeArgBuilder.append(argRune)
    }

    var escapeArg = escapeArgBuilder.toString()
    if (hasSpace) {
        while (slashCount > 0) {
            escapeArgBuilder.append(r'\\')
            slashCount--
        }
        let sb = StringBuilder(r'"')
        sb.append(escapeArgBuilder)
        sb.append(r'"')
        escapeArg = sb.toString()
    }
    return escapeArg
}

@When[os == "Windows"]
func createEnvironmentBlock(environments: ?Map<String, String>): CStringResource {
    let environmentMap: Map<String, String> = environments ?? return CString(CPointer()).asResource()

    if (environmentMap.isEmpty()) {
        return unsafe { LibC.mallocCString(String.fromUtf8Unchecked([0u8, 0u8])).asResource() }
    }

    let environment_arr: Array<String> = environmentMap |>
        map<(String, String), String> {
        envEntry: (String, String) =>
        let sb = StringBuilder(envEntry[0])
        sb.append(r'=')
        sb.append(envEntry[1])
        sb.append(r'\0')
        sb.toString()
    } |> collectArray
    let envBlockBuilder: StringBuilder = StringBuilder()
    environment_arr |> forEach<String> {
        envElement => envBlockBuilder.append(envElement)
    }
    envBlockBuilder.append(r'\0')
    return unsafe { LibC.mallocCString(envBlockBuilder.toString()).asResource() }
}

/*
 * @noThrow
 */
func initStdStream(processRtnData: ProcessRtnData): (OutputStream, InputStream, InputStream) {
    let stdInStream: OutputStream
    if (processRtnData.stdInHandle == INVALID_HANDLE) {
        stdInStream = NullProcessStream()
    } else {
        stdInStream = ProcessOutputStream(FileDescriptor(processRtnData.stdInHandle))
    }

    let stdOutStream: InputStream
    if (processRtnData.stdOutHandle == INVALID_HANDLE) {
        stdOutStream = NullProcessStream()
    } else {
        stdOutStream = ProcessInputStream(FileDescriptor(processRtnData.stdOutHandle))
    }

    let stdErrStream: InputStream
    if (processRtnData.stdErrHandle == INVALID_HANDLE) {
        stdErrStream = NullProcessStream()
    } else {
        stdErrStream = ProcessInputStream(FileDescriptor(processRtnData.stdErrHandle))
    }

    return (stdInStream, stdOutStream, stdErrStream)
}

@When[os != "Windows"]
/*
 * @throws OutOfMemoryError
 * @throws IndexOutOfBoundsException
 * @throws IllegalMemoryException
 * @throws IllegalArgumentException
 * @throws FSException
 * @throws ProcessException
 */
func buildSubProcess(command: String, arguments: Array<String>, workingDir_c: CString, environment: ?Map<String, String>,
    std_redirects: Array<ProcessRedirect>): SubProcess {
    let cmdArgCombinList: ArrayList<String> = ArrayList<String>.of(command)
    cmdArgCombinList.add(all: arguments)
    var cmdArg_cArr: Array<CString> = cmdArgCombinList |> map {arg: String => unsafe { LibC.mallocCString(arg) }} |>
        collectCStringArray
    var environment_cArr: Array<CString> = Array<CString>()
    try {
        environment_cArr = match (environment) {
            case Some(env) => env |>
                map<(String, String), CString> {
                envEntry: (String, String) =>
                let sb: StringBuilder = StringBuilder(envEntry[0])
                sb.append(r'=')
                sb.append(envEntry[1])
                unsafe { LibC.mallocCString(sb.toString()) }
            } |> collectCStringArray
            case _ => Array<CString>()
        }
    } catch (e: IllegalMemoryException) {
        for (arg_cStr in cmdArg_cArr) {
            unsafe { LibC.free(arg_cStr) }
        }
        throw e
    }

    let cmdArg_cpHandle: CPointerHandle<CString> = unsafe { acquireArrayRawData<CString>(cmdArg_cArr) }
    let environment_cpHandle: CPointerHandle<CString> = unsafe { acquireArrayRawData<CString>(environment_cArr) }
    var environment_pt: CPointer<CString> = CPointer<CString>()
    if (let Some(_) <- environment) {
        environment_pt = environment_cpHandle.pointer
    }
    let subProcess: SubProcess
    var processRtnData_cp: CPointer<ProcessRtnData> = CPointer<ProcessRtnData>()
    var processInfo_cp: CPointer<ProcessInfo> = CPointer<ProcessInfo>()
    var processStartInfo_cp: CPointer<ProcessStartInfo> = CPointer<ProcessStartInfo>()
    var command_c: CString = CString(CPointer<UInt8>())
    try {
        let stdIn_fd = matchRedirectFileHandle(std_redirects[0], StdIO.StdIn)
        let stdOut_fd = matchRedirectFileHandle(std_redirects[1], StdIO.StdOut)
        let stdErr_fd = matchRedirectFileHandle(std_redirects[2], StdIO.StdErr)

        command_c = unsafe { LibC.mallocCString(command) }
        let processStartInfo: ProcessStartInfo = ProcessStartInfo(command_c, cmdArg_cpHandle.pointer,
            UIntNative(cmdArg_cArr.size), workingDir_c, environment_pt, UIntNative(environment_cArr.size), stdIn_fd,
            stdOut_fd, stdErr_fd)
        processStartInfo_cp = unsafe { CJ_OS_CreateProcessStartInfo() }
        unsafe { processStartInfo_cp.write(processStartInfo) }
        processRtnData_cp = unsafe { CJ_OS_StartProcess(processStartInfo_cp) }
        if (processRtnData_cp.isNull()) {
            throw ProcessException("Created process failed.")
        }

        let processRtnData: ProcessRtnData = unsafe { processRtnData_cp.read() }
        if (processRtnData.errCode != 0) {
            throw ProcessException("Created process failed, errMessage: \"${processRtnData.errMessage}\".")
        }

        processInfo_cp = unsafe { CJ_OS_GetProcessInfoByPid(processRtnData.pid) }
        if (processInfo_cp.isNull()) {
            throw ProcessException("Created process failed.")
        }

        let processInfo = unsafe { processInfo_cp.read() }
        let pid: Int32 = processRtnData.pid
        let (commandInfo, name, workDirPath, argumentsInfo, commandLine, environments) = getProcessInfo(processInfo)
        let (stdInStream, stdOutStream, stdErrStream) = initStdStream(processRtnData)
        subProcess = SubProcess(Int64(pid), name, commandInfo, argumentsInfo, commandLine, workDirPath, environments,
            stdInStream, stdOutStream, stdErrStream)
    } catch (e: Exception) {
        if (!processRtnData_cp.isNull()) {
            let processRtnData: ProcessRtnData = unsafe { processRtnData_cp.read() }
            if (processRtnData.pid != 0) {
                unsafe { CJ_OS_WaitSubProcessExit(processRtnData.pid) }
            }
        }
        throw e
    } finally {
        unsafe {
            if (!command_c.isNull()) {
                LibC.free(command_c)
            }
            for (arg_cStr in cmdArg_cArr) {
                LibC.free(arg_cStr)
            }
            releaseArrayRawData<CString>(cmdArg_cpHandle)
            for (env_cStr in environment_cArr) {
                LibC.free(env_cStr)
            }
            releaseArrayRawData<CString>(environment_cpHandle)
            CJ_OS_FreeProcessInfo(processInfo_cp)
            CJ_OS_FreeProcessRtnData(processRtnData_cp)
            CJ_OS_FreeProcessStartInfo(processStartInfo_cp)
        }
    }

    return subProcess
}







/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalMemoryException
 * @throws IllegalArgumentException
 * @throws FSException
 * @throws ProcessException
 */
func matchRedirectFileHandle(redirect: ProcessRedirect, stdio: StdIO): IntNative {
    return match (redirect) {
        case ProcessRedirect.Pipe => INVALID_HANDLE
        case ProcessRedirect.Inherit => match (stdio) {
            case StdIO.StdIn => getStdInHandle()
            case StdIO.StdOut => getStdOutHandle()
            case StdIO.StdErr => getStdErrHandle()
        }
        case ProcessRedirect.Discard =>
            if (let Some(fileHandle) <- getNulFileHandle()) {
                fileHandle
            } else {
                throw ProcessException("Failed to open null file, can not redirect stdio to discard mode.")
            }
        case ProcessRedirect.FromFile(file: File) =>
            if (!exists(file.info.path) || file.isClosed()) {
                throw ProcessException("Redirect file closed or not existed, not allow redirect.")
            }
            file.fileDescriptor.fileHandle
    }
}

/*
 * @throws OutOfMemoryError
 * @throws IndexOutOfBoundsException
 * @throws ProcessException
 * @throws IllegalArgumentException
 */
public func findProcess(pid: Int64): Process {
    if (pid > Int64(Int32.Max) || pid < 0) {
        throw IllegalArgumentException("Invaild pid: \"${pid}\", can not get process.")
    }
    return Process.buildProcess(Int32(pid))
}












/*
 * @throws OutOfMemoryError
 * @throws IndexOutOfBoundsException
 * @throws IllegalMemoryException
 * @throws FSException
 * @throws ProcessException
 * @throws IllegalArgumentException
 */
public func launch(command: String, arguments: Array<String>, workingDirectory!: ?Path = None,
    environment!: ?Map<String, String> = None, stdIn!: ProcessRedirect = Inherit, stdOut!: ProcessRedirect = Inherit,
    stdErr!: ProcessRedirect = Inherit): SubProcess {
    var std_redirects: Array<ProcessRedirect> = [stdIn, stdOut, stdErr]
    if (command.contains("\0")) {
        throw IllegalArgumentException("Command \"${command}\" cannot contains null character.")
    }

    for (arg in arguments) {
        if (arg.contains("\0")) {
            throw IllegalArgumentException("Argument \"${arg}\" cannot contains null character.")
        }
    }

    if (let Some(envMap) <- environment) {
        for (envEntry in envMap) {
            if (envEntry[0].contains("\0") || envEntry[0].contains("=") || envEntry[1].contains("\0")) {
                throw IllegalArgumentException(
                    "Environment \"${envEntry[0]}\" entry cannot contains invalid character.")
            }
        }
    }

    if (let Some(dir) <- workingDirectory) {
        try {
            if (!FileInfo(dir).isDirectory()) {
                throw IllegalArgumentException("WorkingDirectory \"${dir}\" must be directory.")
            }
        } catch (_: FSException) {
            throw IllegalArgumentException("WorkingDirectory \"${dir}\" not exist in the file system.")
        }
    }

    if (getNulFileHandle().isNone() && Process.hasDiscardMode(std_redirects)) {
        throw IllegalArgumentException("Failed to open null file, can not redirect stdio to discard mode.")
    }
    let workingDir_c: CString = match (workingDirectory) {
        case Some(dir) => unsafe { LibC.mallocCString(dir.toString()) }
        case _ => CString(CPointer())
    }

    try {
        return buildSubProcess(command, arguments, workingDir_c, environment, std_redirects)
    } finally {
        unsafe {
            workingDir_c.asResource().close()
        }
    }
}



/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalMemoryException
 * @throws IllegalArgumentException
 * @throws OutOfMemoryError
 * @throws TimeoutException
 * @throws FSException
 * @throws ArithmeticException
 * @throws ProcessException
 */
public func execute(command: String, arguments: Array<String>, workingDirectory!: ?Path = None,
    environment!: ?Map<String, String> = None, stdIn!: ProcessRedirect = Inherit, stdOut!: ProcessRedirect = Inherit,
    stdErr!: ProcessRedirect = Inherit, timeout!: ?Duration = None): Int64 {
    let subProcess: SubProcess = launch(command, arguments, workingDirectory: workingDirectory, environment: environment,
        stdIn: stdIn, stdOut: stdOut, stdErr: stdErr)
    subProcess.wait(timeout: timeout)
}



/*
 * @throws IllegalMemoryException
 * @throws IllegalArgumentException
 * @throws OverflowException
 * @throws IndexOutOfBoundsException
 * @throws OutOfMemoryError
 * @throws TimeoutException
 * @throws FSException
 * @throws ArithmeticException
 * @throws ProcessException
 */
public func executeWithOutput(command: String, arguments: Array<String>, workingDirectory!: ?Path = None,
    environment!: ?Map<String, String> = None, stdIn!: ProcessRedirect = Inherit, stdOut!: ProcessRedirect = Pipe,
    stdErr!: ProcessRedirect = Pipe): (Int64, Array<Byte>, Array<Byte>) {
    let subProcess: SubProcess = launch(command, arguments, workingDirectory: workingDirectory, environment: environment,
        stdIn: stdIn, stdOut: stdOut, stdErr: stdErr)
    subProcess.waitOutput()
}
