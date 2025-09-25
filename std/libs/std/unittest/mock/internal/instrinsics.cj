






protected package std.unittest.mock.internal

@Frozen
@Intrinsic
/*
 * @noThrow
 */
public unsafe func createMock<T>(handler: CallHandler): T

@Frozen
@Intrinsic
/*
 * @noThrow
 */
public unsafe func createSpy<T>(handler: CallHandler, objectToSpyOn: T): T
