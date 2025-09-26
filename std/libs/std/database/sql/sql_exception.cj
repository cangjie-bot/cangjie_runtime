










package std.database.sql




public open class SqlException <: Exception {
    var _sqlState = ""
    var _errorCode: Int64 = 0




    public prop sqlState: String {
        get() {
            _sqlState
        }
    }




    public prop errorCode: Int64 {
        get() {
            _errorCode
        }
    }

        /**
         * @throws IllegalArgumentException
         */
    public override prop message: String {
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




    public init() {
        super()
    }








    public init(message: String, sqlState: String, errorCode: Int64) {
        super(message)
        this._sqlState = sqlState
        this._errorCode = errorCode
    }






    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "SqlException"
    }
}
