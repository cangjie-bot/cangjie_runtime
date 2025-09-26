






package std.unittest

import std.sync.ReentrantMutex
import std.time.DateTime
import std.collection.ArrayList
import std.collection.concurrent.ConcurrentLinkedQueue

enum LaunchApi {
    | FromPublicApi
    | FromCli
}

enum LaunchSource {
    | TestBinary
    | TestRunner

    /**
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws UnittestCliOptionsFormatException
     * @throws getOrThrow
     * @throws JsonException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
    static func fromDefaultConfiguration(): LaunchSource {
        if (defaultConfiguration().launchedWithTestRunner) {
            TestRunner
        } else {
            TestBinary
        }
    }
}

class Framework {
    private var transport: ?Transport = None
    private var progressQueue: ?ConcurrentLinkedQueue<UTProgress> = None
    private let mtx: ReentrantMutex = ReentrantMutex()
    private var currentlyRunning: RunContext = OutsideOfFrameworkContext()
    private static let instance = Framework()
    private static let internalContext = FrameworkInternalsContext()

    private init() {}
    /**
     * @throws RegexException
     * @throws JsonException
     * @throws OverflowException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws ArithmeticException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     * @throws OutOfMemoryError
     */
    static func launch<T>(api!: LaunchApi, hasWorkersInSetup!: Bool,
        progressQueue!: ?ConcurrentLinkedQueue<UTProgress> = None, body!: () -> T): T {
        instance.transport = if (hasWorkersInSetup) {
            Transport.fromDefaultConfiguration()
        } else {
            None
        }
        match (api) {
            case FromCli => instance.progressQueue = progressQueue
            case _ => ()
        }
        instance.currentlyRunning = internalContext
        try {
            body()
        } finally {
            instance.currentlyRunning = OutsideOfFrameworkContext()
            instance.transport?.close()
            instance.progressQueue = None
        }
    }

    static func isExecuting(): Bool {
        !(instance.currentlyRunning is OutsideOfFrameworkContext)
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    private func enterContext(newContext: RunContext): Unit {
        synchronized(mtx) {
            currentlyRunning = newContext
        }
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws AssertException
     */
    private func leaveContext(leavingContext: RunContext) {
        synchronized(mtx) {
            if (!refEq(currentlyRunning, leavingContext)) {
                throw AssertException("Invalid context structure")
            }
            currentlyRunning = internalContext
        }
    }

    /**
     * @throws AssertException
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    static func runStepBody(stepKind: StepKind, info: StepInfo, body: () -> Unit): RunStepResult {
        let context = RunStepContext(stepKind, info)
        instance.enterContext(context)
        try {
            body()
        } catch (e: Exception) {
            context.onException(e)
        } catch (e: Error) {
            context.onException(ErrorWrapperException(e))
        } finally {
            instance.leaveContext(context)
        }

        context.finishStep()
    }

    /**
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    static func runCatching(f: () -> Unit) {
        try {
            f()
        } catch (e: Exception) {
            withCurrentContext{ ctx => ctx.onException(e) }
        } catch (e: Error) {
            withCurrentContext{ ctx => ctx.onException(ErrorWrapperException(e)) }
        }
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    static func withCurrentContext<T>(f: (RunContext) -> T): T {
        synchronized(instance.mtx) {
            f(instance.currentlyRunning)
        }
    }
    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws AssertException
     * @throws IllegalSynchronizationStateException
     */
    static func abortCurrentStep(): ?RunStepResult {
        withCurrentContext { ctx =>
            let stepCtx = ctx as RunStepContext ?? return None
            stepCtx.checkResults.add(all: internalContext.checkResults)
            internalContext.checkResults.clear()
            let result = stepCtx.finishStep()
            instance.leaveContext(ctx)
            result
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    static func collectUnattachedFailures(): ArrayList<CheckResult> {
        withCurrentContext { _ =>
            let buf = ArrayList<CheckResult>()

            for (cr in internalContext.checkResults) {
                if (cr is TimeoutCheckResult) {
                    buf.add(cr)
                } else {
                    buf.add(UnattachedCheckResult(cr))
                }
            }

            internalContext.checkResults.clear()
            buf
        }
    }

    /**
     * @throws IllegalMemoryException
     * @throws RegexException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws OverflowException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws UnittestOptionValidationException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws JsonException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws Exception
     * @throws ProcessException
     */
    static func onTestCasesRegistered(packageName: String, casesCount: UInt64): Unit {
        let workerId = match (TestProcessKind.fromDefaultConfiguration()) {
            case Worker(_, _, nCasesSkip, _) where nCasesSkip > 0 => return
            case Worker(workerId, _, _, _) => workerId
            case _ => 0
        }

        let message = TestCasesRegistrationPart(casesCount, workerId: workerId, packageName: packageName)
        instance.progressQueue?.add(TestProgressData(message, workerId: workerId))

        let channel = match (instance.transport) {
            case Some(transport) => transport.channel ?? return;
            case None => return;
        }

        channel.send(message)
        instance.transport?.channel?.delimitOutput()

        match (channel.receive(limit: 1).next()) {
            case Some(ExecutionPermitPart) => ()
            case _ => throw Exception("Expected execution permission from the Main process")
        }
    }

    /**
     * @throws InvalidDataException
     * @throws Exception
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws JsonException
     * @throws SocketException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    static func onLifecycleStart(suiteId: TestSuiteId, suiteInfo: TestSuiteReportInfo, step: LStep): Unit {
        let header = LifecycleExecutionResultHeader(suiteId, suiteInfo, step, DateTime.now())
        instance.progressQueue?.add(TestProgressData(header))
        instance.transport?.channel?.send(header)
    }

    /**
     * @throws InvalidDataException
     * @throws Exception
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws JsonException
     * @throws SocketException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    static func onTestCaseStarted(caseId: TestCaseId, caseInfo: TestCaseReportInfo, suiteInfo: TestSuiteReportInfo): Unit {
        let header = TestCaseExecutionResultHeader(caseId, caseInfo, suiteInfo, DateTime.now())
        instance.progressQueue?.add(TestProgressData(header))
        instance.transport?.channel?.send(header)
    }

    /**
     * @throws Exception
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws JsonException
     * @throws SocketException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     */
    static func onFinished(result: TestCaseResult): Unit {
        let body = ExecutionResultBody(result)
        instance.progressQueue?.add(TestProgressData(body))
        instance.transport?.channel?.send(body)
        instance.transport?.channel?.delimitOutput()
    }

    /**
     * @throws SocketException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws FSException
     * @throws ProcessException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     */
    static func initWorker(ctx: MainExecutionCtx, workerId!: Int64): WorkerProcess {
        let manager = instance.transport.getOrThrow().manager.getOrThrow()
        let port = manager.port
        let overriddenCtx = ctx.withCommand(
            ctx.executeCommand.withArgs("--${KeyInternalMainProcessPort().name}=${port}"))
        withCurrentContext {
            _ => WorkerProcess.create(overriddenCtx, workerId, instance.progressQueue) {
                manager.accept()
            }
        }
    }
}

class OutsideOfFrameworkContext <: RunContext {
    protected func storeCheckResult(_: CheckResult) {
    }
}
class FrameworkInternalsContext <: RunContext {}

abstract class RunContext {
    let checkResults = ArrayList<CheckResult>()
    private var suppressed = false
    var passedChecks: Int64 = 0

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected open func checkFailed(c: CheckResult): Unit {
        storeCheckResult(c)
    }

    /**
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected open func onException(e: Exception): Unit {
        storeCheckResult(e.asCheckResult() ?? return)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected open func storeCheckResult(check: CheckResult): Unit {
        if (suppressed) { return }
        checkResults.add(check)
    }

    func checkPassed(): Unit {
        passedChecks++
    }

    func suppressIfHasFailures() {
        if (!checkResults.isEmpty()) {
            suppressed = true
        }
    }

    func hasFailures(): Bool {
        !checkResults.isEmpty()
    }
}

class RunStepContext <: RunContext {
    var startTime: DateTime = DateTime.now()

    RunStepContext(
        var stepKind: StepKind,
        var stepInfo: StepInfo
    ) {}

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws BenchmarkStoppedError
     */
    protected func checkFailed(c: CheckResult) {
        storeCheckResult(c)
        if (let Bench(_) <- stepInfo) {
            throw BenchmarkStoppedError()
        }
    }

    /**
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func finishStep(): RunStepResult {
        let info = if (checkResults.isEmpty()) {
            stepInfo
        } else {
            Failure(checkResults.toArray())
        }
        RunStepResult(passedChecks, startTime, stepKind, info)
    }
}

class BenchmarkStoppedError <: Exception {
    BenchmarkStoppedError() {
        super("Any failure in benchmark stops it.")
    }
}
