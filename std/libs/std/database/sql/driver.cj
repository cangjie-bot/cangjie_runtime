










package std.database.sql




public interface Driver {




    prop name: String




    prop version: String





    prop preferredPooling: Bool








    /*
     * @noThrow
     */
    func open(connectionString: String, opts: Array<(String, String)>): Datasource
}
