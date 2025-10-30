# std.core



## Function Introduction



The core package is the core package of the standard library, providing some basic API capabilities suitable for programming in the Cangjie language.



It provides built-in types (signed integers, unsigned integers, floating-point types, etc.), common functions (print, println, eprint, etc.), common interfaces (ToString, Hashable, Equatable, Collection, etc.), common classes and structs (Array, String, Range, etc.), and common exception classes (Error, Exception and some of their subclasses).



> **Note:**
>
> The core package does not need to be explicitly imported; it is imported by default.



## API List



### Functions



| Function Name | Functionality |

| ------------ | ------------ |

| [acquireArrayRawData(Array\<T>) where T <: CType](./core_package_api/core_package_funcs.md#func-acquirearrayrawdatatarrayt-where-t--ctype) | Obtain the raw pointer instance of the data in Array\<T>, where T needs to satisfy the CType constraint. |

| [alignOf\<T>() where T <: CType](./core_package_api/core_package_funcs.md#func-alignoft-where-t--ctype) | Get the memory alignment value of type T. |

| [eprint(String, Bool)](./core_package_api/core_package_funcs.md#func-eprintstring-bool) | Print the specified string to the standard error text stream. |

| [eprintln(String)](./core_package_api/core_package_funcs.md#func-eprintlnstring) | Print the specified string to the standard error text stream, with a newline added at the end. |

| [eprint\<T>(T, Bool) where T <: ToString](./core_package_api/core_package_funcs.md#func-eprinttt-bool-where-t--tostring) | Print the string representation of the specified T type instance to the standard error text stream. |

| [eprintln\<T>(T) where T <: ToString](./core_package_api/core_package_funcs.md#func-eprintlntt-where-t--tostring) | Print the string representation of the specified T type instance to the standard error text stream, with a newline added at the end. |

| [ifNone(Option\<T>, () -> Unit)](./core_package_api/core_package_funcs.md#func-ifnonetoptiont----unit) | Execute the action function if the input is data of type Option.None. |

| [ifSome(Option\<T>, (T) -> Unit)](./core_package_api/core_package_funcs.md#func-ifsometoptiont-t---unit) | Execute the action function if the input is data of type Option.Some. |

| [max\<T>(T, T, Array\<T>) where T <: Comparable\<T>](./core_package_api/core_package_funcs.md#func-maxtt-t-arrayt-where-t--comparablet) | Get the maximum value in a set of data |

| [min\<T>(T, T, Array\<T>) where T <: Comparable\<T>](./core_package_api/core_package_funcs.md#func-mintt-t-arrayt-where-t--comparablet) | Get the minimum value in a set of data |

| [print(Bool, Bool)](./core_package_api/core_package_funcs.md#func-printbool-bool) | Output the string representation of Bool type data to the console. |

| [print(Float16, Bool)](./core_package_api/core_package_funcs.md#func-printfloat16-bool) | Output the string representation of Float16 type data to the console. |

| [print(Float32, Bool)](./core_package_api/core_package_funcs.md#func-printfloat32-bool) | Output the string representation of Float32 type data to the console. |

| [print(Float64, Bool)](./core_package_api/core_package_funcs.md#func-printfloat64-bool) | Output the string representation of Float64 type data to the console. |

| [print(Int16, Bool)](./core_package_api/core_package_funcs.md#func-printint16-bool) | Output the string representation of Int16 type data to the console. |

| [print(Int32, Bool)](./core_package_api/core_package_funcs.md#func-printint32-bool) | Output the string representation of Int32 type data to the console. |

| [print(Int64, Bool)](./core_package_api/core_package_funcs.md#func-printint64-bool) | Output the string representation of Int64 type data to the console. |

| [print(Int8, Bool)](./core_package_api/core_package_funcs.md#func-printint8-bool) | Output the string representation of Int8 type data to the console. |

| [print(Rune, Bool)](./core_package_api/core_package_funcs.md#func-printrune-bool) | Output the string representation of Rune type data to the console. |

| [print(String, Bool)](./core_package_api/core_package_funcs.md#func-printstring-bool) | Output the specified string to the console. |

| [print(UInt16, Bool)](./core_package_api/core_package_funcs.md#func-printuint16-bool) | Output the string representation of UInt16 type data to the console. |

| [print(UInt32, Bool)](./core_package_api/core_package_funcs.md#func-printuint32-bool) | Output the string representation of UInt32 type data to the console. |

| [print(UInt64, Bool)](./core_package_api/core_package_funcs.md#func-printuint64-bool) | Output the string representation of UInt64 type data to the console. |

| [print(UInt8, Bool)](./core_package_api/core_package_funcs.md#func-printuint8-bool) | Output the string representation of UInt8 type data to the console. |

| [print\<T>(T, Bool) where T <: ToString](./core_package_api/core_package_funcs.md#func-printtt-bool-where-t--tostring) | Output the string representation of the T type instance to the console. |

| [println()](./core_package_api/core_package_funcs.md#func-println) | Output a newline character to the standard output (stdout). |

| [println(Bool)](./core_package_api/core_package_funcs.md#func-printlnbool) | Output the string representation of Bool type data to the console, with a newline added at the end. |

| [println(Float16)](./core_package_api/core_package_funcs.md#func-printlnfloat16) | Output the string representation of Float16 type data to the console, with a newline added at the end. |

| [println(Float32)](./core_package_api/core_package_funcs.md#func-printlnfloat32) | Output the string representation of Float32 type data to the console, with a newline added at the end. |

| [println(Float64)](./core_package_api/core_package_funcs.md#func-printlnfloat64) | Output the string representation of Float64 type data to the console, with a newline added at the end. |

| [println(Int16)](./core_package_api/core_package_funcs.md#func-printlnint16) | Output the string representation of Int16 type data to the console, with a newline added at the end. |

| [println(Int32)](./core_package_api/core_package_funcs.md#func-printlnint32) | Output the string representation of Int32 type data to the console, with a newline added at the end. |

| [println(Int64)](./core_package_api/core_package_funcs.md#func-printlnint64) | Output the string representation of Int64 type data to the console, with a newline added at the end. |

| [println(Int8)](./core_package_api/core_package_funcs.md#func-printlnint8) | Output the string representation of Int8 type data to the console, with a newline added at the end. |

| [println(Rune)](./core_package_api/core_package_funcs.md#func-printlnrune) | Output the string representation of Rune type data to the console, with a newline added at the end. |

| [println(String)](./core_package_api/core_package_funcs.md#func-printlnstring) | Output the specified string to the console, with a newline added at the end. |

| [println(UInt16)](./core_package_api/core_package_funcs.md#func-printlnuint16) | Output the string representation of UInt16 type data to the console, with a newline added at the end. |

| [println(UInt32)](./core_package_api/core_package_funcs.md#func-printlnuint32) | Output the string representation of UInt32 type data to the console, with a newline added at the end. |

| [println(UInt64)](./core_package_api/core_package_funcs.md#func-printlnuint64) | Output the string representation of UInt64 type data to the console, with a newline added at the end. |

| [println(UInt8)](./core_package_api/core_package_funcs.md#func-printlnuint8) | Output the string representation of UInt8 type data to the console, with a newline added at the end. |

| [println\<T>(T) where T <: ToString](./core_package_api/core_package_funcs.md#func-printlntt-where-t--tostring) | Output the string representation of the `T` type instance to the console, with a newline added at the end. |

| [readln()](./core_package_api/core_package_funcs.md#func-readln) | Accept console input until a newline or EOF is encountered. |

| [refEq(Object, Object)](./core_package_api/core_package_funcs.md#func-refeqobject-object) | Determine whether the memory addresses of two Object instances are the same. |

| [releaseArrayRawData(CPointerHandle\<T>) where T <: CType](./core_package_api/core_package_funcs.md#func-releasearrayrawdatatcpointerhandlet-where-t--ctype) | Release the raw pointer instance, which is obtained through acquireArrayRawData. |

| [sizeOf\<T>() where T <: CType](./core_package_api/core_package_funcs.md#func-sizeoft-where-t--ctype) | Get the memory space size occupied by type T. |

| [sleep(Duration)](./core_package_api/core_package_funcs.md#func-sleepduration) | Put the current thread to sleep. |

| [zeroValue\<T>()](./core_package_api/core_package_funcs.md#func-zerovaluet) | Get a T type instance that has been fully zero-initialized. |



### Type Aliases



| Type Alias | Functionality |

| ------------ | ------------ |

| [Byte](./core_package_api/core_package_types.md#type-byte) | The `Byte` type is an alias of the built-in type `UInt8`. |

| [Int](./core_package_api/core_package_types.md#type-int) | The `Int` type is an alias of the built-in type `Int64`. |

| [UInt](./core_package_api/core_package_types.md#type-uint) | The `UInt` type is an alias of the built-in type `UInt64`. |



### Built-in Types



| Built-in Type Name | Functionality |

| ------------ | ------------ |

| [Int8](./core_package_api/core_package_intrinsics.md#int8) | Represents an 8-bit signed integer, with a range of [-2^7, 2^7 - 1]. |

| [Int16](./core_package_api/core_package_intrinsics.md#int16) | Represents a 16-bit signed integer, with a range of [-2^15, 2^15 - 1]. |

| [Int32](./core_package_api/core_package_intrinsics.md#int32) | Represents a 32-bit signed integer, with a range of [-2^31, 2^31 - 1]. |

| [Int64](./core_package_api/core_package_intrinsics.md#int64) | Represents a 64-bit signed integer, with a range of [-2^63, 2^63 - 1]. |

| [IntNative](./core_package_api/core_package_intrinsics.md#intnative) | Represents a platform-dependent signed integer, whose length is consistent with the bit width of the current system. |

| [UInt8](./core_package_api/core_package_intrinsics.md#uint8) | Represents an 8-bit unsigned integer, with a range of [0 ~ 2^8 - 1]. |

| [UInt16](./core_package_api/core_package_intrinsics.md#uint16) | Represents a 16-bit unsigned integer, with a range of [0 ~ 2^16 - 1]. |

| [UInt32](./core_package_api/core_package_intrinsics.md#uint32) | Represents a 32-bit unsigned integer, with a range of [0 ~ 2^32 - 1]. |

| [UInt64](./core_package_api/core_package_intrinsics.md#uint64) | Represents a 64-bit unsigned integer, with a range of [0 ~ 2^64 - 1]. |

| [UIntNative](./core_package_api/core_package_intrinsics.md#uintnative) | Represents a platform-dependent unsigned integer, whose length is consistent with the bit width of the current system. |

| [Float16](./core_package_api/core_package_intrinsics.md#float16) | Represents a 16-bit floating-point number, conforming to the half-precision format (`binary16`) in `IEEE 754`. |

| [Float32](./core_package_api/core_package_intrinsics.md#float32) | Represents a 32-bit floating-point number, conforming to the single-precision format (`binary32`) in `IEEE 754`. |

| [Float64](./core_package_api/core_package_intrinsics.md#float64) | Represents a 64-bit floating-point number, conforming to the double-precision format (`binary64`) in `IEEE 754`. |

| [Bool](./core_package_api/core_package_intrinsics.md#bool) | Represents a boolean type, with two values: `true` and `false`. |

| [Rune](./core_package_api/core_package_intrinsics.md#rune) | Represents a character in the Unicode character set. |

| [Unit](./core_package_api/core_package_intrinsics.md#unit) | Represents the type of expressions in the Cangjie language that only care about side effects and not values. |

| [CPointer\<T>](./core_package_api/core_package_intrinsics.md#cpointert) | Represents a pointer to an instance of type `T`, used in scenarios of interoperation with the C language, corresponding to `T*` in C. |

| [CString](./core_package_api/core_package_intrinsics.md#cstring) | Represents a C-style string, used in scenarios of interoperation with the C language. |



### Interfaces



| Interface Name | Functionality |

| ------------ | ------------ |

| [Any](./core_package_api/core_package_interfaces.md#interface-any) | `Any` is the parent type of all types; all `interface`s inherit it by default, and all non-`interface` types implement it by default. |

| [Hasher](./core_package_api/core_package_interfaces.md#interface-hasher) | This interface is used to handle hash combination operations. |

| [ThreadContext](./core_package_api/core_package_interfaces.md#interface-threadcontext) | Cangjie thread context interface. |

| [Countable\<T>](./core_package_api/core_package_interfaces.md#interface-countablet) | This interface indicates that the type is countable. |

| [Collection\<T>](./core_package_api/core_package_interfaces.md#interface-collectiont) | This interface is used to represent a collection; container types should usually implement this interface. |

| [Less\<T>](./core_package_api/core_package_interfaces.md#interface-lesst) | This interface represents less-than calculation. |

| [Greater\<T>](./core_package_api/core_package_interfaces.md#interface-greatert) | This interface represents greater-than calculation. |

| [LessOrEqual\<T>](./core_package_api/core_package_interfaces.md#interface-lessorequalt) | This interface represents less-than-or-equal-to calculation. |

| [GreaterOrEqual\<T>](./core_package_api/core_package_interfaces.md#interface-greaterorequalt) | This interface represents greater-than-or-equal-to calculation. |

| [Comparable\<T>](./core_package_api/core_package_interfaces.md#interface-comparablet) | This interface represents comparison operations, which is a collection of interfaces for equality, less-than, greater-than, less-than-or-equal-to, and greater-than-or-equal-to. |

| [Equal\<T>](./core_package_api/core_package_interfaces.md#interface-equalt) | This interface is used to support equality judgment operations. |

| [NotEqual\<T>](./core_package_api/core_package_interfaces.md#interface-notequalt) | This interface is used to support inequality judgment operations. |

| [Equatable\<T>](./core_package_api/core_package_interfaces.md#interface-equatablet) | This interface is a collection of the equality and inequality judgment interfaces. |

| [Hashable](./core_package_api/core_package_interfaces.md#interface-hashable) | This interface is used to calculate hash values. |

| [Iterable\<E>](./core_package_api/core_package_interfaces.md#interface-iterablee) | This interface represents iterability; types that implement this interface (usually container types) can be iterated in `for-in` statements, and can also obtain their corresponding iterator type instances and call the `next` function to implement iteration. |

| [Resource](./core_package_api/core_package_interfaces.md#interface-resource) | This interface is used for resource management, usually for closing and releasing resources such as memory and handles. |

| [ToString](./core_package_api/core_package_interfaces.md#interface-tostring) | This interface is used to provide a string representation of a specific type. |

| [CType](./core_package_api/core_package_interfaces.md#interface-ctype) | Represents an interface that supports interoperation with the C language. |



### Classes



| Class Name | Functionality |

| ------------ | ------------ |

| [ArrayIterator\<T>](./core_package_api/core_package_classes.md#class-arrayiteratort) | Array iterator; for details on iteration functionality, see the descriptions of the `Iterable` and `Iterator` interfaces. |

| [Box\<T>](./core_package_api/core_package_classes.md#class-boxt) | The `Box` type provides the ability to add a `class` wrapper layer to other types. |

| [Future\<T>](./core_package_api/core_package_classes.md#class-futuret) | A Future\<T> instance represents a Cangjie thread task, which can be used to obtain the calculation result of the Cangjie thread and send a cancellation signal to the Cangjie thread. |

| [Iterator\<T>](./core_package_api/core_package_classes.md#class-iteratort) | This class represents an iterator, providing a `next` method to support iterative traversal of members in a container. |

| [Object](./core_package_api/core_package_classes.md#class-object) | Construct an `object` instance. |

| [RangeIterator\<T> <: Iterator\<T> where T <: Countable\<T> \& Comparable\<T> \& Equatable\<T>](./core_package_api/core_package_classes.md#class-rangeiteratort--iteratort-where-t--countablet--comparablet--equatablet) | Iterator for the `Range` type; for details on iteration functionality, see the descriptions of the `Iterable` and `Iterator` interfaces. |

| [StackTraceElement](./core_package_api/core_package_classes.md#class-stacktraceelement) | Represents specific information of an exception stack, including the class name, function name, file name, and line number where the exception occurred. |

| [StringBuilder](./core_package_api/core_package_classes.md#class-stringbuilder) | This class is mainly used for string construction. |

| [Thread](./core_package_api/core_package_classes.md#class-thread) | The `Thread` class represents a Cangjie class, which can be used to obtain the thread ID and name, query whether the thread has a cancellation request, register a handler function for unhandled exceptions of the thread, etc. |

| [ThreadLocal\<T>](./core_package_api/core_package_classes.md#class-threadlocalt) | This class represents a Cangjie thread-local variable. |

| [ThreadSnapshot](./core_package_api/core_package_classes.) | This class is used to obtain information about the current thread or all threads, including name, id, state, and call stack. |



### Enums



| Enum Name | Functionality |

| ------------ | ------------ |

| [AnnotationKind](./core_package_api/core_package_enums.md#enum-annotationkind) | Indicates the positions that custom annotations expect to support. |

| [Endian](./core_package_api/core_package_enums.md#enum-endian) | The enum type Endian represents the endianness of the running platform, divided into big-endian and little-endian. |

| [Ordering](./core_package_api/core_package_enums.md#enum-ordering) | Ordering represents the result of a comparison, which includes three cases: less than, greater than, and equal to. |

| [Option\<T>](./core_package_api/core_package_enums.md#enum-optiont) | Option\<T> is a wrapper for the `T` type, indicating that there may or may not be a value. |

| [ThreadState](./core_package_api/core_package_enums.md#enum-threadstate) | ThreadState represents the state of a thread, which includes four states: waiting to execute, executing, suspended, and finished executing. |



### Structs



| Struct Name | Functionality |

| ------------ | ------------ |

| [Array\<T>](./core_package_api/core_package_structs.md#struct-arrayt) | Cangjie array type, used to represent an ordered sequence of elements of a single type. |

| [CPointerHandle\<T> where T <: CType](./core_package_api/core_package_structs.md#struct-cpointerhandlet-where-t--ctype) | Represents the raw pointer of an `Array` array; the generic parameter in this type should satisfy the `CType` constraint. |

| [CPointerResource\<T> where T <: CType](./core_package_api/core_package_structs.md#struct-cpointerresourcet-where-t--ctype) | This struct represents the resource management type corresponding to `CPointer`; its instance can be obtained through the member function `asResource` of `CPointer`. |

| [CStringResource](./core_package_api/core_package_structs.md#struct-cstringresource) | This struct represents the resource management type corresponding to `CString`; its instance can be obtained through the member function `asResource` of `CString`. |

| [DefaultHasher](./core_package_api/core_package_structs.md#struct-defaulthasher) | This struct provides a default hash algorithm implementation. |

| [Duration](./core_package_api/core_package_structs.md#struct-duration) | Represents a time interval, a time type describing a period of time, providing common static instances, as well as calculation, comparison and other functions. |

| [LibC](./core_package_api/core_package_structs.md#struct-libc) | Provides C interfaces that are used more frequently in Cangjie, such as applying for and releasing CType instances on the heap. |

| [Range\<T> where T <: Countable\<T> \& Comparable\<T> \& Equatable\<T>](./core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) | This class is a range type, used to represent a sequence of `T` with a fixed range and step size, requiring `T` to be countable and ordered. |

| [String](./core_package_api/core_package_structs.md#struct-string) | This struct represents a Cangjie string, providing a series of string operations such as construction, search, and concatenation. |



### Exception Classes



| Exception Class Name | Functionality |

| ------------ | ------------ |

| [ArithmeticException](./core_package_api/core_package_exceptions.md#class-arithmeticexception) | Arithmetic exception class, used when an arithmetic exception occurs. |

| [Error](./core_package_api/core_package_exceptions.md#class-error) | `Error` is the parent class of all error classes. This class cannot be inherited or initialized, but can be caught. |

| [Exception](./core_package_api/core_package_exceptions.md#class-exception) | `Exception` is the parent class of all exception classes. |

| [IllegalArgumentException](./core_package_api/core_package_exceptions.md#class-illegalargumentexception) | Exception class indicating that an argument is illegal. |

| [IllegalFormatException](./core_package_api/core_package_exceptions.md#class-illegalformatexception) | Exception class indicating that the format of a variable is invalid or non-standard. |

| [IllegalMemoryException](./core_package_api/core_package_exceptions.md#class-illegalmemoryexception) | Exception class indicating a memory operation error. |

| [IllegalStateException](./core_package_api/core_package_exceptions.md#class-illegalstateexception) | Exception class indicating that the state is illegal. |

| [IncompatiblePackageException](./core_package_api/core_package_exceptions.md#class-incompatiblepackageexception) | Exception class indicating that the package is incompatible. |

| [IndexOutOfBoundsException](./core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) | Exception class indicating that the index is out of bounds. |

| [NegativeArraySizeException](./core_package_api/core_package_exceptions.md#class-negativearraysizeexception) | Exception class indicating that the array size is negative. |

| [NoneValueException](./core_package_api/core_package_exceptions.md#class-nonevalueexception) | Exception class indicating that the value of an Option\<T> instance is `None`, usually thrown in the `getOrThrow` function. |

| [OutOfMemoryError](./core_package_api/core_package_exceptions.md#class-outofmemoryerror) | Error class indicating an out-of-memory error; this class cannot be inherited or initialized, but can be caught. |

| [OverflowException](./core_package_api/core_package_exceptions.md#class-overflowexception) | Exception class indicating an arithmetic overflow. |

| [SpawnException](./core_package_api/core_package_exceptions.md#class-spawnexception) | Thread exception class, indicating that an exception occurred during thread processing. |

| [StackOverflowError](./core_package_api/core_package_exceptions.md#class-stackoverflowerror) | Error class indicating a stack overflow error; this class cannot be inherited or initialized, but can be caught. |

| [TimeoutException](./core_package_api/core_package_exceptions.md#class-timeoutexception) | Exception thrown when a blocking operation times out. |

| [UnsupportedException](./core_package_api/core_package_exceptions.md#class-unsupportedexception) | Exception class indicating that a function is not supported. |