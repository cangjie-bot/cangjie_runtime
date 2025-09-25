









package std.unittest.common


protected enum JsonKind {
    JsNull | JsBool | JsInt | JsFloat | JsString | JsArray | JsObject
}


                         /*
                          * @noThrow
                          */
protected abstract class JsonValue <: ToString {








    /*
     * @noThrow
     */
    public func toString(): String








    /*
     * @noThrow
     */
    public func toJsonString(): String










    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws JsonException
     */
    public static func fromStr(s: String): JsonValue {
        parseString(s)
    }






    /*
     * @noThrow
     */
    public func kind(): JsonKind








    /*
     * @throws JsonException
     */
    public func asNull(): JsonNull {
        match (this) {
            case jsonNull: JsonNull => jsonNull
            case _ => throw JsonException("Fail to convert to JsonNull")
        }
    }








    /*
     * @throws JsonException
     */
    public func asBool(): JsonBool {
        match (this) {
            case jsonBool: JsonBool => jsonBool
            case _ => throw JsonException("Fail to convert to JsonBool")
        }
    }








    /*
     * @throws JsonException
     */
    public func asInt(): JsonInt {
        match (this) {
            case jsonInt: JsonInt => jsonInt
            case _ => throw JsonException("Fail to convert to JsonInt")
        }
    }








    /*
     * @throws JsonException
     */
    public func asFloat(): JsonFloat {
        match (this) {
            case jsonFloat: JsonFloat => jsonFloat
            case jsonInt: JsonInt => JsonFloat(jsonInt.getValue())
            case _ => throw JsonException("Fail to convert to JsonFloat")
        }
    }








    /*
     * @throws JsonException
     */
    public func asString(): JsonString {
        match (this) {
            case jsonString: JsonString => jsonString
            case _ => throw JsonException("Fail to convert to JsonString")
        }
    }








    /*
     * @throws JsonException
     */
    public func asArray(): JsonArray {
        match (this) {
            case jsonArray: JsonArray => jsonArray
            case _ => throw JsonException("Fail to convert to JsonArray")
        }
    }








    /*
     * @throws JsonException
     */
    public func asObject(): JsonObject {
        match (this) {
            case jsonObject: JsonObject => jsonObject
            case _ => throw JsonException("Fail to convert to JsonObject")
        }
    }
}
