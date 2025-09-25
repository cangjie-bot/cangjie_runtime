










package std.database.sql




public interface Datasource <: Resource {




    func setOption(key: String, value: String): Unit






    func connect(): Connection
}
