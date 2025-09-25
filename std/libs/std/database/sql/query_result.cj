










package std.database.sql




public interface QueryResult <: Resource {




    prop columnInfos: Array<ColumnInfo>







    @Deprecated[message: "Use memeber funcation `func next(): Bool` instead."]
    func next(values: Array<SqlDbType>): Bool

    func next(): Bool

    @When[backend == "cjnative"]
    func get<T>(index: Int64): T

    @When[backend == "cjnative"]
    func getOrNull<T>(index: Int64): ?T
}
