









package std.unittest.common

import std.collection.*


protected interface Serializable<T> {






    func serializeInternal(): DataModel







    static func deserialize(dm: DataModel): T
}


extend Int64 <: Serializable<Int64> {






    public func serializeInternal(): DataModel {
        return DataModelInt(this)
    }









    public static func deserialize(dm: DataModel): Int64 {
        return match (dm) {
            case dmi: DataModelInt => dmi.getValue()
            case _ => throw DataModelException("this data is not DataModelInt")
        }
    }
}


extend Int32 <: Serializable<Int32> {






    public func serializeInternal(): DataModel {
        return DataModelInt(Int64(this))
    }









    public static func deserialize(dm: DataModel): Int32 {
        return match (dm) {
            case dmi: DataModelInt => Int32(dmi.getValue())
            case _ => throw DataModelException("this data is not DataModelInt")
        }
    }
}


extend Int16 <: Serializable<Int16> {






    public func serializeInternal(): DataModel {
        return DataModelInt(Int64(this))
    }









    public static func deserialize(dm: DataModel): Int16 {
        return match (dm) {
            case dmi: DataModelInt => Int16(dmi.getValue())
            case _ => throw DataModelException("this data is not DataModelInt")
        }
    }
}


extend Int8 <: Serializable<Int8> {






    public func serializeInternal(): DataModel {
        return DataModelInt(Int64(this))
    }









    public static func deserialize(dm: DataModel): Int8 {
        return match (dm) {
            case dmi: DataModelInt => Int8(dmi.getValue())
            case _ => throw DataModelException("this data is not DataModelInt")
        }
    }
}


extend UInt64 <: Serializable<UInt64> {






    public func serializeInternal(): DataModel {
        return DataModelInt(Int64(this))
    }









    public static func deserialize(dm: DataModel): UInt64 {
        return match (dm) {
            case dmi: DataModelInt => UInt64(dmi.getValue())
            case _ => throw DataModelException("this data is not DataModelInt")
        }
    }
}


extend UInt32 <: Serializable<UInt32> {






    public func serializeInternal(): DataModel {
        return DataModelInt(Int64(this))
    }









    public static func deserialize(dm: DataModel): UInt32 {
        return match (dm) {
            case dmi: DataModelInt => UInt32(dmi.getValue())
            case _ => throw DataModelException("this data is not DataModelInt")
        }
    }
}


extend UInt16 <: Serializable<UInt16> {






    public func serializeInternal(): DataModel {
        return DataModelInt(Int64(this))
    }









    public static func deserialize(dm: DataModel): UInt16 {
        return match (dm) {
            case dmi: DataModelInt => UInt16(dmi.getValue())
            case _ => throw DataModelException("this data is not DataModelInt")
        }
    }
}


extend UInt8 <: Serializable<UInt8> {






    public func serializeInternal(): DataModel {
        return DataModelInt(Int64(this))
    }









    public static func deserialize(dm: DataModel): UInt8 {
        return match (dm) {
            case dmi: DataModelInt => UInt8(dmi.getValue())
            case _ => throw DataModelException("this data is not DataModelInt")
        }
    }
}


extend Float64 <: Serializable<Float64> {






    public func serializeInternal(): DataModel {
        return DataModelFloat(this)
    }









    public static func deserialize(dm: DataModel): Float64 {
        return match (dm) {
            case dmf: DataModelFloat => dmf.getValue()
            case dmi: DataModelInt => Float64(dmi.getValue())
            case _ => throw DataModelException("this data is not DataModelFloat")
        }
    }
}


extend Float32 <: Serializable<Float32> {






    public func serializeInternal(): DataModel {
        return DataModelFloat(Float64(this))
    }









    public static func deserialize(dm: DataModel): Float32 {
        return match (dm) {
            case dmf: DataModelFloat => Float32(dmf.getValue())
            case _ => throw DataModelException("this data is not DataModelFloat")
        }
    }
}


extend Float16 <: Serializable<Float16> {






    public func serializeInternal(): DataModel {
        return DataModelFloat(Float64(this))
    }









    public static func deserialize(dm: DataModel): Float16 {
        return match (dm) {
            case dmf: DataModelFloat => Float16(dmf.getValue())
            case _ => throw DataModelException("this data is not DataModelFloat")
        }
    }
}


extend Bool <: Serializable<Bool> {






    public func serializeInternal(): DataModel {
        return DataModelBool(this)
    }









    public static func deserialize(dm: DataModel): Bool {
        return match (dm) {
            case dmb: DataModelBool => dmb.getValue()
            case _ => throw DataModelException("this data is not DataModelBool")
        }
    }
}


extend String <: Serializable<String> {






    public func serializeInternal(): DataModel {
        return DataModelString(this)
    }









    public static func deserialize(dm: DataModel): String {
        return match (dm) {
            case dms: DataModelString => dms.getValue()
            case _ => throw DataModelException("this data is not DataModelString")
        }
    }
}


extend Rune <: Serializable<Rune> {






    public func serializeInternal(): DataModel {
        return DataModelString(this.toString())
    }










    public static func deserialize(dm: DataModel): Rune {
        let charStr: String = match (dm) {
            case dms: DataModelString => dms.getValue()
            case _ => throw DataModelException("this data is not DataModelString")
        }
        if (charStr.toRuneArray().size != 1) {
            throw Exception("this data is not Rune")
        }
        return Rune(charStr[0])
    }
}


extend<T> Option<T> <: Serializable<Option<T>> where T <: Serializable<T> {






    public func serializeInternal(): DataModel {
        return match (this) {
            case Some(x) => x.serializeInternal()
            case None => DataModelNull()
        }
    }







    public static func deserialize(dm: DataModel): Option<T> {
        return match (dm) {
            case dmn: DataModelNull => Option<T>.None
            case _ => Option<T>.Some(T.deserialize(dm))
        }
    }
}


extend<T> Array<T> <: Serializable<Array<T>> where T <: Serializable<T> {






    public func serializeInternal(): DataModel {
        return createDataModelSeq<T>(this)
    }









    public static func deserialize(dm: DataModel): Array<T> {
        var data: ArrayList<DataModel> = match (dm) {
            case dms: DataModelSeq => dms.getItems()
            case _ => throw DataModelException("this data is not DataModelSeq")
        }
        let dataSize = data.size
        if (dataSize == 0) {
            return Array<T>()
        }
        let arr: Array<T> = Array<T>(dataSize, repeat: T.deserialize(data[0]))
        for (i in 1..dataSize) {
            arr[i] = T.deserialize(data[i])
        }
        return arr
    }
}


extend<T> ArrayList<T> <: Serializable<ArrayList<T>> where T <: Serializable<T> {






    public func serializeInternal(): DataModel {
        return createDataModelSeq<T>(this)
    }









    public static func deserialize(dm: DataModel): ArrayList<T> {
        var data: ArrayList<DataModel> = match (dm) {
            case dms: DataModelSeq => dms.getItems()
            case _ => throw DataModelException("this data is not DataModelSeq")
        }
        var arr: ArrayList<T> = ArrayList<T>()
        for (i in data) {
            arr.add(T.deserialize(i))
        }
        return arr
    }
}


extend<T> HashSet<T> <: Serializable<HashSet<T>> where T <: Serializable<T> & Hashable & Equatable<T> {






    public func serializeInternal(): DataModel {
        return createDataModelSeq<T>(this)
    }









    public static func deserialize(dm: DataModel): HashSet<T> {
        var data: DataModelSeq = match (dm) {
            case dms: DataModelSeq => dms
            case _ => throw DataModelException("this data is not DataModelSeq")
        }
        var arr: HashSet<T> = HashSet<T>()
        for (i in data.getItems()) {
            arr.add(T.deserialize(i))
        }
        return arr
    }
}


extend<K, V> HashMap<K, V> <: Serializable<HashMap<K, V>>
    where K <: Serializable<K> & Hashable & Equatable<K>, V <: Serializable<V> {








    public func serializeInternal(): DataModel {
        var dms: DataModelStruct = DataModelStruct()
        for ((k, v) in this) {
            match (k) {
                case k: String => dms.add(field<V>(k, v))
                case _ => throw DataModelException("this data is not String")
            }
        }
        return dms
    }









    public static func deserialize(dm: DataModel): HashMap<K, V> {
        var data: DataModelStruct = match (dm) {
            case dms: DataModelStruct => dms
            case _ => throw DataModelException("this data is not DataModelStruct")
        }
        var arr: HashMap<K, V> = HashMap<K, V>()
        for (i in data.getFields()) {
            match (i.getName()) {
                case k: K => arr.add(k, V.deserialize(i.getData()))
                case _ => throw DataModelException("this data is not String")
            }
        }
        return arr
    }
}
