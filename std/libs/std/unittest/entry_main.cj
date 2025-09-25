






package std.unittest

import std.unittest.common.*
import std.collection.*
import std.fs.*
import std.process.*
import std.sync.Semaphore

private let OP_INTERNAL_TESTRUNNER_INPUT_PATH_NAME = camelCaseToKebabCase(KeyInternalTestrunnerInputPath().name)
private let OP_INTERNAL_TESTRUNNER_INPUT_PATH = "--${OP_INTERNAL_TESTRUNNER_INPUT_PATH_NAME}"

extend Configuration {
    prop launchedWithTestRunner: Bool {
        /*
         * @throws IndexOutOfBoundsException
         */
        get() {
            get(KeyInternalTestrunnerInputPath.internalTestrunnerInputPath).isSome()
        }
    }
}

private let MAX_N_WORKERS_PER_PACKAGE = 5

/*
 * @throws IllegalFormatException
 * @throws IllegalMemoryException
 * @throws Error
 * @throws DataModelException
 * @throws InvalidDataException
 * @throws ConcurrentModificationException
 * @throws RegexException
 * @throws JsonException
 * @throws NoneValueException
 * @throws OutOfMemoryError
 * @throws Exception
 * @throws FSException
 * @throws getOrFail
 * @throws UnittestOptionValidationException
 * @throws IndexOutOfBoundsException
 * @throws AssertException
 * @throws UnittestCliOptionsFormatException
 * @throws getOrThrow
 * @throws SocketException
 * @throws ProcessException
 * @throws IllegalSynchronizationStateException
 * @throws MockFrameworkException
 * @throws ArithmeticException
 * @throws OverflowException
 * @throws IllegalArgumentException
 * @throws TimeoutException
 * @throws MockFrameworkInternalError
 * @throws ExpectationFailedException
 * @throws IllegalStateException
 * @throws EnvException
 */
public func entryMain(testPackage: TestPackage): Int64 {
    if (printUnittestHelpPageIfRequested()) {
        return 0
    }
    
    
    let reportFormat = ReportFormat.fromDefaultConfiguration()
    let testGroup = testPackage.build()
    let outputReporter = TestOutputReporter.fromDefaultConfiguration()
    let progressReporter = ProgressReporter.fromDefaultConfiguration()
    progressReporter?.startReporting()
    let filterService = FilterService.fromDefaultConfiguration()
    let hasWorersInSetup = needStartWorker(testGroup.suites, outputReporter) || TestProcessKind
        .fromDefaultConfiguration()
        .isWorker
    let result = Framework.launch(api: FromCli, progressQueue: progressReporter?.updateQueue,
        hasWorkersInSetup: hasWorersInSetup) {
        => executeSmart(testGroup.name, testGroup.suites, filterService, outputReporter,
            needStartWorker: hasWorersInSetup)
    }

    progressReporter?.stopAndClear()
    if (!TestProcessKind.fromDefaultConfiguration().isWorker) {
        let pp = TerminalPrettyPrinter.fromDefaultConfiguration()
        TextReports.printDefaultReport(pp, result, outputReporter, defaultConfiguration())
        reportFormat?.report(result)
    }
    errorCode(result.details)
}
/*
 * @throws FSException
 * @throws DataModelException
 * @throws InvalidDataException
 * @throws IllegalStateException
 * @throws OverflowException
 * @throws OutOfMemoryError
 * @throws Error
 * @throws IllegalMemoryException
 * @throws NoneValueException
 * @throws IllegalFormatException
 * @throws SocketException
 * @throws IllegalArgumentException
 * @throws Exception
 * @throws ProcessException
 * @throws ArithmeticException
 * @throws IndexOutOfBoundsException
 * @throws TimeoutException
 * @throws getOrFail
 * @throws UnittestOptionValidationException
 * @throws ConcurrentModificationException
 * @throws RegexException
 * @throws JsonException
 * @throws IllegalSynchronizationStateException
 * @throws UnittestCliOptionsFormatException
 * @throws getOrThrow
 */
protected func testRunnerEntryMain(): Int64 {
    let nWorkers = ParallelInfo.fromDefaultConfiguration().nWorkers
    let semaphore = Semaphore(nWorkers)
    let nWorkersPerPackage = if (defaultConfiguration().noRun) { 1 } else {
        min(MAX_N_WORKERS_PER_PACKAGE, nWorkers)
    }
    let parallelCtx = ParallelCtx(nWorkersPerPackage, semaphore)
    let format = ReportFormat.fromDefaultConfiguration()
    let outputReporter = TestOutputReporter.fromDefaultConfiguration()
    let progressReporter = ProgressReporter.fromDefaultConfiguration()
    progressReporter?.startReporting()
    let perPackageReporter = PerPackageReporter(format, outputReporter)
    let reportCtx = ReportCtx(perPackageReporter, outputReporter)
    let project = ExecutableTestProject.fromDefaultConfiguration()
    let projectResult = Framework.launch(api: FromCli, progressQueue: progressReporter?.updateQueue,
        hasWorkersInSetup: true) {
        project.execute(parallelCtx, reportCtx)
    }
    TextReports.printProjectSummaryReport(projectResult, outputReporter, defaultConfiguration())
    progressReporter?.stopAndClear()
    errorCode(projectResult.details)
}

class ModuleExecutionResult <: ResultContainer<TestGroupResult> {
    /*
     * @noThrow
     */
    ModuleExecutionResult(
        let moduleName: String
    ) {}
}

      /*
       * @noThrow
       */
class ProjectExecutionResult <: ResultContainer<ModuleExecutionResult> {}

class PackageExecutionResult {
    /*
     * @noThrow
     */
    PackageExecutionResult(let packageResult: TestGroupResult) {}
}
private struct ExecutableTestProject <: Serializable<ExecutableTestProject> {
    /*
     * @noThrow
     */
    ExecutableTestProject(let testModules: Array<ExecutableTestModule>) {}
    static let API_VERSION = 2

    /*
     * @throws Exception
     */
    public func serializeInternal(): DataModel {
        throw Exception("Implemented in CJPM")
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws DataModelException
     * @throws Exception
     */
    public static func deserialize(dm: DataModel): ExecutableTestProject {
        let dms = dm as DataModelStruct ?? throw Exception("Data is expected to be a DataModelStruct")
        if (Int64.deserialize(dms.get("apiVersion")) != API_VERSION) {
            throw Exception("This version of CJPM is not compatible with std.unittest")
        }
        ExecutableTestProject(
            Array<ExecutableTestModule>.deserialize(dms.get("testModules"))
        )
    }

    /*
     * @throws JsonException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws DataModelException
     * @throws Exception
     */
    static func fromJson(string: String): ExecutableTestProject {
        string |>
            JsonValue.fromStr |>
            DataModelStruct.fromJson |>
            ExecutableTestProject.deserialize
    }

    /*
     * @throws RegexException
     * @throws ArithmeticException
     * @throws IllegalMemoryException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws DataModelException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws UnittestOptionValidationException
     * @throws IllegalArgumentException
     * @throws JsonException
     * @throws FSException
     * @throws Exception
     * @throws ProcessException
     * @throws OutOfMemoryError
     */
    static func fromDefaultConfiguration(): ExecutableTestProject {
        if (let Some(path) <- defaultConfiguration().get(KeyInternalTestrunnerInputPath.internalTestrunnerInputPath)) {
            Path(path) |> File.readFrom |> String.fromUtf8 |> ExecutableTestProject.fromJson
        } else {
            eprintln("Error: std.testrunner executable is expected to be called only by 'cjpm test' command internally.")
            throw Exception("${OP_INTERNAL_TESTRUNNER_INPUT_PATH} is expected")
        }
    }

    /*
     * @throws RegexException
     * @throws ConcurrentModificationException
     * @throws UnittestOptionValidationException
     * @throws TimeoutException
     * @throws DataModelException
     * @throws InvalidDataException
     * @throws JsonException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IllegalMemoryException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws Exception
     * @throws ProcessException
     * @throws FSException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws SocketException
     */
    func execute(parallelCtx: ParallelCtx, reportCtx: ReportCtx): ProjectExecutionResult {
        this.testModules |> mapParallelOrdered(this.testModules.size) { testModule =>
            testModule.registerTestCases(parallelCtx, reportCtx)
        } |> collectArray

        let projectResult = ProjectExecutionResult()
        this.testModules |>
            mapParallelOrdered(this.testModules.size) { testModule =>
                testModule.execute(parallelCtx, reportCtx)
            } |>
            forEach(projectResult.add)
        projectResult.finish()
        projectResult
    }
}
private struct ExecutableTestModule <: Serializable<ExecutableTestModule> {
    /*
     * @noThrow
     */
    ExecutableTestModule(let name: String, let testPackages: Array<ExecutableTestPackage>) {}

    /*
     * @throws Exception
     */
    public func serializeInternal(): DataModel {
        throw Exception("Implemented in CJPM")
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws DataModelException
     * @throws Exception
     */
    public static func deserialize(dm: DataModel): ExecutableTestModule {
        let dms = dm as DataModelStruct ?? throw Exception("Data is expected to be a DataModelStruct")
        ExecutableTestModule(
            String.deserialize(dms.get("name")),
            Array<ExecutableTestPackage>.deserialize(dms.get("testPackages"))
        )
    }

    /*
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
    func registerTestCases(parallelCtx: ParallelCtx, reportCtx: ReportCtx): Unit {
        this.testPackages |> mapParallelOrdered(this.testPackages.size) { testPackage =>
            testPackage.registerTestCases(parallelCtx, reportCtx)
        } |> collectArray
    }

    /*
     * @throws RegexException
     * @throws ConcurrentModificationException
     * @throws UnittestOptionValidationException
     * @throws TimeoutException
     * @throws DataModelException
     * @throws InvalidDataException
     * @throws JsonException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IllegalMemoryException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws Exception
     * @throws ProcessException
     * @throws FSException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws SocketException
     */
    func execute(parallelCtx: ParallelCtx, reportCtx: ReportCtx): ModuleExecutionResult {
        let packageResults = ModuleExecutionResult(name)
        this.testPackages |> mapParallelOrdered(this.testPackages.size) { testPackage =>
            let packageResult = testPackage.execute(parallelCtx, reportCtx)
            reportCtx.perPackageReporter.printIntermediateResult(packageResult)
            reportCtx.perPackageReporter.dumpPackageReport(packageResult)
            packageResult.packageResult
        } |> forEach(packageResults.add)
        packageResults.finish()
        packageResults
    }
}
private struct ExecutableTestPackage <: Serializable<ExecutableTestPackage> {
    /*
     * @noThrow
     */
    ExecutableTestPackage(let name: String, let executeCommand: TestPackageExecuteCommand) {}

    /*
     * @throws Exception
     */
    public func serializeInternal(): DataModel {
        throw Exception("Implemented in CJPM")
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws DataModelException
     * @throws Exception
     */
    public static func deserialize(dm: DataModel): ExecutableTestPackage {
        let dms = dm as DataModelStruct ?? throw Exception("Data is expected to be a DataModelStruct")
        ExecutableTestPackage(
            String.deserialize(dms.get("name")),
            TestPackageExecuteCommand.deserialize(dms.get("executeCommand"))
        )
    }

    private let registeredWorkers = ArrayList<WorkerProcess>()

    /*
     * @throws OutOfMemoryError
     * @throws ProcessException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    private func buildExecutionContext(parallelCtx: ParallelCtx, reportCtx: ReportCtx): MainExecutionCtx {
        let inheritingCommand = this.executeCommand
            .overridingCurrentEnv()
            .withJsonConfiguration()
            .withRunnerOption()
        MainExecutionCtx(
            parallelCtx.nWorkersPerPackage,
            parallelCtx.workersQuota,
            reportCtx.outputReporter,
            inheritingCommand
        )
    }

    /*
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
    func registerTestCases(parallelCtx: ParallelCtx, reportCtx: ReportCtx): Unit {
        registeredWorkers.add(all: initWorkersMain(buildExecutionContext(parallelCtx, reportCtx)))
    }

    /*
     * @throws TimeoutException
     * @throws InvalidDataException
     * @throws JsonException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IllegalMemoryException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws Exception
     * @throws ProcessException
     * @throws FSException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws SocketException
     */
    func execute(parallelCtx: ParallelCtx, reportCtx: ReportCtx): PackageExecutionResult {
        let ctx = buildExecutionContext(parallelCtx, reportCtx)
        let result = PackageExecutionResult(executeMain(registeredWorkers.toArray(), this.name, ctx))
        registeredWorkers.clear()
        return result
    }
}
struct TestPackageExecuteCommand <: Serializable<TestPackageExecuteCommand> {
    /*
     * @noThrow
     */
    TestPackageExecuteCommand(
        public let command: String,
        public let args: Array<String>,
        public let env: Map<String, String>
    ) {}

    /*
     * @throws Exception
     */
    public func serializeInternal(): DataModel {
        throw Exception("Implemented in CJPM")
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws DataModelException
     * @throws Exception
     */
    public static func deserialize(dm: DataModel): TestPackageExecuteCommand {
        let dms = dm as DataModelStruct ?? throw Exception("Data is expected to be a DataModelStruct")
        TestPackageExecuteCommand(
            String.deserialize(dms.get("command")),
            Array<String>.deserialize(dms.get("args")),
            HashMap<String, String>.deserialize(dms.get("env"))
        )
    }

    /*
     * @throws OutOfMemoryError
     * @throws ProcessException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func overridingCurrentEnv(): TestPackageExecuteCommand {
        let env = HashMap<String, String>()
        try {
            env.add(all: Process.current.environment)
        } catch (_: ProcessException) {  }
        env.add(all: this.env)
        TestPackageExecuteCommand(command, args, env)
    }

    /*
     * @throws OutOfMemoryError
     * @throws ProcessException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func withJsonConfiguration(): TestPackageExecuteCommand {
        let args = ArrayList<String>()
        args.add(all: this.args)
        for (arg in Process.currentArgs where arg.contains("--json-configuration")) {
            args.add(arg)
        }
        TestPackageExecuteCommand(command, args.toArray(), env)
    }


    /*
     * @throws OutOfMemoryError
     * @throws ProcessException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    func withRunnerOption(): TestPackageExecuteCommand {
        for (arg in Process.currentArgs where arg.contains(OP_INTERNAL_TESTRUNNER_INPUT_PATH)) {
            return TestPackageExecuteCommand(command, args + arg, env)
        }
        throw Exception("Expected test runner input")
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func withArgs(newArgs: Array<String>): TestPackageExecuteCommand {
        let args = ArrayList<String>()
        args.add(all: this.args)
        args.add(all: newArgs)
        TestPackageExecuteCommand(command, args.toArray(), env)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     */
    static func fromCurrentProcess(): TestPackageExecuteCommand {
        let env = HashMap<String, String>()
        try {
            env.add(all: Process.current.environment)
        } catch (_: ProcessException) {  }
        TestPackageExecuteCommand(Process.current.command, Process.currentArgs, env)
    }
}

struct ParallelCtx {
    /*
     * @noThrow
     */
    ParallelCtx(let nWorkersPerPackage: Int64, let workersQuota: Semaphore) {}
}

struct ReportCtx {
    /*
     * @noThrow
     */
    ReportCtx(let perPackageReporter: PerPackageReporter, let outputReporter: TestOutputReporter) {}
}

class PerPackageReporter {
    /*
     * @noThrow
     */
    PerPackageReporter(private let format: ?ReportFormat, private let outputReporter: TestOutputReporter) {}

    /*
     * @throws OverflowException
     * @throws UnittestOptionValidationException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws FSException
     * @throws Exception
     * @throws ProcessException
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws JsonException
     * @throws RegexException
     * @throws ConcurrentModificationException
     * @throws InvalidDataException
     * @throws DataModelException
     * @throws IllegalMemoryException
     */
    func printIntermediateResult(executionResult: PackageExecutionResult) {
        let pp = TerminalPrettyPrinter.fromDefaultConfiguration()
        pp.exclusive { pp =>
            let packageResult = executionResult.packageResult
            TextReports.printIntermediatePackageResult(pp, packageResult, outputReporter, defaultConfiguration())
        }
    }

    /*
     * @noThrow
     */
    func dumpPackageReport(executionResult: PackageExecutionResult) {
        format?.report(executionResult.packageResult)
    }
}

/*
 * @throws getOrThrow
 * @throws JsonException
 * @throws OutOfMemoryError
 * @throws RegexException
 * @throws UnittestOptionValidationException
 * @throws IndexOutOfBoundsException
 * @throws ArithmeticException
 * @throws ProcessException
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 * @throws UnittestCliOptionsFormatException
 * @throws Exception
 */
private func errorCode(details: Details): Int64 {
    if (TestProcessKind.fromDefaultConfiguration().isWorker) {
        0
    } else {
        details.errorCount + details.failedCount
    }
}

/*
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
private func needStartWorker(tests: Array<TestSuite>, outputReporter: TestOutputReporter): Bool {
    isParallelEnabled() || deathAwareEnabled() || anyTimeout(tests) || outputReporter.capture
}

/*
 * @throws getOrThrow
 * @throws JsonException
 * @throws OutOfMemoryError
 * @throws ArithmeticException
 * @throws ProcessException
 * @throws UnittestOptionValidationException
 * @throws RegexException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Exception
 * @throws IllegalMemoryException
 * @throws UnittestCliOptionsFormatException
 */
private func isParallelEnabled(): Bool {
    let parallelInfo = ParallelInfo.fromDefaultConfiguration()
    match (parallelInfo) {
        case Parallel(_) => true
        case NoParalell => false
    }
}

/*
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
private func deathAwareEnabled(): Bool {
    defaultConfiguration().get(KeyDeathAware.deathAware) ?? false
}

/*
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
private func anyTimeout(suites: Array<TestSuite>): Bool {
    if (defaultConfiguration().timeout.isSome()) {
        return true
    }
    if (suites |> any { it => it.suiteConfiguration.timeout.isSome() }) {
        return true
    }
    suites |>
        flatMap<TestSuite, CaseOrBench> { it => it.cases } |>
        any<CaseOrBench> { it => it.caseConfiguration.timeout.isSome() }
}
