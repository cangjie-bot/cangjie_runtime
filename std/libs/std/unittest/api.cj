






package std.unittest

import std.collection.ArrayList

public class TestSuite {
    /*
     * @noThrow
     */
    TestSuite(
        private let _name: String,
        let cases: Array<CaseOrBench>,
        let suiteConfiguration: Configuration,
        let beforeAlls: Array<() -> Unit>,
        let beforeEachs: Array<(String) -> Unit>,
        let afterEachs: Array<(String) -> Unit>,
        let afterAlls: Array<() -> Unit>,
        let template: ?TestSuite
    ) {
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() { _name }
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func runTests(): TestReport {
        run(Configuration(), OnlyTests).asTestReport(Configuration())
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func runTests(configuration: Configuration): TestReport {
        run(configuration, OnlyTests).asTestReport(configuration)
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func runBenchmarks(): BenchReport {
        run(Configuration(), OnlyBenchmarks).asBenchReport(Configuration())
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func runBenchmarks(configuration: Configuration): BenchReport {
        run(configuration, OnlyBenchmarks).asBenchReport(configuration)
    }

    /*
     * @throws InvalidDataException
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws OverflowException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
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
    func run(configuration: Configuration, mode: ExecutionMode): TestGroupResult {
        fakeGroup(this).run(configuration, mode)
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
    func execute(groupName: String, runConfiguration: Configuration, filterService: FilterService): TestSuiteResult {
        let id = TestSuiteId.fromTestSuite(groupName, this)
        TestSuiteExecutor(runConfiguration, id, this, filterService).execute()
    }

    /*
     * @noThrow
     */
    public static func builder(name: String): TestSuiteBuilder {
        TestSuiteBuilder(name)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func builder(suite: TestSuite): TestSuiteBuilder {
        let builder = TestSuiteBuilder(suite.name)
        builder.beforeAlls.add(all: suite.beforeAlls)
        builder.beforeEachs.add(all: suite.beforeEachs)
        builder.afterEachs.add(all: suite.afterEachs)
        builder.afterAlls.add(all: suite.afterAlls)
        builder.tests.add(all: suite.cases)
        builder.configure(suite.suiteConfiguration)
        builder.template_ = suite.template
        builder
    }
}

public class TestGroup {
    /*
     * @noThrow
     */
    TestGroup(
        private let _name: String,
        let suites: Array<TestSuite>,
        let groupConfiguration: Configuration
    ) {}

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            _name
        }
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func runTests(): TestReport {
        run(Configuration(), OnlyTests).asTestReport(Configuration())
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func runTests(configuration: Configuration): TestReport {
        run(configuration, OnlyTests).asTestReport(configuration)
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func runBenchmarks(): BenchReport {
        run(Configuration(), OnlyBenchmarks).asBenchReport(Configuration())
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func runBenchmarks(configuration: Configuration): BenchReport {
        run(configuration, OnlyBenchmarks).asBenchReport(configuration)
    }

    /*
     * @throws InvalidDataException
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws OverflowException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
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
    func run(configuration: Configuration, mode: ExecutionMode): TestGroupResult {
        let groupId = this.name
        let runConfiguration = Configuration.merge(configuration, groupConfiguration)
        let filterService = FilterService(UserTestFilter.fromConfiguration(configuration), mode.asFilter())
        Framework.launch<TestGroupResult>(api: FromPublicApi, hasWorkersInSetup: false) {
            let groupResult = TestGroupResult(groupId, [])
            for (suite in suites) {
                let suiteResult = suite.execute(groupId, runConfiguration, filterService)
                groupResult.add(suiteResult)
            }
            groupResult.finish()
            groupResult
        }
    }
    /*
     * @noThrow
     */
    public static func builder(name: String): TestGroupBuilder {
        TestGroupBuilder(name)
    }

    /*
     * @noThrow
     */
    public static func builder(group: TestGroup): TestGroupBuilder {
        TestGroupBuilder(group.name)
    }
}

public class TestGroupBuilder {
    private let suites = ArrayList<TestSuite>()
    private var configuration = Configuration()

    /*
     * @noThrow
     */
    TestGroupBuilder(
        private var name: String
    ) {}

    /*
     * @noThrow
     */
    public func setName(name: String): TestGroupBuilder {
        this.name = name
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func configure(configuration: Configuration): TestGroupBuilder {
        this.configuration = Configuration.merge(this.configuration, configuration)
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(test: UnitTestCase): TestGroupBuilder {
        suites.add(fakeSuite(Case(test)))
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(benchmark: Benchmark): TestGroupBuilder {
        suites.add(fakeSuite(Bench(benchmark)))
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(suite: TestSuite): TestGroupBuilder {
        suites.add(suite)
        this
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func build(): TestGroup {
        TestGroup(name, suites.toArray(), configuration)
    }
}

public class TestSuiteBuilder {
    let beforeAlls = ArrayList<() -> Unit>()
    let beforeEachs = ArrayList<(String) -> Unit>()
    let afterEachs = ArrayList<(String) -> Unit>()
    let afterAlls = ArrayList<() -> Unit>()

    var configuration = Configuration()
    var tests = ArrayList<CaseOrBench>()

    var template_ = Option<TestSuite>.None

    /*
     * @noThrow
     */
    TestSuiteBuilder(
        private var name: String
    ) {}

    /*
     * @noThrow
     */
    public func setName(name: String): TestSuiteBuilder {
        this.name = name
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func configure(configuration: Configuration): TestSuiteBuilder {
        this.configuration = Configuration.merge(this.configuration, configuration)
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func beforeEach(body: (String) -> Unit): TestSuiteBuilder {
        beforeEachs.add(body)
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func afterEach(body: (String) -> Unit): TestSuiteBuilder {
        afterEachs.add(body)
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func beforeEach(body: () -> Unit): TestSuiteBuilder {
        beforeEachs.add({ _ => body() })
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func afterEach(body: () -> Unit): TestSuiteBuilder {
        afterEachs.add({ _ => body() })
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func beforeAll(body: () -> Unit): TestSuiteBuilder {
        beforeAlls.add(body)
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func afterAll(body: () -> Unit): TestSuiteBuilder {
        afterAlls.add(body)
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(test: UnitTestCase): TestSuiteBuilder {
        tests.add(Case(test))
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(benchmark: Benchmark): TestSuiteBuilder {
        tests.add(Bench(benchmark))
        this
    }

    /*
     * @noThrow
     */
    public func template(template: TestSuite): TestSuiteBuilder {
        template_ = Some(template)
        this
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func build(): TestSuite {
        TestSuite(
            name,
            tests.toArray(),
            configuration,
            beforeAlls.toArray(),
            beforeEachs.toArray(),
            afterEachs.toArray(),
            afterAlls.toArray(),
            template_
        )
    }
}

public class UnitTestCase {
    /*
     * @noThrow
     */
    UnitTestCase(
        private let _name: String,
        let caseConfiguration: Configuration,
        let executor: Executor
    ) {}

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            _name
        }
    }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func run(): TestReport {
        fakeGroup(fakeSuite(Case(this))).run(Configuration(), OnlyTests).asTestReport(caseConfiguration)
    }

    /*
     * @noThrow
     */
    public static func createParameterized<T>(name: String, strategy: DataStrategy<T>,
        configuration!: Configuration = Configuration(), body!: (T) -> Unit): UnitTestCase {
        let processor = DataStrategyProcessor<T>.start(strategy, "args")
        createParameterized<T>(name, processor, configuration: configuration, body: body)
    }

    /*
     * @noThrow
     */
    public static func createParameterized<T>(name: String, strategy: DataStrategyProcessor<T>,
        configuration!: Configuration = Configuration(), body!: (T) -> Unit): UnitTestCase {
        let executor = TestCaseExecutor(strategy, body)
        UnitTestCase(name, configuration, executor)
    }

    /*
     * @noThrow
     */
    public static func create(name: String, configuration!: Configuration = Configuration(), body!: () -> Unit): UnitTestCase {
        createParameterized<Unit>(name, noArgsProcessor(), configuration: configuration, body: { _ => body() })
    }
}

public class Benchmark {
    /*
     * @noThrow
     */
    Benchmark(
        private let _name: String,
        let benchmarkConfiguration: Configuration,
        let executor: Executor
    ) {}

                               /*
                                * @noThrow
                                */
    public prop name: String { get() { _name } }

    /*
     * @throws EnvException
     * @throws ExpectationFailedException
     * @throws MockFrameworkInternalError
     * @throws RegexException
     * @throws JsonException
     * @throws AssertException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws MockFrameworkException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws IllegalSynchronizationStateException
     * @throws UnittestOptionValidationException
     * @throws getOrFail
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws IllegalFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func run(): BenchReport {
        fakeGroup(fakeSuite(Bench(this))).run(Configuration(), OnlyBenchmarks).asBenchReport(benchmarkConfiguration)
    }

    /*
     * @noThrow
     */
    static func createWithExplicitLoop<T>(
        name: String,
        strategy: DataStrategyProcessor<T>,
        configuration: Configuration,
        optLambda: (T, Int64, Int64) -> Float64
    ): Benchmark {
        Benchmark(name, configuration, BenchExecutor<T>(strategy, optLambda))
    }
    /*
     * @throws IllegalArgumentException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
    public static func createParameterized<T>(
        name: String,
        strategy: DataStrategy<T>,
        configuration!: Configuration = Configuration(),
        measurement!: Measurement = TimeNow(),
        body!: (T) -> Unit
    ): Benchmark {
        createParameterized(name, DataStrategyProcessor.start(strategy, "args"), configuration: configuration,
            measurement: measurement, body: body)
    }
    /*
     * @throws IllegalArgumentException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
    public static func createParameterized<T>(
        name: String,
        strategy: DataStrategyProcessor<T>,
        configuration!: Configuration = Configuration(),
        measurement!: Measurement = TimeNow(),
        body!: (T) -> Unit
    ): Benchmark {
        configuration.set(KeyMeasurementInfo.measurementInfo, measurement.info)
        createWithExplicitLoop<T>(name, strategy, configuration, createBenchmarkLoop<T>(measurement, body))
    }
    /*
     * @throws IllegalArgumentException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
    public static func create(
        name: String,
        configuration!: Configuration = Configuration(),
        measurement!: Measurement = TimeNow(),
        body!: () -> Unit
    ): Benchmark {
        createParameterized<Unit>(name, noArgsProcessor(), configuration: configuration, measurement: measurement,
            body: {_ => body()})
    }
    /*
     * @noThrow
     */
    private static func createBenchmarkLoop<T>(
        measurement: Measurement,
        singleRun: (T) -> Unit
    ): (T, Int64, Int64) -> Float64 {
        { value, count: Int64, max: Int64 =>
            let start = measurement.measure()
            for (i in 0..max) {
                if (i < count) {
                    singleRun(value)
                }
            }
            measurement.measure() - start
        }
    }
}

public struct TestCaseInfo {
    /*
     * @noThrow
     */
    TestCaseInfo(
        public let groupName: String,
        public let suiteName: String,
        public let caseName: String        
    ) {}
}

sealed abstract class Report {
    private let details: Details

    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    Report(
        let groupResult: TestGroupResult,
        let runConfiguration: Configuration
    ) {
        this.details = groupResult.details
    }

                                      /*
                                       * @noThrow
                                       */
    public prop errorCount:   Int64 { get() { details.errorCount }}
                                      /*
                                       * @noThrow
                                       */
    public prop caseCount:    Int64 { get() { details.totalCount }}
                                      /*
                                       * @noThrow
                                       */
    public prop passedCount:  Int64 { get() { details.passedCount }}
                                      /*
                                       * @noThrow
                                       */
    public prop failedCount:  Int64 { get() { details.failedCount }}
                                      /*
                                       * @noThrow
                                       */
    public prop skippedCount: Int64 { get() { details.skippedCount }}
}

public class TestReport <: Report {
    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    TestReport(groupResult: TestGroupResult, runConfiguration: Configuration) {
        super(groupResult, runConfiguration)
    }

    /*
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws FSException
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws NoneValueException
     */
    public func reportTo<T>(reporter: Reporter<TestReport, T>): T {
        (doReport(reporter) as T).getOrThrow()
    }

    /*
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws FSException
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws Exception
     */
    private func doReport<T>(reporter: Reporter<TestReport, T>): Any {
        match (reporter) {
            case printer: TextReporterBase<T> => return printer.printReport(this)
            case xmlReporter: XmlReporter => UTestReportFormat.XML(xmlReporter.directory).report(groupResult)
            case _ => throw Exception("Unkown reporter")
        }
    }
}

public class BenchReport <: Report {
    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    BenchReport(groupResult: TestGroupResult, runConfiguration: Configuration) {
        super(groupResult, runConfiguration)
    }

    /*
     * @throws InvalidDataException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws RegexException
     * @throws ConcurrentModificationException
     * @throws JsonException
     * @throws FSException
     * @throws Exception
     * @throws ProcessException
     * @throws ArithmeticException
     * @throws OutOfMemoryError
     * @throws TimeoutException
     */
    public func reportTo<T>(reporter: Reporter<BenchReport, T>): T {
        (doReport(reporter) as T).getOrThrow()
    }

    /*
     * @throws InvalidDataException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws RegexException
     * @throws ConcurrentModificationException
     * @throws JsonException
     * @throws FSException
     * @throws Exception
     * @throws ProcessException
     * @throws ArithmeticException
     * @throws OutOfMemoryError
     * @throws TimeoutException
     */
    private func doReport<T>(reporter: Reporter<BenchReport, T>): Any {
        match (reporter) {
            case printer: TextReporterBase<T> => printer.printReport(this)
            case csv: CsvReporter => BenchReportFormat.CSV(csv.directory).report(groupResult)
            case csvRaw: CsvRawReporter => BenchReportFormat.CSV_RAW(csvRaw.directory).report(groupResult)
            case rawStatsReporter: RawStatsReporter => rawStatsReporter.benchResultsAsMap(groupResult)
            case _ => throw Exception("Unkown reporter")
        }
    }
}

public interface TestClass {
    /*
     * @noThrow
     */
    func asTestSuite(): TestSuite
}
public class TestPackage {
    private let builder: TestGroupBuilder

    /*
     * @noThrow
     */
    public TestPackage(
        let name: String
    ) {
        this.builder = TestGroupBuilder(name)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func registerCase(testCase: () -> UnitTestCase): Unit {
        builder.add(testCase())
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func registerSuite(suite: () -> TestSuite): Unit {
        builder.add(suite())
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func registerBench(bench: () -> Benchmark): Unit {
        builder.add(bench())
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func build(): TestGroup {
        builder.build()
    }
}

enum ExecutionMode {
    OnlyTests | OnlyBenchmarks

    /*
     * @noThrow
     */
    func asFilter(): FrameworkTestFilter {
        match (this) {
            case OnlyTests => BenchTestFilter(false)
            case OnlyBenchmarks => BenchTestFilter(true)
        }
    }
}

enum CaseOrBench {
      /*
       * @noThrow
       */
    | Case(UnitTestCase)
      /*
       * @noThrow
       */
    | Bench(Benchmark)

    prop caseConfiguration: Configuration {
        /*
         * @noThrow
         */
        get() {
            match (this) {
                case Case(testCase) => testCase.caseConfiguration
                case Bench(benchmark) => benchmark.benchmarkConfiguration
            }
        }
    }

    prop name: String {
        /*
         * @noThrow
         */
        get() {
            match (this) {
                case Case(testCase) => testCase.name
                case Bench(benchmark) => benchmark.name
            }
        }
    }

    prop isBench: Bool {
        /*
         * @noThrow
         */
        get() {
            match (this) {
                case Case(_) => false
                case Bench(_) => true
            }
        }
    }

    prop executor: Executor {
        /*
         * @noThrow
         */
        get() {
            match (this) {
                case Case(testCase) => testCase.executor
                case Bench(benchmark) => benchmark.executor
            }
        }
    }
}

/*
 * @noThrow
 */
private func fakeSuite(test: CaseOrBench): TestSuite {
    TestSuite("TestCase_${test.name}", [test], Configuration(),
        [], [], [], [], None
    )
}

/*
 * @noThrow
 */
private func fakeGroup(testSuite: TestSuite): TestGroup {
    TestGroup(
        "default",
        [testSuite], Configuration()
    )
}

extend TestGroupResult {
    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    func asBenchReport(runConfiguration: Configuration) {
        BenchReport(this, runConfiguration)
    }

    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     */
    func asTestReport(runConfiguration: Configuration) {
        TestReport(this, runConfiguration)
    }
}

private let NO_ARGS_NAME = "<no args>"

/*
 * @noThrow
 */
private func noArgsProcessor(): DataStrategyProcessor<Unit> {
    DataStrategyProcessor<Unit>.start([()], "<no args>")
}

extend Array<InputParameter> {
    /*
     * @throws IndexOutOfBoundsException
     */
    func isNoArg() {
        size == 1 && this[0].name == NO_ARGS_NAME
    }
}
