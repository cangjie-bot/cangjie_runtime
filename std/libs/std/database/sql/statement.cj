









package std.database.sql




public interface Statement <: Resource {




    prop parameterColumnInfos: Array<ColumnInfo>



    /*
     * @noThrow
     */
    func setOption(key: String, value: String): Unit






    @Deprecated[message: "Use memeber funcation `func update(): UpdateResult` instead."]
    /*
     * @noThrow
     */
    func update(params: Array<SqlDbType>): UpdateResult





    @Deprecated[message: "Use memeber funcation `func query(): QueryResult` instead."]
    /*
     * @noThrow
     */
    func query(params: Array<SqlDbType>): QueryResult

    @When[backend == "cjnative"]
    /*
     * @noThrow
     */
    func set<T>(index: Int64, value: T): Unit

    /*
     * @noThrow
     */
    func setNull(index: Int64): Unit

    /*
     * @noThrow
     */
    func update(): UpdateResult

    /*
     * @noThrow
     */
    func query(): QueryResult
}
