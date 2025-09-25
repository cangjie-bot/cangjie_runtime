









package std.database.sql




public interface Statement <: Resource {




    prop parameterColumnInfos: Array<ColumnInfo>



    func setOption(key: String, value: String): Unit






    @Deprecated[message: "Use memeber funcation `func update(): UpdateResult` instead."]
    func update(params: Array<SqlDbType>): UpdateResult





    @Deprecated[message: "Use memeber funcation `func query(): QueryResult` instead."]
    func query(params: Array<SqlDbType>): QueryResult

    @When[backend == "cjnative"]
    func set<T>(index: Int64, value: T): Unit

    func setNull(index: Int64): Unit

    func update(): UpdateResult

    func query(): QueryResult
}
