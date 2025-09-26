






package std.unittest

import std.fs.Path
import std.collection.*
import std.unittest.common.PrettyPrinter

sealed interface Reporter<TReport, TReturn> {}
public class CsvReporter <: Reporter<BenchReport, Unit> {
    public CsvReporter(let directory: Path) {}
}

public class CsvRawReporter <: Reporter<BenchReport, Unit> {
    public CsvRawReporter(let directory: Path) {}
}

public class XmlReporter <: Reporter<TestReport, Unit> {
    public XmlReporter(let directory: Path) {}
}

public class ConsoleReporter <: Reporter<TestReport, Unit> & Reporter<BenchReport, Unit> {
    public ConsoleReporter(let colored!: Bool = true) {}
}

public class TextReporter<PP> <: Reporter<TestReport, PP> & Reporter<BenchReport, PP>
        where PP <: PrettyPrinter {
    public TextReporter(let into!: PP) {}
}

interface TextReporterBase<PP> <: Reporter<TestReport, PP> & Reporter<BenchReport, PP> {
    func printReport(report: Report): PP
}

extend <PP> TextReporter<PP> <: TextReporterBase<PP> where PP <: PrettyPrinter {
    /**
     * @throws OverflowException
     * @throws FSException
     * @throws IllegalMemoryException
     * @throws ConcurrentModificationException
     * @throws RegexException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws UnittestOptionValidationException
     * @throws ArithmeticException
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws DataModelException
     * @throws JsonException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func printReport(report: Report): PP {
        let outputReporter = TestOutputReporter.fromDefaultConfiguration()
        TextReports.printDefaultReport(into, report.groupResult, outputReporter, report.runConfiguration)
        return into
    }
}

extend ConsoleReporter <: TextReporterBase<Unit> {
    /**
     * @throws OverflowException
     * @throws FSException
     * @throws IllegalMemoryException
     * @throws ConcurrentModificationException
     * @throws RegexException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws UnittestOptionValidationException
     * @throws ArithmeticException
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws DataModelException
     * @throws JsonException
     * @throws IllegalSynchronizationStateException
     * @throws getOrThrow
     * @throws UnittestCliOptionsFormatException
     * @throws ProcessException
     * @throws Exception
     */
    public func printReport(report: Report): Unit {
        let pp = TerminalPrettyPrinter(colored)
        let outputReporter = TestOutputReporter.fromDefaultConfiguration()
        TextReports.printDefaultReport(pp, report.groupResult, outputReporter, report.runConfiguration)
    }
}
public class RawStatsReporter <: Reporter<BenchReport, HashMap<String, (Float64, Float64)>> {
    public RawStatsReporter() {}

    /**
     * @throws ConcurrentModificationException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func benchResultsAsMap(result: TestGroupResult): HashMap<String, (Float64,Float64)> {
        let caseNameToMeasurement = HashMap<String, (Float64,Float64)>()
        result.visitAll<TestCaseResult> { cr =>
            for ((key, value) in getEntries(cr)) {
                caseNameToMeasurement[key] = value
            }
        }
        caseNameToMeasurement
    }

    /**
     * @throws ConcurrentModificationException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws NoneValueException
     */
    private static func getEntries(tcr: TestCaseResult): ArrayList<(String, (Float64, Float64))> {
        let result = ArrayList<(String, (Float64, Float64))>()
        tcr.visitPassedBenches{ step =>
            let key = step.caseId.caseName + (step.arg.textDescription?.toString() ?? "")
            result.add((key, ((step.result.mainResult, step.result.errorEst))))
        }
        result
    }
}
