







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
    public init(v: String) {
        _value = v
    }
    public mut prop value: String {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlChar"
        }
    }
}




@Deprecated[message: "Use `?String` instead."]
public class SqlNullableChar <: SqlNullableDbType {
    var _value: ?String
    public init(v: ?String) {
        _value = v
    }
    public mut prop value: ?String {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableChar"
        }
    }
}




@Deprecated[message: "Use `String` instead."]
public class SqlVarchar <: SqlDbType {
    var _value: String
    public init(v: String) {
        _value = v
    }
    public mut prop value: String {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlVarchar"
        }
    }
}




@Deprecated[message: "Use `?String` instead."]
public class SqlNullableVarchar <: SqlNullableDbType {
    var _value: ?String
    public init(v: ?String) {
        _value = v
    }
    public mut prop value: ?String {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableVarchar"
        }
    }
}




@Deprecated[message: "Use `Array<Byte>` instead."]
public class SqlBinary <: SqlDbType {
    var _value: Array<Byte>
    public init(v: Array<Byte>) {
        _value = v
    }
    public mut prop value: Array<Byte> {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlBinary"
        }
    }
}




@Deprecated[message: "Use `?Array<Byte>` instead."]
public class SqlNullableBinary <: SqlNullableDbType {
    var _value: ?Array<Byte>
    public init(v: ?Array<Byte>) {
        _value = v
    }
    public mut prop value: ?Array<Byte> {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableBinary"
        }
    }
}




@Deprecated[message: "Use `Array<Byte>` instead."]
public class SqlVarBinary <: SqlDbType {
    var _value: Array<Byte>
    public init(v: Array<Byte>) {
        _value = v
    }
    public mut prop value: Array<Byte> {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlVarBinary"
        }
    }
}




@Deprecated[message: "Use `?Array<Byte>` instead."]
public class SqlNullableVarBinary <: SqlNullableDbType {
    var _value: ?Array<Byte>
    public init(v: ?Array<Byte>) {
        _value = v
    }
    public mut prop value: ?Array<Byte> {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableVarBinary"
        }
    }
}




@Deprecated[message: "Use `InputStream` instead."]
public class SqlClob <: SqlDbType {
    var _value: InputStream
    public init(v: InputStream) {
        _value = v
    }
    public mut prop value: InputStream {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlClob"
        }
    }
}




@Deprecated[message: "Use `?InputStream` instead."]
public class SqlNullableClob <: SqlNullableDbType {
    var _value: ?InputStream
    public init(v: ?InputStream) {
        _value = v
    }
    public mut prop value: ?InputStream {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableClob"
        }
    }
}




@Deprecated[message: "Use `InputStream` instead."]
public class SqlBlob <: SqlDbType {
    var _value: InputStream
    public init(v: InputStream) {
        _value = v
    }
    public mut prop value: InputStream {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlBlob"
        }
    }
}




@Deprecated[message: "Use `?InputStream` instead."]
public class SqlNullableBlob <: SqlNullableDbType {
    var _value: ?InputStream
    public init(v: ?InputStream) {
        _value = v
    }
    public mut prop value: ?InputStream {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableBlob"
        }
    }
}




@Deprecated[message: "Use `Bool` instead."]
public class SqlBool <: SqlDbType {
    var _value: Bool
    public init(v: Bool) {
        _value = v
    }
    public mut prop value: Bool {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlBool"
        }
    }
}




@Deprecated[message: "Use `?Bool` instead."]
public class SqlNullableBool <: SqlNullableDbType {
    var _value: ?Bool
    public init(v: ?Bool) {
        _value = v
    }
    public mut prop value: ?Bool {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableBool"
        }
    }
}




@Deprecated[message: "Use `Int8` instead."]
public class SqlByte <: SqlDbType {
    var _value: Int8
    public init(v: Int8) {
        _value = v
    }
    public mut prop value: Int8 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlByte"
        }
    }
}




@Deprecated[message: "Use `?Int8` instead."]
public class SqlNullableByte <: SqlNullableDbType {
    var _value: ?Int8
    public init(v: ?Int8) {
        _value = v
    }
    public mut prop value: ?Int8 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableByte"
        }
    }
}




@Deprecated[message: "Use `Int16` instead."]
public class SqlSmallInt <: SqlDbType {
    var _value: Int16
    public init(v: Int16) {
        _value = v
    }
    public mut prop value: Int16 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlSmallInt"
        }
    }
}




@Deprecated[message: "Use `?Int16` instead."]
public class SqlNullableSmallInt <: SqlNullableDbType {
    var _value: ?Int16
    public init(v: ?Int16) {
        _value = v
    }
    public mut prop value: ?Int16 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableSmallInt"
        }
    }
}




@Deprecated[message: "Use `Int32` instead."]
public class SqlInteger <: SqlDbType {
    var _value: Int32
    public init(v: Int32) {
        _value = v
    }
    public mut prop value: Int32 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlInteger"
        }
    }
}




@Deprecated[message: "Use `?Int32` instead."]
public class SqlNullableInteger <: SqlNullableDbType {
    var _value: ?Int32
    public init(v: ?Int32) {
        _value = v
    }
    public mut prop value: ?Int32 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableInteger"
        }
    }
}




@Deprecated[message: "Use `Int64` instead."]
public class SqlBigInt <: SqlDbType {
    var _value: Int64
    public init(v: Int64) {
        _value = v
    }
    public mut prop value: Int64 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlBigInt"
        }
    }
}




@Deprecated[message: "Use `?Int64` instead."]
public class SqlNullableBigInt <: SqlNullableDbType {
    var _value: ?Int64
    public init(v: ?Int64) {
        _value = v
    }
    public mut prop value: ?Int64 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableBigInt"
        }
    }
}




@Deprecated[message: "Use `Float32` instead."]
public class SqlReal <: SqlDbType {
    var _value: Float32
    public init(v: Float32) {
        _value = v
    }
    public mut prop value: Float32 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlReal"
        }
    }
}




@Deprecated[message: "Use `?Float32` instead."]
public class SqlNullableReal <: SqlNullableDbType {
    var _value: ?Float32
    public init(v: ?Float32) {
        _value = v
    }
    public mut prop value: ?Float32 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableReal"
        }
    }
}




@Deprecated[message: "Use `Float64` instead."]
public class SqlDouble <: SqlDbType {
    var _value: Float64
    public init(v: Float64) {
        _value = v
    }
    public mut prop value: Float64 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlDouble"
        }
    }
}




@Deprecated[message: "Use `?Float64` instead."]
public class SqlNullableDouble <: SqlNullableDbType {
    var _value: ?Float64
    public init(v: ?Float64) {
        _value = v
    }
    public mut prop value: ?Float64 {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableDouble"
        }
    }
}




@Deprecated[message: "Use `DateTime` instead."]
public class SqlDate <: SqlDbType {
    var _value: DateTime
    public init(v: DateTime) {
        _value = v
    }
    public mut prop value: DateTime {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlDate"
        }
    }
}




@Deprecated[message: "Use `?DateTime` instead."]
public class SqlNullableDate <: SqlNullableDbType {
    var _value: ?DateTime
    public init(v: ?DateTime) {
        _value = v
    }
    public mut prop value: ?DateTime {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableDate"
        }
    }
}




@Deprecated[message: "Use `DateTime` instead."]
public class SqlTime <: SqlDbType {
    var _value: DateTime
    public init(v: DateTime) {
        _value = v
    }
    public mut prop value: DateTime {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlTime"
        }
    }
}




@Deprecated[message: "Use `?DateTime` instead."]
public class SqlNullableTime <: SqlNullableDbType {
    var _value: ?DateTime
    public init(v: ?DateTime) {
        _value = v
    }
    public mut prop value: ?DateTime {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableTime"
        }
    }
}




@Deprecated[message: "Use `DateTime` instead."]
public class SqlTimeTz <: SqlDbType {
    var _value: DateTime
    public init(v: DateTime) {
        _value = v
    }
    public mut prop value: DateTime {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlTimeTz"
        }
    }
}




@Deprecated[message: "Use `?DateTime` instead."]
public class SqlNullableTimeTz <: SqlNullableDbType {
    var _value: ?DateTime
    public init(v: ?DateTime) {
        _value = v
    }
    public mut prop value: ?DateTime {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableTimeTz"
        }
    }
}




@Deprecated[message: "Use `DateTime` instead."]
public class SqlTimestamp <: SqlDbType {
    var _value: DateTime
    public init(v: DateTime) {
        _value = v
    }
    public mut prop value: DateTime {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlTimestamp"
        }
    }
}




@Deprecated[message: "Use `?DateTime` instead."]
public class SqlNullableTimestamp <: SqlNullableDbType {
    var _value: ?DateTime
    public init(v: ?DateTime) {
        _value = v
    }
    public mut prop value: ?DateTime {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableTimestamp"
        }
    }
}




@Deprecated[message: "Use `Duration` instead."]
public class SqlInterval <: SqlDbType {
    var _value: Duration
    public init(v: Duration) {
        _value = v
    }
    public mut prop value: Duration {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlInterval"
        }
    }
}




@Deprecated[message: "Use `?Duration` instead."]
public class SqlNullableInterval <: SqlNullableDbType {
    var _value: ?Duration
    public init(v: ?Duration) {
        _value = v
    }
    public mut prop value: ?Duration {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableInterval"
        }
    }
}




@Deprecated[message: "Use `Decimal` instead."]
public class SqlDecimal <: SqlDbType {
    var _value: Decimal
    public init(v: Decimal) {
        _value = v
    }
    public mut prop value: Decimal {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlDecimal"
        }
    }
}




@Deprecated[message: "Use `?Decimal` instead."]
public class SqlNullableDecimal <: SqlNullableDbType {
    var _value: ?Decimal
    public init(v: ?Decimal) {
        _value = v
    }
    public mut prop value: ?Decimal {
        get() {
            return _value
        }
        set(value) {
            _value = value
        }
    }
    public prop name: String {
        get() {
            "SqlNullableDecimal"
        }
    }
}
