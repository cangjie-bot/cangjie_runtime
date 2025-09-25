










package std.database.sql




public open class SqlException <: Exception {
    var _sqlState = ""
    var _errorCode: Int64 = 0




    public prop sqlState: String {
        /*
         * @noThrow
         */
        get() {
            _sqlState
        }
    }




    public prop errorCode: Int64 {
        /*
         * @noThrow
         */
        get() {
            _errorCode
        }
    }

    public override prop message: String {
        /*
         * @throws IllegalArgumentException
         */
        get() {
            var msg = super.message
            if (msg != "") {
                msg += ", "
            }
            if (_sqlState != "") {
                msg += "SqlState: ${_sqlState}, "
            }
            msg += "errorCode: ${_errorCode}"
            msg
        }
    }




    /*
     * @noThrow
     */
    public init() {
        super()
    }








    /*
     * @noThrow
     */
    public init(message: String, sqlState: String, errorCode: Int64) {
        super(message)
        this._sqlState = sqlState
        this._errorCode = errorCode
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
        return "SqlException"
    }
}
