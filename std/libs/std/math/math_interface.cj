










package std.math

@Deprecated[message: "Use `public interface FloatingPoint<T>` instead."]
public interface MathExtension<T> {
    /*
     * @noThrow
     */
    static func GetPI(): T
    /*
     * @noThrow
     */
    static func GetE(): T
}

public interface MaxMinValue<T> {
    /*
     * @noThrow
     */
    static func getMax(): T
    /*
     * @noThrow
     */
    static func getMin(): T
}

public interface Number<T> {
    /*
     * @noThrow
     */
    operator func +(rhs: T): T
    /*
     * @noThrow
     */
    operator func -(rhs: T): T
    /*
     * @noThrow
     */
    operator func *(rhs: T): T
    /*
     * @noThrow
     */
    operator func /(rhs: T): T
    /*
     * @noThrow
     */
    operator func -(): T
}

public interface Integer<T> <: Number<T> {
    /*
     * @noThrow
     */
    static func isSigned(): Bool

    /*
     * @noThrow
     */
    operator func %(rhs: T): T
    /*
     * @noThrow
     */
    operator func &(rhs: T): T
    /*
     * @noThrow
     */
    operator func |(rhs: T): T
    /*
     * @noThrow
     */
    operator func ^(rhs: T): T
    /*
     * @noThrow
     */
    operator func !(): T
    /*
     * @noThrow
     */
    operator func >>(n: Int64): T
    /*
     * @noThrow
     */
    operator func <<(n: Int64): T
}

public interface FloatingPoint<T> <: Number<T> {
    /*
     * @noThrow
     */
    static func getPI(): T
    /*
     * @noThrow
     */
    static func getE(): T
    /*
     * @noThrow
     */
    static func getNaN(): T
    /*
     * @noThrow
     */
    static func getInf(): T
    /*
     * @noThrow
     */
    static func getMinDenormal(): T
    /*
     * @noThrow
     */
    static func getMinNormal(): T

    /*
     * @noThrow
     */
    func isInf(): Bool
    /*
     * @noThrow
     */
    func isNaN(): Bool
    /*
     * @noThrow
     */
    func isNormal(): Bool
}
