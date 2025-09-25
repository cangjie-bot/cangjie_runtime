






package std.unittest.diff

import std.unittest.common.PrettyPrinter

extend String <: AssertPrintable<String> {
    public prop hasNestedDiff: Bool {
        get() { false }
    }
    public func pprintForAssertion(pp: PrettyPrinter, right: String, leftPrefix: String, rightPrefix: String,
        level: Int64): PrettyPrinter {
        return pp.pprintStringDiff(this, right, leftPrefix, rightPrefix, level)
    }
}

extend PrettyPrinter {
    func pprintStringDiff(left: String, right: String, leftPrefix: String, rightPrefix: String, level: Int64) {
        if (left.contains("\n") || right.contains("\n")) {
            if (level == 1) {
                pprintNotEqual(leftPrefix, rightPrefix).appendLine(" (multiline difference below)")
            } else {
                appendLine("Multiline difference:")
            }
            printMultilineDiff(left, right)
        } else {
            let q = "\""
            if (level == 1) {
                pprintNotEqual(leftPrefix, rightPrefix).newLine()
                indent {
                    printOneLineDiff(left, right, leftPrefix: leftPrefix + ": ${q}", rightPrefix: rightPrefix + ": ${q}",
                        leftSuffix: q, rightSuffix: q)
                }
            } else {
                printOneLineDiff(left, right, leftPrefix: leftPrefix + ": ${q}", rightPrefix: rightPrefix + ": ${q}",
                    leftSuffix: q, rightSuffix: q)
            }
        }
        return this
    }
}
