







package std.database.sql

import std.io.InputStream
import std.math.numeric.Decimal
import std.time.DateTime





@Deprecated
public interface SqlDbType {
    prop name: String
}




@Deprecated
public interface SqlNullableDbType <: SqlDbType {}




@Deprecated[message: "Use `String` instead."]
public class SqlChar <: SqlDbType {
    var _value: String
    /*
     * @noThrow
     */
    public init(v: String) {
        _value = v
    }
    public mut prop value: String {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlChar"
        }
    }
}




@Deprecated[message: "Use `?String` instead."]
public class SqlNullableChar <: SqlNullableDbType {
    var _value: ?String
    /*
     * @noThrow
     */
    public init(v: ?String) {
        _value = v
    }
    public mut prop value: ?String {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableChar"
        }
    }
}




@Deprecated[message: "Use `String` instead."]
public class SqlVarchar <: SqlDbType {
    var _value: String
    /*
     * @noThrow
     */
    public init(v: String) {
        _value = v
    }
    public mut prop value: String {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlVarchar"
        }
    }
}




@Deprecated[message: "Use `?String` instead."]
public class SqlNullableVarchar <: SqlNullableDbType {
    var _value: ?String
    /*
     * @noThrow
     */
    public init(v: ?String) {
        _value = v
    }
    public mut prop value: ?String {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableVarchar"
        }
    }
}




@Deprecated[message: "Use `Array<Byte>` instead."]
public class SqlBinary <: SqlDbType {
    var _value: Array<Byte>
    /*
     * @noThrow
     */
    public init(v: Array<Byte>) {
        _value = v
    }
    public mut prop value: Array<Byte> {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlBinary"
        }
    }
}




@Deprecated[message: "Use `?Array<Byte>` instead."]
public class SqlNullableBinary <: SqlNullableDbType {
    var _value: ?Array<Byte>
    /*
     * @noThrow
     */
    public init(v: ?Array<Byte>) {
        _value = v
    }
    public mut prop value: ?Array<Byte> {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableBinary"
        }
    }
}




@Deprecated[message: "Use `Array<Byte>` instead."]
public class SqlVarBinary <: SqlDbType {
    var _value: Array<Byte>
    /*
     * @noThrow
     */
    public init(v: Array<Byte>) {
        _value = v
    }
    public mut prop value: Array<Byte> {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlVarBinary"
        }
    }
}




@Deprecated[message: "Use `?Array<Byte>` instead."]
public class SqlNullableVarBinary <: SqlNullableDbType {
    var _value: ?Array<Byte>
    /*
     * @noThrow
     */
    public init(v: ?Array<Byte>) {
        _value = v
    }
    public mut prop value: ?Array<Byte> {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableVarBinary"
        }
    }
}




@Deprecated[message: "Use `InputStream` instead."]
public class SqlClob <: SqlDbType {
    var _value: InputStream
    /*
     * @noThrow
     */
    public init(v: InputStream) {
        _value = v
    }
    public mut prop value: InputStream {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlClob"
        }
    }
}




@Deprecated[message: "Use `?InputStream` instead."]
public class SqlNullableClob <: SqlNullableDbType {
    var _value: ?InputStream
    /*
     * @noThrow
     */
    public init(v: ?InputStream) {
        _value = v
    }
    public mut prop value: ?InputStream {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableClob"
        }
    }
}




@Deprecated[message: "Use `InputStream` instead."]
public class SqlBlob <: SqlDbType {
    var _value: InputStream
    /*
     * @noThrow
     */
    public init(v: InputStream) {
        _value = v
    }
    public mut prop value: InputStream {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlBlob"
        }
    }
}




@Deprecated[message: "Use `?InputStream` instead."]
public class SqlNullableBlob <: SqlNullableDbType {
    var _value: ?InputStream
    /*
     * @noThrow
     */
    public init(v: ?InputStream) {
        _value = v
    }
    public mut prop value: ?InputStream {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableBlob"
        }
    }
}




@Deprecated[message: "Use `Bool` instead."]
public class SqlBool <: SqlDbType {
    var _value: Bool
    /*
     * @noThrow
     */
    public init(v: Bool) {
        _value = v
    }
    public mut prop value: Bool {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlBool"
        }
    }
}




@Deprecated[message: "Use `?Bool` instead."]
public class SqlNullableBool <: SqlNullableDbType {
    var _value: ?Bool
    /*
     * @noThrow
     */
    public init(v: ?Bool) {
        _value = v
    }
    public mut prop value: ?Bool {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableBool"
        }
    }
}




@Deprecated[message: "Use `Int8` instead."]
public class SqlByte <: SqlDbType {
    var _value: Int8
    /*
     * @noThrow
     */
    public init(v: Int8) {
        _value = v
    }
    public mut prop value: Int8 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlByte"
        }
    }
}




@Deprecated[message: "Use `?Int8` instead."]
public class SqlNullableByte <: SqlNullableDbType {
    var _value: ?Int8
    /*
     * @noThrow
     */
    public init(v: ?Int8) {
        _value = v
    }
    public mut prop value: ?Int8 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableByte"
        }
    }
}




@Deprecated[message: "Use `Int16` instead."]
public class SqlSmallInt <: SqlDbType {
    var _value: Int16
    /*
     * @noThrow
     */
    public init(v: Int16) {
        _value = v
    }
    public mut prop value: Int16 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlSmallInt"
        }
    }
}




@Deprecated[message: "Use `?Int16` instead."]
public class SqlNullableSmallInt <: SqlNullableDbType {
    var _value: ?Int16
    /*
     * @noThrow
     */
    public init(v: ?Int16) {
        _value = v
    }
    public mut prop value: ?Int16 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableSmallInt"
        }
    }
}




@Deprecated[message: "Use `Int32` instead."]
public class SqlInteger <: SqlDbType {
    var _value: Int32
    /*
     * @noThrow
     */
    public init(v: Int32) {
        _value = v
    }
    public mut prop value: Int32 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlInteger"
        }
    }
}




@Deprecated[message: "Use `?Int32` instead."]
public class SqlNullableInteger <: SqlNullableDbType {
    var _value: ?Int32
    /*
     * @noThrow
     */
    public init(v: ?Int32) {
        _value = v
    }
    public mut prop value: ?Int32 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableInteger"
        }
    }
}




@Deprecated[message: "Use `Int64` instead."]
public class SqlBigInt <: SqlDbType {
    var _value: Int64
    /*
     * @noThrow
     */
    public init(v: Int64) {
        _value = v
    }
    public mut prop value: Int64 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlBigInt"
        }
    }
}




@Deprecated[message: "Use `?Int64` instead."]
public class SqlNullableBigInt <: SqlNullableDbType {
    var _value: ?Int64
    /*
     * @noThrow
     */
    public init(v: ?Int64) {
        _value = v
    }
    public mut prop value: ?Int64 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableBigInt"
        }
    }
}




@Deprecated[message: "Use `Float32` instead."]
public class SqlReal <: SqlDbType {
    var _value: Float32
    /*
     * @noThrow
     */
    public init(v: Float32) {
        _value = v
    }
    public mut prop value: Float32 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlReal"
        }
    }
}




@Deprecated[message: "Use `?Float32` instead."]
public class SqlNullableReal <: SqlNullableDbType {
    var _value: ?Float32
    /*
     * @noThrow
     */
    public init(v: ?Float32) {
        _value = v
    }
    public mut prop value: ?Float32 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableReal"
        }
    }
}




@Deprecated[message: "Use `Float64` instead."]
public class SqlDouble <: SqlDbType {
    var _value: Float64
    /*
     * @noThrow
     */
    public init(v: Float64) {
        _value = v
    }
    public mut prop value: Float64 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlDouble"
        }
    }
}




@Deprecated[message: "Use `?Float64` instead."]
public class SqlNullableDouble <: SqlNullableDbType {
    var _value: ?Float64
    /*
     * @noThrow
     */
    public init(v: ?Float64) {
        _value = v
    }
    public mut prop value: ?Float64 {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableDouble"
        }
    }
}




@Deprecated[message: "Use `DateTime` instead."]
public class SqlDate <: SqlDbType {
    var _value: DateTime
    /*
     * @noThrow
     */
    public init(v: DateTime) {
        _value = v
    }
    public mut prop value: DateTime {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlDate"
        }
    }
}




@Deprecated[message: "Use `?DateTime` instead."]
public class SqlNullableDate <: SqlNullableDbType {
    var _value: ?DateTime
    /*
     * @noThrow
     */
    public init(v: ?DateTime) {
        _value = v
    }
    public mut prop value: ?DateTime {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableDate"
        }
    }
}




@Deprecated[message: "Use `DateTime` instead."]
public class SqlTime <: SqlDbType {
    var _value: DateTime
    /*
     * @noThrow
     */
    public init(v: DateTime) {
        _value = v
    }
    public mut prop value: DateTime {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlTime"
        }
    }
}




@Deprecated[message: "Use `?DateTime` instead."]
public class SqlNullableTime <: SqlNullableDbType {
    var _value: ?DateTime
    /*
     * @noThrow
     */
    public init(v: ?DateTime) {
        _value = v
    }
    public mut prop value: ?DateTime {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableTime"
        }
    }
}




@Deprecated[message: "Use `DateTime` instead."]
public class SqlTimeTz <: SqlDbType {
    var _value: DateTime
    /*
     * @noThrow
     */
    public init(v: DateTime) {
        _value = v
    }
    public mut prop value: DateTime {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlTimeTz"
        }
    }
}




@Deprecated[message: "Use `?DateTime` instead."]
public class SqlNullableTimeTz <: SqlNullableDbType {
    var _value: ?DateTime
    /*
     * @noThrow
     */
    public init(v: ?DateTime) {
        _value = v
    }
    public mut prop value: ?DateTime {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableTimeTz"
        }
    }
}




@Deprecated[message: "Use `DateTime` instead."]
public class SqlTimestamp <: SqlDbType {
    var _value: DateTime
    /*
     * @noThrow
     */
    public init(v: DateTime) {
        _value = v
    }
    public mut prop value: DateTime {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlTimestamp"
        }
    }
}




@Deprecated[message: "Use `?DateTime` instead."]
public class SqlNullableTimestamp <: SqlNullableDbType {
    var _value: ?DateTime
    /*
     * @noThrow
     */
    public init(v: ?DateTime) {
        _value = v
    }
    public mut prop value: ?DateTime {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableTimestamp"
        }
    }
}




@Deprecated[message: "Use `Duration` instead."]
public class SqlInterval <: SqlDbType {
    var _value: Duration
    /*
     * @noThrow
     */
    public init(v: Duration) {
        _value = v
    }
    public mut prop value: Duration {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlInterval"
        }
    }
}




@Deprecated[message: "Use `?Duration` instead."]
public class SqlNullableInterval <: SqlNullableDbType {
    var _value: ?Duration
    /*
     * @noThrow
     */
    public init(v: ?Duration) {
        _value = v
    }
    public mut prop value: ?Duration {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableInterval"
        }
    }
}




@Deprecated[message: "Use `Decimal` instead."]
public class SqlDecimal <: SqlDbType {
    var _value: Decimal
    /*
     * @noThrow
     */
    public init(v: Decimal) {
        _value = v
    }
    public mut prop value: Decimal {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlDecimal"
        }
    }
}




@Deprecated[message: "Use `?Decimal` instead."]
public class SqlNullableDecimal <: SqlNullableDbType {
    var _value: ?Decimal
    /*
     * @noThrow
     */
    public init(v: ?Decimal) {
        _value = v
    }
    public mut prop value: ?Decimal {
        /*
         * @noThrow
         */
        get() {
            return _value
        }
        /*
         * @noThrow
         */
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "SqlNullableDecimal"
        }
    }
}
