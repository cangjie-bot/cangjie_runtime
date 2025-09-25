






package std.unittest

import std.collection.ArrayList
import std.fs.*
import std.unittest.common.PrettyText

class XmlBuilder <: ToString {
    private let element_ = XmlElementBuilder()
    private var version_: ToString = "1.0"
    private var encoding_: ?ToString = None

    /*
     * @noThrow
     */
    public func version(v: ToString) {
        version_ = v
        this
    }

    /*
     * @noThrow
     */
    public func encoding(format: ToString) {
        encoding_ = format
        this
    }

    /*
     * @noThrow
     */
    public func element(name: ToString, childBuilder: (XmlElementBuilder) -> Unit): This {
        element_.name(name)
        childBuilder(element_)
        this
    }

    /*
     * @noThrow
     */
    public func toString() {
        """
<?xml version="${version_}"${match (encoding_) { case Some(e) => " encoding=\"${e}\""; case _ => "" }}?>
${element_}
"""
    }
}

open class XmlElementBuilder <: ToString {
    private var name_: ToString = ""
    private var attributes_ = ArrayList<(ToString, ToString)>()
    private var children = ArrayList<XmlElementBuilder>()
    private var content_: ToString = ""

    /*
     * @noThrow
     */
    XmlElementBuilder(let level!: UInt64 = 0) {}

    public mut prop attributes: ArrayList<(ToString, ToString)> {
        /*
         * @noThrow
         */
        get() { attributes_ }
        /*
         * @noThrow
         */
        set(value) { attributes_ = value }
    }

    public mut prop content: ToString {
        /*
         * @noThrow
         */
        get() { content_ }
        /*
         * @noThrow
         */
        set(value) { content_ = value }
    }

    /*
     * @noThrow
     */
    public func name(name: ToString) {
        this.name_ = name
        this
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func attribute(key: ToString, value: ToString): This {
        attributes.add((key, value.toString().toXmlEscapedString()))
        this
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func optionalAttribute(key: ToString, value: ?String): This {
        if (let Some(value) <- value) {
            attribute(key, value)
        }
        this
    }

    /*
     * @noThrow
     */
    public open func element(contentBuilder: () -> ToString): This {
        content = contentBuilder()
        this
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public open func element(name: ToString, childBuilder: (XmlElementBuilder) -> Unit): This {
        let child = XmlElementBuilder(level: level + 1)
        name |> child.name
        child |> childBuilder
        child |> children.add
        this
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func buildAttributes(sb: StringBuilder) {
        for ((k, v) in attributes) {
            sb.append(" ${k}=\"${v}\"")
        }
    }

    /*
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func buildContent(sb: StringBuilder) {
        let charsData = content.toString().toXmlEscapedString()
        match {
            case !charsData.isEmpty() => sb.append(charsData)
            case !children.isEmpty() =>
                sb.append(r'\n')
                for (child in children) {
                    sb.append(child)
                    sb.append(r'\n')
                }
                sb.append(indent())
            case _ => ()
        }
    }

    /*
     * @throws IllegalArgumentException
     */
    private func indent() {
        "\t" * Int64(level)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func build(sb: StringBuilder): Unit {
        let contentSb = StringBuilder()
        buildContent(contentSb)

        sb.append(indent())
        sb.append("<${name_}")
        buildAttributes(sb)

        match (contentSb.size == 0) {
            case true => sb.append("/>")
            case false =>
                sb.append(">")
                sb.append(contentSb)
                sb.append("</${name_}>")
        }
    }

    /*
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public open func toString(): String {
        let sb = StringBuilder()
        build(sb)
        sb.toString()
    }
}

extend String {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    func toXmlEscapedString() {
        this.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("'", "&apos;")
        .replace("\"", "&quot;")
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    func toSafeFileName() {
        this.replace("<", ".")
            .replace(",", ".")
            .replace(">", "")
            .replace("/", "_")
            .replace(" ", "")
    }
}

interface ReportFormat {
    static prop isBench: Bool {
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
        get() { defaultConfiguration().bench }
    }



    /*
     * @throws getOrThrow
     * @throws JsonException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws UnittestCliOptionsFormatException
     */
    static func fromString(format: String, path: Path): ReportFormat {
        match (isBench) {
            case true => BenchReportFormat.fromString(format, path)
            case false => UTestReportFormat.fromString(format, path)
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
    static func default(path: Path): ReportFormat {
        match (isBench) {
            case true => BenchReportFormat.default(path)
            case false => UTestReportFormat.default(path)
        }
    }

    /*
     * @throws getOrThrow
     * @throws JsonException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws UnittestCliOptionsFormatException
     */
    static func fromDefaultConfiguration(): ?ReportFormat {
        let reportDir = getReportDirectory(KeyReportPath.reportPath)
        if (let Some(explicitFormat) <- defaultConfiguration().get(KeyReportFormat.reportFormat)) {
            let dir = reportDir ?? throw UnittestCliOptionsFormatException(
                "--report-path directory should be specified since --report-format is specified")
            return ReportFormat.fromString(explicitFormat, dir)
        }
        ReportFormat.default(reportDir ?? return None)
    }

    /*
     * @noThrow
     */
    func report(testInfo: TestGroupResult): Unit
}

enum UTestReportFormat <: ReportFormat {
      /*
       * @noThrow
       */
    | XML(Path)

    /*
     * @noThrow
     */
    public static redef func default(path: Path): ReportFormat {
        XML(path)
    }

    public static redef prop isBench: Bool {
        /*
         * @noThrow
         */
        get() { false }
    }

    /*
     * @throws UnittestCliOptionsFormatException
     */
    public static redef func fromString(format: String, path: Path): ReportFormat {
        match (format.toAsciiUpper()) {
            case "XML" => XML(path)
            case _ => throw UnittestCliOptionsFormatException("Unsupported test report format: ${format}")
        }
    }

    /*
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws FSException
     */
    public func report(result: TestGroupResult): Unit {
        match (this) {
            case XML(path) => result.reportXml(path.join("tests"))
        }
    }
}



/*
 * @throws getOrThrow
 * @throws JsonException
 * @throws OutOfMemoryError
 * @throws ArithmeticException
 * @throws ProcessException
 * @throws IllegalArgumentException
 * @throws Exception
 * @throws UnittestCliOptionsFormatException
 * @throws IllegalMemoryException
 * @throws RegexException
 * @throws UnittestOptionValidationException
 * @throws IndexOutOfBoundsException
 */
func getReportDirectory<Key>(key: Key): ?Path where Key <: KeyFor<String> {
    let pathStr = defaultConfiguration().get<String>(key) ?? return None
    if (pathStr.isAsciiBlank()) {
        return None
    }
    if (File.exists(pathStr)) { return None }
    Path(pathStr)
}

/*
 * @throws ArithmeticException
 */
private func timeFormat(time: Duration): Float64 { Float64(time.toNanoseconds()) / 1_000_000_000.0 }

extend TestSuiteId {
    /*
     * @noThrow
     */
    func asClassName() {
        "${groupName}.${suiteName}"
    }
}

private class XmlReport {
    var currentCaseId: TestCaseId
    var fakeId: TestCaseId
    /*
     * @noThrow
     */
    XmlReport(let suiteResult: TestSuiteResult) {
        fakeId = TestCaseId(suiteResult.suiteId, "lifecycle", isBench: false)
        currentCaseId = fakeId
    }

    /*
     * @throws Exception
     * @throws NoneValueException
     * @throws ArithmeticException
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     */
    func buildTestSuite(): ToString {
        let builder = XmlBuilder().encoding("UTF-8")

        builder.element("testsuite") { testSuiteXml =>
            let details = suiteResult.details
            testSuiteXml
                .attribute("name", suiteResult.suiteId.asClassName())
                .attribute("tests", details.totalCount)
                .attribute("failures", details.failedCount)
                .attribute("errors", details.errorCount)
                .attribute("skipped", details.skippedCount)
                .attribute("time", timeFormat(details.duration))
                .attribute("timestamp", details.startTimestamp)

            if (!suiteResult.suiteInfo.isEmpty && !suiteResult.suiteId.isFromTopLevelFunc) {
                testSuiteXml.element("properties") { propertiesXml =>
                    tagsProperty(propertiesXml, suiteResult.suiteInfo.tags)
                }
            }

            suiteResult.visitPassedTests { tcr => 
                if (tcr.details.totalCount == 0) { return }
                buildTestEntry(tcr.subResults[0], tcr.caseId, tcr.caseInfo, testSuiteXml)
            }

            suiteResult.visitFailedSteps { subResult, tcr => 
                buildTestEntry(subResult, tcr.caseId, tcr.caseInfo, testSuiteXml)
            }
        }
    }

    /*
     * @throws ArithmeticException
     * @throws Exception
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func buildTestEntry(
        result: RunStepResult, caseId: TestCaseId,
        caseInfo: TestCaseReportInfo, elementBuilder: XmlElementBuilder
    ) {
        let message = match (result.kind) {
            case CaseStep(descr) where result.hasFailures() => descr.intoErrorMessage()?.toString()
            case Lifecycle(x) => lifecycleStageFailedText(x).toString()
            case _ => None<String>
        }

        elementBuilder.element("testcase") { testCaseXml =>
            testCaseXml
                .attribute("name", caseId.caseName)
                .attribute("classname", caseId.suiteId.asClassName())
                .attribute("assertions", totalAssertions(result))
                .attribute("time", timeFormat(result.duration))

            match (result.statusCode()) {
                case SKIP => testCaseXml.element("skipped") { _ => }
                case FAIL => testCaseXml.element("failure") { it =>
                    it.optionalAttribute("message", message)
                    it.element { checkResultsAsString(result.checkResults) }
                }
                case TIMEOUT => testCaseXml.element("failure") { it =>
                    it.optionalAttribute("message", message)
                    it.attribute("type", "Timeout")
                    it.element { checkResultsAsString(result.checkResults) }
                }
                case ERROR => testCaseXml.element("error") { it =>
                    it.optionalAttribute("message", message)
                    it.element { checkResultsAsString(result.checkResults) }
                }
                case NORUN => ()
                case PASS => ()
            }

            if (!caseInfo.isEmpty) {
                testCaseXml.element("properties") { propertiesXml =>
                    tagsProperty(propertiesXml, caseInfo.tags)
                }
            }
        }
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func tagsProperty(propertiesXml: XmlElementBuilder, tags: Array<String>) {
        propertiesXml.element("property") { propertyXml =>
            let tagsValue = String.join(tags, delimiter: ",")
            propertyXml.attribute("name", "tags").attribute("value", tagsValue)
        }
    }

    /*
     * @noThrow
     */
    private func totalAssertions(result: RunStepResult): Int64 {
        var total = result.checksPassed
        for (assertionFailure in result.checkResults) {
            if (assertionFailure is AssertExpectCheckResult) {
                total += 1
            }
        }
        total
    }

    /*
     * @throws Exception
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func checkResultsAsString(crs: Array<CheckResult>): String {
        let text = PrettyText()
        for (cr in crs) {
            cr.pprintWithFailedPrefix(text).newLine()
        }
        text.toString()
    }
}

extend TestGroupResult {
    /*
     * @throws InvalidDataException
     * @throws OutOfMemoryError
     * @throws Exception
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws FSException
     */
    func reportXml(dir: Path): Unit {
        Directory.ensureExists(dir)
        this.visitAll<TestSuiteResult> { suiteResult =>
            let fileName = suiteResult.suiteId.reportFileName(isBench: false, extension: "xml")
            let xmlBytes = XmlReport(suiteResult).buildTestSuite().toString().toArray()
            File.writeTo(
                dir.join(fileName),
                xmlBytes
            )
        }
    }
}

extend TestSuiteId {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    func reportFileName(isBench!: Bool, extension!: String): String {
        let prefix = if (isBench) { "bench" } else { "test" }
        "${prefix}-${this.groupName.toSafeFileName()}.${suiteName.toSafeFileName()}.${extension}"
    }
}
