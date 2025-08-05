# Classes

## class CurrentProcess <sup>(deprecated)</sup>

```cangjie
public class CurrentProcess <: Process
```

Functionality: This class represents the current process, inheriting from the [Process](process_package_classes.md#class-process) class, providing operations related to the current process.

Features provided include:

- Mechanism to obtain standard streams (`stdIn`, `stdOut`, `stdErr`) of the current process.
- Mechanism to register callback functions upon process exit.
- Mechanism to terminate the current process with configurable exit status codes.

> **Note:**
>
> This class will be deprecated in future versions.

Parent Type:

- [Process](../process_package_overview.md#class-process)

### prop arguments

```cangjie
public prop arguments: Array<String>
```

Functionality: Returns the argument list of the current process. For example, if the command line is `a.out ab cd ef` where `a.out` is the program name, the returned list contains three elements: ab, cd, ef.

> **Note:**
>
> - When using the C language to call the Cangjie dynamic library via `int SetCJCommandLineArgs(int argc, const char* argv[])`, the first argument will be discarded when retrieving command line arguments through the `arguments` property of the current process.

Type: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[String](../../core/core_package_api/core_package_structs.md#struct-string)>

### prop homeDirectory

```cangjie
public prop homeDirectory: Path
```

Functionality: Gets the path to the home directory.

Type: [Path](../../fs/fs_package_api/fs_package_structs.md#struct-path)

### prop stdErr

```cangjie
public prop stdErr: OutputStream
```

Functionality: Gets the standard error stream of the current process.

Type: [OutputStream](../../io/io_package_api/io_package_interfaces.md#interface-outputstream)

### prop stdIn

```cangjie
public prop stdIn: InputStream
```

Functionality: Gets the standard input stream of the current process.

Type: [InputStream](../../io/io_package_api/io_package_interfaces.md#interface-inputstream)

### prop stdOut

```cangjie
public prop stdOut: OutputStream
```

Functionality: Gets the standard output stream of the current process.

Type: [OutputStream](../../io/io_package_api/io_package_interfaces.md#interface-outputstream)

### prop tempDirectory

```cangjie
public prop tempDirectory: Path
```

Functionality: Gets the path to the temporary directory. Retrieves environment variables `TMPDIR`, `TMP`, `TEMP`, and `TEMPDIR`. If none of these exist, defaults to `/tmp`.

Type: [Path](../../fs/fs_package_api/fs_package_structs.md#struct-path)

### func atExit(() -> Unit)

```cangjie
public func atExit(callback: () -> Unit): Unit
```

Functionality: Registers a callback function to be executed upon process exit.

> **Note:**
>
> Do not use the C language `atexit` function to avoid unexpected issues.

Parameters:

- callback: () ->[Unit](../../core/core_package_api/core_package_intrinsics.md#unit) - The callback function to register.

### func exit(Int64)

```cangjie
public func exit(code: Int64): Nothing
```

Functionality: Terminates the current process immediately with the specified exit status code.

Parameters:

- code: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - The exit status code.

### func getEnv(String)

```cangjie
public func getEnv(k: String): Option<String>
```

Functionality: Gets the value of the specified environment variable.

Parameters:

- k: [String](../../core/core_package_api/core_package_structs.md#struct-string) - The name of the environment variable.

Returns:

- [Option](../../core/core_package_api/core_package_enums.md#enum-optiont)\<[String](../../core/core_package_api/core_package_structs.md#struct-string)> - The value of the specified environment variable.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if parameter `k` contains a null character.

### func removeEnv(String)

```cangjie
public func removeEnv(k: String): Unit
```

Functionality: Removes the specified environment variable.

Parameters:

- k: [String](../../core/core_package_api/core_package_structs.md#struct-string) - The name of the environment variable to remove.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if parameter `k` contains a null character.

### func setEnv(String, String)

```cangjie
public func setEnv(k: String, v: String): Unit
```

Functionality: Sets an environment variable pair. Overwrites existing variables with the same name.

> **Note:**
>
> On Windows, if parameter `v` is an empty string, variable `k` will be removed from the environment.

Parameters:

- k: [String](../../core/core_package_api/core_package_structs.md#struct-string) - The environment variable name.
- v: [String](../../core/core_package_api/core_package_structs.md#struct-string) - The environment variable value.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown if parameters `k` or `v` contain null characters.

## class Process

```cangjie
public open class Process
```

Functionality: This class provides process-related operations.

> **Note:**
>
> Features include:
>
> - Obtaining the current process instance.
> - Binding to a process instance by process ID.
> - Creating child processes with specified inputs.
> - Retrieving process information.
> - Terminating processes with optional force termination.

### static prop current <sup>(deprecated)</sup>

```cangjie
public static prop current: CurrentProcess
```

Functionality: Gets the current process instance.

> **Note:**
>
> This will be deprecated in future versions. Use global functions from the [env](../../env/env_package_overview.md#functions) package instead.

Type: [CurrentProcess](process_package_classes.md#class-currentprocess-deprecated)

### prop arguments <sup>(deprecated)</sup>

```cangjie
public open prop arguments: Array<String>
```

Functionality: Gets process arguments. On Windows, this property cannot be retrieved without privileged APIs.

> **Note:**
>
> This will be deprecated in future versions.

Type: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[String](../../core/core_package_api/core_package_structs.md#struct-string)>

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown if the process doesn't exist, is a zombie process, or when attempting to retrieve arguments in unsupported scenarios on Windows.

### prop command

```cangjie
public prop command: String
```

Functionality: Gets the process command.

Type: [String](../../core/core_package_api/core_package_structs.md#struct-string)

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown if the process doesn't exist, is a zombie process, or the command cannot be retrieved.

### prop commandLine <sup>(deprecated)</sup>

```cangjie
public prop commandLine: Array<String>
```

Functionality: Gets the current process command line. On Windows, this can only retrieve the current process's command line; other scenarios require privileged APIs.

> **Note:**
>
> This will be deprecated in future versions. Use [getcommandline()](../../env/env_package_api/env_package_funcs.md#func-getcommandline) instead.

Type: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[String](../../core/core_package_api/core_package_structs.md#struct-string)>

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown if the process doesn't exist, is a zombie process, or when attempting to retrieve the command line in unsupported scenarios.

### prop environment <sup>(deprecated)</sup>

```cangjie
public prop environment: Map<String, String>
```

Functionality: Gets the current process environment variables. On Windows, this can only retrieve the current process's environment variables; other scenarios require privileged APIs.

> **Note:**
>
> This will be deprecated in future versions. Use [getVariables()](../../env/env_package_api/env_package_funcs.md#func-getvariables) instead.

Type: [Map](../../collection/collection_package_api/collection_package_interface.md#interface-mapk-v)\<[String](../../core/core_package_api/core_package_structs.md#struct-string), [String](../../core/core_package_api/core_package_structs.md#struct-string)>

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown if the process doesn't exist, is a zombie process, or when attempting to retrieve environment variables in unsupported scenarios.

### prop name

```cangjie
public prop name: String
```

Functionality: Gets the process name.

Type: [String](../../core/core_package_api/core_package_structs.md#struct-string)

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown if the process doesn't exist, is a zombie process, or the name cannot be retrieved.

### prop pid

```cangjie
public prop pid: Int64
```

Functionality: Gets the process ID.

Type: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64)

### prop startTime

```cangjie```markdown
public prop startTime: DateTime
```

Function: Gets the process start time. Returns [DateTime.UnixEpoch](../../time/time_package_api/time_package_structs.md#static-prop-unixepoch) on failure.

Type: [DateTime](../../time/time_package_api/time_package_structs.md#struct-datetime)

### prop systemTime

```cangjie
public prop systemTime: Duration
```

Function: Gets the process system time. Returns -1ms on failure.

Type: [Duration](../../core/core_package_api/core_package_structs.md#struct-duration)

### prop userTime

```cangjie
public prop userTime: Duration
```

Function: Gets the process user time. Returns -1ms on failure.

Type: [Duration](../../core/core_package_api/core_package_structs.md#struct-duration)

### prop workingDirectory <sup>(deprecated)</sup>

```cangjie
public prop workingDirectory: Path
```

Function: Gets the process working directory. For `Windows` platform, this property only takes effect for the current process. In other scenarios, this property cannot be obtained under non-privileged `API`.

> **Note:**
>
> Will be deprecated in future versions. Use [getHomeDirectory()](../../env/env_package_api/env_package_funcs.md#func-gethomedirectory) instead.

Type: [Path](../../fs/fs_package_api/fs_package_structs.md#struct-path)

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown when the process does not exist, the corresponding process is a zombie process, or the working directory cannot be obtained in unsupported scenarios on `Windows` platform.

### func isAlive()

```cangjie
public func isAlive(): Bool
```

Function: Returns whether the process is alive.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the process is alive, otherwise `false`.

### static func of(Int64) <sup>(deprecated)</sup>

```cangjie
public static func of(pid: Int64): Process
```

Function: Binds a process instance based on the input process `id`.

> **Note:**
>
> Will be deprecated in future versions. Use [findProcess](./process_package_funcs.md#func-findprocessint64) instead.

Parameters:

- pid: [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - Process `id`.

Return value:

- [Process](process_package_classes.md#class-process) - Returns the process instance corresponding to the process `id`.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when the input process `id` exceeds the maximum value of [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) or is less than `0`.
- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown when memory allocation fails or the process corresponding to `pid` does not exist.

### static func run(String, Array\<String>, ?Path, ?Map\<String, String>, ProcessRedirect, ProcessRedirect,ProcessRedirect, ?Duration) <sup>(deprecated)</sup>

```cangjie
public static func run(command: String,
                      arguments: Array<String>,
                      workingDirectory!: ?Path = None,
                      environment!: ?Map<String, String> = None,
                      stdIn!: ProcessRedirect = Inherit,
                      stdOut!: ProcessRedirect = Inherit,
                      stdErr!: ProcessRedirect = Inherit,
                      timeout!: ?Duration = None): Int64
```

Function: Creates and runs a child process based on input parameters, waits for the child process to complete, and returns the child process exit status.

> **Note:**
>
> - Will be deprecated in future versions. Use [execute](./process_package_funcs.md#func-executestring-arraystring-path-mapstring-string-processredirect-processredirectprocessredirect-duration) instead.
> - On `Windows` platform, immediately deleting the child process executable file after execution may fail with an `Access is denied` exception. If this occurs, retry deleting the file after a short delay. Refer to examples for detailed implementation.

Parameters:

- command: [String](../../core/core_package_api/core_package_structs.md#struct-string) - Specifies the child process command. `command` must not contain null characters.
- arguments: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[String](../../core/core_package_api/core_package_structs.md#struct-string)> - Specifies child process arguments. Strings in `arguments` must not contain null characters.
- workingDirectory!: ?[Path](../../fs/fs_package_api/fs_package_structs.md#struct-path) - Named optional parameter. Specifies the child process working directory. Default inherits the current process working directory. The path must be an existing directory and cannot be empty or contain null characters.
- environment!: ?[Map](../../collection/collection_package_api/collection_package_interface.md#interface-mapk-v)\<[String](../../core/core_package_api/core_package_structs.md#struct-string), [String](../../core/core_package_api/core_package_structs.md#struct-string)> - Named optional parameter. Specifies child process environment variables. Default inherits current process environment variables. `key` must not contain null characters or `'='`, and `value` must not contain null characters.
- stdIn!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard input redirection. Default inherits current process standard input.
- stdOut!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard output redirection. Default inherits current process standard output.
- stdErr!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard error redirection. Default inherits current process standard error.
- timeout!: ?[Duration](../../core/core_package_api/core_package_structs.md#struct-duration) - Named optional parameter. Specifies the timeout for waiting on the child process. Default is no timeout. Setting `timeout` to `0` or negative values means no timeout.

Return value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - Returns the child process exit status. If the child process exits normally, returns the exit code. If killed by a signal, returns the signal number that caused termination.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when `command` contains null characters, or strings in `arguments` contain null characters, or `workingDirectory` is not an existing directory or is empty/contains null characters, or `environment` keys contain null characters or `'='`, or values contain null characters, or when `stdIn`, `stdOut`, `stdErr` are in file mode and the input file is closed/deleted.
- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown when memory allocation fails, or the `command` does not exist, or waiting times out.

### static func runOutput(String, Array\<String>, ?Path, ?Map\<String, String>, ProcessRedirect, ProcessRedirect, ProcessRedirect) <sup>(deprecated)</sup>

```cangjie
public static func runOutput(command: String,
                            arguments: Array<String>,
                            workingDirectory!: ?Path = None,
                            environment!: ?Map<String, String> = None,
                            stdIn!: ProcessRedirect = Inherit,
                            stdOut!: ProcessRedirect = Pipe,
                            stdErr!: ProcessRedirect = Pipe): (Int64, Array<Byte>, Array<Byte>)
```

Function: Creates and runs a child process based on input parameters, waits for completion, and returns the exit status, standard output, and standard error. Not suitable for scenarios with large output streams. For such cases, use the standard stream properties in [SubProcess](process_package_classes.md#class-subprocess) combined with the `wait` function.

> **Note:**
>
> Will be deprecated in future versions. Use [executeWithOutput](./process_package_funcs.md#func-executewithoutputstring-arraystring-path-mapstring-string-processredirect-processredirect-processredirect) instead.

Parameters:

- command: [String](../../core/core_package_api/core_package_structs.md#struct-string) - Specifies the child process command. `command` must not contain null characters.
- arguments: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[String](../../core/core_package_api/core_package_structs.md#struct-string)> - Specifies child process arguments. Strings in `arguments` must not contain null characters.
- workingDirectory!: ?[Path](../../fs/fs_package_api/fs_package_structs.md#struct-path) - Named optional parameter. Specifies the child process working directory. Default inherits the current process working directory. The path must be an existing directory and cannot be empty or contain null characters.
- environment!: ?[Map](../../collection/collection_package_api/collection_package_interface.md#interface-mapk-v)\<[String](../../core/core_package_api/core_package_structs.md#struct-string), [String](../../core/core_package_api/core_package_structs.md#struct-string)> - Named optional parameter. Specifies child process environment variables. Default inherits current process environment variables. `key` must not contain null characters or `'='`, and `value` must not contain null characters.
- stdIn!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard input redirection. Default inherits current process standard input.
- stdOut!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard output redirection. Default inherits current process standard output.
- stdErr!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard error redirection. Default inherits current process standard error.

Return value:

- ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64), [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[Byte](../../core/core_package_api/core_package_types.md#type-byte)>, [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[Byte](../../core/core_package_api/core_package_types.md#type-byte)>) - Returns the child process execution result, including exit status (exit code if normal termination, signal number if killed), standard output, and standard error.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when `command` contains null characters, or strings in `arguments` contain null characters, or `workingDirectory` is not an existing directory or is empty/contains null characters, or `environment` keys contain null characters or `'='`, or values contain null characters, or when `stdIn`, `stdOut`, `stdErr` are in file mode and the input file is closed/deleted.
- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown when memory allocation fails, or the `command` does not exist, or the child process does not exist, or standard stream reading fails.

### static func start(String, Array\<String>, ?Path, ?Map\<String, String>, ProcessRedirect, ProcessRedirect, ProcessRedirect) <sup>(deprecated)</sup>

```cangjie
public static func start(command: String,
                        arguments: Array<String>,
                        workingDirectory!: ?Path = None,
                        environment!: ?Map<String, String> = None,
                        stdIn!: ProcessRedirect = Inherit,
                        stdOut!: ProcessRedirect = Inherit,
                        stdErr!: ProcessRedirect = Inherit): SubProcess
```

Function: Creates and runs a child process based on input parameters and returns a child process instance. After calling this function, you must call `wait` or `waitOutput` to prevent zombie processes from remaining after termination.

> **Note:**
>
> Will be deprecated in future versions. Use [launch](./process_package_funcs.md#func-launchstring-arraystring-path-mapstring-string-processredirect-processredirect-processredirect) instead.

Parameters:

- command: [String](../../core/core_package_api/core_package_structs.md#struct-string) - Specifies the child process command. `command` must not contain null characters.
- arguments: [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[String](../../core/core_package_api/core_package_structs.md#struct-string)> - Specifies child process arguments. Strings in `arguments` must not contain null characters.
- workingDirectory!: ?[Path](../../fs/fs_package_api/fs_package_structs.md#struct-path) - Named optional parameter. Specifies the child process working directory. Default inherits the current process working directory. The path must be an existing directory and cannot be empty or contain null characters.
- environment!: ?[Map](../../collection/collection_package_api/collection_package_interface.md#interface-mapk-v)\<[String](../../core/core_package_api/core_package_structs.md#struct-string), [String](../../core/core_package_api/core_package_structs.md#struct-string)> - Named optional parameter. Specifies child process environment variables. Default inherits current process environment variables. `key` must not contain null characters or `'='`, and `value` must not contain null characters.
- stdIn!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard input redirection. Default inherits current process standard input.
- stdOut!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard output redirection. Default inherits current process standard output.
- stdErr!: [ProcessRedirect](process_package_enums.md#enum-processredirect) - Named optional parameter. Specifies child process standard error redirection. Default inherits current process standard error.

Return value:

- [SubProcess](process_package_classes.md#class-subprocess) - Returns a child process instance.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Thrown when `command` contains null characters, or strings in `arguments` contain null characters, or `workingDirectory` is not an existing directory or is empty/contains null characters, or `environment` keys contain null characters or `'='`, or values contain null characters, or when `stdIn`, `stdOut`, `stdErr` are in file mode and the input file is closed/deleted.
- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown when memory allocation fails or the `command` does not exist.

### func terminate(Bool)

```cangjie
public func terminate(force!: Bool = false): Unit
```

Function: Terminates the process. Returns the child process execution result, including exit status (exit code if normal termination, signal number if killed), standard output, and standard error.

Parameters:

- force!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Named optional parameter. Specifies whether to force terminate the process. Default is `false`. If `false`, the process can terminate after releasing resources. If `true`, the process is killed immediately. On `Windows`, this always forces termination.

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown if the process does not exist or termination is not allowed.

### func terminateAliveProcess(Int32, Bool)

```cangjie
protected open func terminateAliveProcess(pid: Int32, force: Bool): Unit
```

Function: Terminates the specified process. Returns the child process execution result, including exit status (exit code if normal termination, signal number if killed), standard output, and standard error.

Parameters:

- pid: [Int32](../../core/core_package_api/core_package_intrinsics.md#int32) - Process `ID` to terminate.
- force!: [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Named optional parameter. Specifies whether to force terminate the process. Default is `false`. If `false`, the process can terminate after releasing resources. If `true`, the process is killed immediately. On `Windows`, this always forces termination.

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown if the process does not exist or termination is not allowed.

## class SubProcess

```cangjie
public class SubProcess <: Process
```

Function: This class represents a child process, inheriting from [Process](process_package_classes.md#class-process), and provides child process operation functionalities.

> **Description:**
>
> Provides the following functionalities:
>
> - Mechanisms to access child process standard streams (`stdIn`, `stdOut`, `stdErr`).
> - Mechanism to wait for child process execution and return exit status code, with timeout support.
> - Mechanism to wait for child process execution and return output results (including normal/error results), with timeout support.

Parent type:

- [Process](../process_package_overview.md#class-process)

### prop stdErr <sup>(deprecated)</sup>

```cangjie
public prop stdErr: InputStream
```

Function: Gets the input stream connected to the child process standard error stream.

> **Note:**
>
> Will be deprecated in future versions. Use [stdErrPipe](./process_package_classes.md#prop-stderrpipe) instead.

Type: [InputStream](../../io/io_package_api/io_package_interfaces.md#interface-inputstream)

### prop stdErrPipe

```cangjie
public prop stdErrPipe: InputStream
```

Function: Gets the input stream connected to the child process standard error stream.

Type: [InputStream](../../io/io_package_api/io_package_interfaces.md#interface-inputstream)

### prop stdIn <sup>(deprecated)</sup>

```cangjie
public prop stdIn: OutputStream
```

Function: Gets the output stream connected to the child process standard input stream.

> **Note:**
>
> Will be deprecated in future versions. Use [stdInPipe](./process_package_classes.md#prop-stdinpipe) instead.

Type: [OutputStream](../../io/io_package_api/io_package_interfaces.md#interface-outputstream)

### prop stdInPipe

```cangjie
public prop stdInPipe: OutputStream
```

Function: Gets the output stream connected to the child process standard input stream.

Type: [OutputStream](../../io/io_package_api/io_package_inter```cangjie
public prop stdOut: InputStream
```

Function: Gets the input stream connected to the standard output stream of the child process.

> **Note:**
>
> This will be deprecated in future versions. Use [stdOutPipe](./process_package_classes.md#prop-stdoutpipe) instead.

Type: [InputStream](../../io/io_package_api/io_package_interfaces.md#interface-inputstream)

### prop stdOutPipe

```cangjie
public prop stdOutPipe: InputStream
```

Function: Gets the input stream connected to the standard output stream of the child process.

Type: [InputStream](../../io/io_package_api/io_package_interfaces.md#interface-inputstream)

### func wait(?Duration)

```cangjie
public func wait(timeout!: ?Duration = None): Int64
```

Function: Blocks the current process to wait for the child process to complete execution and returns the child process exit status code. Allows specifying a timeout duration. For scenarios requiring standard stream operations (Pipe mode), users should prioritize handling standard streams to avoid deadlocks caused by full child process stream buffers when calling this function.

> **Explanation:**
>
> Timeout handling mechanism:
>
> - When no parameter is passed, `timeout` is `None`, or the value is less than or equal to [Duration](../../core/core_package_api/core_package_structs.md#struct-duration).Zero, blocks until the child process execution completes.
> - When `timeout` is greater than [Duration](../../core/core_package_api/core_package_structs.md#struct-duration).Zero, blocks until the child process completes or throws a timeout exception upon expiration.

Parameters:

- timeout!: ?[Duration](../../core/core_package_api/core_package_structs.md#struct-duration) - Named optional parameter specifying the timeout duration for waiting on the child process. Defaults to `None`.

Return Value:

- [Int64](../../core/core_package_api/core_package_intrinsics.md#int64) - Returns the child process exit status. If the child process exits normally, returns the exit code; if terminated by a signal, returns the signal number that caused termination.

Exceptions:

- [TimeoutException](../../core/core_package_api/core_package_exceptions.md#class-timeoutexception) - Thrown when the wait times out before the child process exits.

### func waitOutput()

```cangjie
public func waitOutput(): (Int64, Array<Byte>, Array<Byte>)
```

Function: Blocks the current process to wait for the child process to complete execution and returns the child process exit status code along with the results (including standard output and error stream outputs). Not suitable for scenarios with large output volumes in standard/error streams. It is recommended to handle streams manually using the standard stream properties provided in [SubProcess](process_package_classes.md#class-subprocess) combined with the wait function.

Return Value:

- ([Int64](../../core/core_package_api/core_package_intrinsics.md#int64), [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[Byte](../../core/core_package_api/core_package_types.md#type-byte)>, [Array](../../core/core_package_api/core_package_structs.md#struct-arrayt)\<[Byte](../../core/core_package_api/core_package_types.md#type-byte)>) - The execution result of the child process, including the exit status (exit code if normal termination, signal number if terminated by signal), standard output results, and error results.

Exceptions:

- [ProcessException](process_package_exceptions.md#class-processexception) - Thrown when the child process does not exist or standard stream reading fails.