# std.core

## Function Introduction

The core package is the standard library's core package, providing the most basic API capabilities for Cangjie language programming.

It provides built-in types (signed integers, unsigned integers, floating-point types, etc.), common functions (print, println, eprint, etc.), common interfaces (ToString, Hashable, Equatable, Collection, etc.), common classes and structs (Array, String, Range, etc.), and common exception classes (Error, Exception and some of their subclasses).

> **Note:**
>
> The core package does not need to be explicitly imported, it is imported by default.

## API List

### Functions

| Function Name | Description |
| ------------ | ------------ |
| [acquireArrayRawData(Array\) where T <: CType](./core_package_api/core_package_funcs.md#func-acquirearrayrawdatatarrayt-where-t--ctype) | Get the raw pointer instance of data in Array\, T needs to satisfy the CType constraint. |
| [alignOf\() where T <: CType](./core_package_api/core_package_funcs.md#func-alignoft-where-t--ctype) | Get the memory alignment value of type T. |
| [eprint(String, Bool)](./core_package_api/core_package_funcs.md#func-eprintstring-bool) | Print the specified string to the standard error text stream. |
| [eprintln(String)](./core_package_api/core_package_funcs.md#func-eprintlnstring) | Print the specified string to the standard error text stream, adding a newline at the end. |
| [eprint\(T, Bool) where T <: ToString](./core_package_api/core_package_funcs.md#func-eprinttt-bool-where-t--tostring) | Print the string representation of the specified T type instance to the standard error text stream. |
| [eprintln\(T) where T <: ToString](./core_package_api/core_package_funcs.md#func-eprintlntt-where-t--tostring) | Print the string representation of the specified T type instance to the standard error text stream, adding a newline at the end. |
| [ifNone(Option\, () -> Unit)](./core_package_api/core_package_funcs.md#func-ifnonetoptiont----unit) | Execute the action function if the input is Option.None type data. |
| [ifSome(Option\, (T) -> Unit)](./core_package_api/core_package_funcs.md#func-ifsometoptiont-t---unit) | Execute the action function if the input is Option.Some type data. |
| [max\(T, T, Array\) where T <: Comparable\](./core_package_api/core_package_funcs.md#func-maxtt-t-arrayt-where-t--comparablet) | Get the maximum value from a group of data |
| [min\(T, T, Array\) where T <: Comparable\](./core_package_api/core_package_funcs.md#func-mintt-t-arrayt-where-t--comparablet) | Get the minimum value from a group of data |
| [print(Bool, Bool)](./core_package_api/core_package_funcs.md#func-printbool-bool) | Output the string expression of Bool type data to the console. |
| [print(Float16, Bool)](./core_package_api/core_package_funcs.md#func-printfloat16-bool) | Output the string expression of Float16 type data to the console. |
| [print(Float32, Bool)](./core_package_api/core_package_funcs.md#func-printfloat32-bool) | Output the string expression of Float32 type data to the console. |
| [print(Float64, Bool)](./core_package_api/core_package_funcs.md#func-printfloat64-bool) | Output the string expression of Float64 type data to the console. |
| [print(Int16, Bool)](./core_package_api/core_package_funcs.md#func-printint16-bool) | Output the string expression of Int16 type data to the console. |
| [print(Int32, Bool)](./core_package_api/core_package_funcs.md#func-printint32-bool) | Output the string expression of Int32 type data to the console. |
| [print(Int64, Bool)](./core_package_api/core_package_funcs.md#func-printint64-bool) | Output the string expression of Int64 type data to the console. |
| [print(Int8, Bool)](./core_package_api/core_package_funcs.md#func-printint8-bool) | Output the string expression of Int8 type data to the console. |
| [print(Rune, Bool)](./core_package_api/core_package_funcs.md#func-printrune-bool) | Output the string expression of Rune type data to the console. |
| [print(String, Bool)](./core_package_api/core_package_funcs.md#func-printstring-bool) | Output the specified string to the console. |
| [print(UInt16, Bool)](./core_package_api/core_package_funcs.md#func-printuint16-bool) | Output the string expression of UInt16 type data to the console. |
| [print(UInt32, Bool)](./core_package_api/core_package_funcs.md#func-printuint32-bool) | Output the string expression of UInt32 type data to the console. |
| [print(UInt64, Bool)](./core_package_api/core_package_funcs.md#func-printuint64-bool) | Output the string expression of UInt64 type data to the console. |
| [print(UInt8, Bool)](./core_package_api/core_package_funcs.md#func-printuint8-bool) | Output the string expression of UInt8 type data to the console. |
| [print\(T, Bool) where T <: ToString](./core_package_api/core_package_funcs.md#func-printtt-bool-where-t--tostring) | Output the string representation of T type instance to the console. |
| [println()](./core_package_api/core_package_funcs.md#func-println) | Output a newline character to standard output (stdout). |
| [println(Bool)](./core_package_api/core_package_funcs.md#func-printlnbool) | Output the string expression of Bool type data to the console, adding a newline at the end. |
| [println(Float16)](./core_package_api/core_package_funcs.md#func-printlnfloat16) | Output the string expression of Float16 type data to the console, adding a newline at the end. |
| [println(Float32)](./core_package_api/core_package_funcs.md#func-printlnfloat32) | Output the string expression of Float32 type data to the console, adding a newline at the end. |
| [println(Float64)](./core_package_api/core_package_funcs.md#func-printlnfloat64) | Output the string expression of Float64 type data to the console, adding a newline at the end. |
| [println(Int16)](./core_package_api/core_package_funcs.md#func-printlnint16) | Output the string expression of Int16 type data to the console, adding a newline at the end. |
| [println(Int32)](./core_package_api/core_package_funcs.md#func-printlnint32) | Output the string expression of Int32 type data to the console, adding a newline at the end. |
| [println(Int64)](./core_package_api/core_package_funcs.md#func-printlnint64) | Output the string expression of Int64 type data to the console, adding a newline at the end. |
| [println(Int8)](./core_package_api/core_package_funcs.md#func-printlnint8) | Output the string expression of Int8 type data to the console, adding a newline at the end. |
| [println(Rune)](./core_package_api/core_package_funcs.md#func-printlnrune) | Output the string expression of Rune type data to the console, adding a newline at the end. |
| [println(String)](./core_package_api/core_package_funcs.md#func-printlnstring) | Output the specified string to the console, adding a newline at the end. |
| [println(UInt16)](./core_package_api/core_package_funcs.md#func-printlnuint16) | Output the string expression of UInt16 type data to the console, adding a newline at the end. |
| [println(UInt32)](./core_package_api/core_package_funcs.md#func-printlnuint32) | Output the string expression of UInt32 type data to the console, adding a newline at the end. |
| [println(UInt64)](./core_package_api/core_package_funcs.md#func-printlnuint64) | Output the string expression of UInt64 type data to the console, adding a newline at the end. |
| [println(UInt8)](./core_package_api/core_package_funcs.md#func-printlnuint8) | Output the string expression of UInt8 type data to the console, adding a newline at the end. |
| [println\(T) where T <: ToString](./core_package_api/core_package_funcs.md#func-printlntt-where-t--tostring) | Output the string representation of `T` type instance to the console, adding a newline at the end. |
| [readln()](./core_package_api/core_package_funcs.md#func-readln) | Accept console input until encountering a newline or EOF. |
| [refEq(Object, Object)](./core_package_api/core_package_funcs.md#func-refeqobject-object) | Determine whether two Object instances have the same memory address. |
| [releaseArrayRawData(CPointerHandle\) where T <: CType](./core_package_api/core_package_funcs.md#func-releasearrayrawdatatcpointerhandlet-where-t--ctype) | Release the raw pointer instance obtained through acquireArrayRawData. |
| [sizeOf\() where T <: CType](./core_package_api/core_package_funcs.md#func-sizeoft-where-t--ctype) | Get the memory space size occupied by type T. |
| [sleep(Duration)](./core_package_api/core_package_funcs.md#func-sleepduration) | Sleep the current thread. |
| [zeroValue\()](./core_package_api/core_package_funcs.md#func-zerovaluet) | Get a T type instance that has been zero-initialized. |

### Type Aliases

| Type Alias | Description |
| ------------ | ------------ |
| [Byte](./core_package_api/core_package_types.md#type-byte) | `Byte` type is an alias for the built-in type `UInt8`. |
| [Int](./core_package_api/core_package_types.md#type-int) | `Int` type is an alias for the built-in type `Int64`. |
| [UInt](./core_package_api/core_package_types.md#type-uint) | `UInt` type is an alias for the built-in type `UInt64`. |

### Built-in Types

| Built-in Type Name | Description |
| ------------ | ------------ |
| [Int8](./core_package_api/core_package_intrinsics.md#int8) | Represents an 8-bit signed integer, with a range of [-2^7, 2^7 - 1]. |
| [Int16](./core_package_api/core_package_intrinsics.md#int16) | Represents a 16-bit signed integer, with a range of [-2^{15}, 2^{15} - 1]. |
| [Int32](./core_package_api/core_package_intrinsics.md#int32) | Represents a 32-bit signed integer, with a range of [-2^{31}, 2^{31} - 1]. |
| [Int64](./core_package_api/core_package_intrinsics.md#int64) | Represents a 64-bit signed integer, with a range of [-2^{63}, 2^{63} - 1]. |
| [IntNative](./core_package_api/core_package_intrinsics.md#intnative) | Represents a platform-related signed integer, whose length is consistent with the bit width of the current system. |
| [UInt8](./core_package_api/core_package_intrinsics.md#uint8) | Represents an 8-bit unsigned integer, with a range of [0 ~ 2^8 - 1]. |
| [UInt16](./core_package_api/core_package_intrinsics.md#uint16) | Represents a 16-bit unsigned integer, with a range of [0 ~ 2^{16} - 1]. |
| [UInt32](./core_package_api/core_package_intrinsics.md#uint32) | Represents a 32-bit unsigned integer, with a range of [0 ~ 2^{32} - 1]. |
| [UInt64](./core_package_api/core_package_intrinsics.md#uint64) | Represents a 64-bit unsigned integer, with a range of [0 ~ 2^{64} - 1]. |
| [UIntNative](./core_package_api/core_package_intrinsics.md#uintnative) | Represents a platform-related unsigned integer, whose length is consistent with the bit width of the current system. |
| [Float16](./core_package_api/core_package_intrinsics.md#float16) | Represents a 16-bit floating-point number, conforming to the half-precision format (`binary16`) in `IEEE 754`. |
| [Float32](./core_package_api/core_package_intrinsics.md#float32) | Represents a 32-bit floating-point number, conforming to the single-precision format (`binary32`) in `IEEE 754`. |
| [Float64](./core_package_api/core_package_intrinsics.md#float64) | Represents a 64-bit floating-point number, conforming to the double-precision format (`binary64`) in `IEEE 754`. |
| [Bool](./core_package_api/core_package_intrinsics.md#bool) | Represents a boolean type, with two values: `true` and `false`. |
| [Rune](./core_package_api/core_package_intrinsics.md#rune) | Represents a character in the Unicode character set. |
| [Unit](./core_package_api/core_package_intrinsics.md#unit) | Represents the type of expressions in the Cangjie language that only care about side effects rather than values. |
| [CPointer\](./core_package_api/core_package_intrinsics.md#cpointert) | Represents a pointer to an instance of type `T`, used in scenarios of interoperability with C language, corresponding to `T*` in C language. |
| [CString](./core_package_api/core_package_intrinsics.md#cstring) | Represents a C-style string, used in scenarios of interoperability with C language. |

### Interfaces

| Interface Name | Description |
| ------------ | ------------ |
| [Any](./core_package_api/core_package_interfaces.md#interface-any) | `Any` is the parent type of all types. All `interface`s inherit it by default, and all non-`interface` types implement it by default. |
| [Hasher](./core_package_api/core_package_interfaces.md#interface-hasher) | This interface is used to handle hash combination operations. |
| [ThreadContext](./core_package_api/core_package_interfaces.md#interface-threadcontext) | Cangjie thread context interface. |
| [Countable\](./core_package_api/core_package_interfaces.md#interface-countablet) | This interface indicates that the type is countable. |
| [Collection\](./core_package_api/core_package_interfaces.md#interface-collectiont) | This interface represents a collection, and container types should typically implement this interface. |
| [Less\](./core_package_api/core_package_interfaces.md#interface-lesst) | This interface represents less-than calculation. |
| [Greater\](./core_package_api/core_package_interfaces.md#interface-greatert) | This interface represents greater-than calculation. |
| [LessOrEqual\](./core_package_api/core_package_interfaces.md#interface-lessorequalt) | This interface represents less-than-or-equal calculation. |
| [GreaterOrEqual\](./core_package_api/core_package_interfaces.md#interface-greaterorequalt) | This interface represents greater-than-or-equal calculation. |
| [Comparable\](./core_package_api/core_package_interfaces.md#interface-comparablet) | This interface represents comparison operations, which is a collection of equal, less-than, greater-than, less-than-or-equal, and greater-than-or-equal interfaces. |
| [Equal\](./core_package_api/core_package_interfaces.md#interface-equalt) | This interface is used to support equality operations. |
| [NotEqual\](./core_package_api/core_package_interfaces.md#interface-notequalt) | This interface is used to support inequality operations. |
| [Equatable\](./core_package_api/core_package_interfaces.md#interface-equatablet) | This interface is a collection of equality and inequality interfaces. |
| [Hashable](./core_package_api/core_package_interfaces.md#interface-hashable) | This interface is used to calculate hash values. |
| [Iterable\](./core_package_api/core_package_interfaces.md#interface-iterablee) | This interface represents iterability. Types that implement this interface (typically container types) can iterate in `for-in` statements, or obtain their corresponding iterator type instances and call the `next` function to implement iteration. |
| [Resource](./core_package_api/core_package_interfaces.md#interface-resource) | This interface is used for resource management, typically for closing and releasing resources such as memory and handles. |
| [ToString](./core_package_api/core_package_interfaces.md#interface-tostring) | This interface provides string representation for specific types. |
| [CType](./core_package_api/core_package_interfaces.md#interface-ctype) | Represents an interface that supports interoperability with C language. |

### Classes

| Class Name | Description |
| ------------ | ------------ |
| [ArrayIterator\](./core_package_api/core_package_classes.md#class-arrayiteratort) | Array iterator, for detailed iteration functionality, see the `Iterable` and `Iterator` interface descriptions. |
| [Box\](./core_package_api/core_package_classes.md#class-boxt) | The `Box` type provides the ability to add a `class` encapsulation layer to other types. |
| [Future\](./core_package_api/core_package_classes.md#class-futuret) | Future\ instances represent a Cangjie thread task, which can be used to obtain the computation result of a Cangjie thread and send cancellation signals to the Cangjie thread. |
| [Iterator\](./core_package_api/core_package_classes.md#class-iteratort) | This class represents an iterator, providing the `next` method to support iterative traversal of members within containers. |
| [Object](./core_package_api/core_package_classes.md#class-object) | Construct an `object` instance. |
| [RangeIterator\ <: Iterator\ where T <: Countable\ & Comparable\ & Equatable\](./core_package_api/core_package_classes.md#class-rangeiteratort--iteratort-where-t--countablet--comparablet--equatablet) | Iterator for `Range` type, for detailed iteration functionality, see the `Iterable` and `Iterator` interface descriptions. |
| [StackTraceElement](./core_package_api/core_package_classes.md#class-stacktraceelement) | Represents specific information of an exception stack, including the class name, function name, file name, and line number where the exception occurred. |
| [StringBuilder](./core_package_api/core_package_classes.md#class-stringbuilder) | This class is mainly used for string construction. |
| [Thread](./core_package_api/core_package_classes.md#class-thread) | The `Thread` class represents a Cangjie class, which can be used to obtain thread ID and name, check if there is a cancellation request for the thread, and register unhandled exception handlers for threads. |
| [ThreadLocal\](./core_package_api/core_package_classes.md#class-threadlocalt) | This class represents Cangjie thread-local variables. |
| [ThreadSnapshot](./core_package_api/core_package_classes.) | This class is used to obtain information about the current thread or all threads, including name, ID, state, and call stack. |

### Enums

| Enum Name | Description |
| ------------ | ------------ |
| [AnnotationKind](./core_package_api/core_package_enums.md#enum-annotationkind) | Represents the positions where custom annotations hope to be supported. |
| [Endian](./core_package_api/core_package_enums.md#enum-endian) | The enum type Endian represents the endianness of the running platform, divided into big-endian and little-endian. |
| [Ordering](./core_package_api/core_package_enums.md#enum-ordering) | Ordering represents the result of comparing sizes, which includes three cases: less than, greater than, and equal. |
| [Option\](./core_package_api/core_package_enums.md#enum-optiont) | Option\ is an encapsulation of type `T`, representing that there may or may not be a value. |
| [ThreadState](./core_package_api/core_package_enums.md#enum-threadstate) | ThreadState represents the state of a thread, which includes four states: waiting for execution, executing, suspended, and execution completed. |

### Structs

| Struct Name | Description |
| ------------ | ------------ |
| [Array\](./core_package_api/core_package_structs.md#struct-arrayt) | Cangjie array type, used to represent an ordered sequence composed of elements of a single type. |
| [CPointerHandle\ where T <: CType](./core_package_api/core_package_structs.md#struct-cpointerhandlet-where-t--ctype) | Represents the raw pointer of an `Array` array, the generic parameter in this type should satisfy the `CType` constraint. |
| [CPointerResource\ where T <: CType](./core_package_api/core_package_structs.md#struct-cpointerresourcet-where-t--ctype) | This struct represents the resource management type corresponding to `CPointer`, and its instances can be obtained through the member function `asResource` of `CPointer`. |
| [CStringResource](./core_package_api/core_package_structs.md#struct-cstringresource) | This struct represents the resource management type corresponding to `CString`, and its instances can be obtained through the member function `asResource` of `CString`. |
| [DefaultHasher](./core_package_api/core_package_structs.md#struct-defaulthasher) | This struct provides the default hash algorithm implementation. |
| [Duration](./core_package_api/core_package_structs.md#struct-duration) | Represents a time interval, a time type that describes a period of time, providing commonly used static instances, as well as calculation and comparison functions. |
| [LibC](./core_package_api/core_package_structs.md#struct-libc) | Provides frequently used C interfaces in Cangjie, such as allocating and freeing heap CType instances. |
| [Range\ where T <: Countable\ & Comparable\ & Equatable\](./core_package_api/core_package_structs.md#struct-ranget-where-t--countablet--comparablet--equatablet) | This class is a range type, used to represent a sequence of `T` with a fixed range and step size, requiring `T` to be countable and ordered. |
| [String](./core_package_api/core_package_structs.md#struct-string) | This struct represents a Cangjie string, providing a series of string operations such as construction, searching, and concatenation. |

### Exception Classes

| Exception Class Name | Description |
| ------------ | ------------ |
| [ArithmeticException](./core_package_api/core_package_exceptions.md#class-arithmeticexception) | Arithmetic exception class, used when arithmetic exceptions occur. |
| [Error](./core_package_api/core_package_exceptions.md#class-error) | `Error` is the parent class of all error classes. This class cannot be inherited or initialized, but can be caught. |
| [Exception](./core_package_api/core_package_exceptions.md#class-exception) | `Exception` is the parent class of all exception classes. |
| [IllegalArgumentException](./core_package_api/core_package_exceptions.md#class-illegalargumentexception) | Exception class representing illegal parameters. |
| [IllegalFormatException](./core_package_api/core_package_exceptions.md#class-illegalformatexception) | Exception class representing invalid or non-standard variable formats. |
| [IllegalMemoryException](./core_package_api/core_package_exceptions.md#class-illegalmemoryexception) | Exception class representing memory operation errors. |
| [IllegalStateException](./core_package_api/core_package_exceptions.md#class-illegalstateexception) | Exception class representing illegal states. |
| [IncompatiblePackageException](./core_package_api/core_package_exceptions.md#class-incompatiblepackageexception) | Exception class representing incompatible packages. |
| [IndexOutOfBoundsException](./core_package_api/core_package_exceptions.md#class-indexoutofboundsexception) | Exception class representing index out of bounds. |
| [NegativeArraySizeException](./core_package_api/core_package_exceptions.md#class-negativearraysizeexception) | Exception class representing negative array size. |
| [NoneValueException](./core_package_api/core_package_exceptions.md#class-nonevalueexception) | Exception class representing that the value of an Option\ instance is `None`, usually thrown in the `getOrThrow` function. |
| [OutOfMemoryError](./core_package_api/core_package_exceptions.md#class-outofmemoryerror) | Error class representing insufficient memory, this class cannot be inherited or initialized, but can be caught. |
| [OverflowException](./core_package_api/core_package_exceptions.md#class-overflowexception) | Exception class representing arithmetic overflow. |
| [SpawnException](./core_package_api/core_package_exceptions.md#class-spawnexception) | Thread exception class, representing exceptions that occur during thread processing. |
| [StackOverflowError](./core_package_api/core_package_exceptions.md#class-stackoverflowerror) | Error class representing stack overflow, this class cannot be inherited or initialized, but can be caught. |
| [TimeoutException](./core_package_api/core_package_exceptions.md#class-timeoutexception) | Exception raised when a blocking operation times out. |
| [UnsupportedException](./core_package_api/core_package_exceptions.md#class-unsupportedexception) | Exception class representing unsupported features. |
