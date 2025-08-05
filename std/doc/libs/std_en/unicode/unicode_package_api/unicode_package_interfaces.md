# Interface

## interface UnicodeRuneExtension

```cangjie
public interface UnicodeRuneExtension {
    func isLetter(): Bool
    func isLowerCase(): Bool
    func isNumber(): Bool
    func isTitleCase(): Bool
    func isUpperCase(): Bool
    func isWhiteSpace(): Bool
    func toLowerCase(): Rune
    func toLowerCase(opt: CasingOption): Rune
    func toTitleCase(): Rune
    func toTitleCase(opt: CasingOption): Rune
    func toUpperCase(): Rune
    func toUpperCase(opt: CasingOption): Rune
}
```

Function: Interface for Unicode character set related extensions.

Can be used to add a series of Unicode character set related extension functions to the [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) type, including character type determination, case conversion, whitespace removal, etc.

### func isLetter()

```cangjie
func isLetter(): Bool
```

Function: Determines whether the type is a Unicode letter character.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the type is a Unicode letter character, otherwise returns `false`.

### func isLowerCase()

```cangjie
func isLowerCase(): Bool
```

Function: Determines whether the type is a Unicode lowercase character.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the type is a Unicode lowercase character, otherwise returns `false`.

### func isNumber()

```cangjie
func isNumber(): Bool
```

Function: Determines whether the type is a Unicode numeric character.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the type is a Unicode numeric character, otherwise returns `false`.

### func isTitleCase()

```cangjie
func isTitleCase(): Bool
```

Function: Determines whether the type is a Unicode titlecase character.

Titlecase characters in Unicode refer to a special form of letters used in certain languages to represent the first letter of each word in titles in uppercase form. These letters are represented by special characters, such as U+01C5 (ǅ) and U+01F1 (Ǳ). These characters are typically used in some Eastern European languages like Croatian and Serbian.

Titlecase characters include: `0x01C5`, `0x01C8`, `0x01CB`, `0x01F2`, `0x1F88 - 0x1F8F`, `0x1F98 - 0x1F9F`, `0x1F98 - 0x1F9F`, `0x1FA8 - 0x1FAF`, `0x1FBC`, `0x1FCC`, `0x1FFC`

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the type is a Unicode titlecase character, otherwise returns `false`.

### func isUpperCase()

```cangjie
func isUpperCase(): Bool
```

Function: Determines whether the type is a Unicode uppercase character.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the type is a Unicode uppercase character, otherwise returns `false`.

### func isWhiteSpace()

```cangjie
func isWhiteSpace(): Bool
```

Function: Determines whether the type is a Unicode whitespace character.

Whitespace characters include `0x0009`, `0x000A`, `0x000B`, `0x000C`, `0x000D`, `0x0020`, `0x0085`, `0x00A0`, `0x1680`, `0x2000`, `0x2001`, `0x2002`, `0x2003`, `0x2004`, `0x2005`, `0x2006`, `0x2007`, `0x2008`, `0x2009`, `0x200A`, `0x2028`, `0x2029`, `0x202F`, `0x205F`, `0x3000`.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the type is a Unicode whitespace character, otherwise returns `false`.

### func toLowerCase()

```cangjie
func toLowerCase(): Rune
```

Function: Gets the corresponding Unicode lowercase character for this type.

Return value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The lowercase character corresponding to the current type.

### func toTitleCase()

```cangjie
func toTitleCase(): Rune
```

Function: Gets the corresponding Unicode titlecase character for this type.

Return value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The titlecase character corresponding to the current type.

### func toUpperCase()

```cangjie
func toUpperCase(): Rune
```

Function: Gets the corresponding Unicode uppercase character for this type.

Return value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The uppercase character corresponding to the current type.

### func toLowerCase(CasingOption)

```cangjie
func toLowerCase(opt: CasingOption): Rune
```

Function: Gets the corresponding Unicode lowercase character for this type.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The input language enumeration.

Return value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The lowercase character corresponding to the current type.

### func toTitleCase(CasingOption)

```cangjie
func toTitleCase(opt: CasingOption): Rune
```

Function: Gets the corresponding Unicode titlecase character for this type.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The input language enumeration.

Return value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The titlecase character corresponding to the current type.

### func toUpperCase(CasingOption)

```cangjie
func toUpperCase(opt: CasingOption): Rune
```

Function: Gets the corresponding Unicode uppercase character for this type.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The input language enumeration.

Return value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The uppercase character corresponding to the current type.

### extend Rune <: UnicodeRuneExtension

```cangjie
extend Rune <: UnicodeRuneExtension
```

Function: Extends the [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) type with the [UnicodeRuneExtension](unicode_package_interfaces.md#interface-UnicodeRuneExtension) interface to support character set related operations.

Parent type:

- [UnicodeRuneExtension](#interface-unicoderuneextension)

#### func isLetter()

```cangjie
public func isLetter(): Bool
```

Function: Determines whether the character is a Unicode letter character.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the character is a Unicode letter character, otherwise returns `false`.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'a'.isLetter())
    println(r'1'.isLetter())
}
```

Execution result:

```text
true
false
```

#### func isLowerCase()

```cangjie
public func isLowerCase(): Bool
```

Function: Determines whether the character is a Unicode lowercase character.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the character is a Unicode lowercase character, otherwise returns `false`.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'a'.isLowerCase())
    println(r'A'.isLowerCase())
}
```

Execution result:

```text
true
false
```

#### func isNumber()

```cangjie
public func isNumber(): Bool
```

Function: Determines whether the character is a Unicode numeric character.

Return value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the character is a Unicode numeric character, otherwise returns `false`.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'a'.isNumber())
    println(r'1'.isNumber())
}
```

Execution result:

```text
false
true
```

#### func isTitleCase()

```cangjie
public func isTitleCase(): Bool
```

Function: Determines whether the character is a Unicode titlecase character.

Titlecase characters in Unicode refer to a special form of letters used in certain languages to represent the first letter of each word in titles in uppercase form. These letters are represented by special characters, such as U+01C5 (ǅ) and U+01F1 (Ǳ). These characters are typically used in some Eastern European languages like Croatian and Serbian.

Titlecase characters include: `0x01C5`, `0x01C8`, `0x01CB`, `0x01F2`, `0x1F88 - 0x1F8F`, `0x1F98 - 0x1F9F`, `0x1F98 - 0x1F9F`, `0x1FA8 - 0x1FAF`, `0x1FBC`, `0x1FCC`, `0x1FFC`Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the character is a `Unicode` title case character, otherwise returns `false`.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'ǅ'.isTitleCase())
}
```

Execution Result:

```text
true
```

#### func isUpperCase()

```cangjie
public func isUpperCase(): Bool
```

Function: Determines whether the character is a `Unicode` uppercase character.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the character is a `Unicode` uppercase character, otherwise returns `false`.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'a'.isUpperCase())
    println(r'A'.isUpperCase())
}
```

Execution Result:

```text
false
true
```

#### func isWhiteSpace()

```cangjie
public func isWhiteSpace(): Bool
```

Function: Determines whether the character is a `Unicode` whitespace character.

Whitespace characters include `0x0009`, `0x000A`, `0x000B`, `0x000C`, `0x000D`, `0x0020`, `0x0085`, `0x00A0`, `0x1680`, `0x2000`, `0x2001`, `0x2002`, `0x2003`, `0x2004`, `0x2005`, `0x2006`, `0x2007`, `0x2008`, `0x2009`, `0x200A`, `0x2028`, `0x2029`, `0x202F`, `0x205F`, `0x3000`.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the character is a `Unicode` whitespace character, otherwise returns `false`.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r' '.isWhiteSpace())
}
```

Execution Result:

```text
true
```

#### func toLowerCase()

```cangjie
public func toLowerCase(): Rune
```

Function: Gets the corresponding `Unicode` lowercase character for this character.

Return Value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The lowercase character corresponding to the current character.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'A'.toLowerCase())
}
```

Execution Result:

```text
a
```

#### func toLowerCase(CasingOption)

```cangjie
public func toLowerCase(opt: CasingOption): Rune
```

Function: Gets the corresponding `Unicode` lowercase character for this character.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The language enumeration to be passed in.

Return Value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The lowercase character corresponding to the current character.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'A'.toLowerCase(CasingOption.Other))
}
```

Execution Result:

```text
a
```

#### func toTitleCase()

```cangjie
public func toTitleCase(): Rune
```

Function: Gets the corresponding `Unicode` title case character for this character.

Return Value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The title case character corresponding to the current character.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'a'.toTitleCase())
}
```

Execution Result:

```text
A
```

#### func toTitleCase(CasingOption)

```cangjie
public func toTitleCase(opt: CasingOption): Rune
```

Function: Gets the corresponding `Unicode` title case character for this character.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The language enumeration to be passed in.

Return Value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The title case character corresponding to the current character.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'a'.toTitleCase(CasingOption.Other))
}
```

Execution Result:

```text
A
```

#### func toUpperCase()

```cangjie
public func toUpperCase(): Rune
```

Function: Gets the corresponding `Unicode` uppercase character for this character.

Return Value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The uppercase character corresponding to the current character.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'a'.toUpperCase())
}
```

Execution Result:

```text
A
```

#### func toUpperCase(CasingOption)

```cangjie
public func toUpperCase(opt: CasingOption): Rune
```

Function: Gets the corresponding `Unicode` uppercase character for this character.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The language enumeration to be passed in.

Return Value:

- [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) - The uppercase character corresponding to the current character.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(r'a'.toUpperCase(CasingOption.Other))
}
```

Execution Result:

```text
A
```

## interface UnicodeStringExtension

```cangjie
public interface UnicodeStringExtension {
    func isBlank(): Bool
    func toLower(): String
    func toLower(opt: CasingOption): String
    func toTitle(): String
    func toTitle(opt: CasingOption): String
    func toUpper(): String
    func toUpper(opt: CasingOption): String
    func trim(): String
    func trimEnd(): String
    func trimLeft(): String
    func trimRight(): String
    func trimStart(): String
}
```

Function: Interface for `Unicode` character set-related extensions.

Can be used to add a series of `Unicode` character set-related extension functions to the [String](../../core/core_package_api/core_package_structs.md#struct-string) type, including character type determination, case conversion, and whitespace removal.

### func isBlank()

```cangjie
func isBlank(): Bool
```

Function: Determines whether the current string is empty or contains only whitespace characters from the `Unicode` character set.

Whitespace characters include `0x0009`, `0x000A`, `0x000B`, `0x000C`, `0x000D`, `0x0020`, `0x0085`, `0x00A0`, `0x1680`, `0x2000`, `0x2001`, `0x2002`, `0x2003`, `0x2004`, `0x2005`, `0x2006`, `0x2007`, `0x2008`, `0x2009`, `0x200A`, `0x2028`, `0x2029`, `0x202F`, `0x205F`, `0x3000`.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the string is empty or contains only whitespace characters, otherwise returns `false`.```cangjie
func toLower(): String
```

Function: Converts all uppercase characters within the current string's `Unicode` character set range to lowercase.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted all-lowercase string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func toLower(CasingOption)

```cangjie
func toLower(opt: CasingOption): String
```

Function: Converts all uppercase characters within the current string's `Unicode` character set range to lowercase.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The language enumeration to be passed.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted all-lowercase string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func toTitle()

```cangjie
func toTitle(): String
```

Function: Converts characters within the current string's `Unicode` character set range that can be converted to title case to title case.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted title case string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func toTitle(CasingOption)

```cangjie
func toTitle(opt: CasingOption): String
```

Function: Converts characters within the current string's `Unicode` character set range that can be converted to title case to title case.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The language enumeration to be passed.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted title case string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func toUpper()

```cangjie
func toUpper(): String
```

Function: Converts all lowercase characters within the current string's `Unicode` character set range to uppercase.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted all-uppercase string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func toUpper(CasingOption)

```cangjie
func toUpper(opt: CasingOption): String
```

Function: Converts all lowercase characters within the current string's `Unicode` character set range to uppercase.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The language enumeration to be passed.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted all-uppercase string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func trim()

```cangjie
func trim(): String
```

Function: Removes leading and trailing whitespace from the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) type.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with leading and trailing whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func trimEnd()

```cangjie
func trimEnd(): String
```

Function: Removes trailing whitespace from the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../../std/core/core_package_api/core_package_intrinsics.md#rune) type.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with trailing whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func trimLeft() <sup>(deprecated)</sup>

```cangjie
func trimLeft(): String
```

Function: Removes leading whitespace from the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) type.

> **Note:**
>
> This function will be deprecated in future versions. Use [trimStart](./unicode_package_interfaces.md#func-trimstart) instead.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with leading whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func trimRight() <sup>(deprecated)</sup>

```cangjie
func trimRight(): String
```

Function: Removes trailing whitespace from the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../../std/core/core_package_api/core_package_intrinsics.md#rune) type.

> **Note:**
>
> This function will be deprecated in future versions. Use [trimEnd](./unicode_package_interfaces.md#func-trimend) instead.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with trailing whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### func trimStart()

```cangjie
func trimStart(): String
```

Function: Removes leading whitespace from the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) type.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with leading whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

### extend String <: UnicodeStringExtension

```cangjie
extend String <: UnicodeStringExtension
```

Function: Extends the [String](../../../std/core/core_package_api/core_package_structs.md#struct-string) type with the [UnicodeRuneExtension](unicode_package_interfaces.md#interface-UnicodeStringExtension) interface to support character set-related operations.

Parent Type:

- [UnicodeStringExtension](#interface-unicodestringextension)

#### func isBlank()

```cangjie
public func isBlank(): Bool
```

Function: Determines whether the current string is empty or consists solely of whitespace characters within the `Unicode` character set.

Whitespace characters include `0x0009`, `0x000A`, `0x000B`, `0x000C`, `0x000D`, `0x0020`, `0x0085`, `0x00A0`, `0x1680`, `0x2000`, `0x2001`, `0x2002`, `0x2003`, `0x2004`, `0x2005`, `0x2006`, `0x2007`, `0x2008`, `0x2009`, `0x200A`, `0x2028`, `0x2029`, `0x202F`, `0x205F`, `0x3000`.

Return Value:

- [Bool](../../core/core_package_api/core_package_intrinsics.md#bool) - Returns `true` if the string is empty or consists solely of whitespace characters; otherwise, returns `false`.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println(" \t\n\r".isBlank())
}
```

Output:

```text
true
```

#### func toLower()

```cangjie
public func toLower(): String
```

Function: Converts all uppercase characters within the current string's `Unicode` character set range to lowercase.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted all-lowercase string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println("AbcDEF".toLower())
}
```

Output:

```text
abcdef
```

#### func toLower(CasingOption)

```cangjie
public func toLower(opt: CasingOption): String
```

Function: Converts all uppercase characters within the current string's `Unicode` character set range to lowercase.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The language enumeration to be passed.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted all-lowercase string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println("AbcDEF".toLower(CasingOption.Other))
}
```

Output:```text
abcdef
```

#### func toTitle()

```cangjie
public func toTitle(): String
```

Function: Converts characters within the current string that can be transformed to title case in the `Unicode` character set to title case.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted title case string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println("AbcDEF".toTitle())
}
```

Execution Result:

```text
ABCDEF
```

#### func toTitle(CasingOption)

```cangjie
public func toTitle(opt: CasingOption): String
```

Function: Converts characters within the current string that can be transformed to title case in the `Unicode` character set to title case.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The input language enumeration.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted title case string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println("AbcDEF".toTitle(CasingOption.Other))
}
```

Execution Result:

```text
ABCDEF
```

#### func toUpper()

```cangjie
public func toUpper(): String
```

Function: Converts all lowercase characters within the current string that fall within the `Unicode` character set to uppercase.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted uppercase string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println("AbcDEF".toUpper())
}
```

Execution Result:

```text
ABCDEF
```

#### func toUpper(CasingOption)

```cangjie
public func toUpper(opt: CasingOption): String
```

Function: Converts all lowercase characters within the current string that fall within the `Unicode` character set to uppercase.

Parameters:

- opt: [CasingOption](./unicode_package_enums.md#enum-casingoption) - The input language enumeration.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The converted uppercase string.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    println("AbcDEF".toUpper(CasingOption.Other))
}
```

Execution Result:

```text
ABCDEF
```

#### func trim()

```cangjie
public func trim(): String
```

Function: Removes whitespace characters from the beginning and end of the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) type.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with leading and trailing whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    let str = "  x  "
    println("\"${str.trim()}\"")
}
```

Execution Result:

```text
"x"
```

#### func trimEnd()

```cangjie
public func trimEnd(): String
```

Function: Removes whitespace characters from the end of the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../../std/core/core_package_api/core_package_intrinsics.md#rune) type.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with trailing whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*

main(): Unit {
    let str = "  x  "
    println("\"${str.trimEnd()}\"")
}
```

Execution Result:

```text
"  x"
```

#### func trimLeft() <sup>(deprecated)</sup>

```cangjie
public func trimLeft(): String
```

Function: Removes whitespace characters from the beginning of the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) type.

> **Note:**
>
> This function will be deprecated in future versions. Use [trimStart](./unicode_package_interfaces.md#func-trimend) instead.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with leading whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:

```cangjie
import std.unicode.*

main(): Unit {
    let str = "  x  "
    println("\"${str.trimLeft()}\"")
}
```

Execution Result:

```text
"x  "
```

#### func trimRight() <sup>(deprecated)</sup>

```cangjie
public func trimRight(): String
```

Function: Removes whitespace characters from the end of the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../../std/core/core_package_api/core_package_intrinsics.md#rune) type.

> **Note:**
>
> This function will be deprecated in future versions. Use [trimEnd](./unicode_package_interfaces.md#func-trimend) instead.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with trailing whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:

```cangjie
import std.unicode.*

main(): Unit {
    let str = "  x  "
    println("\"${str.trimRight()}\"")
}
```

Execution Result:

```text
"  x"
```

#### func trimStart()

```cangjie
public func trimStart(): String
```

Function: Removes whitespace characters from the beginning of the string. Whitespace characters are defined in the extension function [isWhiteSpace](#func-iswhitespace) of the [Rune](../../core/core_package_api/core_package_intrinsics.md#rune) type.

Return Value:

- [String](../../core/core_package_api/core_package_structs.md#struct-string) - The string with leading whitespace removed.

Exceptions:

- [IllegalArgumentException](../../core/core_package_api/core_package_exceptions.md#class-illegalargumentexception) - Throws an exception if the string contains invalid UTF-8 encoding.

Example:
<!-- verify -->
```cangjie
import std.unicode.*```kotlin
main(): Unit {
    let str = "  x  "
    println("\"${str.trimStart()}\"")
}
```

Execution result:

```text
"x  "
```