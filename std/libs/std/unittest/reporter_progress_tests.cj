






package std.unittest

import std.collection.*
import std.collection.*
import std.collection.concurrent.NonBlockingQueue
import std.math.abs
import std.time.*
import std.unittest.common.*

private const GROUP_WORD = "group"
private const TEST_WORD = "test"

private const PROGRESS_INDICATOR_FINISHED_FILL = "|"
private const PROGRESS_INDICATOR_REMAIN_FILL = "-"
private const DEFAULT_PROGRESS_INDICATOR_WIDTH = 20
private const MIN_PROGRESS_INDICATOR_WIDTH = 10
private const MAX_PROGRESS_INDICATOR_WIDTH = 50

private const PERCENT_VALUE_WIDTH = 3
private const MARK_WIDTH = 4
private const STATIC_SIZED_AREA_WIDTH = 1  + PERCENT_VALUE_WIDTH + 5  + MARK_WIDTH + 1  + 10

private const DEFAULT_NAMED_AREA_WIDTH = 36
private const MIN_NAMED_AREA_WIDTH = 20

private const DEFAULT_HEIGHT = 12
private const DEFAULT_WIDTH = STATIC_SIZED_AREA_WIDTH + DEFAULT_PROGRESS_INDICATOR_WIDTH + DEFAULT_NAMED_AREA_WIDTH

private const MIN_WIDTH = STATIC_SIZED_AREA_WIDTH + MIN_PROGRESS_INDICATOR_WIDTH + MIN_NAMED_AREA_WIDTH
private const MIN_HEIGHT = 4

/*
 * @noThrow
 */
private func namedAreaWidth(total: Int64): Int64 {
    total - STATIC_SIZED_AREA_WIDTH - progressIndicatorWidth(total)
}

/*
 * @noThrow
 */
private func progressIndicatorWidth(total: Int64): Int64 {
    let v = (total - STATIC_SIZED_AREA_WIDTH) * 36 / 100
    max(min(v, MAX_PROGRESS_INDICATOR_WIDTH), MIN_PROGRESS_INDICATOR_WIDTH)
}

/*
 * @noThrow
 */
private func groupNameWidth(total: Int64): Int64 {
    namedAreaWidth(total) - GROUP_WORD.size - 4 
}

/*
 * @noThrow
 */
private func testCaseNameWidth(total: Int64): Int64 {
    total - TEST_WORD.size - 4  - 10  - MARK_WIDTH - 2 
}

class TestProgressReporter <: UTProgressReporter {
    private var width = DEFAULT_WIDTH
    private var height = DEFAULT_HEIGHT



    private var markWidth = MARK_WIDTH

    private let booker: TestProgressCollector

    /*
     * @noThrow
     */
    TestProgressReporter(let testCasesParallelism: Int64, let isBrief!: Bool, let entriesLimit!: ?UInt64 = None) {
        booker = TestProgressCollector(testCasesParallelism)
    }

    public override prop updateQueue: NonBlockingQueue<UTProgress> {
        /*
         * @noThrow
         */
        get() {
            booker.updateQueue
        }
    }

    /*
     * @noThrow
     */
    public override func start(): Unit {
        booker.start()
    }

    /*
     * @throws ConcurrentModificationException
     * @throws OutOfMemoryError
     * @throws Exception
     * @throws NoneValueException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public override func report(terminalHeight: ?UInt64, terminalWidth: ?UInt64): PrettyText {
        booker.flushChanges()
        let report = PrettyText()
        if (booker.registeredPackagesCount == 0u64) { return report }

        adjustSize(terminalHeight, terminalWidth)
        if (!isBrief) {
            report.append(buildPackagesReport())
            report.append(buildTestCasesReport())
            report.append(buildFailedCaseReport())
        }

        report.append(buildSummaryReport())
        report
    }

    /*
     * @throws ArithmeticException
     * @throws NoneValueException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func buildPackagesReport(): PrettyText {
        let text = PrettyText()
        let packages = booker.currentPackages

        let visiblePackagesSize = min(packages.size, packagesHeightLimit)

        for (pack in packages[..visiblePackagesSize]) {
            let packagename = "${GROUP_WORD} ${pack.trimmed(groupNameWidth(width)).padEnd(groupNameWidth(width))}"
            let percent = percentString(pack.finishPercent)

            let markSymbol = match {
                case pack.isFailed => "✗"
                case pack.finishedCases < pack.totalCases => ""
                case _ => "✓"
            }
            let mark = markSymbol.padEnd(MARK_WIDTH + if (markSymbol.size > 1) { markSymbol.size - 1 } else { 0 })

            let duration = pack.duration.toStringFormatted()
            let statusColor = if (pack.isFailed) { Color.RED} else { Color.GREEN }

            text.append("📦").space().append(packagename).space()
            text.append(percent).space()
            pack.progress.pprint(text, width: progressIndicatorWidth(width))
            text.space()
            text.colored(statusColor, mark).space()
            text.append("(").append(duration).append(")").appendLine()
        }
        return text
    }

    /*
     * @throws NoneValueException
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func buildTestCasesReport(): PrettyText {
        let text = PrettyText()
        let cases = booker.currentTestCases

        let visibleCasesSize = min(cases.size, testCasesHeightLimit)

        for (tcase in cases[..visibleCasesSize]) {
            let casename = "${TEST_WORD} ${tcase.trimmed(testCaseNameWidth(width)).padEnd(Int64(testCaseNameWidth(width)))}"
            let duration = tcase.duration.toStringFormatted()

            text.append("🧪").space().append(casename).space()
            text.append("".padEnd(MARK_WIDTH)).space()
            text.append("(").append(duration).append(")").appendLine()
        }
        return text
    }

    /*
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func buildFailedCaseReport(): PrettyText {
        let text = PrettyText()
        if (let Some(failedCase) <- booker.lastFailedStep) {
            let statusCode = failedCase.check.statusCode().toString()
            let caseNameSpace = namedAreaWidth(width) + progressIndicatorWidth(width) - statusCode.size - 1 - 3 
            text.append("   ")
            text.colored(Color.RED, statusCode).space()
            text.append(failedCase.trimmed(caseNameSpace).padEnd(caseNameSpace))
        }
        text.appendLine()
        return text
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func buildSummaryReport(): PrettyText {
        let text = PrettyText()
        let summary = booker.summary

        let percent = percentString(summary.finishPercent)

        let statusInfo = PrettyText()
        match (summary.crashedWorkers) {
            case 0 =>
                statusInfo.append("passed:").space().colored(
                    if (summary.passedCases > 0) { Color.GREEN } else { Color.DEFAULT_COLOR },
                    summary.passedCases.toString()
                )
                statusInfo.append(",").space()
                statusInfo.append("failed:").space().colored(
                    if (summary.failedCases > 0) { Color.RED } else { Color.DEFAULT_COLOR },
                    summary.failedCases.toString()
                )
            case _ =>
                statusInfo.append("error:").space().colored(Color.RED, "failed to register test(s)")
        }

        markWidth = max(markWidth, summary.totalCases.toString().size * 2 + 1  )
        let emptiness = "".padEnd(namedAreaWidth(width) - statusInfo.toString().size - markWidth + MARK_WIDTH)
        let finishedCounter = "${summary.finishedCases}/${summary.totalCases}".padStart(markWidth)
        let duration = summary.duration.toStringFormatted()

        text.append(statusInfo).append(emptiness).space()
            .append(percent).space()

        summary.progress.pprint(text, width: progressIndicatorWidth(width))
        text.space()

        text.append(finishedCounter).space()
            .append("(").append(duration).append(")").space()

        text
    }

    private prop packagesHeightLimit: Int64 {
        /*
         * @noThrow
         */
        get() {
            height - testCasesHeightLimit - 2
        }
    }

    private prop testCasesHeightLimit: Int64 {
        /*
         * @noThrow
         */
        get() {
            min(height - 2 - 1, testCasesParallelism)
        }
    }

    /*
     * @noThrow
     */
    private func adjustSize(terminalHeight: ?UInt64, terminalWidth: ?UInt64) {
        let prevWidth = width
        let prevHeight = height

        let availableHeight = match (terminalHeight) {
            case Some(h) => Int64(h) - 1
            case _ => DEFAULT_HEIGHT
        }

        height = min(height, Int64(booker.registeredPackagesCount) + testCasesParallelism + 2)
        if (let Some(lim) <- entriesLimit) {
            height = min(height, Int64(lim) + 2)
        }

        height = max(height, MIN_HEIGHT)

        if (isBrief) {
            height = 1
        }

        width = match (terminalWidth) {
            case Some(w) => max(Int64(w) - 1, MIN_WIDTH)
            case _ => DEFAULT_WIDTH
        }
        width = max(width, MIN_WIDTH)
    }
}

private class TestProgressCollector {
    let updateQueue = NonBlockingQueue<UTProgress>()


    private let registeredWorkers = HashSet<UniqueWorkerId>()
    private let totalPackageCasesCount = HashMap<String, UInt64>()
    private let packagesOrder = ArrayList<String>()
    private let packagesStartTime = HashMap<String, DateTime>()
    private let finishedPackageCasesCount = HashMap<String, UInt64>()
    private let packagesProgress = HashMap<String, Progress>()
    private let failedPackages = HashSet<String>()

    private var _totalCasesCount = 0u64
    private let casesOrder: Array<?Int64>
    private var _finishedCasesCount = 0u64
    private var _passedCasesCount = 0u64
    private var _failedCasesCount = 0u64
    private var _crashedWorkers = 0u64
    private var _lastFailedStep: ?FailedTestCaseProgressData = None

    private let summaryProgress = Progress(totalPieces: 0)
    private var startTime: MonoTime = MonoTime.now()


    private let executing = HashMap<Int64, TestCaseProgressData>()

    private let finishedPackages = ArrayList<String>()

    /*
     * @noThrow
     */
    TestProgressCollector(testCasesParallelism: Int64) {
        casesOrder = Array<?Int64>(testCasesParallelism, repeat: None)
    }

    prop totalCasesCount: UInt64 {
        /*
         * @noThrow
         */
        get() {
            _totalCasesCount
        }
    }

    prop finishedCasesCount: UInt64 {
        /*
         * @noThrow
         */
        get() {
            _finishedCasesCount
        }
    }

    prop passedCasesCount: UInt64 {
        /*
         * @noThrow
         */
        get() {
            _passedCasesCount
        }
    }

    prop failedCasesCount: UInt64 {
        /*
         * @noThrow
         */
        get() {
            _failedCasesCount
        }
    }

    prop crashedWorkersCount: UInt64 {
        /*
         * @noThrow
         */
        get() {
            _crashedWorkers
        }
    }

    prop registeredPackagesCount: UInt64 {
        /*
         * @noThrow
         */
        get() {
            UInt64(totalPackageCasesCount.size)
        }
    }

    prop currentPackagesCount: UInt64 {
        /*
         * @noThrow
         */
        get() {
            UInt64(packagesOrder.size)
        }
    }

    prop lastFailedStep: ?FailedTestCaseProgressData {
        /*
         * @noThrow
         */
        get() {
            _lastFailedStep
        }
    }

    prop currentPackages: Array<PackageProgressData> {
        /*
         * @throws NoneValueException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            packagesOrder |> filterMap<String, PackageProgressData> { name: String =>
                let totalCases = totalPackageCasesCount[name]
                if (totalCases == 0) { return None }
                PackageProgressData(
                    name,
                    totalCases: totalCases,
                    finishedCases: finishedPackageCasesCount[name],
                    isFailed: failedPackages.contains(name),
                    startTime: packagesStartTime[name],
                    progress: packagesProgress[name]
                )
            } |> collectArray
        }
    }

    prop currentTestCases: Array<TestCaseProgressData> {
        /*
         * @throws NoneValueException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            casesOrder |> filterMap<?Int64, TestCaseProgressData> { id_: ?Int64 =>
                let id = id_ ?? return None
                executing[id]
            } |> collectArray
        }
    }

    prop summary: SummaryProgressData {
        /*
         * @noThrow
         */
        get() {
            SummaryProgressData(
                passedCases: _passedCasesCount,
                failedCases: _failedCasesCount,
                finishedCases: _finishedCasesCount,
                totalCases: _totalCasesCount,
                crashedWorkers: _crashedWorkers,
                startTime: startTime,
                progress: summaryProgress
            )
        }
    }

    /*
     * @noThrow
     */
    func start() {
        startTime = MonoTime.now()
    }

    /*
     * @throws ConcurrentModificationException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws Exception
     * @throws NoneValueException
     */
    func flushChanges() {
        clearFinishedPackages()
        while (true) {
            let element = match (updateQueue.dequeue()) {
                case None => break
                case Some(n: TestProgressData) => n
                case _ => continue
            }

            match (element.data) {
                case body: ExecutionResultBody => updateBody(body, element.workerId)
                case r: TestCasesRegistrationPart => registerWorkerIfRequired(r.casesCount, id: r.workerId, pack: r.packageName)
                case header: ExecutionResultHeader => updateHeader(header, element.workerId)
                case registrationFailure: TestCasesRegistrationFailed => addWorkerCrash()
                case _ => ()
            }
        }
    }

    /*
     * @noThrow
     */
    private func addWorkerCrash(): Unit {
        _crashedWorkers += 1
    }

    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func registerWorkerIfRequired(cases: UInt64, id!: Int64, pack!: String) {
        if (cases == 0) {
            totalPackageCasesCount.addIfAbsent(pack, 0u64)
            finishedPackageCasesCount.addIfAbsent(pack, 0u64)
            packagesProgress.addIfAbsent(pack, Progress(totalPieces: Int64(cases)))
            return
        }
        let worker = UniqueWorkerId(id: id, pack: pack)
        if (registeredWorkers.add(worker)) {
            _totalCasesCount += cases
            totalPackageCasesCount.addIfAbsent(pack, 0u64)
            totalPackageCasesCount[pack] += cases
            finishedPackageCasesCount.addIfAbsent(pack, 0u64)
            if (packagesProgress.addIfAbsent(pack, Progress(totalPieces: Int64(cases))).isSome()) {
                packagesProgress[pack].expand(cases)
            }
            summaryProgress.expand(cases)
        }
    }

    /*
     * @throws ConcurrentModificationException
     * @throws IndexOutOfBoundsException
     */
    private func clearFinishedPackages() {
        for (pack in finishedPackages) {
            packagesOrder.removeIf { p: String => p == pack }
            packagesStartTime.remove(pack)
            packagesProgress.remove(pack)
            totalPackageCasesCount.remove(pack)
        }
        finishedPackages.clear()
    }

    /*
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func updateBody(body: ExecutionResultBody, workerId: Int64) {
        executing.remove(workerId)
        match (casesOrder.indexOf(workerId)) {
            case Some(i) => casesOrder[i] = None
            case None => ()
        }
        let pack = body.stepResult.caseId.suiteId.groupName

        if (body.isSkip) {
            if (totalPackageCasesCount[pack] == 0) {
                finishedPackages.add(pack)
            }
            return
        }

        if (!body.isClassLifecycle) {
            _finishedCasesCount++
            finishedPackageCasesCount[pack]++
        }

        if (finishedPackageCasesCount[pack] >= totalPackageCasesCount[pack]) {
            finishedPackages.add(pack)
        }

        if (body.isFailed) {
            if (body.isClassLifecycle) {
                _totalCasesCount++
                packagesProgress[pack].expand(1)
                summaryProgress.expand(1)
            }

            _failedCasesCount++
            _lastFailedStep = FailedTestCaseProgressData(body.toCaseName(), suiteId: body.stepResult.caseId.suiteId, check: body.firstFailedStep)
            failedPackages.add(pack)
            packagesProgress[pack].update(positive: false)
            summaryProgress.update(positive: false)
        } else if (body.isPassed && !body.isClassLifecycle) {
            _passedCasesCount++
            packagesProgress[pack].update(positive: true)
            summaryProgress.update(positive: true)
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws Exception
     * @throws NoneValueException
     */
    private func updateHeader(header: ExecutionResultHeader, workerId: Int64) {
        if (executing.add(workerId, TestCaseProgressData(header.toCaseName(), suiteId: header.suiteId, startTime: header.startTime)).isNone()) {
            match (casesOrder.indexOf(None)) {
                case Some(i) => casesOrder[i] = workerId
                case None => ()
            }
            let packageName = header.suiteId.groupName

            packagesStartTime[packageName] = if (packagesStartTime.contains(packageName)) {
                min(header.startTime, packagesStartTime[packageName])
            } else {
                header.startTime
            }

            if (packagesOrder |> all { it: String => it != packageName }) {
                packagesOrder.add(packageName)
            }
        }
    }
}

struct TestProgressData <: UTProgress {
    /*
     * @noThrow
     */
    TestProgressData(let data: ExecutionResultPart, let workerId!: Int64 = 0) {}
}

private struct UniqueWorkerId <: Hashable & Equatable<UniqueWorkerId> {
    /*
     * @noThrow
     */
    UniqueWorkerId(let id!: Int64, let pack!: String) {}

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        var hasher = DefaultHasher()
        hasher.write(id)
        hasher.write(pack)
        return hasher.finish()
    }

    /*
     * @noThrow
     */
    public operator func ==(other: UniqueWorkerId): Bool {
        this.id == other.id && this.pack == other.pack
    }

    /*
     * @noThrow
     */
    public operator func !=(other: UniqueWorkerId): Bool {
        !(this == other)
    }
}

private struct PackageProgressData {
    /*
     * @noThrow
     */
    PackageProgressData(
        let name: String,
        let totalCases!: UInt64,
        let finishedCases!: UInt64,
        let isFailed!: Bool,
        let startTime!: DateTime,
        let progress!: Progress
    ) {}

    prop finishPercent: UInt64 {
        /*
         * @noThrow
         */
        get() {
            if (totalCases == 0) { 0u64 } else { 100 * finishedCases / totalCases }
        }
    }

    prop duration: Duration {
        /*
         * @throws ArithmeticException
         */
        get() {
            DateTime.now() - startTime
        }
    }

    /*
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func trimmed(limit: Int64): String {
        trimPackage(name, limit: limit)
    }
}

private enum TestCaseName <: ToString {
      /*
       * @noThrow
       */
    | CaseName(TestCaseId)
      /*
       * @noThrow
       */
    | CNStep(LStep)

    /*
     * @noThrow
     */
    public override func toString() {
        match (this) {
            case CaseName(s) => s.caseName
            case CNStep(step) => step.toString()
        }
    }
}

private struct TestCaseProgressData {
    /*
     * @noThrow
     */
    TestCaseProgressData(let name: TestCaseName, let suiteId!: TestSuiteId, let startTime!: DateTime) {}

    prop duration: Duration {
        /*
         * @throws ArithmeticException
         */
        get() {
            DateTime.now() - startTime
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func trimmed(limit: Int64): String {
        trim(suiteId, name, limit: limit)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    static func trim(suiteId: TestSuiteId, name: TestCaseName, limit!: Int64): String {
        let fullname = "${suiteId.suiteName}" + match (name) {
            case CaseName(_) => "."
            case CNStep(_) => " at "
        } + name.toString()
        if (fullname.size > limit) { fullname[..limit - 3] + "..." } else { fullname }
    }
}

private struct FailedTestCaseProgressData {
    /*
     * @noThrow
     */
    FailedTestCaseProgressData(let name: TestCaseName, let suiteId!: TestSuiteId, let check!: RunStepResult) {}

    /*
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func trimmed(limit: Int64): String {
        let caseTrimmed = TestCaseProgressData.trim(suiteId, name, limit: limit)
        trimPackage(suiteId.groupName, limit: limit - caseTrimmed.size) + "." + caseTrimmed
    }
}

private struct SummaryProgressData {
    /*
     * @noThrow
     */
    SummaryProgressData(
        let passedCases!: UInt64,
        let failedCases!: UInt64,
        let finishedCases!: UInt64,
        let totalCases!: UInt64,
        let crashedWorkers!: UInt64,
        let startTime!: MonoTime,
        let progress!: Progress
    ) {}

    prop finishPercent: UInt64 {
        /*
         * @noThrow
         */
        get() {
            if (totalCases == 0) { 0u64 } else { 100 * finishedCases / totalCases }
        }
    }

    prop isFailed: Bool {
        /*
         * @noThrow
         */
        get() {
            failedCases > 0u64
        }
    }

    prop duration: Duration {
        /*
         * @throws ArithmeticException
         */
        get() {
            MonoTime.now() - startTime
        }
    }
}

extend ExecutionResultPart {
    /*
     * @throws NoneValueException
     * @throws Exception
     */
    func toCaseName(): TestCaseName {
        match (this) {
            case h: TestCaseExecutionResultHeader => CaseName(h.caseId)
            case h: LifecycleExecutionResultHeader => CNStep(h.step)
            case b: ExecutionResultBody => match ((b.stepResult.subResults |> last).getOrThrow().kind) {
                case Lifecycle(step) => CNStep(step)
                case _ => CaseName(b.stepResult.caseId)
            }
            case _ => throw Exception("Unexpected branch")
        }
    }
}

extend ExecutionResultBody {
    prop isSkip: Bool {
        /*
         * @noThrow
         */
        get() {
            stepResult.subResults |> any { it: RunStepResult =>
                match(it.kind) {
                    case Skip => true
                    case _ => false
                }
            }
        }
    }

    prop isFailed: Bool {
        /*
         * @noThrow
         */
        get() {
            stepResult.subResults |> any { it: RunStepResult =>
                it.hasFailures()
            }
        }
    }

    prop firstFailedStep: RunStepResult {
        /*
         * @throws Exception
         */
        get() {
            (stepResult.subResults |> filter { it: RunStepResult =>
                it.hasFailures()
            } |> first<RunStepResult>) ?? throw Exception("There is no failed check")
        }
    }

    prop isPassed: Bool {
        /*
         * @noThrow
         */
        get() {
            stepResult.subResults |> all { it: RunStepResult =>
                match ((it.info, it.kind)) {
                    case (Failure(_), _) => false
                    case (_, Skip) => false
                    case (_, UserCode) => false
                    case _ => true
                }
            }
        }
    }

    prop isClassLifecycle: Bool {
        /*
         * @noThrow
         */
        get() {
            stepResult.subResults |> any { it: RunStepResult => it.kind.isClassLifecycle() }
        }
    }

    prop isBeforeAll: Bool {
        /*
         * @noThrow
         */
        get() {
            stepResult.subResults |> any { it: RunStepResult =>
                match (it.kind) {
                    case Lifecycle(BeforeAll) => true
                    case _ => false
                }
            }
        }
    }
}

extend TestCaseId {
    /*
     * @noThrow
     */
    func toDisplayString() {
        "${suiteId.toDisplayString()}.${caseName}"
    }
}

extend TestSuiteId {
    /*
     * @noThrow
     */
    func toDisplayString() {
        "${groupName}.${suiteName}"
    }
}

extend Duration {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func toStringFormatted(): String {
        let hh = toHours().toString().padStart(2, padding: "0")
        let mm = (toMinutes() % 60).toString().padStart(2, padding: "0")
        let ss = (toSeconds() % 60).toString().padStart(2, padding: "0")
        return "${hh}:${mm}:${ss}"
    }
}

/*
 * @throws OutOfMemoryError
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
private func trimPackage(pack: String, limit!: Int64): String {
    if (pack.size <= limit) { return pack }
    let levels = pack.split(".")
    var size = pack.size

    for (i in 0..levels.size) {
        if (size <= limit) { break }
        size -= levels[i].size - 1
        levels[i] = String.fromUtf8(levels[i][0])
    }

    let trimmed = levels |> collectString<String>(delimiter: ".")
    match {
        case trimmed.size > limit => trimmed[trimmed.size - limit..]
        case _ => trimmed
    }
}


/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
private func percentString(percent: UInt64, width!: Int64 = PERCENT_VALUE_WIDTH): String {
    percent.toString().padStart(width) + "%"
}

private class Progress <: PrettyPrintable {


    private var text = PrettyText()


    private let pieces = ArrayList<Bool>()


    private var barIdx = 0


    private var drawnPieces = 0


    private var prevWidth = 0


    private var prevPieceWidth = 0


    private var prevPieceStatus = true

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    Progress(var totalPieces!: Int64) {
        pieces.reserve(totalPieces)
    }

    private let POSITIVE_COLOR = Color.GREEN
    private let NEGATIVE_COLOR = Color.RED
    private let GRAY_COLOR = Color.GRAY

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func update(positive!: Bool = true): Unit {
        if (pieces.size >= totalPieces) { return }

        pieces.add(positive)
    }


    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func expand(extendBy: UInt64) {
        pieces.reserve(Int64(extendBy))
        totalPieces += Int64(extendBy)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func pprint(to: PrettyPrinter, crashedWorkers!: UInt64 = 0, width!: Int64, mainBar!: Bool = false): PrettyPrinter {
        if (prevWidth != width) {
            text = PrettyText()
            barIdx = 0
            drawnPieces = 0
            prevWidth = width
            prevPieceStatus = true
            prevPieceWidth = 0
        }
        let statusColor  = if (crashedWorkers > 0) { NEGATIVE_COLOR } else { GRAY_COLOR }
        to.colored(statusColor) { to.append("[") }

        for (i in drawnPieces..pieces.size) {
            let pieceWidth = progressWidth(i, fullWidth: width)
            let progress = PROGRESS_INDICATOR_FINISHED_FILL * pieceWidth
            let pieceStatus = match {
                case prevPieceWidth == 0 => pieces[i] && prevPieceStatus
                case _ => pieces[i]
            }
            let pieceColor = match (mainBar) {
                case true => if (pieceStatus && crashedWorkers == 0) { POSITIVE_COLOR } else { NEGATIVE_COLOR }
                case _ => if (pieceStatus) { POSITIVE_COLOR } else { NEGATIVE_COLOR }
            }
            text.colored(pieceColor, progress)
            barIdx += pieceWidth
            prevPieceStatus = pieceStatus
            prevPieceWidth = pieceWidth
        }
        drawnPieces = pieces.size

        let remained = PROGRESS_INDICATOR_REMAIN_FILL * (width - barIdx)
        to.append(text)
        to.colored(statusColor, remained)
        to.colored(statusColor) { to.append("]") }

        return to
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public override func pprint(to: PrettyPrinter): PrettyPrinter {
        pprint(to, width: DEFAULT_PROGRESS_INDICATOR_WIDTH)
    }

    /*
     * @noThrow
     */
    private func progressPercent(ofIdx: Int64): Int64 {
        (ofIdx + 1) * 100 / totalPieces
    }

    /*
     * @noThrow
     */
    private func progressWidth(ofIdx: Int64, fullWidth!: Int64): Int64 {
        progressPercent(ofIdx) * fullWidth / 100 - barIdx
    }
}
