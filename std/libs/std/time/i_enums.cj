










package std.time


let SHORT_DAY_OF_WEEK_FORM = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
let LONG_DAY_OF_WEEK_FORM = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

public enum DayOfWeek <: ToString & Equatable<DayOfWeek> {
    Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday









    public static func of(dayOfWeek: Int64): DayOfWeek {
        return match (dayOfWeek) {
            case 0 => Sunday
            case 1 => Monday
            case 2 => Tuesday
            case 3 => Wednesday
            case 4 => Thursday
            case 5 => Friday
            case 6 => Saturday
            case _ => throw IllegalArgumentException("The input parameter ranges from 0 to 6")
        }
    }






    @Deprecated[message: "Use member function `public func toInteger(): Int64` instead."]
    public func value(): Int64 {
        toInteger()
    }

    public func toInteger(): Int64 {
        return match (this) {
            case Sunday => 0
            case Monday => 1
            case Tuesday => 2
            case Wednesday => 3
            case Thursday => 4
            case Friday => 5
            case Saturday => 6
        }
    }






    public func toString(): String {
        return LONG_DAY_OF_WEEK_FORM[this.toInteger()]
    }







    public operator func ==(r: DayOfWeek): Bool {
        return this.toInteger() == r.toInteger()
    }







    public operator func !=(r: DayOfWeek): Bool {
        return this.toInteger() != r.toInteger()
    }

    public operator func +(n: Int64): DayOfWeek {
        return DayOfWeek.of((this.toInteger() + n % DAYS_PER_WEEK + DAYS_PER_WEEK) % DAYS_PER_WEEK)
    }

    public operator func -(n: Int64): DayOfWeek {
        return DayOfWeek.of((this.toInteger() - n % DAYS_PER_WEEK + DAYS_PER_WEEK) % DAYS_PER_WEEK)
    }
}

let SHORT_MONTH_FORM = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                        "Aug", "Sep", "Oct", "Nov", "Dec"]
let LONG_MONTH_FORM = ["January", "February", "March", "April", "May", "June", "July",
                       "August", "September", "October", "November", "December"]

public enum Month <: ToString & Equatable<Month> {
    January | February | March | April | May | June
    | July | August | September | October | November | December









    public static func of(mon: Int64): Month {
        return match (mon) {
            case 1 => January
            case 2 => February
            case 3 => March
            case 4 => April
            case 5 => May
            case 6 => June
            case 7 => July
            case 8 => August
            case 9 => September
            case 10 => October
            case 11 => November
            case 12 => December
            case _ => throw IllegalArgumentException("The input parameter ranges from 1 to 12")
        }
    }






    @Deprecated[message: "Use member function `public func toInteger(): Int64` instead."]
    public func value(): Int64 {
        toInteger()
    }

    public func toInteger(): Int64 {
        return match (this) {
            case January => 1
            case February => 2
            case March => 3
            case April => 4
            case May => 5
            case June => 6
            case July => 7
            case August => 8
            case September => 9
            case October => 10
            case November => 11
            case December => 12
        }
    }






    public func toString(): String {
        return LONG_MONTH_FORM[this.toInteger() - 1]
    }






    public operator func +(n: Int64): Month {
        return Month.of((this.toInteger() - 1 + n % MONTHS_PER_YEAR + MONTHS_PER_YEAR) % MONTHS_PER_YEAR + 1)
    }






    public operator func -(n: Int64): Month {
        return Month.of((this.toInteger() - 1 - n % MONTHS_PER_YEAR + MONTHS_PER_YEAR) % MONTHS_PER_YEAR + 1)
    }







    public operator func ==(r: Month): Bool {
        return this.toInteger() == r.toInteger()
    }







    public operator func !=(r: Month): Bool {
        return this.toInteger() != r.toInteger()
    }
}
