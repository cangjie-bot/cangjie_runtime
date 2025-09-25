









package std.unittest.common


protected class JsonException <: Exception {




    /*
     * @noThrow
     */
    public init() {
        super()
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
        return "JsonException"
    }
}
