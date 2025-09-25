










package std.time

import std.convert.*

@C
struct NativeClock {
    public var sec: Int64
    public var nanosec: Int64
    /*
     * @noThrow
     */
    public init(sec!: Int64, nanosec!: Int64) {
        this.sec = sec
        this.nanosec = nanosec
    }
}















public struct DateTime <: ToString & Hashable & Comparable<DateTime> & Formattable & Parsable<DateTime> {


    let d: Duration


    let tz: TimeZone

    
    public static prop UnixEpoch: DateTime {
        /*
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ArithmeticException
         */
        get() {
            DateTime.ofUTC(
                year: 1970,
                month: 1,
                dayOfMonth: 1,
                hour: 0,
                minute: 0,
                second: 0,
                nanosecond: 0
            )
        }
    }



    public prop year: Int64 {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         */
        get() {
            getYearAndSecond()[0]
        }
    }



    public prop month: Month {
        /*
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            getMonthAndDay()[0]
        }
    }



    @Deprecated[message: "Use `public prop month: Month` instead."]
    public prop monthValue: Int64 {
        /*
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            month.toInteger()
        }
    }



    public prop dayOfMonth: Int64 {
        /*
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            getMonthAndDay()[1]
        }
    }



    public prop dayOfWeek: DayOfWeek {
        /*
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            let (yearAfter, secondAfter) = getYearAndSecond()
            let days = getDayOfWeek(yearAfter, secondAfter)
            return DayOfWeek.of(days)
        }
    }



    public prop dayOfYear: Int64 {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         */
        get() {
            let second = getYearAndSecond()[1]
            return Int64(second) / SECS_PER_DAY + 1
        }
    }



    public prop hour: Int64 {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         */
        get() {
            let second = getYearAndSecond()[1]
            return Int64(second) % SECS_PER_DAY / SECS_PER_HOUR
        }
    }



    public prop minute: Int64 {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         */
        get() {
            let second = getYearAndSecond()[1]
            return Int64(second) % SECS_PER_HOUR / SECS_PER_MINUTE
        }
    }



    public prop second: Int64 {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         */
        get() {
            let second = getYearAndSecond()[1]
            return Int64(second) % SECS_PER_MINUTE
        }
    }



    public prop nanosecond: Int64 {
        /*
         * @noThrow
         */
        get() {
            Int64(d.ns)
        }
    }



    public prop isoWeek: (Int64, Int64) {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         */
        get() {
            let (year, sec) = getYearAndSecond()
            let vTuesday = 4
            var df = vTuesday - getDayOfWeek(year, sec)
            if (df == vTuesday) {
                df = -3
            }
            let (yearAfter, sec_) = adjustYearAndSecond(year, sec, -df * SECS_PER_DAY)
            return (yearAfter, Int64(sec_) / SECS_PER_WEEK + 1)
        }
    }


    public prop zone: TimeZone {
        /*
         * @noThrow
         */
        get() {
            tz
        }
    }


    public prop zoneId: String {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         */
        get() {
            if (tz.zoneId == "localtime") {
                return tz.lookup(d.sec - SECS_OF_UNIX_TO_AD1)[0]
            } else {
                return tz.zoneId
            }
        }
    }


    public prop zoneOffset: Duration {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         * @throws ArithmeticException
         */
        get() {
            let offset = getOffset()
            Duration.second * offset
        }
    }

    public prop date: (Int64, Month, Int64) {
        /*
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            return getDate()
        }
    }

    public prop time: (Int64, Int64, Int64) {
        /*
         * @throws IllegalArgumentException
         * @throws InvalidDataException
         * @throws IndexOutOfBoundsException
         */
        get() {
            let second = Int64(getYearAndSecond()[1])
            return (second % SECS_PER_DAY / SECS_PER_HOUR,
                    second % SECS_PER_HOUR / SECS_PER_MINUTE,
                    second % SECS_PER_MINUTE)
        }
    }







    /*
     * @noThrow
     */
    init(secs: Int64, nanos: UInt32, tz: TimeZone) {
        this.d = Duration(secs, nanos)
        this.tz = tz
    }





    @Frozen
    /*
     * @noThrow
     */
    public static func now(timeZone!: TimeZone = TimeZone.Local): DateTime {
        var (curSec, curNS) = systemNow()
        return DateTime(curSec + SECS_OF_UNIX_TO_AD1, UInt32(curNS), timeZone)
    }




    /*
     * @noThrow
     */
    public static func nowUTC(): DateTime {
        return now(timeZone: TimeZone.UTC)
    }





    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public static func fromUnixTimeStamp(d: Duration): DateTime {
        return DateTime.UnixEpoch + d
    }










    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    public static func ofEpoch(second!: Int64, nanosecond!: Int64): DateTime {
        if (nanosecond < 0 || nanosecond > MAX_NANOSECOND) {
            throw IllegalArgumentException("The nanosecond value should be in the range [0, 999,999,999].")
        }
        if (second < SECS_OF_MIN_TO_AD1 - SECS_OF_UNIX_TO_AD1) {
            throw ArithmeticException(YEAR_OUT_OF_RANGE)
        }
        if (second > SECS_OF_MAX_TO_AD1 - SECS_OF_UNIX_TO_AD1) {
            throw ArithmeticException(YEAR_OUT_OF_RANGE)
        }
        let seconds = second + SECS_OF_UNIX_TO_AD1
        checkResultYear(seconds)
        DateTime(seconds, UInt32(nanosecond), TimeZone.UTC)
    }















    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    public static func of(
        year!: Int64,
        month!: Int64,
        dayOfMonth!: Int64,
        hour!: Int64 = 0,
        minute!: Int64 = 0,
        second!: Int64 = 0,
        nanosecond!: Int64 = 0,
        timeZone!: TimeZone = TimeZone.Local
    ): DateTime {
        checkDateTime(year, month, dayOfMonth, hour, minute, second, nanosecond)
        return DateTime.ofUnchecked(year, month, dayOfMonth, hour, minute, second, nanosecond, timeZone)
    }















    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    public static func of(
        year!: Int64,
        month!: Month,
        dayOfMonth!: Int64,
        hour!: Int64 = 0,
        minute!: Int64 = 0,
        second!: Int64 = 0,
        nanosecond!: Int64 = 0,
        timeZone!: TimeZone = TimeZone.Local
    ): DateTime {
        DateTime.of(
            year: year,
            month: month.toInteger(),
            dayOfMonth: dayOfMonth,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond,
            timeZone: timeZone
        )
    }














    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public static func ofUTC(
        year!: Int64,
        month!: Int64,
        dayOfMonth!: Int64,
        hour!: Int64 = 0,
        minute!: Int64 = 0,
        second!: Int64 = 0,
        nanosecond!: Int64 = 0
    ): DateTime {
        checkDateTime(year, month, dayOfMonth, hour, minute, second, nanosecond)
        DateTime.ofUTCUnchecked(year, month, dayOfMonth, hour, minute, second, nanosecond)
    }














    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public static func ofUTC(
        year!: Int64,
        month!: Month,
        dayOfMonth!: Int64,
        hour!: Int64 = 0,
        minute!: Int64 = 0,
        second!: Int64 = 0,
        nanosecond!: Int64 = 0
    ): DateTime {
        DateTime.ofUTC(
            year: year,
            month: month.toInteger(),
            dayOfMonth: dayOfMonth,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanosecond
        )
    }







    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    public static func parse(str: String): DateTime {
        return parseTime(str, DateTimeFormat.RFC3339, isRFC3339: true)
    }

    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    public static func tryParse(str: String): Option<DateTime> {
        try {
            parse(str)
        } catch (_) {
            None
        }
    }









    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    public static func parse(str: String, format: String): DateTime {
        return parseTime(str, format)
    }

    @Deprecated[message: "Use member funtion `public static func parse(str: String, format: String): DateTime` instead."]
    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    public static func parse(str: String, format: DateTimeFormat): DateTime {
        return parseTime(str, format.format)
    }






    /*
     * @throws ArithmeticException
     */
    public func inUTC(): DateTime {
        checkResultYear(d.sec)
        return this.toUTC()
    }






    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func inLocal(): DateTime {
        return inTimeZone(TimeZone.Local)
    }







    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func inTimeZone(timeZone: TimeZone): DateTime {
        let offset = timeZone.lookup(d.sec + SECS_OF_UNIX_TO_AD1)[1]
        checkResultYear(d.sec + offset)
        DateTime(d.sec, d.ns, timeZone)
    }








    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func toUnixTimeStamp(): Duration {
        return this - UnixEpoch
    }




    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let res = StringBuilder()
        res.append(addZeroPrefix(this.year, 4))
        res.append(r'-')
        res.append(addZeroPrefix(this.month.toInteger(), 2))
        res.append(r'-')
        res.append(addZeroPrefix(this.dayOfMonth, 2))
        res.append(r'T')
        res.append(addZeroPrefix(this.hour, 2))
        res.append(r':')
        res.append(addZeroPrefix(this.minute, 2))
        res.append(r':')
        res.append(addZeroPrefix(this.second, 2))
        if (this.nanosecond != 0) {
            var nano = this.nanosecond
            var times = 0
            while (nano % 10 == 0) {
                times += 1
                nano /= 10
            }
            res.append(r'.')
            res.append(addZeroPrefix(nano, 9 - times))
        }
        res.append(toOffsetString(4))
        return res.toString()
    }








    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    public func format(fmt: String): String {
        let res = StringBuilder()
        let layout = fmt.toRuneArray()
        let size = layout.size
        var index = 0
        var formatType: FormatType
        while (index < size) {
            (index, formatType) = parseFormat(layout, index)
            formatType.checkLength()
            toStringEx(res, formatType)
        }
        return res.toString()
    }

    @Deprecated[message: "Use member funtion `public func format(fmt: String): String` instead."]
    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(format: DateTimeFormat): String {
        let res = StringBuilder()
        for (f in format.data) {
            toStringEx(res, f)
        }
        return res.toString()
    }

    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    private func toStringEx(sb: StringBuilder, fmt: FormatType) {
        match (fmt) {
            case FormatYear(length) => sb.append(toYearString(length, false))
            case FormatISOYear(length) => sb.append(toYearString(length, true))
            case FormatMonth(length) => sb.append(toMonthString(length))
            case FormatDayOfMonth(length) => sb.append(this.dayOfMonth.toString().padStart(length, padding: "0"))
            case FormatHourIn24(length) => sb.append(this.hour.toString().padStart(length, padding: "0"))
            case FormatHourIn12(length) => sb.append(toHourIn12String(length))
            case FormatMinute(length) => sb.append(this.minute.toString().padStart(length, padding: "0"))
            case FormatSecond(length) => sb.append(this.second.toString().padStart(length, padding: "0"))
            case FormatSecondFraction(length) => sb.append(toSecondFractionString(length))
            case FormatOffset(length) => sb.append(toOffsetString(length))
            case FormatZoneInfo(length) => sb.append(toZoneInfoString(length))
            case FormatGMTOffset(length) => sb.append(toGMTOffsetString(length))
            case FormatDayOfYear(length) => sb.append(toDayOfYearString(length))
            case FormatAmPm(_) => sb.append(if (this.hour < 12) {
                "AM"
            } else {
                "PM"
            })
            case FormatDayOfWeek(length) => sb.append(toDayOfWeekString(length))
            case FormatISOWeek(length) => sb.append(this.isoWeek[1].toString().padStart(length, padding: "0"))
            case FormatEra(length) => sb.append(toEraString(length))
            case Separator(rune) => sb.append(rune)
            case Termination => ()
        }
    }




    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return d.hashCode()
    }










    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func addYears(n: Int64): DateTime {
        let year = this.year
        if ((n > 0 && year > MAX_YEAR - n) || (n < 0 && year < MIN_YEAR - n)) {
            throw ArithmeticException(YEAR_OUT_OF_RANGE)
        }
        var yearAfter = year + n
        var dayAfter = this.dayOfMonth
        if (isLeapYear(year) && this.dayOfYear == DAYS_OF_JAN_TO_MARCH_LEAP && !isLeapYear(yearAfter)) {
            dayAfter -= 1
        }
        return DateTime.ofUnchecked(yearAfter, this.month.toInteger(), dayAfter, this.hour, this.minute, this.second,
            Int64(this.d.ns), this.zone)
    }










    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func addMonths(n: Int64): DateTime {
        let month = this.month.toInteger()
        if (isSumOverflow(month, n)) {
            throw ArithmeticException(YEAR_OUT_OF_RANGE)
        }
        let monthsAfter = month + n
        var yearAfter = this.year + (monthsAfter / MONTHS_PER_YEAR)
        var monthAfter = monthsAfter % MONTHS_PER_YEAR
        if (monthAfter < 1) {
            yearAfter -= 1
            monthAfter += MONTHS_PER_YEAR
        }
        var days = DAYS_OF_MONTH[monthAfter]
        if (isLeapYear(yearAfter) && monthAfter == 2) {
            days += 1
        }
        if (yearAfter > MAX_YEAR || yearAfter < MIN_YEAR) {
            throw ArithmeticException(YEAR_OUT_OF_RANGE)
        }
        var dayAfter = days
        let dayOfMonth = this.dayOfMonth
        if (days > dayOfMonth) {
            dayAfter = dayOfMonth
        }
        return DateTime.ofUnchecked(yearAfter, monthAfter, dayAfter, this.hour, this.minute, this.second,
            Int64(this.d.ns), this.zone)
    }







    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func addWeeks(n: Int64): DateTime {
        checkMul(DAYS_PER_WEEK, n)
        let days = n * DAYS_PER_WEEK
        return this.addDays(days)
    }







    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func addDays(n: Int64): DateTime {
        checkMul(SECS_PER_DAY, n)
        let offset = getOffset()
        var seconds = n * SECS_PER_DAY
        if (isSumOverflow(offset, seconds) || isSumOverflow(d.sec, seconds + offset)) {
            throw ArithmeticException(YEAR_OUT_OF_RANGE)
        }
        seconds = d.sec + seconds + offset
        let (year, sec) = toYearAndSecond(seconds)
        checkResultYear(seconds)
        let (month, day) = getDate(year, UInt32(sec))
        let hour = sec % SECS_PER_DAY / SECS_PER_HOUR
        let minute = sec % SECS_PER_HOUR / SECS_PER_MINUTE
        let second = sec % SECS_PER_MINUTE
        return DateTime.ofUnchecked(year, month.toInteger(), day, hour, minute, second, Int64(d.ns), this.zone)
    }







    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func addHours(n: Int64): DateTime {
        checkMul(SECS_PER_HOUR, n)
        let seconds = n * SECS_PER_HOUR
        return this.addSeconds(seconds)
    }







    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func addMinutes(n: Int64): DateTime {
        checkMul(SECS_PER_MINUTE, n)
        let seconds = n * SECS_PER_MINUTE
        return this.addSeconds(seconds)
    }







    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func addSeconds(n: Int64): DateTime {
        if (isSumOverflow(d.sec, n)) {
            throw ArithmeticException(YEAR_OUT_OF_RANGE)
        }
        let seconds = d.sec + n
        let offset = this.tz.lookup(second)[1]
        checkResultYear(seconds + offset)
        return DateTime(seconds, d.ns, this.tz)
    }







    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func addNanoseconds(n: Int64): DateTime {
        return this + Duration.nanosecond * n
    }








    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public operator func +(r: Duration): DateTime {
        checkSecAdd(d.sec, r.sec)
        var sec = d.sec + r.sec
        var ns = Int64(d.ns) + Int64(r.ns)
        if (ns >= NS_PER_SEC) {
            sec += 1
            ns -= NS_PER_SEC
        }
        let offset = this.tz.lookup(sec - SECS_OF_UNIX_TO_AD1)[1]
        checkResultYear(sec + offset)
        return DateTime(sec, UInt32(ns), this.tz)
    }








    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public operator func -(r: Duration): DateTime {
        if (r.sec == Int64.Min) {
            throw ArithmeticException(YEAR_OUT_OF_RANGE)
        }
        checkSecAdd(d.sec, -r.sec)
        var sec = d.sec - r.sec
        var ns = Int64(d.ns) - Int64(r.ns)
        if (ns < 0) {
            sec -= 1
            ns += NS_PER_SEC
        }
        let offset = this.tz.lookup(sec - SECS_OF_UNIX_TO_AD1)[1]
        checkResultYear(sec + offset)
        return DateTime(sec, UInt32(ns), this.tz)
    }








    /*
     * @throws ArithmeticException
     */
    public operator func -(r: DateTime): Duration {
        return this.d - r.d
    }





    /*
     * @noThrow
     */
    public operator func ==(r: DateTime): Bool {
        return this.d == r.d
    }





    /*
     * @noThrow
     */
    public operator func !=(r: DateTime): Bool {
        return !(this == r)
    }





    /*
     * @noThrow
     */
    public operator func >=(r: DateTime): Bool {
        return this.d >= r.d
    }





    /*
     * @noThrow
     */
    public operator func >(r: DateTime): Bool {
        return this.d > r.d
    }





    /*
     * @noThrow
     */
    public operator func <=(r: DateTime): Bool {
        return this.d <= r.d
    }





    /*
     * @noThrow
     */
    public operator func <(r: DateTime): Bool {
        return this.d < r.d
    }





    /*
     * @noThrow
     */
    public func compare(rhs: DateTime): Ordering {
        match {
            case this < rhs => Ordering.LT
            case this > rhs => Ordering.GT
            case _ => Ordering.EQ
        }
    }

    
    /*
     * @noThrow
     */
    private func toUTC(): DateTime {
        return DateTime(d.sec, d.ns, TimeZone.UTC)
    }

    
    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    private static func ofUnchecked(
        year: Int64,
        month: Int64,
        dayOfMonth: Int64,
        hour: Int64,
        minute: Int64,
        second: Int64,
        nanosecond: Int64,
        timeZone: TimeZone
    ): DateTime {
        let secInYear = toSecondInYear(year, month, dayOfMonth, hour, minute, second)
        let unix = toEpochSeconds(year, UInt32(secInYear))
        let (_, offset, start, end) = timeZone.lookup(unix)
        let preOffset = if (start == Int64.Min) {
            offset
        } else {
            timeZone.lookup(start - 1)[1]
        }
        let secSinceAD1 = unix + SECS_OF_UNIX_TO_AD1

        if (unix - offset < start && unix - preOffset >= start) {
            return DateTime(secSinceAD1 - preOffset, UInt32(nanosecond), timeZone)
        }
        if (unix - offset >= start && unix - preOffset < start || unix - preOffset < start && preOffset < offset) {
            return DateTime(secSinceAD1 - preOffset, UInt32(nanosecond), timeZone)
        }
        let nextOffset = timeZone.lookup(end)[1]
        if (unix - offset >= end && unix - nextOffset < end) {
            return DateTime(secSinceAD1 - offset, UInt32(nanosecond), timeZone)
        }
        if (unix - offset >= end && offset > nextOffset || unix - nextOffset >= end && offset < nextOffset) {
            return DateTime(secSinceAD1 - nextOffset, UInt32(nanosecond), timeZone)
        }

        return DateTime(secSinceAD1 - offset, UInt32(nanosecond), timeZone)
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    private static func ofUTCUnchecked(
        year: Int64,
        month: Int64,
        dayOfMonth: Int64,
        hour: Int64,
        minute: Int64,
        second: Int64,
        nanosecond: Int64
    ): DateTime {
        let seconds = toSecondsFromAD1(year, month, dayOfMonth, hour, minute, second)
        DateTime(seconds, UInt32(nanosecond), TimeZone.UTC)
    }

    
    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    private func getYearAndSecond(): (Int64, UInt32) {
        let offset = getOffset()
        let (year, sec) = toYearAndSecond(d.sec + offset)
        return (year, UInt32(sec))
    }

    
    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func getMonthAndDay(): (Month, Int64) {
        let (yearAfter, secondAfter) = getYearAndSecond()
        let (monthAfter, dayAfter) = getDate(yearAfter, secondAfter)
        return (monthAfter, dayAfter)
    }

    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func getDate(): (Int64, Month, Int64) {
        let (yearAfter, secondAfter) = getYearAndSecond()
        let (monthAfter, dayAfter) = getDate(yearAfter, secondAfter)
        return (yearAfter, monthAfter, dayAfter)
    }

    
    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    private func getOffset(): Int64 {
        return this.tz.lookup(d.sec - SECS_OF_UNIX_TO_AD1)[1]
    }

    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func toYearString(length: Int64, isISOYear: Bool): String {
        var yearAfter = this.year
        let isNegative = yearAfter < 0
        if (isISOYear) {
            yearAfter = isoWeek[0]
        }
        if (isNegative) {
            yearAfter = -yearAfter
        }
        var paddingLength = length
        if (length == 2) {
            if ((yearAfter >= 1969 && yearAfter <= 1999) || yearAfter >= 2000 && yearAfter <= 2068) {
                return (yearAfter % 100).toString()
            }
            paddingLength = 4
        }

        var temp = yearAfter.toString().padStart(paddingLength, padding: "0")
        if (isNegative) {
            temp = "-" + temp
        }
        return temp
    }

    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func toMonthString(length: Int64): String {
        return match (length) {
            case 1 | 2 => this.month.toInteger().toString().padStart(length, padding: "0")
            case 3 => this.month.toString()[..3]
            case _ => this.month.toString()
        }
    }

    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func toHourIn12String(length: Int64): String {
        return if (hour == HOUR_24_START || hour == HOUR_12_END) {
            "12"
        } else {
            (this.hour % HOUR_12_INTERVAL).toString().padStart(length, padding: "0")
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func toSecondFractionString(length: Int64): String {




        let width = 3 * length
        let fraction = Int64(d.ns) / (10 ** UInt64(9 - width))
        return fraction.toString().padStart(width, padding: "0")
    }

    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func toDayOfWeekString(length: Int64): String {
        return match (length) {
            case 1 | 2 => this.dayOfWeek.toInteger().toString().padStart(length, padding: "0")
            case 3 => this.dayOfWeek.toString()[..3]
            case _ => this.dayOfWeek.toString()
        }
    }

    /*
     * @noThrow
     */
    func toEraString(length: Int64): String {
        return match (length) {
            case 1 => "A"
            case 2 => "AD"
            case _ => "Anno Domini"
        }
    }

    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func toOffsetString(length: Int64): String {
        let offset = getOffset()
        let (off, sign): (Int64, String) = if (offset < 0) {
            (-offset, "-")
        } else {
            (offset, "+")
        }

        let convertFn = {
            length: Int64, width: Int64 => return length.toString().padStart(width, padding: "0")
        }
        let hour = off / SECS_PER_HOUR
        let minute = off % SECS_PER_HOUR / SECS_PER_MINUTE
        let second = off % SECS_PER_MINUTE

        if (length > 3 && offset == 0) {
            return "Z"
        }

        if (length == 3 || (length > 3 && second != 0)) {
            return "${sign}${convertFn(hour, 2)}:${convertFn(minute, 2)}:${convertFn(second, 2)}"
        }

        if (length == 2 || length > 3) {
            return "${sign}${convertFn(hour, 2)}:${convertFn(minute, 2)}"
        }

        return sign + convertFn(hour, 2)
    }

    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    func toZoneInfoString(length: Int64): String {
        return match (length) {
            case 4 => this.zoneId
            case _ => try {
                this.tz.lookup(d.sec - SECS_OF_UNIX_TO_AD1)[0]
            } catch (_: InvalidDataException) {
                this.zoneId
            }
        }
    }

    
    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     */
    func toGMTOffsetString(length: Int64): String {
        var res = toOffsetString(length)
        let offset = getOffset()
        if (offset == 0) {
            res = match (length) {
                case 1 => "+0"
                case 3 => "+00:00:00"
                case _ => "+00:00"
            }
        } else if (offset % SECS_PER_HOUR == 0 && length == 1) {
            if (res[1] == b'0') {
                res = "${Rune(UInt32(res[0]))}${Rune(UInt32(res[2]))}"
            }
        }
        return "GMT${res}"
    }

    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func toDayOfYearString(length: Int64): String {
        if (length == 1) {
            this.dayOfYear.toString()
        } else {
            this.dayOfYear.toString().padStart(3, padding: "0")
        }
    }

    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    func genDateTime(zoneId: String, zoneOffset: Int64): DateTime {
        if (zoneId == "") {
            if (zoneOffset != MAX_OFFSET + 1) {
                let zoneName = if (zoneOffset == 0) {
                    "GMT"
                } else {
                    genZoneNameWithOffset(zoneOffset)
                }
                checkResultYear(d.sec)
                return DateTime(d.sec - zoneOffset, d.ns, TimeZone(zoneName, Int32(zoneOffset)))
            }
            return DateTime.of(year: year, month: month, dayOfMonth: dayOfMonth, hour: hour, minute: minute,
                second: second, nanosecond: nanosecond)
        } else {
            try {
                var timeZone = TimeZone.load(zoneId)
                let dateTime = DateTime.of(year: year, month: month, dayOfMonth: dayOfMonth, hour: hour, minute: minute,
                    second: second, nanosecond: nanosecond, timeZone: timeZone)
                var offset = dateTime.zoneOffset.toSeconds()
                if (zoneOffset != MAX_OFFSET + 1 && zoneOffset != offset) {
                    throw TimeParseException("The zone offset does not match.")
                }
                return dateTime
            } catch (_: InvalidDataException) {
                var localTimeZone = TimeZone.Local
                var offset = localTimeZone.lookupName(zoneId, d.sec - SECS_OF_UNIX_TO_AD1)
                if (offset == MAX_OFFSET + 1) {
                    throw TimeParseException("Illegal zone name or zone id.")
                }
                if (zoneOffset != MAX_OFFSET + 1 && zoneOffset != offset) {
                    throw TimeParseException("The zone offset does not match.")
                }
                return DateTime(d.sec - offset, d.ns, TimeZone(zoneId, Int32(offset)))
            }
        }
    }

    /*
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws TimeParseException
     */
    func checkExtraInfo(isoYear: Int64, isoWeek: Int64, dayOfWeek: Int64): Unit {
        if (isoYear != MAX_YEAR + 1) {
            if (isoYear != this.isoWeek[0]) {
                throw TimeParseException("The year based on ISO8601 does not match.")
            }
        }
        if (isoWeek != 0) {
            if (isoWeek != this.isoWeek[1]) {
                throw TimeParseException("The week based on ISO8601 does not match.")
            }
        }
        if (dayOfWeek != -1) {
            if (dayOfWeek != this.dayOfWeek.toInteger()) {
                throw TimeParseException("The day of week does not match.")
            }
        }
    }
}

/*
 * @noThrow
 */
func isSumOverflow(left: Int64, right: Int64): Bool {
    return (right > 0 && left > Int64.Max - right) || (right < 0 && left < Int64.Min - right)
}

/*
 * @throws ArithmeticException
 */
func checkSecAdd(left: Int64, right: Int64): Unit {
    if ((right > 0 && left > MAX_UTC_SECS - right) || (right < 0 && left < MIN_UTC_SECS - right)) {
        throw ArithmeticException(YEAR_OUT_OF_RANGE)
    }
}

/*
 * @throws ArithmeticException
 */
func checkMul(left: Int64, right: Int64): Unit {
    if ((right > Int64.Max / left) || (right < Int64.Min / left)) {
        throw ArithmeticException(YEAR_OUT_OF_RANGE)
    }
}




/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func checkDateTime(
    year: Int64,
    month: Int64,
    dayOfMonth: Int64,
    hour: Int64,
    minute: Int64,
    second: Int64,
    nanosecond: Int64
): Unit {
    if (year > MAX_YEAR || year < MIN_YEAR) {
        throw IllegalArgumentException("Year value must be in [-999,999,999, 999,999,999].")
    }
    let days = daysIn(month, year)
    if (dayOfMonth < 1 || dayOfMonth > days) {
        throw IllegalArgumentException("Day of ${Month.of(month).toString()} in ${year} must be in [1, ${days}].")
    }
    if (hour < 0 || hour > 23) {
        throw IllegalArgumentException("Hour must be in [0, 23].")
    }
    if (minute < 0 || minute > 59) {
        throw IllegalArgumentException("Minute must be in [0, 59].")
    }
    if (second < 0 || second > 59) {
        throw IllegalArgumentException("Second must be in [0, 59].")
    }
    if (nanosecond < 0 || nanosecond > MAX_NANOSECOND) {
        throw IllegalArgumentException("Nanosecond must be in [0, 999,999,999].")
    }
}


/*
 * @noThrow
 */
func toYearAndSecond(sec: Int64): (Int64, Int64) {
    var year = START_AD_YEAR
    var seconds = sec
    if (seconds < 0) {
        seconds -= SECS_OF_MIN_TO_AD1
        year = MIN_YEAR
    }
    var days = seconds / SECS_PER_DAY
    var restSec = seconds % SECS_PER_DAY

    var times = days / DAYS_PER_400YEARS
    year += 400 * times
    days %= DAYS_PER_400YEARS

    times = days / DAYS_PER_100YEARS
    times -= times >> 2
    year += 100 * times
    days -= DAYS_PER_100YEARS * times

    times = days / DAYS_PER_4YEARS
    year += 4 * times
    days %= DAYS_PER_4YEARS

    times = days / DAYS_OF_NORMAL_YEAR
    times -= times >> 2
    year += times
    days -= DAYS_OF_NORMAL_YEAR * times

    let secInYear = restSec + days * SECS_PER_DAY
    return (year, secInYear)
}



/*
 * @throws ArithmeticException
 */
func toEpochSeconds(year: Int64, sec: UInt32): Int64 {
    try {
        var days = daysSinceUnix(year)
        var secs = days * SECS_PER_DAY
        return secs + Int64(sec)
    } catch (_: ArithmeticException) {
        throw ArithmeticException(YEAR_OUT_OF_RANGE)
    }
}



/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func getDate(year: Int64, sec: UInt32): (Month, Int64) {
    var days = Int64(sec) / SECS_PER_DAY
    if (isLeapYear(year)) {
        if (days == DAYS_BEFORE[2]) {
            return (Month.February, 29)
        }
        if (days > DAYS_BEFORE[2]) {
            days -= 1
        }
    }
    var idx = 0
    var day = 0
    while (idx < DAYS_BEFORE.size) {
        
        if (days == DAYS_BEFORE[idx]) {
            idx++
            day = 1
            break
        }

        
        if (days < DAYS_BEFORE[idx]) {
            day = days - DAYS_BEFORE[idx - 1] + 1
            break
        }
        idx++
    }
    var month = Month.of(idx)
    return (month, day)
}


/*
 * @noThrow
 */
func getDayOfWeek(year: Int64, sec: UInt32): Int64 {
    var days = daysSinceAD1(year)
    days += Int64(sec) / SECS_PER_DAY
    days += 1
    days %= 7
    if (days >= 0) {
        return days
    } else {
        return days + 7
    }
}


/*
 * @noThrow
 */
func daysSinceUnix(year: Int64): Int64 {
    var days = daysSinceAD1(year)
    return days - DAYS_OF_UNIX_TO_AD1
}


/*
 * @noThrow
 */
func daysSinceAD1(year: Int64): Int64 {
    if (year == 0) {
        return -DAYS_OF_LEAP_YEAR
    }
    if (year > 0) {
        return daysAD1ToYear(year)
    }
    return -(daysAD1ToYear(-year + 1) + DAYS_OF_LEAP_YEAR)
}







/*
 * @noThrow
 */
func daysAD1ToYear(year: Int64): Int64 {
    let years = year - 1
    var days = 365 * years
    days += years / 4
    days -= years / 100
    days += years / 400
    return days
}








/*
 * @noThrow
 */
func adjustYearAndSecond(year: Int64, second: UInt32, offset: Int64): (Int64, UInt32) {
    if (offset == 0) {
        return (year, second)
    }
    var seconds = Int64(second) - offset
    var curYearSec = SECS_OF_NORMAL_YEAR 
    if (isLeapYear(year)) {
        curYearSec += SECS_PER_DAY
    }
    if (seconds >= curYearSec) {
        return (year + 1, UInt32(seconds - curYearSec))
    }
    if (seconds < 0) {
        var lastYearSec = SECS_OF_NORMAL_YEAR
        if (isLeapYear(year - 1)) {
            lastYearSec += SECS_PER_DAY
        }
        return (year - 1, UInt32(seconds + lastYearSec))
    }
    return (year, UInt32(seconds))
}







/*
 * @noThrow
 */
func isLeapYear(year: Int64): Bool {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
}









/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func daysIn(month: Int64, year: Int64): Int64 {
    if (month < 1 || month > 12) {
        throw IllegalArgumentException("Month value must be in the range [1, 12].")
    }
    if (month == 2 && isLeapYear(year)) {
        return 29
    }
    return DAYS_OF_MONTH[month]
}


public class TimeParseException <: Exception {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "TimeParseException"
    }
}













/*
 * @throws IllegalMemoryException
 * @throws ArithmeticException
 * @throws IllegalArgumentException
 * @throws OutOfMemoryError
 * @throws InvalidDataException
 * @throws IndexOutOfBoundsException
 * @throws TimeParseException
 */
func parseTime(value: String, format: String, isRFC3339!: Bool = false): DateTime {
    var dtValue = value.toRuneArray()
    var parser = DateTimeParser(dtValue)
    var (year, month, dayOfMonth, hour, minute, second, nanosecond) = (MAX_YEAR + 1, -1, -1, -1, -1, -1, -1)
    var (zoneOffset, zoneInfo, dayOfYear, dayOfWeek, isoYear, isoWeek) = (MAX_OFFSET + 1, "", -1, -1, MAX_YEAR + 1, 0)
    var (apmFlag, is24Hour, era) = (0, true, false)
    let formatTypes = parseFormat(format)
    for (formatType in formatTypes) {
        match (formatType) {
            case FormatYear(length) => year = parser.parseYear(year, length)
            case FormatISOYear(length) => isoYear = parser.parseYear(isoYear, length)
            case FormatMonth(length) => month = parser.parseMonth(month, length)
            case FormatDayOfMonth(length) => dayOfMonth = parser.parseDayOfMonth(dayOfMonth, length)
            case FormatHourIn24(length) => hour = parser.parseHourIn24(hour, length)
            case FormatHourIn12(length) =>
                hour = parser.parseHourIn12(hour, length)
                is24Hour = false
            case FormatMinute(length) => minute = parser.parseMinute(minute, length)
            case FormatSecond(length) => (second, nanosecond) = parser.parseSecond(second, length, isRFC3339)
            case FormatSecondFraction(length) => nanosecond = parser.parseNanosecond(nanosecond, length)
            case FormatOffset(length) => zoneOffset = parser.parseOffset(zoneOffset, length)
            case FormatZoneInfo(length) => zoneInfo = parser.parseZoneInfo(zoneInfo, length)
            case FormatGMTOffset(length) => zoneOffset = parser.parseGMTOffset(zoneOffset, length)
            case FormatDayOfYear(_) => dayOfYear = parser.parseDayOfYear(dayOfYear)
            case FormatAmPm(_) => apmFlag = parser.parseAmPm(apmFlag)
            case FormatDayOfWeek(length) => dayOfWeek = parser.parseDayOfWeek(dayOfWeek, length)
            case FormatISOWeek(length) => isoWeek = parser.parseISOWeek(isoWeek, length)
            case FormatEra(length) =>
                parser.parseEra(era, length)
                era = true
            case Separator(rune) => parser.checkSeperator(rune)
            case Termination =>
                parser.checkEnd()
                break
        }
    }
    (month, dayOfMonth) = adjustDate(year, month, dayOfMonth, dayOfYear)
    (hour, minute, second, nanosecond) = setDefaultTime(hour, minute, second, nanosecond)
    hour = adjustHour(hour, is24Hour, apmFlag)
    let utc = try {
        DateTime.ofUTC(year: year, month: month, dayOfMonth: dayOfMonth, hour: hour, minute: minute, second: second,
            nanosecond: nanosecond)
    } catch (e: IllegalArgumentException) {
        throw TimeParseException(e.message)
    }
    utc.checkExtraInfo(isoYear, isoWeek, dayOfWeek)
    return utc.genDateTime(zoneInfo, zoneOffset)
}

/*
 * @throws ArithmeticException
 */
func checkResultYear(seconds: Int64): Unit {
    if (seconds >= SECS_OF_MAX_TO_AD1 || seconds < SECS_OF_MIN_TO_AD1) {
        throw ArithmeticException(YEAR_OUT_OF_RANGE)
    }
}


/*
 * @throws IndexOutOfBoundsException
 * @throws ArithmeticException
 */
func toSecondsFromAD1(year: Int64, month: Int64, dayOfMonth: Int64, hour: Int64, minute: Int64, second: Int64): Int64 {
    let secInYear = toSecondInYear(year, month, dayOfMonth, hour, minute, second)
    return toEpochSeconds(year, UInt32(secInYear)) + SECS_OF_UNIX_TO_AD1
}

/*
 * @noThrow
 */
func setDefaultTime(hour: Int64, minute: Int64, second: Int64, nanosecond: Int64): (Int64, Int64, Int64, Int64) {
    return (setDefault(hour), setDefault(minute), setDefault(second), setDefault(nanosecond))
}

/*
 * @throws TimeParseException
 */
func adjustHour(hour: Int64, is24Hour: Bool, apmFlag: Int64): Int64 {
    if (is24Hour) {
        if (apmFlag == 1) {
            if (hour >= HOUR_24_NOON) {
                throw TimeParseException("The time is not in the morning.")
            }
        } else if (apmFlag == 2) {
            if (hour >= 0 && hour < HOUR_24_NOON) {
                throw TimeParseException("The time is not in the afternoon.")
            }
        }
        return hour
    } else {
        return if (apmFlag == 2) {
            if (hour == HOUR_24_NOON) {
                hour
            } else {
                HOUR_24_NOON + hour
            }
        } else {
            if (hour == HOUR_12_START) {
                0
            } else {
                hour
            }
        }
    }
}

/*
 * @throws IndexOutOfBoundsException
 * @throws TimeParseException
 */
func adjustDate(year: Int64, month: Int64, dayOfMonth: Int64, dayOfYear: Int64): (Int64, Int64) {
    if (year == MAX_YEAR + 1) {
        throw TimeParseException("Lack of year value.")
    }
    var mon = month
    var day = dayOfMonth
    if (dayOfYear > 0) {
        var (months, days) = dayOfYearToDate(dayOfYear, year)
        if (month > 0 && month != months) {
            throw TimeParseException("Month value does not match dayOfYear.")
        }
        if (dayOfMonth > 0 && dayOfMonth != days) {
            throw TimeParseException("DayOfMonth value does not match dayOfYear.")
        }
        mon = months
        day = days
    }

    if (mon == -1) {
        throw TimeParseException("Lack of month value.")
    }
    if (day == -1) {
        throw TimeParseException("Lack of dayOfMonth value.")
    }
    return (mon, day)
}


/*
 * @throws IndexOutOfBoundsException
 */
func toSecondInYear(year: Int64, month: Int64, dayOfMonth: Int64, hour: Int64, minute: Int64, second: Int64): Int64 {
    var days = (DAYS_BEFORE[month - 1] + dayOfMonth - 1)
    if (month > 2 && isLeapYear(year)) {
        days += 1
    }
    var secInYear = days * SECS_PER_DAY
    secInYear += hour * SECS_PER_HOUR
    secInYear += minute * SECS_PER_MINUTE
    secInYear += second
    return secInYear
}

/*
 * @throws IllegalArgumentException
 */
func genZoneNameWithOffset(offset: Int64): String {
    var (value, sign): (Int64, String) = if (offset < 0) {
        (-offset, "-")
    } else {
        (offset, "+")
    }
    var hour = value / SECS_PER_HOUR
    value = value % SECS_PER_HOUR
    var res = if (hour < 10) {
        "GMT${sign}${hour}"
    } else {
        "GMT${sign}${hour}"
    }
    if (value == 0) {
        return res
    }
    if (hour < 10) {
        res = "GMT${sign}0${hour}"
    }
    var minute = value / SECS_PER_MINUTE
    value = value % SECS_PER_MINUTE
    res += if (minute < 10) {
        "0${minute}"
    } else {
        "${minute}"
    }
    if (value == 0) {
        return res
    }
    var second = value
    res += if (second < 10) {
        "0${second}"
    } else {
        "${second}"
    }
    return res
}

/*
 * @throws IndexOutOfBoundsException
 * @throws TimeParseException
 */
func dayOfYearToDate(dayOfYear: Int64, year: Int64): (Int64, Int64) {
    var max = if (isLeapYear(year)) {
        DAYS_OF_LEAP_YEAR
    } else {
        DAYS_OF_NORMAL_YEAR
    }
    if (dayOfYear > max) {
        throw TimeParseException("DayOfYear value in ${year} must be in [1, ${max}].")
    }
    let daysOfYear = dayOfYear
    var monthAfter = 0
    var dayAfter = 0
    for (i in 0..MONTHS_PER_YEAR) {
        var daysBefore = DAYS_BEFORE[i]
        var days = DAYS_BEFORE[i + 1]
        if (isLeapYear(year) && i >= 1) {
            days += 1
            if (i > 1) {
                daysBefore += 1
            }
        }
        if (days >= daysOfYear) {
            monthAfter = i + 1
            dayAfter = daysOfYear - daysBefore
            break
        }
    }
    return (monthAfter, dayAfter)
}

/*
 * @noThrow
 */
func setDefault(num: Int64): Int64 {
    if (num == -1) {
        return 0
    }
    return num
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func addZeroPrefix(value: Int64, length: Int64): String {
    return value.toString().padStart(length, padding: "0")
}

struct DateTimeParser {
    var value: Array<Rune>
    var index: Int64 = 0
    var parseLen: Int64 = 0

    /*
     * @noThrow
     */
    init(value: Array<Rune>) {
        this.value = value
    }

    /*
     * @noThrow
     */
    func getLenToParse(): Int64 {
        return value.size - index
    }

    /*
     * @noThrow
     */
    func isEnd(): Bool {
        return this.index >= value.size
    }

    /*
     * @noThrow
     */
    func isEnough(): Bool {
        return this.index + this.parseLen <= value.size
    }

    /*
     * @noThrow
     */
    mut func move(len: Int64): Unit {
        this.index += len
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func get(offset: Int64): Rune {
        value[index + offset]
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseYear(value: Int64, length: Int64): Int64 {
        if (value != MAX_YEAR + 1) {
            throw TimeParseException("Extra year format.")
        }
        var isPositive = 1
        var parsedYear = 0
        if (!this.isEnd() && get(0) == r'-') {
            isPositive = -1
            this.move(1)
        }
        this.parseLen = if (length < 5 && length != 2) {
            4
        } else {
            length
        }
        if (this.getLenToParse() >= this.parseLen) {
            parsedYear = this.getInteger() 
            if (length == 2) { 
                if (parsedYear >= 69) {
                    parsedYear += 1900
                } else {
                    parsedYear += 2000
                }
            }
            this.move(this.parseLen)
            return isPositive * parsedYear
        } else {
            throw TimeParseException("Fail to parse at index ${index}: year value is not correct.")
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws TimeParseException
     */
    mut func parseMonth(value: Int64, length: Int64): Int64 {
        if (value != -1) {
            throw TimeParseException("Extra month format.")
        }
        var parsedMonth = match (length) {
            case 1 => parseExtraInteger(length)
            case 2 => parseInteger(length)
            case 3 => matchValue(SHORT_MONTH_FORM)
            case _ => matchValue(LONG_MONTH_FORM) 
        }
        
        if (length > 2) {
            parsedMonth++
        }
        if (parsedMonth < 1 || parsedMonth > 12) {
            throw TimeParseException("Month value must be in [1, 12].")
        }
        this.move(this.parseLen)
        return parsedMonth
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws TimeParseException
     */
    mut func parseDayOfWeek(value: Int64, length: Int64): Int64 {
        if (value != -1) {
            throw TimeParseException("Extra dayOfWeek format.")
        }
        let parsedWeek = match (length) {
            case 1 => parseExtraInteger(length)
            case 2 => parseInteger(length)
            case 3 => matchValue(SHORT_DAY_OF_WEEK_FORM) 
            case _ => matchValue(LONG_DAY_OF_WEEK_FORM) 
        }
        this.move(this.parseLen)
        return parsedWeek
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws TimeParseException
     */
    mut func matchValue(formats: Array<String>): Int64 {
        let val = String(value.slice(this.index, this.getLenToParse()))
        for (i in 0..formats.size) {
            var v = formats[i]
            let restValue = val.removePrefix(v)
            if (val.size > restValue.size) {
                this.parseLen = v.size
                return i
            }
        }
        throw TimeParseException("Fail to parse dayOfWeek or month.")
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws TimeParseException
     */
    mut func parseEra(value: Bool, length: Int64): Unit {
        if (value) {
            throw TimeParseException("Extra era value.")
        }
        let size = match (length) {
            case 1 => 1 
            case 2 => 2 
            case _ => 11 
        }
        if (this.getLenToParse() < size) {
            throw TimeParseException("Illegal era value.")
        }
        let str = String(this.value.slice(index, size))
        if (!(str == "A" || str == "AD" || str == "Anno Domini")) {
            throw TimeParseException("Illegal era value.")
        }
        this.move(size)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseDayOfMonth(value: Int64, length: Int64): Int64 {
        if (value != -1) {
            throw TimeParseException("Extra dayOfMonth format.")
        }
        let parsedMonth = parseExtraInteger(length)
        this.move(this.parseLen)
        return parsedMonth
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseDayOfYear(value: Int64): Int64 {
        if (value != -1) {
            throw TimeParseException("Extra dayOfYear format.")
        }
        if (this.isEnd()) {
            throw TimeParseException("No dayOfYear value to match.")
        }
        var len = this.getLenToParse()
        if (len > 3) {
            len = 3
        }
        var res = 0
        var pos = -1
        for (i in index..index + len) {
            var character = this.value[i]
            if (character.isAsciiNumber()) {
                res = res * 10 + Int64(UInt32(character) - UInt32(r'0'))
                pos++
            } else {
                if (pos == -1) {
                    throw TimeParseException("Fail to parse at index ${i}: dayOfYear value should be integer.")
                }
                break
            }
        }
        if (res == 0) {
            throw TimeParseException("Day of year can not be equal to 0.")
        }
        this.move(pos + 1)
        return res
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseISOWeek(value: Int64, length: Int64): Int64 {
        if (value != 0) {
            throw TimeParseException("Extra isoWeek format.")
        }
        let isoWeek = parseExtraInteger(length)
        this.move(this.parseLen)
        return isoWeek
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseHourIn12(value: Int64, length: Int64): Int64 {
        if (value != -1) {
            throw TimeParseException("Extra hour format.")
        }
        let hour = parseExtraInteger(length)
        if (hour > 12 || hour == 0) {
            throw TimeParseException("Hour value in format \"hh\" must be in [1, 12].")
        }
        this.move(this.parseLen)
        return hour
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseHourIn24(value: Int64, length: Int64): Int64 {
        if (value != -1) {
            throw TimeParseException("Extra hour format.")
        }
        let hour = parseExtraInteger(length)
        if (hour > 23) {
            throw TimeParseException("Hour value in format \"HH\" must be in [0, 23].")
        }
        this.move(this.parseLen)
        return hour
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseMinute(value: Int64, length: Int64): Int64 {
        if (value != -1) {
            throw TimeParseException("Extra minute format.")
        }
        let minute = parseExtraInteger(length)
        if (minute > 59) {
            throw TimeParseException("Minute value must be in [0, 59].")
        }
        this.move(this.parseLen)
        return minute
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseSecond(value: Int64, length: Int64, isRFC3339: Bool): (Int64, Int64) {
        if (value != -1) {
            throw TimeParseException("Extra second format.")
        }
        let second = parseExtraInteger(length)
        if (second > 59) {
            throw TimeParseException("Second value must be in [0, 59].")
        }
        this.move(this.parseLen)
        if (isRFC3339 && this.getLenToParse() > 2 && this.get(0) == r'.') {
            let nanosecond = parseSecFraction(9)
            this.move(this.parseLen + 1)
            return (second, nanosecond)
        }
        return (second, -1)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseNanosecond(value: Int64, length: Int64): Int64 {
        if (value != -1) {
            throw TimeParseException("Extra nanosecond format.")
        }
        var nanosecond = parseInteger(length * 3)
        
        nanosecond = nanosecond * (10 ** UInt64(9 - this.parseLen))
        this.move(this.parseLen)
        return nanosecond
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseOffset(value: Int64, length: Int64): Int64 {
        if (value != MAX_OFFSET + 1) {
            throw TimeParseException("Extra zone offset format.")
        }
        if (length < 4) {
            var len = 3 * length - 1
            if (this.getLenToParse() < len + 1) {
                throw TimeParseException("Illegal zone offset value.")
            }
            return parseOffsetDate(length)
        }
        checkOffsetLength(1)
        if (this.get(0) == r'Z') {
            this.move(1)
            return 0
        }
        if (this.getLenToParse() < 6) {
            throw TimeParseException("Illegal zone offset value.")
        } else if (this.getLenToParse() < 9) {
            return parseOffset(value, 2)
        } else {
            if (this.get(6) == r':' && this.get(7).isAsciiNumber() && this.get(8).isAsciiNumber()) {
                return parseOffset(value, 3)
            }
        }
        return parseOffset(value, 2)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseOffsetDate(length: Int64): Int64 {
        var isPositive: Int64
        match (this.get(0)) {
            case r'+' => isPositive = 1
            case r'-' => isPositive = -1
            case _ => throw TimeParseException("Zone offset should start with \"+\" or \"-\".")
        }
        this.move(1)
        var times = length
        this.parseLen = 2
        var offset = 0
        var seconds = SECS_PER_HOUR
        while (times > 0) {
            let num = getInteger()
            let loopTimes = length - times
            if (loopTimes == 0 && ((isPositive == 1 && num > 25) || (isPositive == -1 && num > 24))) {
                throw TimeParseException("The hour in offset should be in [-24, 25].")
            } else if (loopTimes > 0 && num > 59) {
                throw TimeParseException("The minute or second in offset should be in [0, 59].")
            }
            times--
            offset += num * seconds
            seconds /= 60
            this.move(2)
            if (times == 0) {
                break
            }
            if (this.get(0) != r':') {
                throw TimeParseException("Fail to parse at index ${this.index}: \"${value[index]}\" should be \":\".")
            }
            this.move(1)
        }
        return offset * isPositive
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseAmPm(flag: Int64): Int64 {
        if (flag != 0) {
            throw TimeParseException("Extra AM/PM value.")
        }
        var apmFlag: Int64
        if (this.getLenToParse() < 2) {
            throw TimeParseException("Illegal AM/PM value.")
        }
        if (value[index] == r'A' && value[index + 1] == r'M') {
            apmFlag = 1
        } else if (value[index] == r'P' && value[index + 1] == r'M') {
            apmFlag = 2
        } else {
            throw TimeParseException("Illegal AM/PM value.")
        }
        this.move(2)
        return apmFlag
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws TimeParseException
     */
    mut func parseZoneInfo(value: String, length: Int64): String {
        if (value != "") {
            throw TimeParseException("Extra zone id format.")
        }
        return match (length) {
            case 4 => parseZoneId()
            case _ => parseZoneName()
        }
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    mut func parseZoneId(): String {
        var slash = false
        for (i in this.index..this.value.size) {
            var character = value[i]
            if (character.isAsciiLetter() || (!slash && character == r'/') || character >= r'A' || character == r'_') {
                if (character == r'/') {
                    slash = true
                }
            } else {
                let parsedLen = i - this.index
                let zoneId = String(this.value.slice(this.index, parsedLen))
                this.move(parsedLen)
                return zoneId
            }
        }
        let zoneId = String(this.value.slice(this.index, this.getLenToParse()))
        this.index = this.value.size
        return zoneId
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    mut func parseZoneName(): String {
        for (i in this.index..this.value.size) {
            if (!value[i].isAsciiUpperCase()) {
                let parsedLen = i - this.index
                let zoneName = String(this.value.slice(this.index, parsedLen))
                this.move(parsedLen)
                return zoneName
            }
        }
        let zoneName = String(this.value.slice(this.index, this.getLenToParse()))
        this.index = this.value.size
        return zoneName
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseGMTOffset(value: Int64, length: Int64): Int64 {
        if (value != MAX_OFFSET + 1) {
            throw TimeParseException("Extra zone offset format.")
        }
        checkOffsetLength(5)
        if (this.get(0) == r'G' && this.get(1) == r'M' && this.get(2) == r'T') {
            this.move(3)
        } else {
            throw TimeParseException("Illegal offset form.")
        }
        if (length == 1) {
            var isPositive = 0
            match (this.get(0)) {
                case r'+' => isPositive = 1
                case r'-' => isPositive = -1
                case _ => throw TimeParseException("Zone offset should start with \"+\" or \"-\".")
            }
            this.move(1)
            if (this.getLenToParse() > 1 && this.get(0).isAsciiNumber() && this.get(1).isAsciiNumber()) {
                this.parseLen = 2
                let zoneOffset = getInteger() * SECS_PER_HOUR * isPositive
                this.move(parseLen)
                return zoneOffset
            } else if (this.getLenToParse() > 0 && this.get(0).isAsciiNumber()) {
                this.parseLen = 1
                let zoneOffset = getInteger() * SECS_PER_HOUR * isPositive
                this.move(parseLen)
                return zoneOffset
            } else {
                throw TimeParseException("Illegal offset form.")
            }
        }
        parseOffset(value, length)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func checkSeperator(r: Rune): Unit {
        if (isEnd()) {
            throw TimeParseException("No value to match \"${r}\".")
        }
        if (r != this.get(0)) {
            throw TimeParseException("Fail to parse at index ${index}: \"${value[index]}\" should be \"${r}\".")
        }
        this.move(1)
    }

    /*
     * @throws TimeParseException
     */
    func checkEnd(): Unit {
        if (!isEnd()) {
            throw TimeParseException("Extar value, start at index ${this.index}.")
        }
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    func getInteger(): Int64 {
        var res = 0
        for (i in this.index..this.index + this.parseLen) {
            let character = value[i]
            if (character.isAsciiNumber()) {
                res = res * 10 + Int64(UInt32(character) - UInt32(r'0'))
            } else {
                throw TimeParseException("Fail to parse at index ${i}: \"${value[i]}\" should be integer.")
            }
        }
        return res
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseExtraInteger(length: Int64): Int64 {
        return match (length) {
            case 1 =>
                if (this.getLenToParse() > 1 && this.get(1).isAsciiNumber()) {
                    parseInteger(2)
                } else {
                    parseInteger(1)
                }
            case _ => parseInteger(2)
        }
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseInteger(length: Int64): Int64 {
        this.parseLen = length
        if (!isEnough()) {
            throw TimeParseException("Fail to parse at index ${index}: insufficient remaining length.")
        }
        return getInteger()
    }

    
    /*
     * @throws IndexOutOfBoundsException
     * @throws TimeParseException
     */
    mut func parseSecFraction(length: Int64): Int64 {
        let len = if (this.getLenToParse() < length) {
            this.getLenToParse()
        } else {
            length
        }
        var numLen = len
        var nano = 0
        let start = this.index + 1
        for (i in start..start + len) {
            if (value[i].isAsciiNumber()) {
                nano = nano * 10 + Int64(UInt32(value[i]) - UInt32(r'0'))
            } else {
                numLen = i - start
                break
            }
        }
        if (numLen == 0) {
            throw TimeParseException("Lack of nanosecond value.")
        }
        this.parseLen = numLen
        return nano * 10 ** UInt64(9 - numLen)
    }

    /*
     * @throws TimeParseException
     */
    func checkOffsetLength(n: Int64): Unit {
        if (this.getLenToParse() < n) {
            throw TimeParseException("Illegal zone offset value.")
        }
    }
}
