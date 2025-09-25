






protected package std.unittest.mock.internal



public class IllegalMockCallException <: Exception {
    /*
     * @throws IllegalArgumentException
     */
    public init() {
        super("Mock functions shouldn't be called in the runtime-error mocking mode " +
            "or inside non-frozen generic functions")
    }
}


public class NoDefaultValueForMockException <: Exception {
    /*
     * @throws IllegalArgumentException
     */
    public init(typeName: String, defaultValueForStubInterfaceName: String) {
        super("No provided default value for a return type `${typeName}`. "
            + "Make sure such type implements `${defaultValueForStubInterfaceName}<${typeName}>` interface")
    }
}


public class MockReturnValueTypeMismatchException <: Exception {
    /*
     * @throws IllegalArgumentException
     */
    public init(declarationReturnTypeName: String) {
        super("Type of the stub's return value doesn't match the corresponding declaration's return type. "
            + "Please make sure that type in stub is `${declarationReturnTypeName}`")
    }
}

public class UninitializedStaticCallHandler <: Exception {
    /*
     * @noThrow
     */
    public init() {
        super("Call handler for static declarations should be initialized before its usage")
    }
}
