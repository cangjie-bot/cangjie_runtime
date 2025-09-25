






protected package std.unittest.mock.internal

import std.collection.*

public interface HasDefaultValueForStub<T> {
    /*
     * @noThrow
     */
    static func defaultValueForStub(): T
}

extend Unit <: HasDefaultValueForStub<Unit> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Unit { () }
}

extend Int8 <: HasDefaultValueForStub<Int8> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Int8 { 0 }
}

extend Int16 <: HasDefaultValueForStub<Int16> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Int16 { 0 }
}

extend Int32 <: HasDefaultValueForStub<Int32> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Int32 { 0 }
}

extend Int64 <: HasDefaultValueForStub<Int64> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Int64 { 0 }
}

extend Float16 <: HasDefaultValueForStub<Float16> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Float16 { 0.0 }
}

extend Float32 <: HasDefaultValueForStub<Float32> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Float32 { 0.0 }
}

extend Float64 <: HasDefaultValueForStub<Float64> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Float64 { 0.0 }
}

extend Bool <: HasDefaultValueForStub<Bool> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Bool { false }
}

extend String <: HasDefaultValueForStub<String> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): String { "" }
}

extend<T> Option<T> <: HasDefaultValueForStub<Option<T>> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Option<T> { Option<T>.None }
}

extend<T> Array<T> <: HasDefaultValueForStub<Array<T>> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): Array<T> { [] }
}

extend<T> ArrayList<T> <: HasDefaultValueForStub<ArrayList<T>> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): ArrayList<T> { ArrayList<T>() }
}

extend<T> HashSet<T> <: HasDefaultValueForStub<HashSet<T>> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): HashSet<T> { HashSet<T>() }
}

extend<K, V> HashMap<K, V> <: HasDefaultValueForStub<HashMap<K, V>> {
    /*
     * @noThrow
     */
    public static func defaultValueForStub(): HashMap<K, V> { HashMap<K, V>() }
}
