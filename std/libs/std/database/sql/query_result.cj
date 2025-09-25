










package std.database.sql




public interface QueryResult <: Resource {




    prop columnInfos: Array<ColumnInfo>







    @Deprecated[message: "Use memeber funcation `func next(): Bool` instead."]
    /*
     * @noThrow
     */
    func next(values: Array<SqlDbType>): Bool

    /*
     * @noThrow
     */
    func next(): Bool

    @When[backend == "cjnative"]
    /*
     * @noThrow
     */
    func get<T>(index: Int64): T

    @When[backend == "cjnative"]
    /*
     * @noThrow
     */
    func getOrNull<T>(index: Int64): ?T
}
