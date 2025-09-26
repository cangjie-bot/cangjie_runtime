










package std.time

import std.collection.ArrayList

public class DateTimeFormat {
    public static const RFC1123: String = "www, dd MMM yyyy HH:mm:ss z"
    public static const RFC3339: String = "yyyy-MM-ddTHH:mm:ssOOOO"
    public static const RFC822: String = "ww dd MMM yy HH:mm:ss z"
    public static const RFC850: String = "wwww, dd-MMM-yy HH:mm:ss z"
    let data = ArrayList<FormatType>()
    let rawString: String

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    init(formatString: String) {
        rawString = formatString
        let layout = rawString.toRuneArray()
        let size = layout.size
        var index = 0
        var formatType: FormatType
        while (index < size) {
            (index, formatType) = parseFormat(layout, index)
            formatType.checkLength()
            data.add(formatType)
        }
        data.add(FormatType.Termination)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @Deprecated["Use member function `init(formatString: String)` instead."]
    public static func of(format: String): DateTimeFormat {
        return DateTimeFormat(format)
    }

    @Deprecated["The prop is deprecated, no substitutions."]
    public prop format: String {
        get() {
            rawString
        }
    }
}

enum Text {
    TxtMonth | TxtDayOfWeek | TxtEra
}

enum Numeric {
    NumDay | NumDayOfYear | NumWeekOfYear | NumHour12 | NumHour24 | NumMinute | NumSecond
}

enum FormatType {
    | FormatYear(Int64)
    | FormatISOYear(Int64)
    | FormatMonth(Int64)
    | FormatDayOfMonth(Int64)
    | FormatHourIn24(Int64)
    | FormatHourIn12(Int64)
    | FormatMinute(Int64)
    | FormatSecond(Int64)
    | FormatSecondFraction(Int64)
    | FormatOffset(Int64)
    | FormatZoneInfo(Int64)
    | FormatGMTOffset(Int64)
    | FormatDayOfYear(Int64)
    | FormatAmPm(Int64)
    | FormatDayOfWeek(Int64)
    | FormatISOWeek(Int64)
    | FormatEra(Int64)
    | Separator(Rune)
    | Termination




    /**
     * @throws IllegalArgumentException
     */
    func checkLength(): Unit {
        match (this) {
            case FormatYear(length) => checkFormatLength(length, 9, r'y')
            case FormatISOYear(length) => checkFormatLength(length, 9, r'Y')
            case FormatMonth(length) => checkFormatLength(length, 4, r'M')
            case FormatDayOfMonth(length) => checkFormatLength(length, 2, r'd')
            case FormatHourIn24(length) => checkFormatLength(length, 2, r'H')
            case FormatHourIn12(length) => checkFormatLength(length, 2, r'h')
            case FormatMinute(length) => checkFormatLength(length, 2, r'm')
            case FormatSecond(length) => checkFormatLength(length, 2, r's')
            case FormatSecondFraction(length) => checkFormatLength(length, 3, r'S')
            case FormatOffset(length) => checkFormatLength(length, 4, r'O')
            case FormatZoneInfo(length) => checkFormatLength(length, 4, r'z')
            case FormatGMTOffset(length) => checkFormatLength(length, 4, r'Z')
            case FormatDayOfYear(length) => checkFormatLength(length, 2, r'D')
            case FormatAmPm(length) => checkFormatLength(length, 1, r'a')
            case FormatDayOfWeek(length) => checkFormatLength(length, 4, r'w')
            case FormatISOWeek(length) => checkFormatLength(length, 2, r'W')
            case FormatEra(length) => checkFormatLength(length, 3, r'G')
            case _ => ()
        }
    }

    /**
     * @throws IllegalArgumentException
     */
    func checkFormatLength(length: Int64, maxLen: Int64, r: Rune): Unit {
        if (length > maxLen) {
            throw IllegalArgumentException("The number of character \"${r}\" can not exceed ${maxLen}.")
        }
    }
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func parseFormat(formatString: String): ArrayList<FormatType> {
    let data = ArrayList<FormatType>()
    let layout = formatString.toRuneArray()
    let size = layout.size
    var index = 0
    var formatType: FormatType
    while (index < size) {
        (index, formatType) = parseFormat(layout, index)
        formatType.checkLength()
        data.add(formatType)
    }
    data.add(FormatType.Termination)
    return data
}






/**
 * @throws IndexOutOfBoundsException
 */
func parseFormat(layout: Array<Rune>, index: Int64): (Int64, FormatType) {
    let size = layout.size
    for (idx in index..size) {
        let end = findFormat(idx, layout)
        let length = end - idx
        match (layout[idx]) {
            case r'y' => return (end, FormatYear(length))
            case r'Y' => return (end, FormatISOYear(length))
            case r'M' => return (end, FormatMonth(length))
            case r'd' => return (end, FormatDayOfMonth(length))
            case r'H' => return (end, FormatHourIn24(length))
            case r'h' => return (end, FormatHourIn12(length))
            case r'm' => return (end, FormatMinute(length))
            case r's' => return (end, FormatSecond(length))
            case r'S' => return (end, FormatSecondFraction(length))
            case r'O' => return (end, FormatOffset(length))
            case r'z' => return (end, FormatZoneInfo(length))
            case r'Z' => return (end, FormatGMTOffset(length))
            case r'a' => return (end, FormatAmPm(length))
            case r'D' => return (end, FormatDayOfYear(length))
            case r'w' => return (end, FormatDayOfWeek(length))
            case r'W' => return (end, FormatISOWeek(length))
            case r'G' => return (end, FormatEra(length))
            case _ => return (idx + 1, Separator(layout[idx]))
        }
    }
    return (index, Termination)
}

/**
 * @throws IndexOutOfBoundsException
 */
func findFormat(start: Int64, layout: Array<Rune>) {
    var pos = start + 1
    while (pos < layout.size && layout[pos] == layout[start]) {
        pos++
    }
    return pos
}
