







package std.math.numeric

import std.convert.*

extend Decimal <: Parsable<Decimal> {
    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func parse(value: String): Decimal {
        return Decimal(value)
    }

    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func tryParse(value: String): ?Decimal {
        try {
            parse(value)
        } catch (e: Exception) {
            return None
        }
    }
}

extend Decimal <: Formattable {
    /*
     * @throws ArithmeticException
     * @throws PrecisionMismatchException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     */
    public func format(fmt: String): String {
        return this.toFloat64().format(fmt)
    }
}
