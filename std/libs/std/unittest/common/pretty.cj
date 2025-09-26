






package std.unittest.common

import std.collection.ArrayList


public enum Color <: Equatable<Color> {
    | RED
    | GREEN
    | YELLOW
    | BLUE
    | CYAN
    | MAGENTA
    | GRAY
    | DEFAULT_COLOR

    public operator func ==(that: Color): Bool {
        match (this) {
            case RED => if (let RED <- that) { true } else { false }
            case GREEN => if (let GREEN <- that) { true } else { false }
            case YELLOW => if (let YELLOW <- that) { true } else { false }
            case BLUE => if (let BLUE <- that) { true } else { false }
            case CYAN => if (let CYAN <- that) { true } else { false }
            case MAGENTA => if (let MAGENTA <- that) { true } else { false }
            case GRAY => if (let GRAY <- that) { true } else { false }
            case DEFAULT_COLOR => if (let DEFAULT_COLOR <- that) { true } else { false }
        }
    }
    public operator func !=(that: Color) { !(this == that) }
}


public abstract class PrettyPrinter {




    /**
     * @throws IllegalArgumentException
     */
    public PrettyPrinter(let indentationSize!: UInt64 = 4, let startingIndent!: UInt64 = 0) {
        currentIndent = " " * Int64(indentationSize) * Int64(startingIndent)
    }



    protected func put(s: String): Unit


    protected open func putNewLine(): Unit {
        put("\n")
    }




    protected func setColor(color: Color): Unit


    private var currentIndent: String


    private var needIndent = false



    private var currentColor: Color = DEFAULT_COLOR



    public prop isTopLevel: Bool {
        get() { currentIndent.isEmpty() }
    }











    /**
     * @throws IllegalArgumentException
     */
    public func indent(body: () -> Unit): PrettyPrinter {
        indent(1, body)
    }












    /**
     * @throws IllegalArgumentException
     */
    public func indent(indents: UInt64, body: () -> Unit): PrettyPrinter {
        customOffset(indents * indentationSize, body)
    }















    /**
     * @throws IllegalArgumentException
     */
    public func customOffset(symbols: UInt64, body: () -> Unit): PrettyPrinter {
        let savedIndent = currentIndent
        currentIndent += " " * Int64(symbols)
        try {
            body()
        } finally {
            currentIndent = savedIndent
        }
        return this
    }












    public func colored(color: Color, body: () -> Unit): PrettyPrinter {
        if (color == currentColor) {
            body()
            return this
        }
        let previousColor = currentColor
        currentColor = color
        setColor(color)
        try {
            body()
        } finally {
            currentColor = previousColor
            setColor(previousColor)
        }
        return this
    }







    public open func fillLimitedSpace(spaceSize: Int64, body: () -> Unit): PrettyPrinter {
        body()

        return this
    }




    public func colored(color: Color, text: String): PrettyPrinter {
        if (currentColor == color) {
            return append(text)
        }
        let previousColor = currentColor
        currentColor = color
        setColor(color)
        append(text)
        currentColor = previousColor
        setColor(previousColor)
        return this
    }




    public func append(text: String): PrettyPrinter {
        if (needIndent) {
            put(currentIndent)
            needIndent = false
        }
        put(text)
        return this
    }





    /**
     * @throws IllegalArgumentException
     */
    public func appendCentered(text: String, space: UInt64): PrettyPrinter {
        let actualSize = UInt64(text.size)
        let leftSpaces = (space - actualSize) / 2

        appendPadded(text, leftSpaces, space)
    }

    /**
     * @throws IllegalArgumentException
     */
    public func appendLeftAligned(text: String, space: UInt64): PrettyPrinter {
        appendPadded(text, 0, space)
    }

    /**
     * @throws IllegalArgumentException
     */
    public func appendRightAligned(text: String, space: UInt64): PrettyPrinter {
        let actualSize = UInt64(text.size)
        let dd = space - actualSize
        appendPadded(text, dd, space)
    }

    /**
     * @throws IllegalArgumentException
     */
    private func appendPadded(text: String, leftSpaces: UInt64, space: UInt64): PrettyPrinter {
        if (UInt64(text.size) >= space) {
            return append(text)
        }
        let rightSpaces = space - leftSpaces - UInt64(text.size)
        append(" " * Int64(leftSpaces))
        append(text)
        append(" " * Int64(rightSpaces))
    }



    public func append<PP>(value: PP): PrettyPrinter where PP <: PrettyPrintable {
        if (needIndent) {
            put(currentIndent)
            needIndent = false
        }
        value.pprint(this)
        return this
    }


    public func newLine(): PrettyPrinter {
        putNewLine()
        needIndent = true
        return this
    }



    public func appendLine(text: String): PrettyPrinter {
        append(text)
        newLine()
        return this
    }



    public func appendLine<PP>(value: PP): PrettyPrinter where PP <: PrettyPrintable {
        append(value)
        newLine()
        return this
    }
}






enum PrettyPrintableTextChunk {
    | PPTextPiece(String)
    | PPColorSwitch(Color)
    | PPNewLine
}




public class PrettyText <: PrettyPrinter & PrettyPrintable & ToString {
    /**
     * @throws IllegalArgumentException
     */
    PrettyText(let data: ArrayList<PrettyPrintableTextChunk>) {}


    /**
     * @throws IllegalArgumentException
     */
    public init() {
        this(ArrayList())
    }


    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public init(string: String) {
        this()
        put(string)
    }



    /**
     * @throws IllegalArgumentException
     */
    public static func of<PP>(pp: PP) where PP <: PrettyPrintable {
        let result = PrettyText()
        pp.pprint(result)
        result
    }


    public func isEmpty(): Bool {
        data.isEmpty()
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected override func put(s: String): Unit {
        if (!s.isEmpty()) {
            data.add(PPTextPiece(s))
        }
    }
    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected override func setColor(color: Color): Unit {
        data.add(PPColorSwitch(color))
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected override func putNewLine(): Unit {
        data.add(PPNewLine)
    }



    public func pprint(to: PrettyPrinter): PrettyPrinter {
        for (element in data) {
            match (element) {
                case PPTextPiece(s) => to.append(s)
                case PPColorSwitch(c) => to.setColor(c)
                case PPNewLine => to.newLine()
            }
        }
        return to
    }



    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let result = StringBuilder()
        for (element in data) {
            match (element) {
                case PPTextPiece(s) => result.append(s)
                case PPColorSwitch(_) => ()
                case PPNewLine => result.append("\n")
            }
        }
        return result.toString()
    }
}


public interface PrettyPrintable {




    func pprint(to: PrettyPrinter): PrettyPrinter
}


extend<T> Array<T> <: PrettyPrintable where T <: PrettyPrintable {
    public func pprint(to: PrettyPrinter): PrettyPrinter {
        for (e in this) {
            e.pprint(to)
        }
        return to
    }
}


extend<T> ArrayList<T> <: PrettyPrintable where T <: PrettyPrintable {
    public func pprint(to: PrettyPrinter): PrettyPrinter {
        for (e in this) {
            e.pprint(to)
        }
        return to
    }
}

protected const NOT_PRINTABLE_PLACEHOLDER = "<value not printable>"

protected func toStringOrPlaceholder<T>(value: T) {
    return (value as ToString)?.toString() ?? NOT_PRINTABLE_PLACEHOLDER
}

protected func toStringQuotedOrPlaceholder<T>(value: T) {
    return match (value) {
        case vStr: String => quoteString(vStr)
        case _ => toStringOrPlaceholder(value)
    }
}

protected func quoteString<T>(value: T) where T <: ToString {
    return "\"${value}\""
}
