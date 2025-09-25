









package std.unittest.common

import std.collection.*


const SPACE: Rune = r' '


const INDENT_SIZE: Int64 = 2


                /*
                 * @noThrow
                 */
protected class JsonNull <: JsonValue {






    /*
     * @noThrow
     */
    public func kind(): JsonKind {
        return JsNull
    }






    /*
     * @noThrow
     */
    public func toString(): String {
        return "null"
    }






    /*
     * @noThrow
     */
    public func toJsonString(): String {
        return toString()
    }
}


protected class JsonBool <: JsonValue {
    
    private var value: Bool







    /*
     * @noThrow
     */
    public init(bv: Bool) {
        this.value = bv
    }






    /*
     * @noThrow
     */
    public func getValue(): Bool {
        return value
    }






    /*
     * @noThrow
     */
    public func kind(): JsonKind {
        return JsBool
    }






    /*
     * @noThrow
     */
    public func toString(): String {
        return value.toString()
    }






    /*
     * @noThrow
     */
    public func toJsonString(): String {
        return toString()
    }
}


protected class JsonInt <: JsonValue {
    
    private var value: Int64







    /*
     * @noThrow
     */
    public init(iv: Int64) {
        this.value = iv
    }






    /*
     * @noThrow
     */
    public func getValue(): Int64 {
        return value
    }






    /*
     * @noThrow
     */
    public func kind(): JsonKind {
        return JsInt
    }






    /*
     * @noThrow
     */
    public func toString(): String {
        return value.toString()
    }






    /*
     * @noThrow
     */
    public func toJsonString(): String {
        return toString()
    }
}


protected class JsonFloat <: JsonValue {
    
    private var value: Float64







    /*
     * @noThrow
     */
    public init(fv: Float64) {
        this.value = fv
    }







    /*
     * @noThrow
     */
    public init(v: Int64) {
        this.value = Float64(v)
    }






    /*
     * @noThrow
     */
    public func getValue(): Float64 {
        return value
    }






    /*
     * @noThrow
     */
    public func kind(): JsonKind {
        return JsFloat
    }






    /*
     * @noThrow
     */
    public func toString(): String {
        return value.toString()
    }






    /*
     * @noThrow
     */
    public func toJsonString(): String {
        return toString()
    }
}


protected class JsonString <: JsonValue {
    
    var value: String







    /*
     * @noThrow
     */
    public init(sv: String) {
        this.value = sv
    }






    /*
     * @noThrow
     */
    public func getValue(): String {
        return value
    }






    /*
     * @noThrow
     */
    public func kind(): JsonKind {
        return JsString
    }






    /*
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let buff = WriteBuffer(value.size + 2)
        jsonWriteWithoutFormat(this, buff)
        return unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
    }






    /*
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toJsonString(): String {
        let buff = WriteBuffer(value.size + 2)
        jsonWriteWithoutFormat(this, buff)
        return unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
    }
}


protected class JsonArray <: JsonValue {
    
    private var items: ArrayList<JsonValue>





    /*
     * @throws IllegalArgumentException
     */
    init(capacity: Int64) {
        items = ArrayList<JsonValue>(capacity)
    }

    /*
     * @noThrow
     */
    public init() {
        items = ArrayList<JsonValue>()
    }







    /*
     * @noThrow
     */
    public init(list: ArrayList<JsonValue>) {
        items = list
    }







    /*
     * @noThrow
     */
    public init(list: Array<JsonValue>) {
        items = ArrayList<JsonValue>(list)
    }






    /*
     * @noThrow
     */
    public func kind(): JsonKind {
        return JsArray
    }








    /*
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toJsonString(): String {
        return toJsonString(0)
    }









    /*
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toJsonString(depth: Int64, bracketInNewLine!: Bool = false, indent!: String = "  "): String {
        if (depth < 0) {
            throw IllegalArgumentException("Depth cannot be negative.")
        }
        if (!indent.isContainOnlySpaceAndTab()) {
            throw IllegalArgumentException("Indent must be an empty string or any combination of spaces and tabs.")
        }
        let buff = WriteBuffer(asumecapacity(this))
        jsonWriteArray(this, buff, depth, bracketInNewLine, indent)
        return unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
    }








    /*
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let buff = WriteBuffer(asumecapacity(this))
        jsonWriteWithoutFormat(this, buff)
        return unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
    }






    /*
     * @noThrow
     */
    public func size(): Int64 {
        return items.size
    }






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(jv: JsonValue): JsonArray {
        items.add(jv)
        return this
    }







    /*
     * @noThrow
     */
    public func get(index: Int64): Option<JsonValue> {
        return items.get(index)
    }









    /*
     * @throws JsonException
     */
    public operator func [](index: Int64): JsonValue {
        return match (items.get(index)) {
            case Some(v) => v
            case None => throw JsonException("The index ${index} of JsonArray does not exist.")
        }
    }






    /*
     * @noThrow
     */
    public func getItems(): ArrayList<JsonValue> {
        return items
    }
}


protected class JsonObject <: JsonValue {
    
    private var fields: HashMap<String, JsonValue>





    /*
     * @noThrow
     */
    public init() {
        fields = HashMap<String, JsonValue>()
    }

    /*
     * @throws IllegalArgumentException
     */
    init(capacity: Int64) {
        fields = HashMap<String, JsonValue>(capacity)
    }







    /*
     * @noThrow
     */
    public init(map: HashMap<String, JsonValue>) {
        fields = map
    }






    /*
     * @noThrow
     */
    public func kind(): JsonKind {
        return JsObject
    }








    /*
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toJsonString(): String {
        return toJsonString(0)
    }









    /*
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toJsonString(depth: Int64, bracketInNewLine!: Bool = false, indent!: String = "  "): String {
        if (depth < 0) {
            throw IllegalArgumentException("Depth cannot be negative.")
        }
        if (!indent.isContainOnlySpaceAndTab()) {
            throw IllegalArgumentException("Indent must be an empty string or any combination of spaces and tabs.")
        }
        let buff = WriteBuffer(asumecapacity(this))
        jsonWriteObject(this, buff, depth, bracketInNewLine, indent)
        return unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
    }








    /*
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let buff = WriteBuffer(asumecapacity(this))
        jsonWriteWithoutFormat(this, buff)
        return unsafe { String.fromUtf8Unchecked(buff.getAndClear()) }
    }






    /*
     * @noThrow
     */
    public func size(): Int64 {
        return fields.size
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    public func containsKey(key: String): Bool {
        return fields.contains(key)
    }







    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func put(key: String, v: JsonValue): Unit {
        fields.add(key, v)
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    public func get(key: String): Option<JsonValue> {
        return fields.get(key)
    }









    /*
     * @throws IndexOutOfBoundsException
     * @throws JsonException
     */
    public operator func [](key: String): JsonValue {
        return match (fields.get(key)) {
            case Some(v) => v
            case None => throw JsonException("The Value of JsonObject does not exist")
        }
    }






    /*
     * @noThrow
     */
    public func getFields(): HashMap<String, JsonValue> {
        return fields
    }
}

extend String {
    /*
     * @noThrow
     */
    func isContainOnlySpaceAndTab() {
        for (i in this) {
            if (i != b' ' && i != b'\t') {
                return false
            }
        }
        return true
    }
}
