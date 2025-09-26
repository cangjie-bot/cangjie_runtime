






package std.unittest

import std.unittest.common.*
import std.collection.*
import std.collection.concurrent.ConcurrentLinkedQueue
import std.process.Process
import std.sync.Semaphore
import std.time.DateTime

let EXIT_CODE_ON_TIMEOUT = 42

struct MainExecutionCtx {
    MainExecutionCtx(
        let nWorkers: Int64,
        let workersQuota: Semaphore,
        let outputReporter: TestOutputReporter,
        let executeCommand: TestPackageExecuteCommand
    ) {}

    func withCommand(command: TestPackageExecuteCommand): MainExecutionCtx {
        MainExecutionCtx(nWorkers, workersQuota, outputReporter, command)
    }
}

/**
 * @throws MockFrameworkInternalError
 * @throws EnvException
 * @throws ExpectationFailedException
 * @throws RegexException
 * @throws UnittestOptionValidationException
 * @throws TimeoutException
 * @throws InvalidDataException
 * @throws JsonException
 * @throws IndexOutOfBoundsException
 * @throws OverflowException
 * @throws AssertException
 * @throws IllegalStateException
 * @throws MockFrameworkException
 * @throws getOrThrow
 * @throws UnittestCliOptionsFormatException
 * @throws IllegalSynchronizationStateException
 * @throws ArithmeticException
 * @throws FSException
 * @throws ProcessException
 * @throws Exception
 * @throws IllegalMemoryException
 * @throws OutOfMemoryError
 * @throws IllegalArgumentException
 * @throws NoneValueException
 * @throws SocketException
 */
func executeSmart(
    packageName: String,
    tests: Array<TestSuite>,
    filterService: FilterService,
    outputReporter: TestOutputReporter,
    needStartWorker!: Bool
): TestGroupResult {
    let processKind = TestProcessKind.fromDefaultConfiguration()
    match (processKind) {
        case Main where !needStartWorker =>
            executeWorker(packageName, tests, filterService)
        case Main =>
            let parallelInfo = ParallelInfo.fromDefaultConfiguration()
            let cmd = TestPackageExecuteCommand.fromCurrentProcess()
            let ctx = MainExecutionCtx(parallelInfo.nWorkers, Semaphore(parallelInfo.nWorkers), outputReporter, cmd)
            executeMain(initWorkersMain(ctx), packageName, ctx)
        case Worker(_, _, _, _) =>
            executeWorker(packageName, tests, filterService)
    }
}

/**
 * @throws SocketException
 * @throws OutOfMemoryError
 * @throws NoneValueException
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws FSException
 * @throws ProcessException
 * @throws ArithmeticException
 * @throws IllegalSynchronizationStateException
 * @throws IllegalStateException
 * @throws OverflowException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func initWorkersMain(ctx: MainExecutionCtx): Array<WorkerProcess> {
    let workers = 0..ctx.nWorkers |> mapParallelOrdered(ctx.nWorkers) { workerId: Int64 =>
        WorkerProcess.createAndRegister(workerId, ctx)
    } |> collectArray
    return workers
}

/**
 * @throws TimeoutException
 * @throws InvalidDataException
 * @throws JsonException
 * @throws IllegalMemoryException
 * @throws IllegalStateException
 * @throws IndexOutOfBoundsException
 * @throws OverflowException
 * @throws IllegalSynchronizationStateException
 * @throws OutOfMemoryError
 * @throws Exception
 * @throws ProcessException
 * @throws FSException
 * @throws ArithmeticException
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws SocketException
 */
func executeMain(workers: Array<WorkerProcess>, packageName: String, ctx: MainExecutionCtx): TestGroupResult {
    let workerResults = workers |> mapParallelOrdered(ctx.nWorkers) { worker: WorkerProcess =>
        WorkerProcess.executeRestarting(worker, ctx)
    } |> collectArray

    let parsedWorkerResults = ArrayList<TestSuiteResult>()
    let crashWorkerResults = ArrayList<TestProcessError>()
    let nonTestOutputs = ArrayList<NonTestOutputs>()
    for (result in workerResults) {
        match (result) {
            case OkResult(res, output) => 
                parsedWorkerResults.add(all: res)
                nonTestOutputs.add(all: output)
            case CrashResult(res, crash, output) => 
                parsedWorkerResults.add(all: res)
                nonTestOutputs.add(all: output)
                crashWorkerResults.add(crash)
        }
    }

    let uniqueCrahes = uniqueValues(crashWorkerResults)
    let uniqueNonTestOuputs = uniqueValues(nonTestOutputs)
    let mergedTestSuiteResults = TestSuiteResult.mergeAll(parsedWorkerResults)
    return TestGroupResult.fromPackageSuites(packageName, mergedTestSuiteResults, uniqueCrahes, uniqueNonTestOuputs)
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func uniqueValues<T>(collection: Collection<T>): Array<T> where T <: Hashable {
    let hashToValue = HashMap<Int64, T>()
    for (target in collection) {
        hashToValue.add(target.hashCode(), target)
    }
    return hashToValue.values() |> collectArray
}

/**
 * @throws IllegalMemoryException
 * @throws RegexException
 * @throws UnittestOptionValidationException
 * @throws InvalidDataException
 * @throws ProcessException
 * @throws Exception
 * @throws AssertException
 * @throws IllegalStateException
 * @throws IndexOutOfBoundsException
 * @throws OverflowException
 * @throws MockFrameworkInternalError
 * @throws EnvException
 * @throws ExpectationFailedException
 * @throws getOrThrow
 * @throws UnittestCliOptionsFormatException
 * @throws IllegalSynchronizationStateException
 * @throws MockFrameworkException
 * @throws IllegalArgumentException
 * @throws SocketException
 * @throws JsonException
 * @throws OutOfMemoryError
 * @throws ArithmeticException
 */
func executeWorker(packageName: String, suites: Array<TestSuite>, filterService: FilterService): TestGroupResult {
    let suitesToBeExecuted = registerTestSuites(packageName, suites, filterService)
    let testGroupResult = TestGroupResult(packageName, [])
    for (suite in suitesToBeExecuted) {
        let suiteResult = suite.execute(packageName, defaultConfiguration(), filterService)
        testGroupResult.add(suiteResult)
    }
    testGroupResult.finish()
    testGroupResult
}

/**
 * @throws IllegalMemoryException
 * @throws RegexException
 * @throws IndexOutOfBoundsException
 * @throws OverflowException
 * @throws IllegalStateException
 * @throws UnittestOptionValidationException
 * @throws OutOfMemoryError
 * @throws InvalidDataException
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
private func registerTestSuites(packageName: String, suites: Array<TestSuite>, filterService: FilterService): Array<TestSuite> {
    let suitesToBeExecuted = suites |> filter { suite: TestSuite =>
        let suiteKey = SuiteFilterKey.fromTestSuite(packageName, suite)
        filterService.register(suiteKey, suite)
        let includeSuite = !filterService.frameworkFilter.shouldSkipTestClass(suiteKey)
        if (includeSuite) {
            if (!suite.suiteConfiguration.skip && filterService.userFilter.shouldSkipTestClass(suiteKey)) {
                suite.suiteConfiguration.set(KeySkip.skip, true)
            }
        }
        includeSuite
    } |> collectArray

    let casesToBeExecuted = suitesToBeExecuted |> fold<TestSuite, Int64>(0) { total, suite =>
        let suiteId = TestSuiteId.fromTestSuite(packageName, suite)
        let casesCount = match (suite.suiteConfiguration.get(KeySkip.skip)) {
            case Some(true) => 0
            case _ => suite.casesCountToBeExecuted(filterService, suiteId)
        }
        total + casesCount
    }

    Framework.onTestCasesRegistered(packageName, UInt64(casesToBeExecuted))
    suitesToBeExecuted
}

enum TestProcessKind {
    | Main
    | Worker(Int64, Int64, Int64, UInt16)

    /**
     * @throws getOrThrow
     * @throws JsonException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws IllegalMemoryException
     * @throws UnittestCliOptionsFormatException
     * @throws Exception
     */
    static func fromDefaultConfiguration(): TestProcessKind {
        let config = defaultConfiguration()
        match ((
            config.get(KeyInternalWorkerId.internalWorkerId),
            config.get(KeyInternalNWorkers.internalNWorkers),
            config.get(KeyInternalWorkerSkipNTests.internalWorkerSkipNTests),
            config.get(KeyInternalMainProcessPort.internalMainProcessPort)
        )) {
            case (Some(id), Some(nWorkers), Some(nSkip), Some(port)) => Worker(id, nWorkers, nSkip, port)
            case (None, None, None, None) => Main
            case _ => throw Exception(
                "${KeyInternalWorkerId().name}, ${KeyInternalNWorkers().name}," +
                "${KeyInternalWorkerSkipNTests().name} and ${KeyInternalMainProcessPort().name} " +
                "should be provided together"
            )
        }
    }

    prop isWorker: Bool {
        get() {
            match (this) {
                case Main => false
                case Worker(_, _, _, _) => true
            }
        }
    }
}

struct NonTestOutputs <: Hashable {
    NonTestOutputs(
        let outputBeforeTests: CapturedOutput,
        let outputAfterTests: CapturedOutput
    ) {}

    public func hashCode(): Int64 {
        var hasher = DefaultHasher()
        hasher.write(outputBeforeTests.stdout)
        hasher.write(outputBeforeTests.stderr)
        hasher.write(outputAfterTests.stdout)
        hasher.write(outputAfterTests.stderr)
        return hasher.finish()
    }

    init() {
        this(CapturedOutput(), CapturedOutput())
    }

    init(pair: (CapturedOutput, CapturedOutput)) {
        this(pair[0], pair[1])
    }

    func isEmpty(): Bool {
        return outputBeforeTests.isEmpty() && outputAfterTests.isEmpty()
    }
}

private struct BunchExecutionResult {
    BunchExecutionResult(
        let results: Array<ExecutionResult>,
        let status: BunchExecutionResultStatus,
        let nonTestOutputs: NonTestOutputs
    ) {}
}

private enum BunchExecutionResultStatus {
    | FinishedSuccessfuly
    | InProgressTimeout
    | OutOfProgressCrashed(TestProcessError)
    | InProgressCrashed(ExecutionResult)
}

enum ExecuteRestartingResult {
    | OkResult(Collection<TestSuiteResult>, ArrayList<NonTestOutputs>)
    | CrashResult(Collection<TestSuiteResult>, TestProcessError, ArrayList<NonTestOutputs>)
}

class WorkerProcess {
    private WorkerProcess(
        private let process: WrappedProcess,
        private let transportChannel: ?TransportChannel,
        private let progressQueue: ?ConcurrentLinkedQueue<UTProgress>,
        private let outputReporter: TestOutputReporter,
        private let workerId: Int64
    ) {}


    /**
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    func waitCasesRegistration() {
        match (transportChannel?.receive(limit: 1u64).next()) {
            case Some(Some(p: TestCasesRegistrationPart)) => progressQueue?.add(TestProgressData(p, workerId: workerId))
            case Some(Some(_)) => throw Exception(
                "Expected test cases registration message from worker, but got another message")
            case _ => throw Exception("Expected test cases registration message from worker, but got nothing")
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func commitCasesRegistrationFailure() {
        progressQueue?.add(TestProgressData(TestCasesRegistrationFailed(), workerId: workerId))
    }
 
    /**
     * @throws OutOfMemoryError
     * @throws TimeoutException
     * @throws InvalidDataException
     * @throws ProcessException
     * @throws FSException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws IllegalMemoryException
     * @throws Exception
     */
    private func waitExecution(): BunchExecutionResult {
        let messages: Array<ExecutionResultPart> = if (let Some(transportChannel) <- transportChannel) {
            transportChannel.receive() |> inspect { part: ExecutionResultPart =>
                progressQueue?.add(TestProgressData(part, workerId: workerId))
                ()
            } |> collectArray
        } else {
            []
        }
        let code = process.wait()

        let output = WorkerOutput(process.stdout(), process.stderr())
        let parseResult = ExecutionResult.combine(messages)
        match (parseResult) {
            case ParsedComplete(results) where code == 0 =>
                let nonTestOutputs = NonTestOutputs(merge(results, output))
                BunchExecutionResult(results, FinishedSuccessfuly, nonTestOutputs)
            case ParsedComplete(results) where code == EXIT_CODE_ON_TIMEOUT =>
                let nonTestOutputs = NonTestOutputs(merge(results, output))
                BunchExecutionResult(results, InProgressTimeout, nonTestOutputs)
            case ParsedComplete(results) => 
                let nonTestOutputs = NonTestOutputs(merge(results, output))
                let error = TestProcessError(code)
                BunchExecutionResult(results, OutOfProgressCrashed(error), nonTestOutputs)
            case ParsedIncomplete(results, header) =>
                let (beforeTests, lastOutput) = merge(results, output)
                let nonTestsOutput = NonTestOutputs(beforeTests, CapturedOutput())
                let status = InProgressCrashed(mkCrashResult(header, lastOutput, code))
                BunchExecutionResult(results, status, nonTestsOutput)
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
    private func continueExecution() {
        transportChannel?.send(ExecutionPermitPart())
    }

    /**
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    private func merge(
        bunchResults: Array<ExecutionResult>, output: WorkerOutput
    ): (beforeTests: CapturedOutput, lastOutput: CapturedOutput) {
        if (!outputReporter.capture) { return (CapturedOutput(), CapturedOutput()) }

        let outputs: Array<CapturedOutput> = try {
            output.captured
        } catch (e: IllegalStateException) {
            printDebugOutput(output)
            throw Exception("Internal error: output streams have different number of sections (${e.message})")
        }
        
        if (outputs.size == 1) {
            return (outputs[0], CapturedOutput())
        }
        let outputAfterTests = outputs[outputs.size - 1]
        let (begin, end, outputBeforeTests) = if (bunchResults.size + 2 == outputs.size) {
            (1, outputs.size - 1, outputs[0])
        } else if (bunchResults.size + 1 == outputs.size) {
            (0, outputs.size, CapturedOutput())
        } else {
            printDebugOutput(output)
            throw Exception(
                "Internal error: expected nOutputs == nResults, but got nOutputs=${outputs.size}, nResults=${bunchResults.size}")
        }
        for ((result, out) in bunchResults |> zip(outputs[begin..end])) {
            if (result.hasFailures || outputReporter.showAllOutput) {
                result.add(out)
            }
        }
        (outputBeforeTests, outputAfterTests)
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws FSException
     * @throws ProcessException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    static func create(ctx: MainExecutionCtx, workerId: Int64, progressQueue: ?ConcurrentLinkedQueue<UTProgress>,
        connect: () -> TransportChannel): WorkerProcess {
        let process = Process.start(ctx)
        let connection: ?TransportChannel = try {
            connect()
        } catch (_: Exception) {
            process.terminate()
            None
        }

        return WorkerProcess(process, connection, progressQueue, ctx.outputReporter, workerId)
    }

    /**
     * @throws SocketException
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     * @throws ProcessException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    static func createAndRegister(workerId: Int64, ctx: MainExecutionCtx): WorkerProcess {
        ctx.workersQuota.doWith {
            let execution = startWorker(workerId: workerId, ctx: ctx)
            if (execution.hasTransportChannel()) {
                execution.waitCasesRegistration()
            } else {
                execution.commitCasesRegistrationFailure()
            }
            execution
        }
    }

    /**
     * @throws TimeoutException
     * @throws InvalidDataException
     * @throws JsonException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws IllegalStateException
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     * @throws FSException
     * @throws ArithmeticException
     * @throws IllegalMemoryException
     * @throws ProcessException
     * @throws Exception
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws SocketException
     */
    static func executeRestarting(initialWorker: WorkerProcess, ctx: MainExecutionCtx): ExecuteRestartingResult {
        ctx.workersQuota.doWith {
            var currentTestIdx = 0
            let workerId = initialWorker.workerId
            let nonTestOutput = ArrayList<NonTestOutputs>()
            var outOfprogressCrashed: ?TestProcessError = None
            let bunchResults = HashMap<TestSuiteId, TestSuiteResult>()
            while (true) {
                let execution = match(currentTestIdx) {
                    case 0 =>
                        initialWorker.continueExecution()
                        initialWorker
                    case _ => startWorker(workerId: workerId, startingTestIdx: currentTestIdx, ctx: ctx)
                }
                let result = execution.waitExecution()
                nonTestOutput.add(result.nonTestOutputs)
                commitResults(bunchResults, result.results)
                let nSkipCrashed = match (result.status) {
                    case FinishedSuccessfuly => break
                    case InProgressTimeout => 0
                    case OutOfProgressCrashed(crashResult) =>
                        outOfprogressCrashed = crashResult
                        break
                    case InProgressCrashed(crashResult) => commitCrashResult(bunchResults, crashResult)
                }
                let nSkipPassed = result.results |> filter { it: ExecutionResult => it.isCase } |> count
                currentTestIdx += nSkipPassed + nSkipCrashed
            }
            bunchResults.values() |> forEach { result => result.finish() }
            if (let Some(crash) <- outOfprogressCrashed) {
                return ExecuteRestartingResult.CrashResult(bunchResults.values(), crash, nonTestOutput)
            }
            return ExecuteRestartingResult.OkResult(bunchResults.values(), nonTestOutput)
        }
    }

    /**
     * @throws SocketException
     * @throws NoneValueException
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws FSException
     * @throws ProcessException
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private static func startWorker(workerId!: Int64, startingTestIdx!: Int64 = 0, ctx!: MainExecutionCtx): WorkerProcess {
        let workerCommand = ctx.executeCommand.withArgs(
            "--${KeyInternalWorkerId().name}=${workerId}",
            "--${KeyInternalWorkerSkipNTests().name}=${startingTestIdx}",
            "--${KeyInternalNWorkers().name}=${ctx.nWorkers}"
        )
        Framework.initWorker(ctx.withCommand(workerCommand), workerId: workerId)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    private static func commitCrashResult(
        bunchResults: HashMap<TestSuiteId, TestSuiteResult>,
        crashResult: ExecutionResult
    ): Int64 {
        match (crashResult.header) {
            case header: LifecycleExecutionResultHeader where header.step == BeforeAll =>
                if (!bunchResults.contains(crashResult.suiteId)) {
                    commitResults(bunchResults, [crashResult])
                }
                1
            case header: LifecycleExecutionResultHeader where header.step == AfterAll =>
                commitResults(bunchResults, [crashResult])
                0
            case _ =>
                commitResults(bunchResults, [crashResult])
                1
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    private static func commitResults(
        bunchResults: HashMap<TestSuiteId, TestSuiteResult>,
        results: Array<ExecutionResult>
    ): Unit {
        for (result in results) {
            let suiteResult = bunchResults.getOrInsert(result.suiteId) { =>
                TestSuiteResult(result.suiteId, result.suiteInfo)
            }
            suiteResult.add(result.stepResult)
        }
    }

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws Exception
     */
    private static func mkCrashResult(header: ExecutionResultHeader, output: CapturedOutput, code: Int64): ExecutionResult {
        let crash = RunStepResult(0, header.startTime, crashStepKindOf(header), Failure([CrashedCheckResult(code)]))
        let caseResult = match (header) {
            case lHeader: LifecycleExecutionResultHeader =>
                let id = TestCaseId(lHeader.suiteId, lHeader.step.toString(), isBench: false)
                TestCaseResult.fromSingleStep(id, TestCaseReportInfo.empty(), crash)
            case caseHeader: TestCaseExecutionResultHeader =>
                TestCaseResult.fromSingleStep(caseHeader.caseId, caseHeader.caseInfo, crash)    
            case _ => throw Exception("Unreachable")
        }
        let result = ExecutionResult(header, ExecutionResultBody(caseResult))
        result.add(output)
        result
    }

    /**
     * @throws Exception
     */
    private static func crashStepKindOf(header: ExecutionResultHeader): StepKind {
        match (header) {
            case header: LifecycleExecutionResultHeader => Lifecycle(header.step)
            case _: TestCaseExecutionResultHeader => CaseStep(ArgumentDescription(None, 0, 0, None))
            case _ => throw Exception("Unreachable")
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws Exception
     */
    private static func reportWorkerInternalCrash(output: WorkerOutput, code: Int64): Nothing {
        printDebugOutput(output)
        throw Exception(
            "Worker test process unexpectedly failed (code = ${code}). " +
            "Some code crashed outside of the @TestCase or lifecycle methods."
        )
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    private static func printDebugOutput(output: WorkerOutput): Unit {
        eprintln("STDOUT:")
        for (out in output.stdouts) {
            eprint(out)
        }
        eprintln("")
        eprintln("STDERR:")
        for (err in output.stderrs) {
            eprint(err)
        }
        eprintln("")
    }

    private func hasTransportChannel(): Bool {
        return transportChannel.isSome()
    }
}

abstract class ExecutionResultPart <: Serializable<ExecutionResultPart> {
    /**
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    public func serializeInternal(): DataModel {
        match (this) {
            case thiz: TestCaseExecutionResultHeader =>
                DataModelStruct()
                    .add(field<Int8>("tag", 0))
                    .add(field<TestCaseId>("caseId", thiz.caseId))
                    .add(field<TestCaseReportInfo>("caseInfo", thiz.caseInfo))
                    .add(field<TestSuiteReportInfo>("suiteInfo", thiz.suiteInfo))
                    .add(field<String>("startTime", thiz.startTime.toString()))
            case thiz: LifecycleExecutionResultHeader =>
                DataModelStruct()
                    .add(field<Int8>("tag", 1))
                    .add(field<TestSuiteId>("suiteId", thiz.suiteId))
                    .add(field<TestSuiteReportInfo>("suiteInfo", thiz.suiteInfo))
                    .add(field<LStep>("step", thiz.step))
                    .add(field<String>("startTime", thiz.startTime.toString()))
            case thiz: ExecutionResultBody =>
                DataModelStruct()
                    .add(field<Int8>("tag", 2))
                    .add(field<Result>("stepResult", thiz.stepResult))
            case thiz: TestCasesRegistrationPart =>
                DataModelStruct()
                    .add(field<Int8>("tag", 3))
                    .add(field<UInt64>("tests", thiz.casesCount))
                    .add(field<Int64>("workerId", thiz.workerId))
                    .add(field<String>("package", thiz.packageName))
            case thiz: ExecutionPermitPart =>
                DataModelStruct().add(field<Int8>("tag", 4))
            case thiz: TestCasesRegistrationFailed =>
                DataModelStruct().add(field<Int8>("tag", 5))
            case _ => throw Exception("Unreachable")
        }
    }

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws TimeParseException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws DataModelException
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws Exception
     */
    public static func deserialize(dm: DataModel): ExecutionResultPart {
        let dms = dm.asStruct()
        match (Int8.deserialize(dms.get("tag"))) {
            case 0 => TestCaseExecutionResultHeader(
                TestCaseId.deserialize(dms.get("caseId")),
                TestCaseReportInfo.deserialize(dms.get("caseInfo")),
                TestSuiteReportInfo.deserialize(dms.get("suiteInfo")),
                DateTime.parse(String.deserialize(dms.get("startTime")))
            )
            case 1 => LifecycleExecutionResultHeader(
                TestSuiteId.deserialize(dms.get("suiteId")),
                TestSuiteReportInfo.deserialize(dms.get("suiteInfo")),
                LStep.deserialize(dms.get("step")),
                DateTime.parse(String.deserialize(dms.get("startTime")))
            )
            case 2 => ExecutionResultBody(
                (Result.deserialize(dms.get("stepResult")) as TestCaseResult).getOrThrow()
            )
            case 3 => TestCasesRegistrationPart(
                UInt64.deserialize(dms.get("tests")),
                workerId: Int64.deserialize(dms.get("workerId")),
                packageName: String.deserialize(dms.get("package"))
            )
            case 4 => ExecutionPermitPart()
            case 5 => TestCasesRegistrationFailed()
            case tag => throw Exception("Unknown result part tag: ${tag}")
        }
    }
}


abstract class ExecutionResultHeader <: ExecutionResultPart {
    public prop suiteId: TestSuiteId
    public prop suiteInfo: TestSuiteReportInfo
    public prop startTime: DateTime
}

class TestCaseExecutionResultHeader <: ExecutionResultHeader {
    TestCaseExecutionResultHeader(
        let caseId: TestCaseId,
        let caseInfo: TestCaseReportInfo,
        private let suiteInfo_: TestSuiteReportInfo,
        private let startTime_: DateTime
    ) {}
    public override prop suiteId: TestSuiteId { get() { caseId.suiteId } }
    public override prop suiteInfo: TestSuiteReportInfo { get() { suiteInfo_ } }
    public override prop startTime: DateTime { get() { startTime_ } }
}

class LifecycleExecutionResultHeader <: ExecutionResultHeader {
    LifecycleExecutionResultHeader(
        private let suiteId_: TestSuiteId,
        private let suiteInfo_: TestSuiteReportInfo,
        let step: LStep,
        private let startTime_: DateTime
    ) {}
    public override prop suiteId: TestSuiteId { get() { suiteId_ } }
    public override prop suiteInfo: TestSuiteReportInfo { get() { suiteInfo_ } }
    public override prop startTime: DateTime { get() { startTime_ } }
}

class ExecutionResultBody <: ExecutionResultPart {
    ExecutionResultBody(let stepResult: TestCaseResult) {}
}


class TestCasesRegistrationPart <: ExecutionResultPart {
    TestCasesRegistrationPart(let casesCount: UInt64, let workerId!: Int64, let packageName!: String) {}
}

class TestCasesRegistrationFailed <: ExecutionResultPart {
    TestCasesRegistrationFailed() {}
}


class ExecutionPermitPart <: ExecutionResultPart {
    ExecutionPermitPart() {}
}

private enum ExecutionsParseResult {
    | ParsedComplete(Array<ExecutionResult>)
    | ParsedIncomplete(Array<ExecutionResult>, ExecutionResultHeader)
}

private struct ExecutionResult {
    ExecutionResult(let header: ExecutionResultHeader, let body: ExecutionResultBody) {}

    prop suiteId: TestSuiteId {
        get() { header.suiteId }
    }

    prop suiteInfo: TestSuiteReportInfo {
        get() { header.suiteInfo }
    }

    prop startTime: DateTime {
        get() { header.startTime }
    }

    prop stepResult: TestCaseResult {
        get() { body.stepResult }
    }

    prop isCase: Bool {
        get() { header is TestCaseExecutionResultHeader }
    }

    prop hasFailures: Bool {
        get() { body.stepResult.hasFailures() }
    }

    func add(output: CapturedOutput): Unit {
        this.body.stepResult.addOutput(output)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    static func combine(parts: Array<ExecutionResultPart>): ExecutionsParseResult {
        if (parts.isEmpty()) {
            return ParsedComplete([])
        }

        let results = ArrayList<ExecutionResult>()
        var currentHeader: ?ExecutionResultHeader = None
        for (part in parts) {
            match ((currentHeader, part)) {
                case (_, newHeader: ExecutionResultHeader) =>
                    currentHeader = newHeader
                case (None, _: ExecutionResultBody) =>
                    throw Exception("Result header is expected before data")
                case (Some(header), body: ExecutionResultBody) =>
                    let result = ExecutionResult(header, body)
                    results.add(result)
                    currentHeader = None
                case (_, _: TestCasesRegistrationPart) => ()
                case (_, _: TestCasesRegistrationFailed) => ()
                case _ => throw Exception("Required due to bug in compiler")
            }
        }
        match (currentHeader) {
            case None => ParsedComplete(results.toArray())
            case Some(header) => ParsedIncomplete(results.toArray(), header)
        }
    }
}
