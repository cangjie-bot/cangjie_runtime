










package std.database.sql




public interface Datasource <: Resource {




    /*
     * @noThrow
     */
    func setOption(key: String, value: String): Unit






    /*
     * @noThrow
     */
    func connect(): Connection
}
