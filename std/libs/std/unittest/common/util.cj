






package std.unittest.common

import std.collection.enumerate
import std.convert.Formattable

private func isNonPrintable(char: Rune): Bool {
    let cp = UInt32(char)
    if (0x00 <= cp && cp <= 0x1F || 0x7f <= cp && cp <= 0x9f) {
        return true
    }
    return false
}

private func asCodePointEscape(char: Rune): String {
    let resultBuilder = StringBuilder("\\u{")
    let cp = UInt32(char)
    if (cp <= 0xffff) {
        resultBuilder.append(cp.format("04x"))
    } else {
        resultBuilder.append(cp.format("08x"))
    }
    resultBuilder.append(r'}')
    return resultBuilder.toString()
}







protected func shieldEscapeSeq(
    s: String,
    shieldSingleQuote!: Bool = true,
    shieldDoubleQuote!: Bool = true,
    shieldBackslash!: Bool = true,
    shieldInterpolation!: Bool = true
): String {
    let resultBuilder = StringBuilder()
    let runes = s.toRuneArray()
    for ((i, ch) in runes |> enumerate) {
        match (ch) {
            case r'\0' => resultBuilder.append("\\0")
            case r'\\' where shieldBackslash => resultBuilder.append("\\\\")
            case r'\b' => resultBuilder.append("\\b")
            case r'\f' => resultBuilder.append("\\f")
            case r'\n' => resultBuilder.append("\\n")
            case r'\r' => resultBuilder.append("\\r")
            case r'\t' => resultBuilder.append("\\t")
            case r'\v' => resultBuilder.append("\\v")
            case r'\'' where shieldSingleQuote => resultBuilder.append("\\\'")
            case r'\"' where shieldDoubleQuote => resultBuilder.append("\\\"")
            case r'\$' where shieldInterpolation && i < runes.size - 1 && runes[i + 1] == r'{' => resultBuilder.append(
                "\\\$")
            case _ =>
                if (isNonPrintable(ch)) {
                    resultBuilder.append(asCodePointEscape(ch))
                } else {
                    resultBuilder.append(ch)
                }
        }
    }
    return resultBuilder.toString()
}

extend PrettyPrinter {
    protected func space() {
        append(" ")
    }

    protected func appendLine() {
        appendLine("")
    }
}
