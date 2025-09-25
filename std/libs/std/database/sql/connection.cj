










package std.database.sql

import std.collection.Map




public interface Connection <: Resource {




    prop state: ConnectionState




    func getMetaData(): Map<String, String>









    func prepareStatement(sql: String): Statement





    func createTransaction(): Transaction
}
