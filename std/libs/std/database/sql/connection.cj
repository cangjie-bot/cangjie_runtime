










package std.database.sql

import std.collection.Map




public interface Connection <: Resource {




    prop state: ConnectionState




    /*
     * @noThrow
     */
    func getMetaData(): Map<String, String>









    /*
     * @noThrow
     */
    func prepareStatement(sql: String): Statement





    /*
     * @noThrow
     */
    func createTransaction(): Transaction
}
