






package std.unittest

import std.collection.*
import std.unittest.common.KeyTags

let SYM_DOT: String = "."
let SYM_COMMA: String = ","
let SYM_PLUS: String = "+"
let SYM_NEG: String = "-"
let OP_FILTER = "--${KeyFilter().name}"
let OP_INCLUDE_TAGS_NAME = camelCaseToKebabCase(KeyIncludeTags().name)
let OP_INCLUDE_TAGS = "--${OP_INCLUDE_TAGS_NAME}"
let OP_EXCLUDE_TAGS_NAME = camelCaseToKebabCase(KeyExcludeTags().name)
let OP_EXCLUDE_TAGS = "--${OP_EXCLUDE_TAGS_NAME}"
let OP_EXCLUDE_TAGS_KEY = kebabCaseToCamelCase(OP_EXCLUDE_TAGS_NAME)
let OP_BENCH = "--${KeyBench().name}"

struct SuiteFilterKey {
    SuiteFilterKey(
        let suiteId: TestSuiteId,
        let tags!: Array<String> = Array(),
        let topLevelFunc!: ?String = None
    ) {}

    /**
     * @throws IndexOutOfBoundsException
     */
    static func fromTestSuite(groupName: String, suite: TestSuite) {
        let name: ?String = if (suite.suiteConfiguration.fromTopLevel) {
            suite.cases.get(0)?.name
        } else { None }

        SuiteFilterKey(
            TestSuiteId.fromTestSuite(groupName, suite),
            tags: suite.suiteConfiguration.tags,
            topLevelFunc: name
        )
    }
}

struct CaseFilterKey {
    CaseFilterKey(
        let caseId: TestCaseId,
        let tags!: Array<String> = Array(),
        let isTopLevel!: Bool = false
    ) {}

    /**
     * @throws IndexOutOfBoundsException
     */
    static func fromTestCase(suiteId: TestSuiteId, cob: CaseOrBench, config!: ?Configuration = None) {
        let testCaseId = TestCaseId(suiteId, cob.name, isBench: cob.isBench)
        let currConfig = config ?? cob.caseConfiguration

        CaseFilterKey(
            testCaseId,
            tags: currConfig.tags,
            isTopLevel: currConfig.fromTopLevel
        )
    }
}

struct FilterService {
    FilterService(
        let userFilter: TestFilter,
        let frameworkFilter: FrameworkTestFilter
    ) {}

    func register(filterKey: SuiteFilterKey, suite: TestSuite): Unit {
        frameworkFilter.register(filterKey, suite)
    }

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
    static func fromDefaultConfiguration(): FilterService {
        let userFilter: TestFilter = UserTestFilter.fromDefaultConfiguration()
        let frameworkFilter: FrameworkTestFilter = match(TestProcessKind.fromDefaultConfiguration()) {
            case Main =>
                BenchTestFilter.fromDefaultConfiguration()
            case Worker(workerId, nWorkers, nCasesSkip, _) =>
                WorkerTestFilter(BenchTestFilter.fromDefaultConfiguration(), workerId, nWorkers, nCasesSkip)
        }
        FilterService(userFilter, frameworkFilter)
    }
}

interface TestFilter {
    func shouldSkipTestClass(suiteFilterKey: SuiteFilterKey): Bool
    func shouldSkipTestCase(caseFilterKey: CaseFilterKey): Bool
}



interface UserTestFilter <: TestFilter {
    /**
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func fromConfiguration(config: Configuration): TestFilter {
        CompositeTestFilter([
            TagsTestFilter.fromConfiguration(config),
            FilterOptionTestFilter.fromConfiguration(config)
        ])
    }

    /**
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws UnittestCliOptionsFormatException
     * @throws getOrThrow
     * @throws JsonException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
    static func fromDefaultConfiguration(): TestFilter {
        fromConfiguration(defaultConfiguration())
    }
}





interface FrameworkTestFilter <: TestFilter {
    func register(_: SuiteFilterKey, _: TestSuite): Unit {}
}

class BenchTestFilter <: FrameworkTestFilter {
    BenchTestFilter(private let benchEnabled: Bool) {}

    public override func shouldSkipTestClass(_: SuiteFilterKey): Bool { false }

    public override func shouldSkipTestCase(filterKey: CaseFilterKey): Bool {
        filterKey.caseId.isBench != benchEnabled
    }

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
    static func fromDefaultConfiguration(): BenchTestFilter {
        let configuration = defaultConfiguration()
        let benchEnabled = configuration.bench
        BenchTestFilter(benchEnabled)
    }
}

private struct FilterOption {
    public static let ACCEPTING = FilterOption(_classRegex: "*", _funcRegex: "*")

    FilterOption(
        private let _classRegex!: String = "*",
        private let _funcRegex!: String = "*",
        let exclude!: Bool = false,
        let isFuncFilter!: Bool = false
    ) {}

    /**
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func fromString(str: String): FilterOption {
        let exclude: Bool = str.startsWith(SYM_NEG)
        let s = if (exclude) { str[1..str.size] } else { str }

        let parts = s.split(SYM_DOT, 2)
        if (parts.size == 1) {
            FilterOption(_classRegex: parts[0], exclude: exclude)
        } else {
            FilterOption(_classRegex: parts[0], _funcRegex: parts[1], exclude: exclude, isFuncFilter: true)
        }
    }

    prop classFilter: String {
        get() {
            _classRegex
        }
    }

    prop funcFilter: String {
        get() {
            "${_classRegex}${SYM_DOT}${_funcRegex}"
        }
    }
}

class FilterOptionTestFilter <: UserTestFilter {
    private let includeFilters: ArrayList<FilterOption> = ArrayList()
    private let excludeFilters: ArrayList<FilterOption> = ArrayList()

    init() {}

    /**
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    init(filterArgs: Array<String>) {
        filterArgs |>
            map { it: String => FilterOption.fromString(it.trimAscii()) } |>
            forEach { filterOp: FilterOption =>
                let appendArr = if (filterOp.exclude) {
                    excludeFilters
                } else { includeFilters }
                appendArr.add(filterOp)
            }

        if (includeFilters.size == 0) {
            includeFilters.add(FilterOption.ACCEPTING)
        }
    }

    /**
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static redef func fromConfiguration(config: Configuration): FilterOptionTestFilter {
        match (config.get(KeyFilter.filter)?.trimAscii().split(SYM_COMMA, removeEmpty: true)) {
            case None => FilterOptionTestFilter()
            case Some(filterArgs) => FilterOptionTestFilter(filterArgs)
        }
    }

    /**
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws UnittestCliOptionsFormatException
     * @throws getOrThrow
     * @throws JsonException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
    public static redef func fromDefaultConfiguration(): FilterOptionTestFilter {
        fromConfiguration(defaultConfiguration())
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public override func shouldSkipTestClass(filterKey: SuiteFilterKey): Bool {
        let suiteId = filterKey.suiteId
        let name = filterKey.topLevelFunc ?? suiteId.suiteName
        for (filter in excludeFilters where !filter.isFuncFilter) {
            if (dynamicFullMatch(name, filter.classFilter)) {
                return true
            }
        }

        if (includeFilters.isEmpty()) {
            return false
        }
        var includeFiltersIterator = includeFilters.iterator()
        if (filterKey.topLevelFunc != None) {
            includeFiltersIterator = includeFiltersIterator |> filter {filter: FilterOption => !filter.isFuncFilter}
        }

        for (filter in includeFiltersIterator) {
            if (dynamicFullMatch(name, filter.classFilter)) {
                return false
            }
        }

        return true
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public override func shouldSkipTestCase(filterKey: CaseFilterKey): Bool {
        if (filterKey.isTopLevel) {
            return false
        }

        let caseId = filterKey.caseId
        let name = "${caseId.suiteId.suiteName}${SYM_DOT}${caseId.caseName}"

        for (filter in excludeFilters) {
            if (dynamicFullMatch(name, filter.funcFilter)) {
                return true
            }
        }

        if (includeFilters.isEmpty()) { return false }

        for (filter in includeFilters) {
            if (dynamicFullMatch(name, filter.funcFilter)) {
                return false
            }
        }

        return true
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func dynamicFullMatch(s: String, p: String): Bool {
        if (!p.contains("*")) {
            return s == p
        }
        let ss: String = " " + s
        let pp: String = " " + p
        let m: Int64 = ss.size
        let n: Int64 = pp.size
        let dp: Array<Bool> = Array<Bool>(m * n, repeat: false)
        dp[0] = true
        for (i in 0..m * n) {
            let row = i / n
            let col = i % n
            if (col != 0) {
                if (pp[col] == b'*') {
                    dp[i] = dp[i - 1] || (row >= 1 && dp[i - n])
                } else {
                    dp[i] = row >= 1 && dp[i - n - 1] && ss[row] == pp[col]
                }
            }
        }
        return dp[m * n - 1]
    }
}

private class TagsFilterOption {
    TagsFilterOption(
        let tags!: HashSet<String> = HashSet()
    ) {}

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    static func fromString(input: String): TagsFilterOption {
        let result = TagsFilterOption()
        input.split(SYM_PLUS, removeEmpty: true) |>
            forEach<String> { it =>
                result.tags.add(it.trimAscii())
            }
        result
    }
}

class TagsTestFilter <: UserTestFilter {
    private let includeTagFilters: ArrayList<TagsFilterOption> = ArrayList<TagsFilterOption>()
    private let excludeTagFilters: ArrayList<TagsFilterOption> = ArrayList<TagsFilterOption>()

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    init(
        includeArgs!: Array<String> = Array(),
        excludeArgs!: Array<String> = Array()
    ) {
        for (it in includeArgs) {
            includeTagFilters.add(
                TagsFilterOption.fromString(it.trimAscii())
            )
        }

        for (it in excludeArgs) {
            excludeTagFilters.add(
                TagsFilterOption.fromString(it.trimAscii())
            )
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    public static redef func fromConfiguration(config: Configuration): TagsTestFilter {
        let includeTags = config.get(KeyIncludeTags.includeTags)?.trimAscii().split(SYM_COMMA, removeEmpty: true) ??
            Array()
        let excludeTags = config.get(KeyExcludeTags.excludeTags)?.trimAscii().split(SYM_COMMA, removeEmpty: true) ??
            Array()
        TagsTestFilter(includeArgs: includeTags, excludeArgs: excludeTags)
    }

    /**
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws UnittestCliOptionsFormatException
     * @throws getOrThrow
     * @throws JsonException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws IllegalArgumentException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    public static redef func fromDefaultConfiguration(): TagsTestFilter {
        fromConfiguration(defaultConfiguration())
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    public override func shouldSkipTestClass(filterKey: SuiteFilterKey) {

        let suiteId = filterKey.suiteId
        let tags = filterKey.tags
        for (filterOp in excludeTagFilters) {
            if (containsCount(filterOp.tags, tags)) {
                return true
            }
        }
        return false
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    public override func shouldSkipTestCase(filterKey: CaseFilterKey) {
        let caseId = filterKey.caseId
        let tags = filterKey.tags
        for (filterOp in excludeTagFilters) {
            if (containsCount(filterOp.tags, tags)) {
                return true
            }
        }

        if (includeTagFilters.isEmpty()) {
            return false
        }

        for (filterOp in includeTagFilters) {
            if (containsCount(filterOp.tags, tags)) {
                return false
            }
        }
        return true
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private static func containsCount(target: HashSet<String>, tags: Array<String>): Bool {
        (tags |> filter { it => target.contains(it) } |> count) == target.size
    }
}

class CompositeTestFilter <: TestFilter {
    CompositeTestFilter(private let filters: Array<TestFilter>) {}

    public override func shouldSkipTestClass(filterKey: SuiteFilterKey): Bool {
        filters |> any<TestFilter> { filter => filter.shouldSkipTestClass(filterKey) }
    }

    public override func shouldSkipTestCase(filterKey: CaseFilterKey): Bool {
        filters |> any<TestFilter> { filter => filter.shouldSkipTestCase(filterKey) }
    }
}

extend Configuration {
        /**
         * @throws IndexOutOfBoundsException
         */
    prop parallel: Bool {
        get() {
            get<Bool>(KeyParallel.parallel) ?? false
        }
    }

        /**
         * @throws IndexOutOfBoundsException
         */
    prop fromTopLevel: Bool {
        get() {
            get(KeyFromTopLevel.fromTopLevel) ?? false
        }
    }

        /**
         * @throws IndexOutOfBoundsException
         */
    prop tags: Array<String> {
        get() {
            get(KeyTags.tags) ?? Array()
        }
    }
}

class WorkerTestFilter <: FrameworkTestFilter {
    private let shouldSkipClassCache = HashMap<TestSuiteId, Bool>()
    private let shouldSkipCaseCache = HashMap<TestCaseId, Bool>()
    private var testEntityIdx = -1
    private var testCaseIdx = -1

    WorkerTestFilter(
        private let defaultFilter: FrameworkTestFilter, private let workerId: Int64,
        private let nWorkers: Int64, private let nCasesSkip: Int64
    ) {}

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public override func register(filterKey: SuiteFilterKey, suite: TestSuite): Unit {
        defaultFilter.register(filterKey, suite)
        if (suite.suiteConfiguration.parallel) {
            registerParallelTestClass(filterKey, suite)
        } else {
            registerRegularTestClass(filterKey, suite)
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func registerParallelTestClass(filterKey: SuiteFilterKey, suite: TestSuite): Unit {
        var anyCaseToExecute = false
        if (!defaultFilter.shouldSkipTestClass(filterKey)) {
            for (testCase in suite.allCasesIterator) {
                let config = Configuration.merge(suite.suiteConfiguration, testCase.caseConfiguration)
                let caseKey = CaseFilterKey.fromTestCase(filterKey.suiteId, testCase, config: config)
                let shouldSkipCase = registerParallelTestCase(caseKey)
                anyCaseToExecute ||= !shouldSkipCase
            }
        }
        shouldSkipClassCache.add(filterKey.suiteId, !anyCaseToExecute)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func registerParallelTestCase(filterKey: CaseFilterKey): Bool {
        let shouldSkipCase = if (defaultFilter.shouldSkipTestCase(filterKey)) { true } else {
            let caseEntityIdx = this.acquireEntityIdx()
            if (!entityBelongsToCurrentWorker(caseEntityIdx)) { true } else {
                let caseIdx = this.acquireTestCaseIdx()
                caseIsSkipped(caseIdx)
            }
        }
        shouldSkipCaseCache.add(filterKey.caseId, shouldSkipCase)
        shouldSkipCase
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func registerRegularTestClass(filterKey: SuiteFilterKey, suite: TestSuite): Unit {
        var anyCaseToExecute = false
        if (!defaultFilter.shouldSkipTestClass(filterKey)) {
            let testEntityIdx = this.acquireEntityIdx()
            if (entityBelongsToCurrentWorker(testEntityIdx)) {
                for (testCase in suite.allCasesIterator) {
                    let config = Configuration.merge(suite.suiteConfiguration, testCase.caseConfiguration)
                    let caseKey = CaseFilterKey.fromTestCase(filterKey.suiteId, testCase, config: config)
                    let shouldSkipCase = registerRegularTestCase(caseKey)
                    anyCaseToExecute ||= !shouldSkipCase
                }
            }
        }
        shouldSkipClassCache.add(filterKey.suiteId, !anyCaseToExecute)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func registerRegularTestCase(filterKey: CaseFilterKey): Bool {
        let shouldSkipCase = if (defaultFilter.shouldSkipTestCase(filterKey)) { true } else {
            let caseIdx = this.acquireTestCaseIdx()
            caseIsSkipped(caseIdx)
        }
        shouldSkipCaseCache.add(filterKey.caseId, shouldSkipCase)
        shouldSkipCase
    }

    private func acquireEntityIdx(): Int64 {
        testEntityIdx++
        testEntityIdx
    }

    private func acquireTestCaseIdx(): Int64 {
        testCaseIdx++
        testCaseIdx
    }

    private func entityBelongsToCurrentWorker(entityIdx: Int64): Bool {
        entityIdx % nWorkers == workerId
    }

    private func caseIsSkipped(caseIdx: Int64): Bool {
        caseIdx < nCasesSkip
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    public override func shouldSkipTestClass(filterKey: SuiteFilterKey): Bool {
        shouldSkipClassCache.get(filterKey.suiteId) ?? reportNoRegister(filterKey.suiteId)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    public override func shouldSkipTestCase(filterKey: CaseFilterKey): Bool {
        shouldSkipCaseCache.get(filterKey.caseId) ?? reportNoRegister(filterKey.caseId)
    }

    /**
     * @throws Exception
     */
    private static func reportNoRegister(printable: ToString): Nothing {
        throw Exception("${printable} was not registered in the bunch filter")
    }
}
