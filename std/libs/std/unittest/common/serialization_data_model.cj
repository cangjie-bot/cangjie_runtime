










package std.unittest.common

import std.collection.ArrayList


                         /*
                          * @noThrow
                          */
protected abstract class DataModel {}


                /*
                 * @noThrow
                 */
protected class DataModelNull <: DataModel {}


protected class DataModelBool <: DataModel {

    
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
}


protected class DataModelInt <: DataModel {

    
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
}


protected class DataModelFloat <: DataModel {

    
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
}


protected class DataModelString <: DataModel {

    
    private var value: String







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
}


protected class DataModelSeq <: DataModel {

    
    private var items: ArrayList<DataModel>





    /*
     * @noThrow
     */
    public init() {
        items = ArrayList<DataModel>()
    }







    /*
     * @noThrow
     */
    public init(list: ArrayList<DataModel>) {
        items = list
    }






    /*
     * @noThrow
     */
    public func getItems(): ArrayList<DataModel> {
        return items
    }






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(dm: DataModel) {
        items.add(dm)
    }
}


protected class DataModelStruct <: DataModel {

    
    private var fields: ArrayList<Field>





    /*
     * @noThrow
     */
    public init() {
        fields = ArrayList<Field>()
    }







    /*
     * @noThrow
     */
    public init(list: ArrayList<Field>) {
        fields = list
    }






    /*
     * @noThrow
     */
    public func getFields(): ArrayList<Field> {
        return fields
    }







    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(fie: Field): DataModelStruct {
        let key = fie.getName()
        for (field in fields) {
            if (field.getName() == key) {
                field.data = fie.data
                return this
            }
        }
        this.fields.add(fie)
        return this
    }







    /*
     * @noThrow
     */
    public func get(key: String): DataModel {
        for (fie in fields) {
            if (fie.getName() == key) {
                return fie.getData()
            }
        }
        return DataModelNull()
    }
}


protected class Field {

    
    private var name: String

    
    var data: DataModel









    /*
     * @noThrow
     */
    public init(name: String, data: DataModel) {
        this.name = name
        this.data = data
    }






    /*
     * @noThrow
     */
    public func getName(): String {
        return name
    }






    /*
     * @noThrow
     */
    public func getData(): DataModel {
        return data
    }
}






/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func createDataModelSeq<T>(list: Collection<T>): DataModelSeq where T <: Serializable<T> {
    let dms: ArrayList<DataModel> = ArrayList<DataModel>(list.size)
    for (i in list) {
        dms.add(i.serializeInternal())
    }
    return DataModelSeq(dms)
}









/*
 * @noThrow
 */
protected func field<T>(name: String, data: T): Field where T <: Serializable<T> {
    return Field(name, data.serializeInternal())
}




protected class DataModelException <: Exception {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "DataModelException"
    }
}
