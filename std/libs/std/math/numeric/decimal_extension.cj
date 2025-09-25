







package std.math.numeric

import std.convert.*

extend Decimal <: Parsable<Decimal> {
    public static func parse(value: String): Decimal {
        return Decimal(value)
    }

    public static func tryParse(value: String): ?Decimal {
        try {
            parse(value)
        } catch (e: Exception) {
            return None
        }
    }
}

extend Decimal <: Formattable {
    public func format(fmt: String): String {
        return this.toFloat64().format(fmt)
    }
}
