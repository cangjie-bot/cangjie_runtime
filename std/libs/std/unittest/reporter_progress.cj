






package std.unittest

import std.collection.concurrent.NonBlockingQueue
import std.env.atExit
import std.sync.AtomicBool
import std.time.MonoTime
import std.unittest.common.PrettyText

private const UPDATE_FREQ_MS = 350
private const MIN_UPDATE_RELAX_MS = 100
private const ADJUST_TERMINAL_SIZE_FREQ_REDRAWS = 5

class ProgressReporter {
    private let reporter: UTProgressReporter
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
     * @throws IllegalMemoryException
     * @throws UnittestCliOptionsFormatException
     * @throws Exception
     */
    private ProgressReporter() {
        this.reporter = match (getDefaultUTProgressReporter()) {
            case Some(r) => r
            case _ => throw Exception("Actual reporter does not exists! Should 'ProgressReporter' be created?")
        }
    }
    private var terminalHeight: ?UInt64 = None
    private var terminalWidth: ?UInt64 = None

    private var prevReportHeight = 0

    private let printer = TerminalPrettyPrinter.fromDefaultConfiguration()

    private var reporterJob: ?Future<Unit> = None

    private let isActive = AtomicBool(false)

    prop updateQueue: NonBlockingQueue<UTProgress> {
        /*
         * @noThrow
         */
        get() {
            reporter.updateQueue
        }
    }


    /*
     * @throws OutOfMemoryError
     * @throws Error
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    func startReporting() {
        if (!isActive.compareAndSwap(false, true)) {
            return
        }

        atExit {
            stopAndClear()
        }

        reporterJob = spawn {
            reporter.start()
            printer.hideCursor()
            reportLoop {
                let report = reporter.report(terminalHeight, terminalWidth)
                let reportLinesCount = report.toString().count("\n") + 1
                let reportLinesCountTrimmed = if (let Some(theight) <- terminalHeight) {
                    min(reportLinesCount, Int64(theight))
                } else {
                    reportLinesCount
                }

                printer.exclusive { printer: TerminalPrettyPrinter =>
                    clearDynamicArea()

                    printer.append("\n" * reportLinesCountTrimmed)
                    printer.up(reportLinesCountTrimmed)
                    printer.saveCursorPos()

                    if (reportLinesCountTrimmed < prevReportHeight) {
                        printer.append("\n" * (prevReportHeight - reportLinesCountTrimmed))
                        prevReportHeight = reportLinesCountTrimmed
                    }

                    printer.toBottom()
                    printer.up(reportLinesCountTrimmed - 1)
                    printer.append(report)

                    if (let Some(theight) <- terminalHeight) {
                        printer.setScrollableMargins(end: Int64(theight) - reportLinesCountTrimmed)
                    }
                    printer.restoreCursorPos()
                }
            }
        }
    }

    /*
     * @throws Error
     * @throws ArithmeticException
     */
    private func reportLoop(render: () -> Unit) {
        var tact = 0
        while (!Thread.currentThread.hasPendingCancellation) {
            let timeBeforeUpdate = MonoTime.now()


            if (tact % ADJUST_TERMINAL_SIZE_FREQ_REDRAWS == 0) {
                tact = 0
                terminalWidth = printer.terminalWidth
                terminalHeight = printer.terminalHeight
            }

            render()

            tact++
            let updateElapsed = MonoTime.now() - timeBeforeUpdate
            sleep(max(MIN_UPDATE_RELAX_MS, UPDATE_FREQ_MS - updateElapsed.toMilliseconds()) * Duration.millisecond)
        }
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     */
    func stopAndClear() {
        if (!isActive.compareAndSwap(true, false)) { return }
        if (let Some(job) <- reporterJob) {
            job.cancel()
            job.get()
            reporterJob = None
        }

        reporter.reset()

        printer.exclusive { printer =>
            clearDynamicArea()
            printer.showCursor()
        }
    }

    /*
     * @throws OutOfMemoryError
     */
    private func clearDynamicArea() {
        printer.clearAhead()
        printer.saveCursorPos()
        printer.setScrollableMargins()
        printer.restoreCursorPos()
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
     * @throws IllegalMemoryException
     * @throws UnittestCliOptionsFormatException
     * @throws Exception
     */
    static func fromDefaultConfiguration(): ?ProgressReporter {
        let config = defaultConfiguration()
        if (!config.isDynamicProgressEnabled || TestProcessKind.fromDefaultConfiguration().isWorker) {
            return None
        }
        ProgressReporter()
    }
}

extend Configuration {
    prop isDynamicProgressEnabled: Bool {
        /*
         * @throws IndexOutOfBoundsException
         */
        get() {
            !(get(KeyNoProgress.noProgress) ?? false) && !bench && !noRun
        }
    }

    prop isDynamicProgressBrief: Bool {
        /*
         * @throws IndexOutOfBoundsException
         */
        get() {
            get(KeyProgressBrief.progressBrief) ?? false
        }
    }

    prop dynamicProgressEntriesLimit: ?UInt64 {
        /*
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         * @throws UnittestCliOptionsFormatException
         */
        get() {
            match (get(KeyProgressEntriesLimit.progressEntriesLimit)) {
                case Some(0) | None => None
                case Some(x) where x < 0 => throw UnittestCliOptionsFormatException(
                    "--${KeyProgressEntriesLimit.progressEntriesLimit.name}", actual: x.toString(),
                    expected: "Parameter format: non-negative integer value")
                case Some(x) => UInt64(x)
            }
        }
    }
}

interface UTProgressReporter {
    prop updateQueue: NonBlockingQueue<UTProgress>



    /*
     * @noThrow
     */
    func start(): Unit {}

    /*
     * @noThrow
     */
    func report(terminalHeight: ?UInt64, terminalWidth: ?UInt64): PrettyText


    /*
     * @noThrow
     */
    func reset(): Unit {}
}

interface UTProgress {}

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
private func getDefaultUTProgressReporter(): ?UTProgressReporter {
    let defaultConfig = defaultConfiguration()
    match {
        case defaultConfig.bench => None
        case TestProcessKind.fromDefaultConfiguration().isWorker => None
        case defaultConfig.isDynamicProgressEnabled => TestProgressReporter(
            ParallelInfo.fromDefaultConfiguration().nWorkers,
            isBrief: defaultConfig.isDynamicProgressBrief,
            entriesLimit: defaultConfig.dynamicProgressEntriesLimit
        )
        case _ => None
    }
}
