






package std.unittest

import std.unittest.common.PrettyText
import std.unittest.mock.*
import std.collection.*
import std.collection.concurrent.LinkedBlockingQueue
import std.time.DateTime
import std.env.exit

class TestSuiteExecutor {
    private let suiteConfiguration: Configuration
    private let suiteInfo: TestSuiteReportInfo

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    TestSuiteExecutor(
        private let externalConfiguration: Configuration,
        private let suiteId: TestSuiteId,
        private let testSuite: TestSuite,
        private let filterService: FilterService
    ) {
        this.suiteConfiguration = Configuration.merge(externalConfiguration, testSuite.wholeConfiguration)
        this.suiteInfo = TestSuiteReportInfo(tags: this.suiteConfiguration.tags)
    }

    /*
     * @throws IllegalMemoryException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws InvalidDataException
     * @throws JsonException
     * @throws SocketException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws MockFrameworkException
     * @throws IllegalSynchronizationStateException
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws OutOfMemoryError
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws Exception
     */
    func execute(): TestSuiteResult {
        let result = TestSuiteResult(suiteId, suiteInfo)

        let testCases = testSuite.allCasesToBeExecuted(filterService, suiteId)

        if (shallNotRunLifecycle(testCases)) {
            for (testCase in testCases) {
                result.add(tryRun(testCase))
            }
            result.finish()
            return result
        }

        MockFramework.openSession("initializer of class ${testSuite.name}", Stateless)

        let beforeAllResult = runNonTestBodyStep(suiteId, suiteInfo, BeforeAll) {
            testSuite.runBeforeAll()
        }
        result.add(beforeAllResult)

        if (!beforeAllResult.hasFailures()) {
            for (testCase in testCases) {
                result.add(tryRun(testCase))
            }
        }

        let afterAllResult = runNonTestBodyStep(suiteId, suiteInfo, AfterAll) {
            testSuite.runAfterAll()
            Framework.withCurrentContext { ctx =>
                for (unattached in Framework.collectUnattachedFailures()) {
                    ctx.storeCheckResult(unattached)
                }
            }
        }

        if (!beforeAllResult.hasFailures()) {
            result.add(afterAllResult)
        }
        try {
            MockFramework.closeSession()
        } catch (e: Exception) {
        }
        result.finish()
        result
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    private func shallNotRunLifecycle(testCases: Collection<CaseOrBench>): Bool {
        suiteConfiguration.skip || externalConfiguration.noRun || testCases.isEmpty() || allSkipped(testCases)
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    private func allSkipped(testCases: Collection<CaseOrBench>): Bool {
        testCases |> all<CaseOrBench> { it => it.caseConfiguration.skip }
    }

    /*
     * @throws MockFrameworkInternalError
     * @throws IllegalMemoryException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws ExpectationFailedException
     * @throws EnvException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws JsonException
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws Exception
     * @throws IllegalStateException
     * @throws AssertException
     */
    private func tryRun(testOrBench: CaseOrBench): TestCaseResult {
        let caseId = TestCaseId(suiteId, testOrBench.name, isBench: testOrBench.isBench)
        let caseInfo = TestCaseReportInfo(tags: testOrBench.caseConfiguration.tags)
        let caseConfiguration = Configuration.merge(suiteConfiguration, testOrBench.caseConfiguration)
        let caseKey = CaseFilterKey(caseId, tags: caseConfiguration.tags, isTopLevel: caseConfiguration.fromTopLevel)
        let shouldSkip = suiteConfiguration.skip || caseConfiguration.skip ||
            filterService.userFilter.shouldSkipTestCase(caseKey)

        caseConfiguration.initRandom()
        let caseRunner: (TestCaseResult) -> Unit = if (shouldSkip) {
            runSkip
        } else if (externalConfiguration.noRun) {
            runNoRun
        } else {
            var testBody = runSingleCase(caseConfiguration, testOrBench.executor)
            if (let Some(duration) <- caseConfiguration.timeout) {
                testBody = runConsideringTimeout(caseConfiguration, duration, testBody)
            }
            testBody
        }

        runTestCaseStep(caseId, caseInfo, suiteInfo, caseConfiguration, caseRunner)
    }

    /*
     * @throws AssertException
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
    private static func runNonTestBodyStep(
        suiteId: TestSuiteId, suiteInfo: TestSuiteReportInfo,
        stepKind: LStep, stepBody: () -> Unit
    ): TestCaseResult {
        Framework.onLifecycleStart(suiteId, suiteInfo, stepKind)

        let id = TestCaseId(suiteId, stepKind.toString(), isBench: false)
        let info = TestCaseReportInfo.empty()
        let step = runLifecycleStep(stepKind, stepBody)
        let result = TestCaseResult.fromSingleStep(id, info, step)
        result.finish()

        Framework.onFinished(result)
        return result
    }

    /*
     * @throws AssertException
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private static func runLifecycleStep(step: LStep, stepBody: () -> Unit): RunStepResult {
        Framework.runStepBody(Lifecycle(step), Test(0), stepBody)
    }

    /*
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
    private static func runTestCaseStep(
        caseId: TestCaseId,
        caseInfo: TestCaseReportInfo,
        suiteInfo: TestSuiteReportInfo,
        configuration: Configuration,
        caseRunner: (TestCaseResult) -> Unit
    ): TestCaseResult {
        Framework.onTestCaseStarted(caseId, caseInfo, suiteInfo)

        let testCaseResult = TestCaseResult(caseId, caseInfo, RenderOptions.fromConfiguration(configuration))
        caseRunner(testCaseResult)
        testCaseResult.finish()
        Framework.onFinished(testCaseResult)
        return testCaseResult
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    func runSkip(testCaseResult: TestCaseResult): Unit {
        testCaseResult.add(RunStepResult(0, DateTime.now(), StepKind.Skip, Test(0), duration: Duration.Zero))
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    func runNoRun(testCaseResult: TestCaseResult): Unit {
        testCaseResult.add(RunStepResult(0, DateTime.now(), StepKind.NoRun, Test(0), duration: Duration.Zero))
    }

    /*
     * @throws ExpectationFailedException
     * @throws MockFrameworkException
     * @throws AssertException
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     * @throws ArithmeticException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    func runSingleCase(caseConfiguration: Configuration, executor: Executor): (TestCaseResult) -> Unit {
        return { result =>
            let caseId = result.caseId
            let beforeEachResult = runLifecycleStep(BeforeEach) {
                testSuite.runBeforeEach(caseId.caseName)
            }
            result.add(beforeEachResult)

            if (!beforeEachResult.hasFailures()) {
                executor.execute(suiteInfo, result, caseConfiguration)
            }

            let afterEachResult = runLifecycleStep(AfterEach) {
                testSuite.runAfterEach(caseId.caseName)
            }
            if (!result.hasFailures() && afterEachResult.hasFailures()) {
                result.add(afterEachResult)
            }
        }
    }

    /*
     * @throws IllegalMemoryException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws EnvException
     * @throws OverflowException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws JsonException
     * @throws ProcessException
     * @throws Exception
     * @throws IllegalStateException
     * @throws AssertException
     */
    private static func runConsideringTimeout(
        caseConfiguration: Configuration,
        duration: Duration,
        testBody: (TestCaseResult) -> Unit
    ): (TestCaseResult) -> Unit {
        return { testCaseResult =>
            let finishedBeforeTimeoutSignalQueue = LinkedBlockingQueue<Unit>(1)
            let testingThread = spawn {
                testBody(testCaseResult)
            }
            let killerThread = spawn {
                if (let None <- finishedBeforeTimeoutSignalQueue.remove(duration)) {
                    onTimeout(caseConfiguration, testCaseResult, testingThread)
                }
            }
            testingThread.get()
            finishedBeforeTimeoutSignalQueue.add(())
            killerThread.get()
        }
    }

    /*
     * @throws IllegalMemoryException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws EnvException
     * @throws OverflowException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws JsonException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws Exception
     * @throws IllegalStateException
     * @throws AssertException
     */
    private static func onTimeout(
        caseConfiguration: Configuration, 
        testCaseResult: TestCaseResult, 
        testingThread: Future<Unit>
    ) {
        if (TestProcessKind.fromDefaultConfiguration().isWorker) {
            exitOnTimeout(testCaseResult)
        } else {
            let suiteId = testCaseResult.caseId.suiteId
            let info = TestCaseInfo(suiteId.groupName, suiteId.suiteName, testCaseResult.caseId.caseName)
            caseConfiguration.timeoutHandler(info)
            testingThread.cancel()
            Framework.withCurrentContext { ctx: RunContext =>
                let msg = "Execution time exceeded specified timeout."
                ctx.checkFailed(TimeoutCheckResult(PrettyText(msg)))
            }
        }
    }

    /*
     * @throws AssertException
     * @throws Exception
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws JsonException
     * @throws SocketException
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws EnvException
     */
    private static func exitOnTimeout(testCaseResult: TestCaseResult) {
        Framework.withCurrentContext { ctx: RunContext => 
            let msg = "Test case ended with timeout."
            ctx.storeCheckResult(TimeoutCheckResult(PrettyText(msg)))
        }
        if (let Some(currentResult) <- Framework.abortCurrentStep()) {
            testCaseResult.add(currentResult)
        } else if (let Some(prev) <- testCaseResult.subResults.pop()) {
            let newFailures = prev.checkResults |> concat(Framework.collectUnattachedFailures()) |> collectArray
            let newResult = RunStepResult(prev.checksPassed, prev.startTimestamp, prev.kind, Failure(newFailures),
                duration: prev.duration)
            testCaseResult.add(newResult)
        } else {
            let failures = Framework.collectUnattachedFailures().toArray()
            let newResult = RunStepResult(0, DateTime.now(), UserCode, Failure(failures))
            testCaseResult.add(newResult)
        }

        testCaseResult.finish()
        Framework.onFinished(testCaseResult)
        exit(EXIT_CODE_ON_TIMEOUT)
    }
}

extend TestSuite {
    prop wholeConfiguration: Configuration {
        /*
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         */
        get() {
            Configuration.merge(this.template?.wholeConfiguration ?? Configuration(), this.suiteConfiguration)
        }
    }

    prop allCasesIterator: Iterable<CaseOrBench> {
        /*
         * @noThrow
         */
        get() {
            chain(template?.allCasesIterator ?? Array<CaseOrBench>().iterator(), cases)
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func allCasesToBeExecuted(filterService: FilterService, suiteId: TestSuiteId): Array<CaseOrBench> {
        allCasesIterator |> filter { cob: CaseOrBench =>
            let caseKey = CaseFilterKey.fromTestCase(suiteId, cob, config: cob.caseConfiguration)
            !filterService.frameworkFilter.shouldSkipTestCase(caseKey)
        } |> collectArray
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func casesCountToBeExecuted(filterService: FilterService, suiteId: TestSuiteId): Int64 {
        allCasesToBeExecuted(filterService, suiteId).size
    }

    /*
     * @throws ExpectationFailedException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func runBeforeEach(caseShortName: String): Unit {
        try {
            MockFramework.openSession("func beforeEach", Forbidden)
            runBeforeEachMocked(caseShortName)
        } finally {
            MockFramework.closeSession()
        }
    }

    /*
     * @noThrow
     */
    private func runBeforeEachMocked(caseShortName: String): Unit {
        this.template?.runBeforeEachMocked(caseShortName)
        for (c in beforeEachs) {
            c(caseShortName)
        }
    }

    /*
     * @noThrow
     */
    func runAfterEach(caseShortName: String): Unit {
        for (c in afterEachs) {
            c(caseShortName)
        }
        this.template?.runAfterEach(caseShortName)
    }

    /*
     * @noThrow
     */
    func runBeforeAll(): Unit {
        this.template?.runBeforeAll()
        for (c in beforeAlls) {
            c()
        }
    }

    /*
     * @noThrow
     */
    func runAfterAll(): Unit {
        for (c in afterAlls) {
            c()
        }
        this.template?.runAfterAll()
    }
}

extend Configuration {
    prop skip: Bool {
        /*
         * @throws IndexOutOfBoundsException
         */
        get() {
            this.get(KeySkip.skip) ?? false
        }
    }
}
