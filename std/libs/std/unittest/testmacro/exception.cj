






macro package std.unittest.testmacro


class MacroException <: Exception {
    public init(message: String) {
        super("macro failed to expand.\n" + message)
    }

    protected override func getClassName(): String {
        return "Test framework"
    }
}
