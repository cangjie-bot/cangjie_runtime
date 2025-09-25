






package std.unittest.diff

import std.collection.ArrayList
import std.unittest.common.*

struct SampledAssertValue {
    let sampledStr: String
    let endingOmitted: Bool
    let beginningOmittedCharsAmount: Int64

    /*
     * @noThrow
     */
    init(sampledStr: String, endingOmitted!: Bool = false, beginningOmittedCharsAmount!: Int64 = 0) {
        this.sampledStr = sampledStr
        this.endingOmitted = endingOmitted
        this.beginningOmittedCharsAmount = beginningOmittedCharsAmount
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func addPrefixAndSuffix(out: ArrayList<Rune>): (Int64, Int64) {
        var prefixLen = 0
        var suffixLen = 0

        if (beginningOmittedCharsAmount != 0) {
            let prefix = getOmittedPrefix().toRuneArray()
            for (i in 1..prefix.size + 1) {
                out.add(prefix[prefix.size - i], at: 0)
            }
            prefixLen = prefix.size
        }

        if (endingOmitted) {
            out.add(r'.')
            out.add(r'.')
            out.add(r'.')
            suffixLen = 3
        }

        return (prefixLen, suffixLen)
    }

    /*
     * @noThrow
     */
    private func getOmittedPrefix(): String {
        if (beginningOmittedCharsAmount != 0) {
            "(${beginningOmittedCharsAmount.toString()} characters omitted...)"
        } else { "" }
    }
}

enum Edit<T> {
      /*
       * @noThrow
       */
    | Insert(T)
      /*
       * @noThrow
       */
    | Remove(T)
      /*
       * @noThrow
       */
    | Keep(T)
      /*
       * @noThrow
       */
    | Modify(T, T)
}

extend PrettyPrinter {
    /*
     * @noThrow
     */
    func pprintNotEqual(left: String, right: String, needToQuote!: Bool = false): PrettyPrinter {
        if (needToQuote) { append("\"").colored(YELLOW, left).append("\"") } else { colored(YELLOW, left) }
        append(" != ")
        if (needToQuote) { append("\"").colored(YELLOW, right).append("\"") } else { colored(YELLOW, right) }
    }

    /*
     * @throws IllegalArgumentException
     */
    func pprintLeftRight(left: Any, right: Any, leftPrefix: String, rightPrefix: String) {
        pprintNotEqual(leftPrefix, rightPrefix).newLine()
        indent {
            appendRightAligned("left", 5).appendLine(": ${toStringOrPlaceholder(left)}")
            appendRightAligned("right", 5).append(": ${toStringOrPlaceholder(right)}")
        }
    }

    /*
     * @throws IllegalArgumentException
     */
    func pprintForAssertionOrSimple<T>(left: T, right: T, leftPrefix: String, rightPrefix: String, level: Int64) {
        match (left) {
            case l: AssertPrintable<T> =>
                match (right) {
                    case r: AssertPrintable<T> => l.pprintForAssertion(this, right, leftPrefix, rightPrefix, level)
                    case _ => pprintLeftRight(left, right, leftPrefix, rightPrefix)
                }
            case _ => pprintLeftRight(left, right, leftPrefix, rightPrefix)
        }
    }
}
