






package std.unittest

import std.process.*
import std.sync.AtomicOptionReference
import std.fs.*
@When[os == "Windows"]
import std.convert.Parsable
import std.collection.*
import std.random.Random
import std.sync.ReentrantMutex

private let TEMP_DIR = TempDirectory()

struct WrappedProcess {
    WrappedProcess(
        private let process: SubProcess,
        private let stdOutFile: ?Path,
        private let stdErrFile: ?Path
    ) {}

    private let status = AtomicOptionReference<CapturedProcessResult>()

    /**
     * @throws TimeoutException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws FSException
     */
    func wait(): Int64 {
        let exitCode = process.wait()
        if (status.load().isSome()) {
            return exitCode
        }

        let stdOut = readCapturedFrom(stdOutFile)
        let stdErr = readCapturedFrom(stdErrFile)
        let result = CapturedProcessResult(stdOut, stdErr)
        this.status.compareAndSwap(None, Some(result))

        return exitCode
    }

    /**
     * @throws ProcessException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    func terminate(): Unit {
        if (status.load().isSome()) {
            return
        }

        process.terminateSilent(force: true)
    }

    func stdout(): Array<Byte> {
        status.load()?.stdOut ?? []
    }

    func stderr(): Array<Byte> {
        status.load()?.stdErr ?? []
    }
}

private class CapturedProcessResult {
    CapturedProcessResult(
        let stdOut: Array<Byte>,
        let stdErr: Array<Byte>
    ) {}
}
/**
 * @throws IllegalSynchronizationStateException
 * @throws OutOfMemoryError
 * @throws IndexOutOfBoundsException
 * @throws NoneValueException
 * @throws Exception
 * @throws IllegalMemoryException
 * @throws IllegalArgumentException
 * @throws ProcessException
 * @throws FSException
 */
func processStart(ctx: MainExecutionCtx): WrappedProcess {
    Process.start(ctx)
}

extend Process {
    /**
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws ProcessException
     * @throws FSException
     */
    static func start(ctx: MainExecutionCtx): WrappedProcess {
        let stdout = captureFor(ctx)
        let stderr = captureFor(ctx)
        let cmd = ctx.executeCommand

        let process = try {
            launch(
                cmd.command, cmd.args.toArray(), environment: cmd.env,
                stdOut: redirectFor(stdout), stdErr: redirectFor(stderr)
            )
        } catch (cause: Exception) {
            stdout?.close()
            stderr?.close()
            throw cause
        }

        return WrappedProcess(process, stdout?.info.path, stderr?.info.path)
    }
    /**
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws Exception
     */
    private static func captureFor(ctx: MainExecutionCtx): ?File {
        match (ctx.outputReporter.capture) {
            case true => TEMP_DIR.createTempFile(prefix: "test-worker-", suffix: ".stdout")
            case _ => None
        }
    }

    private static func redirectFor(file: ?File): ProcessRedirect {
        match (file) {
            case Some(file) => FromFile(file)
            case None => Inherit
        }
    }
}

extend SubProcess {
    
    /**
     * @throws ProcessException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    func terminateSilent(force!: Bool): Unit {
        if (isAlive()) {
            try {
                terminate(force: force)
            } catch (cause: Exception) {
                eprintln("Failed to terminate worker process ${pid}: ${cause}")
            }
        }
    }
}

/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 * @throws FSException
 */
private func removeFileSilent(path: Path): Unit {
    try {
        remove(path)
    } catch (_) {
    }
}

/**
 * @throws OverflowException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 * @throws FSException
 */
private func readCapturedFrom(path: ?Path): Array<Byte> {
    match (path) {
        case Some(path) where exists(path) =>
            try {
                File.readFrom(path)
            } catch (e: Exception) {
                "Failed to read capture file ${path}: ${e}".toArray()
            } finally {
                removeFileSilent(path)
            }
        case _ => Array<Byte>()
    }
}
