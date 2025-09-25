






macro package std.unittest.testmacro


class MacroException <: Exception {
    /*
     * @throws IllegalArgumentException
     */
    public init(message: String) {
        super("macro failed to expand.\n" + message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "Test framework"
    }
}
