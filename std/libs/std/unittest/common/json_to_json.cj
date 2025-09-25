









package std.unittest.common

import std.collection.*


protected interface ToJson {








    func toJson(): JsonValue









    static func fromJson(jv: JsonValue): DataModel
}


extend DataModel <: ToJson {









    public static func fromJson(jv: JsonValue): DataModel {
        match (jv) {
            case jb: JsonBool => DataModelBool(jb.getValue())
            case ji: JsonInt => DataModelInt(ji.getValue())
            case jf: JsonFloat => DataModelFloat(jf.getValue())
            case js: JsonString => DataModelString(js.getValue())
            case ja: JsonArray => buildDMSeq(ja)
            case jo: JsonObject => buildDMStruct(jo)
            case _: JsonNull => DataModelNull()
            case _ => throw IllegalStateException()
        }
    }




    private static func buildDMSeq(ja: JsonArray): DataModelSeq {
        let dms: DataModelSeq = DataModelSeq()
        let list: ArrayList<DataModel> = dms.getItems()
        let ji = ja.getItems()
        for (i in 0..ji.size) {
            list.add(fromJson(ji[i]))
        }
        return dms
    }




    private static func buildDMStruct(jo: JsonObject): DataModelStruct {
        let dms: DataModelStruct = DataModelStruct()
        let list: ArrayList<Field> = dms.getFields()
        let map: HashMap<String, JsonValue> = jo.getFields()
        for ((str, jv) in map) {
            var dm: DataModel = fromJson(jv)
            var field: Field = Field(str, dm)
            list.add(field)
        }
        return dms
    }








    public func toJson(): JsonValue {
        match (this) {
            case _: DataModelNull => return JsonNull()
            case dmb: DataModelBool => return JsonBool(dmb.getValue())
            case dmi: DataModelInt => return JsonInt(dmi.getValue())
            case dmf: DataModelFloat => return JsonFloat(dmf.getValue())
            case dmstr: DataModelString => return JsonString(dmstr.getValue())
            case dmseq: DataModelSeq => return toJson(dmseq)
            case dms: DataModelStruct => return toJson(dms)
            case _ => throw JsonException("Unmatched DataModel type!")
        }
    }




    private func toJson(dmseq: DataModelSeq): JsonArray {
        let ji = dmseq.getItems()
        let jv: JsonArray = JsonArray(ji.size)
        for (i in 0..ji.size) {
            jv.add(ji[i].toJson())
        }
        return jv
    }




    private func toJson(dms: DataModelStruct): JsonObject {
        let ji = dms.getFields()
        let jo: JsonObject = JsonObject(ji.size)
        for (i in 0..ji.size) {
            let fie = ji[i]
            let value: JsonValue = fie.getData().toJson()
            jo.put(fie.getName(), value)
        }
        return jo
    }
}
