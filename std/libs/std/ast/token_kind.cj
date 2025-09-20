/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package std.ast

/**
 * Note: If Tokens.inc is changed, TokenKind and PATTERNS should change accordingly.
 */
public enum TokenKind <: ToString {
    DOT
    | /*  "."           */
        COMMA
    | /*  ","           */
        LPAREN
    | /*  "("           */
        RPAREN
    | /*  ")"           */
        LSQUARE
    | /*  "["           */
        RSQUARE
    | /*  "]"           */
        LCURL
    | /*  "{"           */
        RCURL
    | /*  "}"           */
        EXP
    | /*  "**"          */
        MUL
    | /*  "*"           */
        MOD
    | /*  "%"           */
        DIV
    | /*  "/"           */
        ADD
    | /*  "+"           */
        SUB
    | /*  "-"           */
        INCR
    | /*  "++"          */
        DECR
    | /*  "--"          */
        AND
    | /*  "&&"          */
        OR
    | /*  "||"          */
        COALESCING
    | /*  "??"          */
        PIPELINE
    | /*  "|>"          */
        COMPOSITION
    | /*  "~>"          */
        NOT
    | /*  "!"           */
        BITAND
    | /*  "&"           */
        BITOR
    | /*  "|"           */
        BITXOR
    | /*  "^"           */
        BITNOT
    | /*  "~"           */
        LSHIFT
    | /*  "<<"          */
        RSHIFT
    | /*  ">>"          */
        COLON
    | /*  ":"           */
        SEMI
    | /*  ";"           */
        ASSIGN
    | /*  "="           */
        ADD_ASSIGN
    | /*  "+="          */
        SUB_ASSIGN
    | /*  "-="          */
        MUL_ASSIGN
    | /*  "*="          */
        EXP_ASSIGN
    | /*  "**="         */
        DIV_ASSIGN
    | /*  "/="          */
        MOD_ASSIGN
    | /*  "%="          */
        AND_ASSIGN
    | /*  "&&="         */
        OR_ASSIGN
    | /*  "||="         */
        BITAND_ASSIGN
    | /*  "&="          */
        BITOR_ASSIGN
    | /*  "|="          */
        BITXOR_ASSIGN
    | /*  "^="          */
        LSHIFT_ASSIGN
    | /*  "<<="         */
        RSHIFT_ASSIGN
    | /*  ">>="         */
        ARROW
    | /*  "->"          */
        BACKARROW
    | /*  "<-"          */
        DOUBLE_ARROW
    | /*  "=>"          */
        RANGEOP
    | /*  ".."          */
        CLOSEDRANGEOP
    | /*  "..="         */
        ELLIPSIS
    | /*  "..."         */
        HASH
    | /*  "#"           */
        AT
    | /*  "@"           */
        QUEST
    | /*  "?"           */
        LT
    | /*  "<"           */
        GT
    | /*  ">"           */
        LE
    | /*  "<="          */
        GE
    | /*  ">="          */
        IS
    | /*  "is"          */
        AS
    | /*  "as"          */
        NOTEQ
    | /*  "!="          */
        EQUAL
    | /*  "=="          */
        WILDCARD
    | /*  "_"           */
        INT8
    | /*  "Int8"        */
        INT16
    | /*  "Int16"       */
        INT32
    | /*  "Int32"       */
        INT64
    | /*  "Int64"       */
        INTNATIVE
    | /*  "IntNative"   */
        UINT8
    | /*  "UInt8"       */
        UINT16
    | /*  "UInt16"      */
        UINT32
    | /*  "UInt32"      */
        UINT64
    | /*  "UInt64"      */
        UINTNATIVE
    | /*  "UIntNative"  */
        FLOAT16
    | /*  "Float16"     */
        FLOAT32
    | /*  "Float32"     */
        FLOAT64
    | /*  "Float64"     */
        RUNE
    | /*  "Rune"        */
        BOOLEAN
    | /*  "Bool"        */
        NOTHING
    | /*  "Nothing"     */
        UNIT
    | /*  "Unit"        */
        STRUCT
    | /*  "struct"      */
        ENUM
    | /*  "enum"        */
        VARRAY
    | /*  "VArray"      */
        THISTYPE
    | /*  "This"        */
        PACKAGE
    | /*  "package"     */
        IMPORT
    | /*  "import"      */
        CLASS
    | /*  "class"       */
        INTERFACE
    | /*  "interface"   */
        FUNC
    | /*  "func"        */
        MACRO
    | /*  "macro"       */
        QUOTE
    | /*  "quote"       */
        DOLLAR
    | /*  "$"           */
        LET
    | /*  "let"         */
        VAR
    | /*  "var"         */
        CONST
    | /*  "const"       */
        TYPE
    | /*  "type"        */
        INIT
    | /*  "init"        */
        THIS
    | /*  "this"        */
        SUPER
    | /*  "super"       */
        IF
    | /*  "if"          */
        ELSE
    | /*  "else"        */
        CASE
    | /*  "case"        */
        TRY
    | /*  "try"         */
        CATCH
    | /*  "catch"       */
        FINALLY
    | /*  "finally"     */
        FOR
    | /*  "for"         */
        DO
    | /*  "do"          */
        WHILE
    | /*  "while"       */
        THROW
    | /*  "throw"       */
        RETURN
    | /*  "return"      */
        CONTINUE
    | /*  "continue"    */
        BREAK
    | /*  "break"       */
        IN
    | /*  "in"          */
        NOT_IN
    | /*  "!in"         */
        MATCH
    | /*  "match"       */
        WHERE
    | /*  "where"       */
        EXTEND
    | /*  "extend"      */
        WITH
    | /*  "with"        */
        PROP
    | /*  "prop"        */
        STATIC
    | /*  "static"      */
        PUBLIC
    | /*  "public"      */
        PRIVATE
    | /*  "private"     */
        INTERNAL
    | /*  "internal"     */
        PROTECTED
    | /*  "protected"   */
        OVERRIDE
    | /*  "override"    */
        REDEF
    | /*  "redef"       */
        ABSTRACT
    | /*  "abstract"    */
        SEALED
    | /*  "sealed"      */
        OPEN
    | /*  "open"        */
        FOREIGN
    | /*  "foreign"     */
        INOUT
    | /*  "inout"       */
        MUT
    | /*  "mut"         */
        UNSAFE
    | /*  "unsafe"      */
        OPERATOR
    | /*  "operator"    */
        SPAWN
    | /*  "spawn"       */
        SYNCHRONIZED
    | /*  "synchronized */
        UPPERBOUND
    | /*  "<:"          */
        MAIN
    | /*  "main"        */
        IDENTIFIER
    | /*  "x"           */
        PACKAGE_IDENTIFIER
    | /*  "x-y"         */
        INTEGER_LITERAL
    | /*  e.g. "1"      */
        RUNE_BYTE_LITERAL
    | /*  e.g. "b'x'"   */
        FLOAT_LITERAL
    | /*  e.g. "'1.0'"  */
        COMMENT
    | /*  e.g. "/*xx*/" */
        NL
    | /*  newline         */
        END
    | /*  end of file     */
        SENTINEL
    | /*  ";"             */
        RUNE_LITERAL
    | /*  e.g. "r'x'"      */
        STRING_LITERAL
    | /*  e.g. ""xx""     */
        SINGLE_QUOTED_STRING_LITERAL
    | /*  e.g. "'xx'"     */
        JSTRING_LITERAL
    | /*  e.g. "J"xx""     */
        MULTILINE_STRING
    | /*  e.g. """"aaa""""   */
        MULTILINE_RAW_STRING
    | /*  e.g. "#"aaa"#"     */
        BOOL_LITERAL
    | /*  "true" or "false"  */
        UNIT_LITERAL
    | /*  "()"               */
        DOLLAR_IDENTIFIER
    | /*  e.g. "$x"          */
        ANNOTATION
    | /*  e.g. "@When"       */
        AT_EXCL
    | /*  "@!"               */
        ILLEGAL
    |
        HANDLE
    | /*  "handle"           */
        PERFORM
    | /*  "perform"          */
         RESUME
    | /*  "resume"           */
        THROWING
    | /*  "throwing"         */
      ...

    public operator func ==(right: TokenKind): Bool {
        match ((this, right)) {
            case (DOT, DOT) => true
            case (COMMA, COMMA) => true
            case (LPAREN, LPAREN) => true
            case (RPAREN, RPAREN) => true
            case (LSQUARE, LSQUARE) => true
            case (RSQUARE, RSQUARE) => true
            case (LCURL, LCURL) => true
            case (RCURL, RCURL) => true
            case (EXP, EXP) => true
            case (MUL, MUL) => true
            case (MOD, MOD) => true
            case (DIV, DIV) => true
            case (ADD, ADD) => true
            case (SUB, SUB) => true
            case (INCR, INCR) => true
            case (DECR, DECR) => true
            case (AND, AND) => true
            case (OR, OR) => true
            case (COALESCING, COALESCING) => true
            case (PIPELINE, PIPELINE) => true
            case (COMPOSITION, COMPOSITION) => true
            case (NOT, NOT) => true
            case (BITAND, BITAND) => true
            case (BITNOT, BITNOT) => true
            case (BITOR, BITOR) => true
            case (BITXOR, BITXOR) => true
            case (LSHIFT, LSHIFT) => true
            case (RSHIFT, RSHIFT) => true
            case (COLON, COLON) => true
            case (SEMI, SEMI) => true
            case (ASSIGN, ASSIGN) => true
            case (ADD_ASSIGN, ADD_ASSIGN) => true
            case (SUB_ASSIGN, SUB_ASSIGN) => true
            case (MUL_ASSIGN, MUL_ASSIGN) => true
            case (EXP_ASSIGN, EXP_ASSIGN) => true
            case (DIV_ASSIGN, DIV_ASSIGN) => true
            case (MOD_ASSIGN, MOD_ASSIGN) => true
            case (AND_ASSIGN, AND_ASSIGN) => true
            case (OR_ASSIGN, OR_ASSIGN) => true
            case (BITAND_ASSIGN, BITAND_ASSIGN) => true
            case (BITOR_ASSIGN, BITOR_ASSIGN) => true
            case (BITXOR_ASSIGN, BITXOR_ASSIGN) => true
            case (LSHIFT_ASSIGN, LSHIFT_ASSIGN) => true
            case (RSHIFT_ASSIGN, RSHIFT_ASSIGN) => true
            case (ARROW, ARROW) => true
            case (BACKARROW, BACKARROW) => true
            case (DOUBLE_ARROW, DOUBLE_ARROW) => true
            case (RANGEOP, RANGEOP) => true
            case (CLOSEDRANGEOP, CLOSEDRANGEOP) => true
            case (ELLIPSIS, ELLIPSIS) => true
            case (HASH, HASH) => true
            case (AT, AT) => true
            case (QUEST, QUEST) => true
            case (LT, LT) => true
            case (GT, GT) => true
            case (LE, LE) => true
            case (GE, GE) => true
            case (IS, IS) => true
            case (AS, AS) => true
            case (NOTEQ, NOTEQ) => true
            case (EQUAL, EQUAL) => true
            case (WILDCARD, WILDCARD) => true
            case (INT8, INT8) => true
            case (INT16, INT16) => true
            case (INT32, INT32) => true
            case (INT64, INT64) => true
            case (INTNATIVE, INTNATIVE) => true
            case (UINT8, UINT8) => true
            case (UINT16, UINT16) => true
            case (UINT32, UINT32) => true
            case (UINT64, UINT64) => true
            case (UINTNATIVE, UINTNATIVE) => true
            case (FLOAT16, FLOAT16) => true
            case (FLOAT32, FLOAT32) => true
            case (FLOAT64, FLOAT64) => true
            case (RUNE, RUNE) => true
            case (BOOLEAN, BOOLEAN) => true
            case (NOTHING, NOTHING) => true
            case (UNIT, UNIT) => true
            case (STRUCT, STRUCT) => true
            case (ENUM, ENUM) => true
            case (VARRAY, VARRAY) => true
            case (THISTYPE, THISTYPE) => true
            case (PACKAGE, PACKAGE) => true
            case (IMPORT, IMPORT) => true
            case (CLASS, CLASS) => true
            case (INTERFACE, INTERFACE) => true
            case (FUNC, FUNC) => true
            case (MACRO, MACRO) => true
            case (QUOTE, QUOTE) => true
            case (DOLLAR, DOLLAR) => true
            case (LET, LET) => true
            case (VAR, VAR) => true
            case (CONST, CONST) => true
            case (TYPE, TYPE) => true
            case (INIT, INIT) => true
            case (THIS, THIS) => true
            case (SUPER, SUPER) => true
            case (IF, IF) => true
            case (ELSE, ELSE) => true
            case (CASE, CASE) => true
            case (TRY, TRY) => true
            case (CATCH, CATCH) => true
            case (FINALLY, FINALLY) => true
            case (FOR, FOR) => true
            case (DO, DO) => true
            case (WHILE, WHILE) => true
            case (THROW, THROW) => true
            case (RETURN, RETURN) => true
            case (CONTINUE, CONTINUE) => true
            case (BREAK, BREAK) => true
            case (IN, IN) => true
            case (NOT_IN, NOT_IN) => true
            case (MATCH, MATCH) => true
            case (WHERE, WHERE) => true
            case (EXTEND, EXTEND) => true
            case (WITH, WITH) => true
            case (PROP, PROP) => true
            case (STATIC, STATIC) => true
            case (PUBLIC, PUBLIC) => true
            case (PRIVATE, PRIVATE) => true
            case (INTERNAL, INTERNAL) => true
            case (PROTECTED, PROTECTED) => true
            case (OVERRIDE, OVERRIDE) => true
            case (REDEF, REDEF) => true
            case (ABSTRACT, ABSTRACT) => true
            case (SEALED, SEALED) => true
            case (OPEN, OPEN) => true
            case (FOREIGN, FOREIGN) => true
            case (INOUT, INOUT) => true
            case (MUT, MUT) => true
            case (UNSAFE, UNSAFE) => true
            case (OPERATOR, OPERATOR) => true
            case (SPAWN, SPAWN) => true
            case (SYNCHRONIZED, SYNCHRONIZED) => true
            case (UPPERBOUND, UPPERBOUND) => true
            case (MAIN, MAIN) => true
            case (IDENTIFIER, IDENTIFIER) => true
            case (PACKAGE_IDENTIFIER, PACKAGE_IDENTIFIER) => true
            case (INTEGER_LITERAL, INTEGER_LITERAL) => true
            case (RUNE_BYTE_LITERAL, RUNE_BYTE_LITERAL) => true
            case (FLOAT_LITERAL, FLOAT_LITERAL) => true
            case (COMMENT, COMMENT) => true
            case (NL, NL) => true
            case (END, END) => true
            case (SENTINEL, SENTINEL) => true
            case (RUNE_LITERAL, RUNE_LITERAL) => true
            case (STRING_LITERAL, STRING_LITERAL) => true
            case (SINGLE_QUOTED_STRING_LITERAL, SINGLE_QUOTED_STRING_LITERAL) => true
            case (JSTRING_LITERAL, JSTRING_LITERAL) => true
            case (MULTILINE_STRING, MULTILINE_STRING) => true
            case (MULTILINE_RAW_STRING, MULTILINE_RAW_STRING) => true
            case (BOOL_LITERAL, BOOL_LITERAL) => true
            case (UNIT_LITERAL, UNIT_LITERAL) => true
            case (DOLLAR_IDENTIFIER, DOLLAR_IDENTIFIER) => true
            case (ANNOTATION, ANNOTATION) => true
            case (AT_EXCL, AT_EXCL) => true
            case (HANDLE, HANDLE) => true
            case (PERFORM, PERFORM) => true
            case (RESUME, RESUME) => true
            case (THROWING, THROWING) => true
            case (ILLEGAL, ILLEGAL) => true
            case _ => false
        }
    }

    public operator func !=(right: TokenKind): Bool {
        return !(this == right)
    }

    public func toString(): String {
        return match (this) {
            case DOT => return "DOT"
            case COMMA => return "COMMA"
            case LPAREN => return "LPAREN"
            case RPAREN => return "RPAREN"
            case LSQUARE => return "LSQUARE"
            case RSQUARE => return "RSQUARE"
            case LCURL => return "LCURL"
            case RCURL => return "RCURL"
            case EXP => return "EXP"
            case MUL => return "MUL"
            case MOD => return "MOD"
            case DIV => return "DIV"
            case ADD => return "ADD"
            case SUB => return "SUB"
            case INCR => return "INCR"
            case DECR => return "DECR"
            case AND => return "AND"
            case OR => return "OR"
            case COALESCING => return "COALESCING"
            case PIPELINE => return "PIPELINE"
            case COMPOSITION => return "COMPOSITION"
            case NOT => return "NOT"
            case BITAND => return "BITAND"
            case BITNOT => return "BITNOT"
            case BITOR => return "BITOR"
            case BITXOR => return "BITXOR"
            case LSHIFT => return "LSHIFT"
            case RSHIFT => return "RSHIFT"
            case COLON => return "COLON"
            case SEMI => return "SEMI"
            case ASSIGN => return "ASSIGN"
            case ADD_ASSIGN => return "ADD_ASSIGN"
            case SUB_ASSIGN => return "SUB_ASSIGN"
            case MUL_ASSIGN => return "MUL_ASSIGN"
            case EXP_ASSIGN => return "EXP_ASSIGN"
            case DIV_ASSIGN => return "DIV_ASSIGN"
            case MOD_ASSIGN => return "MOD_ASSIGN"
            case AND_ASSIGN => return "AND_ASSIGN"
            case OR_ASSIGN => return "OR_ASSIGN"
            case BITAND_ASSIGN => return "BITAND_ASSIGN"
            case BITOR_ASSIGN => return "BITOR_ASSIGN"
            case BITXOR_ASSIGN => return "BITXOR_ASSIGN"
            case LSHIFT_ASSIGN => return "LSHIFT_ASSIGN"
            case RSHIFT_ASSIGN => return "RSHIFT_ASSIGN"
            case ARROW => return "ARROW"
            case BACKARROW => return "BACKARROW"
            case DOUBLE_ARROW => return "DOUBLE_ARROW"
            case RANGEOP => return "RANGEOP"
            case CLOSEDRANGEOP => return "CLOSEDRANGEOP"
            case ELLIPSIS => return "ELLIPSIS"
            case HASH => return "HASH"
            case AT => return "AT"
            case AT_EXCL => return "AT_EXCLAMATION"
            case QUEST => return "QUEST"
            case LT => return "LT"
            case GT => return "GT"
            case LE => return "LE"
            case GE => return "GE"
            case IS => return "IS"
            case AS => return "AS"
            case NOTEQ => return "NOTEQ"
            case EQUAL => return "EQUAL"
            case WILDCARD => return "WILDCARD"
            case INT8 => return "INT8"
            case INT16 => return "INT16"
            case INT32 => return "INT32"
            case INT64 => return "INT64"
            case INTNATIVE => return "INTNATIVE"
            case UINT8 => return "UINT8"
            case UINT16 => return "UINT16"
            case UINT32 => return "UINT32"
            case UINT64 => return "UINT64"
            case UINTNATIVE => return "UINTNATIVE"
            case FLOAT16 => return "FLOAT16"
            case FLOAT32 => return "FLOAT32"
            case FLOAT64 => return "FLOAT64"
            case RUNE => return "RUNE"
            case BOOLEAN => return "BOOLEAN"
            case NOTHING => return "NOTHING"
            case UNIT => return "UNIT"
            case STRUCT => return "STRUCT"
            case ENUM => return "ENUM"
            case VARRAY => return "VARRAY"
            case THISTYPE => return "THISTYPE"
            case PACKAGE => return "PACKAGE"
            case IMPORT => return "IMPORT"
            case CLASS => return "CLASS"
            case INTERFACE => return "INTERFACE"
            case FUNC => return "FUNC"
            case MACRO => return "MACRO"
            case QUOTE => return "QUOTE"
            case DOLLAR => return "DOLLAR"
            case LET => return "LET"
            case VAR => return "VAR"
            case CONST => return "CONST"
            case TYPE => return "TYPE"
            case INIT => return "INIT"
            case THIS => return "THIS"
            case SUPER => return "SUPER"
            case IF => return "IF"
            case ELSE => return "ELSE"
            case CASE => return "CASE"
            case TRY => return "TRY"
            case CATCH => return "CATCH"
            case FINALLY => return "FINALLY"
            case FOR => return "FOR"
            case DO => return "DO"
            case WHILE => return "WHILE"
            case THROW => return "THROW"
            case RETURN => return "RETURN"
            case CONTINUE => return "CONTINUE"
            case BREAK => return "BREAK"
            case IN => return "IN"
            case NOT_IN => return "NOT_IN"
            case MATCH => return "MATCH"
            case WHERE => return "WHERE"
            case EXTEND => return "EXTEND"
            case WITH => return "WITH"
            case PROP => return "PROP"
            case STATIC => return "STATIC"
            case PUBLIC => return "PUBLIC"
            case PRIVATE => return "PRIVATE"
            case INTERNAL => return "INTERNAL"
            case PROTECTED => return "PROTECTED"
            case OVERRIDE => return "OVERRIDE"
            case REDEF => return "REDEF"
            case ABSTRACT => return "ABSTRACT"
            case SEALED => return "SEALED"
            case OPEN => return "OPEN"
            case FOREIGN => return "FOREIGN"
            case INOUT => return "INOUT"
            case MUT => return "MUT"
            case UNSAFE => return "UNSAFE"
            case OPERATOR => return "OPERATOR"
            case SPAWN => return "SPAWN"
            case SYNCHRONIZED => return "SYNCHRONIZED"
            case UPPERBOUND => return "UPPERBOUND"
            case MAIN => return "MAIN"
            case IDENTIFIER => return "IDENTIFIER"
            case PACKAGE_IDENTIFIER => return "PACKAGE_IDENTIFIER"
            case INTEGER_LITERAL => return "INTEGER_LITERAL"
            case RUNE_BYTE_LITERAL => return "RUNE_BYTE_LITERAL"
            case FLOAT_LITERAL => return "FLOAT_LITERAL"
            case COMMENT => return "COMMENT"
            case NL => return "NL"
            case END => return "END"
            case SENTINEL => return "SENTINEL"
            case RUNE_LITERAL => return "RUNE_LITERAL"
            case STRING_LITERAL => return "STRING_LITERAL"
            case SINGLE_QUOTED_STRING_LITERAL => return "SINGLE_QUOTED_STRING_LITERAL"
            case JSTRING_LITERAL => return "JSTRING_LITERAL"
            case MULTILINE_STRING => return "MULTILINE_STRING"
            case MULTILINE_RAW_STRING => return "MULTILINE_RAW_STRING"
            case BOOL_LITERAL => return "BOOL_LITERAL"
            case UNIT_LITERAL => return "UNIT_LITERAL"
            case DOLLAR_IDENTIFIER => return "DOLLAR_IDENTIFIER"
            case ANNOTATION => return "ANNOTATION"
            case HANDLE => return "HANDLE"
            case PERFORM => return "PERFORM"
            case RESUME => return "RESUME"
            case THROWING => return "THROWING"
            case ILLEGAL => return "ILLEGAL"
            case _ => return "INVALID_TOKENKIND"
        }
    }

    func opPrecedence() {
        return match (this) {
            case AT | AT_EXCL => return 18
            case DOT | LPAREN | RPAREN | LSQUARE | RSQUARE => return 17
            case INCR | DECR | QUEST => return 16
            case NOT => return 15
            case EXP => return 14
            case MUL | MOD | DIV => return 13
            case ADD | SUB => return 12
            case LSHIFT | RSHIFT => return 11
            case RANGEOP | CLOSEDRANGEOP => return 10
            case LT | GT | LE | GE | IS | AS => return 9
            case NOTEQ | EQUAL => return 8
            case BITAND => return 7
            case BITXOR => return 6
            case BITOR => return 5
            case AND => return 4
            case OR => return 3
            case COALESCING => return 2
            case PIPELINE | COMPOSITION => return 1
            case _ => return 0
        }
    }

    func isNonAssociative() {
        return match (this) {
            case LT | GT | LE | GE | IS | AS | NOTEQ | EQUAL => return true
            case _ => return false
        }
    }
}

/**
 * PATTERNS is a Look-up Table for TokenKind, TokenKindValue, TokenLiteral.
 * XXX: To add TokenPrecedence? Use map if map can solve the problem.
 * The ORDER MUST be the SAME as the ones in Tokens.inc.
 */
let PATTERNS: Array<(TokenKind, String, String)> = [
    (TokenKind.DOT, "dot", "."),
    (TokenKind.COMMA, "comma", ","),
    (TokenKind.LPAREN, "l_paren", "("),
    (TokenKind.RPAREN, "r_paren", ")"),
    (TokenKind.LSQUARE, "l_square", "["),
    (TokenKind.RSQUARE, "r_square", "]"),
    (TokenKind.LCURL, "l_curl", "{"),
    (TokenKind.RCURL, "r_curl", "}"),
    (TokenKind.EXP, "exp", "**"),
    (TokenKind.MUL, "mul", "*"),
    (TokenKind.MOD, "mod", "%"),
    (TokenKind.DIV, "div", "/"),
    (TokenKind.ADD, "add", "+"),
    (TokenKind.SUB, "sub", "-"),
    (TokenKind.INCR, "incr", "++"),
    (TokenKind.DECR, "decr", "--"),
    (TokenKind.AND, "and", "&&"),
    (TokenKind.OR, "or", "||"),
    (TokenKind.COALESCING, "coalescing", "??"),
    (TokenKind.PIPELINE, "pipeline", "|>"),
    (TokenKind.COMPOSITION, "composition", "~>"),
    (TokenKind.NOT, "not", "!"),
    (TokenKind.BITAND, "bit_and", "&"),
    (TokenKind.BITOR, "bit_or", "|"),
    (TokenKind.BITXOR, "bit_xor", "^"),
    (TokenKind.BITNOT, "bit_not", "~"),
    (TokenKind.LSHIFT, "lshift", "<<"),
    (TokenKind.RSHIFT, "rshift", ">>"),
    (TokenKind.COLON, "colon", ":"),
    (TokenKind.SEMI, "semi", ";"),
    (TokenKind.ASSIGN, "assign", "="),
    (TokenKind.ADD_ASSIGN, "add_assign", "+="),
    (TokenKind.SUB_ASSIGN, "sub_assign", "-="),
    (TokenKind.MUL_ASSIGN, "mul_assign", "*="),
    (TokenKind.EXP_ASSIGN, "exp_assign", "**="),
    (TokenKind.DIV_ASSIGN, "div_assign", "/="),
    (TokenKind.MOD_ASSIGN, "mod_assign", "%="),
    (TokenKind.AND_ASSIGN, "and_assign", "&&="),
    (TokenKind.OR_ASSIGN, "or_assign", "||="),
    (TokenKind.BITAND_ASSIGN, "bit_and_assign", "&="),
    (TokenKind.BITOR_ASSIGN, "bit_or_assign", "|="),
    (TokenKind.BITXOR_ASSIGN, "bit_xor_assign", "^="),
    (TokenKind.LSHIFT_ASSIGN, "lshift_assign", "<<="),
    (TokenKind.RSHIFT_ASSIGN, "rshift_assign", ">>="),
    (TokenKind.ARROW, "arrow", "->"),
    (TokenKind.BACKARROW, "backarrow", "<-"),
    (TokenKind.DOUBLE_ARROW, "double_arrow", "=>"),
    (TokenKind.RANGEOP, "range_op", ".."),
    (TokenKind.CLOSEDRANGEOP, "closed_range_op", "..="),
    (TokenKind.ELLIPSIS, "ellipsis", "..."),
    (TokenKind.HASH, "hash", "#"),
    (TokenKind.AT, "at", "@"),
    (TokenKind.QUEST, "quest", "?"),
    (TokenKind.LT, "less", "<"),
    (TokenKind.GT, "greater", ">"),
    (TokenKind.LE, "less_equal", "<="),
    (TokenKind.GE, "greater_equal", ">="),
    (TokenKind.IS, "is", "is"),
    (TokenKind.AS, "as", "as"),
    (TokenKind.NOTEQ, "not_equal", "!="),
    (TokenKind.EQUAL, "equal", "=="),
    (TokenKind.WILDCARD, "wildcard", "_"),
    (TokenKind.INT8, "Int8", "Int8"),
    (TokenKind.INT16, "Int16", "Int16"),
    (TokenKind.INT32, "Int32", "Int32"),
    (TokenKind.INT64, "Int64", "Int64"),
    (TokenKind.INTNATIVE, "IntNative", "IntNative"),
    (TokenKind.UINT8, "UInt8", "UInt8"),
    (TokenKind.UINT16, "UInt16", "UInt16"),
    (TokenKind.UINT32, "UInt32", "UInt32"),
    (TokenKind.UINT64, "UInt64", "UInt64"),
    (TokenKind.UINTNATIVE, "UIntNative", "UIntNative"),
    (TokenKind.FLOAT16, "Float16", "Float16"),
    (TokenKind.FLOAT32, "Float32", "Float32"),
    (TokenKind.FLOAT64, "Float64", "Float64"),
    (TokenKind.RUNE, "Rune", "Rune"),
    (TokenKind.BOOLEAN, "Bool", "Bool"),
    (TokenKind.NOTHING, "Nothing", "Nothing"),
    (TokenKind.UNIT, "Unit", "Unit"),
    (TokenKind.STRUCT, "struct", "struct"),
    (TokenKind.ENUM, "enum", "enum"),
    (TokenKind.VARRAY, "VArray", "VArray"),
    (TokenKind.THISTYPE, "This", "This"),
    (TokenKind.PACKAGE, "package", "package"),
    (TokenKind.IMPORT, "import", "import"),
    (TokenKind.CLASS, "class", "class"),
    (TokenKind.INTERFACE, "interface", "interface"),
    (TokenKind.FUNC, "func", "func"),
    (TokenKind.MACRO, "macro", "macro"),
    (TokenKind.QUOTE, "quote", "quote"),
    (TokenKind.DOLLAR, "dollar", "$"),
    (TokenKind.LET, "let", "let"),
    (TokenKind.VAR, "var", "var"),
    (TokenKind.CONST, "const", "const"),
    (TokenKind.TYPE, "type", "type"),
    (TokenKind.INIT, "init", "init"),
    (TokenKind.THIS, "this", "this"),
    (TokenKind.SUPER, "super", "super"),
    (TokenKind.IF, "if", "if"),
    (TokenKind.ELSE, "else", "else"),
    (TokenKind.CASE, "case", "case"),
    (TokenKind.TRY, "try", "try"),
    (TokenKind.CATCH, "catch", "catch"),
    (TokenKind.FINALLY, "finally", "finally"),
    (TokenKind.FOR, "for", "for"),
    (TokenKind.DO, "do", "do"),
    (TokenKind.WHILE, "while", "while"),
    (TokenKind.THROW, "throw", "throw"),
    (TokenKind.RETURN, "return", "return"),
    (TokenKind.CONTINUE, "continue", "continue"),
    (TokenKind.BREAK, "break", "break"),
    (TokenKind.IN, "in", "in"),
    (TokenKind.NOT_IN, "not_in", "!in"),
    (TokenKind.MATCH, "match", "match"),
    (TokenKind.WHERE, "where", "where"),
    (TokenKind.EXTEND, "extend", "extend"),
    (TokenKind.WITH, "with", "with"),
    (TokenKind.PROP, "prop", "prop"),
    (TokenKind.STATIC, "static", "static"),
    (TokenKind.PUBLIC, "public", "public"),
    (TokenKind.PRIVATE, "private", "private"),
    (TokenKind.INTERNAL, "internal", "internal"),
    (TokenKind.PROTECTED, "protected", "protected"),
    (TokenKind.OVERRIDE, "override", "override"),
    (TokenKind.REDEF, "redef", "redef"),
    (TokenKind.ABSTRACT, "abstract", "abstract"),
    (TokenKind.SEALED, "sealed", "sealed"),
    (TokenKind.OPEN, "open", "open"),
    (TokenKind.FOREIGN, "foreign", "foreign"),
    (TokenKind.INOUT, "inout", "inout"),
    (TokenKind.MUT, "mut", "mut"),
    (TokenKind.UNSAFE, "unsafe", "unsafe"),
    (TokenKind.OPERATOR, "operator", "operator"),
    (TokenKind.SPAWN, "spawn", "spawn"),
    (TokenKind.SYNCHRONIZED, "synchronized", "synchronized"),
    (TokenKind.UPPERBOUND, "upperbound", "<:"),
    (TokenKind.MAIN, "main", "main"),
    (TokenKind.IDENTIFIER, "identifier", ""),
    (TokenKind.PACKAGE_IDENTIFIER, "package_identifier", ""),
    (TokenKind.INTEGER_LITERAL, "integer_literal", ""),
    (TokenKind.RUNE_BYTE_LITERAL, "rune_byte_literal", ""),
    (TokenKind.FLOAT_LITERAL, "float_literal", ""),
    (TokenKind.COMMENT, "comment", ""),
    (TokenKind.NL, "newline", ""),
    (TokenKind.END, "end", ""),
    (TokenKind.SENTINEL, "sentinel", ""),
    (TokenKind.RUNE_LITERAL, "char_literal", ""),
    (TokenKind.STRING_LITERAL, "double_quoted_string_literal", ""),
    (TokenKind.JSTRING_LITERAL, "jstring_literal", ""),
    (TokenKind.MULTILINE_STRING, "multiline_string", ""),
    (TokenKind.MULTILINE_RAW_STRING, "multiline_raw_string", ""),
    (TokenKind.BOOL_LITERAL, "bool_literal", ""),
    (TokenKind.UNIT_LITERAL, "unit_literal", "()"),
    (TokenKind.DOLLAR_IDENTIFIER, "dollar_identifier", ""),
    (TokenKind.ANNOTATION, "annotation", ""),
    (TokenKind.AT_EXCL, "at_exclamation", "@!"),
    (TokenKind.PERFORM, "perform", "perform"),
    (TokenKind.RESUME, "resume", "resume"),
    (TokenKind.THROWING, "throwing", "throwing"),
    (TokenKind.HANDLE, "handle", "handle"),
    (TokenKind.ILLEGAL, "illegal", "")
]

/**
 * Conversion function for Enum to UInt16
 */
func getTokenID(tk: TokenKind): UInt16 {
    match (tk) {
        case TokenKind.DOT => return 0
        case TokenKind.COMMA => return 1
        case TokenKind.LPAREN => return 2
        case TokenKind.RPAREN => return 3
        case TokenKind.LSQUARE => return 4
        case TokenKind.RSQUARE => return 5
        case TokenKind.LCURL => return 6
        case TokenKind.RCURL => return 7
        case TokenKind.EXP => return 8
        case TokenKind.MUL => return 9
        case TokenKind.MOD => return 10
        case TokenKind.DIV => return 11
        case TokenKind.ADD => return 12
        case TokenKind.SUB => return 13
        case TokenKind.INCR => return 14
        case TokenKind.DECR => return 15
        case TokenKind.AND => return 16
        case TokenKind.OR => return 17
        case TokenKind.COALESCING => return 18
        case TokenKind.PIPELINE => return 19
        case TokenKind.COMPOSITION => return 20
        case TokenKind.NOT => return 21
        case TokenKind.BITAND => return 22
        case TokenKind.BITOR => return 23
        case TokenKind.BITXOR => return 24
        case TokenKind.BITNOT => return 25
        case TokenKind.LSHIFT => return 26
        case TokenKind.RSHIFT => return 27
        case TokenKind.COLON => return 28
        case TokenKind.SEMI => return 29
        case TokenKind.ASSIGN => return 30
        case TokenKind.ADD_ASSIGN => return 31
        case TokenKind.SUB_ASSIGN => return 32
        case TokenKind.MUL_ASSIGN => return 33
        case TokenKind.EXP_ASSIGN => return 34
        case TokenKind.DIV_ASSIGN => return 35
        case TokenKind.MOD_ASSIGN => return 36
        case TokenKind.AND_ASSIGN => return 37
        case TokenKind.OR_ASSIGN => return 38
        case TokenKind.BITAND_ASSIGN => return 39
        case TokenKind.BITOR_ASSIGN => return 40
        case TokenKind.BITXOR_ASSIGN => return 41
        case TokenKind.LSHIFT_ASSIGN => return 42
        case TokenKind.RSHIFT_ASSIGN => return 43
        case TokenKind.ARROW => return 44
        case TokenKind.BACKARROW => return 45
        case TokenKind.DOUBLE_ARROW => return 46
        case TokenKind.RANGEOP => return 47
        case TokenKind.CLOSEDRANGEOP => return 48
        case TokenKind.ELLIPSIS => return 49
        case TokenKind.HASH => return 50
        case TokenKind.AT => return 51
        case TokenKind.QUEST => return 52
        case TokenKind.LT => return 53
        case TokenKind.GT => return 54
        case TokenKind.LE => return 55
        case TokenKind.GE => return 56
        case TokenKind.IS => return 57
        case TokenKind.AS => return 58
        case TokenKind.NOTEQ => return 59
        case TokenKind.EQUAL => return 60
        case TokenKind.WILDCARD => return 61
        case TokenKind.INT8 => return 62
        case TokenKind.INT16 => return 63
        case TokenKind.INT32 => return 64
        case TokenKind.INT64 => return 65
        case TokenKind.INTNATIVE => return 66
        case TokenKind.UINT8 => return 67
        case TokenKind.UINT16 => return 68
        case TokenKind.UINT32 => return 69
        case TokenKind.UINT64 => return 70
        case TokenKind.UINTNATIVE => return 71
        case TokenKind.FLOAT16 => return 72
        case TokenKind.FLOAT32 => return 73
        case TokenKind.FLOAT64 => return 74
        case TokenKind.RUNE => return 75
        case TokenKind.BOOLEAN => return 76
        case TokenKind.NOTHING => return 77
        case TokenKind.UNIT => return 78
        case TokenKind.STRUCT => return 79
        case TokenKind.ENUM => return 80
        case TokenKind.VARRAY => return 81
        case TokenKind.THISTYPE => return 82
        case TokenKind.PACKAGE => return 83
        case TokenKind.IMPORT => return 84
        case TokenKind.CLASS => return 85
        case TokenKind.INTERFACE => return 86
        case TokenKind.FUNC => return 87
        case TokenKind.MACRO => return 88
        case TokenKind.QUOTE => return 89
        case TokenKind.DOLLAR => return 90
        case TokenKind.LET => return 91
        case TokenKind.VAR => return 92
        case TokenKind.CONST => return 93
        case TokenKind.TYPE => return 94
        case TokenKind.INIT => return 95
        case TokenKind.THIS => return 96
        case TokenKind.SUPER => return 97
        case TokenKind.IF => return 98
        case TokenKind.ELSE => return 99
        case TokenKind.CASE => return 100
        case TokenKind.TRY => return 101
        case TokenKind.CATCH => return 102
        case TokenKind.FINALLY => return 103
        case TokenKind.FOR => return 104
        case TokenKind.DO => return 105
        case TokenKind.WHILE => return 106
        case TokenKind.THROW => return 107
        case TokenKind.RETURN => return 108
        case TokenKind.CONTINUE => return 109
        case TokenKind.BREAK => return 110
        case TokenKind.IN => return 111
        case TokenKind.NOT_IN => return 112
        case TokenKind.MATCH => return 113
        case TokenKind.WHERE => return 114
        case TokenKind.EXTEND => return 115
        case TokenKind.WITH => return 116
        case TokenKind.PROP => return 117
        case TokenKind.STATIC => return 118
        case TokenKind.PUBLIC => return 119
        case TokenKind.PRIVATE => return 120
        case TokenKind.INTERNAL => return 121
        case TokenKind.PROTECTED => return 122
        case TokenKind.OVERRIDE => return 123
        case TokenKind.REDEF => return 124
        case TokenKind.ABSTRACT => return 125
        case TokenKind.SEALED => return 126
        case TokenKind.OPEN => return 127
        case TokenKind.FOREIGN => return 128
        case TokenKind.INOUT => return 129
        case TokenKind.MUT => return 130
        case TokenKind.UNSAFE => return 131
        case TokenKind.OPERATOR => return 132
        case TokenKind.SPAWN => return 133
        case TokenKind.SYNCHRONIZED => return 134
        case TokenKind.UPPERBOUND => return 135
        case TokenKind.MAIN => return 136
        case TokenKind.IDENTIFIER => return 137
        case TokenKind.PACKAGE_IDENTIFIER => return 138
        case TokenKind.INTEGER_LITERAL => return 139
        case TokenKind.RUNE_BYTE_LITERAL => return 140
        case TokenKind.FLOAT_LITERAL => return 141
        case TokenKind.COMMENT => return 142
        case TokenKind.NL => return 143
        case TokenKind.END => return 144
        case TokenKind.SENTINEL => return 145
        case TokenKind.RUNE_LITERAL => return 146
        case TokenKind.STRING_LITERAL => return 147
        case TokenKind.SINGLE_QUOTED_STRING_LITERAL => return 147
        case TokenKind.JSTRING_LITERAL => return 148
        case TokenKind.MULTILINE_STRING => return 149
        case TokenKind.MULTILINE_RAW_STRING => return 150
        case TokenKind.BOOL_LITERAL => return 151
        case TokenKind.UNIT_LITERAL => return 152
        case TokenKind.DOLLAR_IDENTIFIER => return 153
        case TokenKind.ANNOTATION => return 154
        case TokenKind.AT_EXCL => return 155
        case TokenKind.PERFORM => return 156
        case TokenKind.RESUME => return 157
        case TokenKind.THROWING => return 158
        case TokenKind.HANDLE => return 159
        case _ => return 160
    }
}

/**
 * Conversion function for UInt16 to Enum
 */
public func getTokenKind(no: UInt16): TokenKind {
    let maxSize = PATTERNS.size
    let index = Int64(no)
    if (index >= maxSize) {
        /* Return ILLEGAL Token. */
        return PATTERNS[maxSize - 1][0]
    }
    return PATTERNS[index][0];
}

@When[os == "Windows"]
func getNewlineValue(): String {
    "\r\n"
}

@When[os != "Windows"]
func getNewlineValue(): String {
    "\n"
}

func getTokenKindValue(tk: TokenKind): String {
    if (tk == SINGLE_QUOTED_STRING_LITERAL) {
        return "single_quoted_string_literal"
    }
    let no = Int64(getTokenID(tk))
    return PATTERNS[no][1]
}

func getTokenLiteral(tk: TokenKind): String {
    if (tk == TokenKind.NL) {
        return getNewlineValue()
    }
    let no = Int64(getTokenID(tk))
    return PATTERNS[no][2]
}

/**
 * A helper class for querying TokenKind information.
 */
class TokenKindHelper {
    /* See 'enum class LitConstKind' in Node.h */
    static let LIT_CONST_KIND_TO_TOKEN_KIND: Array<TokenKind> = [
        TokenKind.INTEGER_LITERAL,
        TokenKind.RUNE_BYTE_LITERAL,
        TokenKind.FLOAT_LITERAL,
        TokenKind.RUNE_LITERAL,
        TokenKind.STRING_LITERAL,
        TokenKind.JSTRING_LITERAL,
        TokenKind.BOOL_LITERAL,
        TokenKind.UNIT_LITERAL
    ]

    /* see 'enum class StringKind' in Node.h */
    static let STRING_KIND_TO_TOKEN_KIND: Array<TokenKind> = [
        TokenKind.STRING_LITERAL,
        TokenKind.JSTRING_LITERAL,
        TokenKind.MULTILINE_STRING,
        TokenKind.MULTILINE_RAW_STRING
    ]

    /* PrimitiveTypeKind. */
    /* The ORDER MUST be the SAME as the ones defined in 'enum class TypeKind' in Types.h. */
    static let PRIMITIVE_TYPE_KIND_TO_TOKEN_KIND: Array<TokenKind> = [
        TokenKind.ILLEGAL, /* TYPE_INVALID */
        TokenKind.UNIT,
        TokenKind.INT8,
        TokenKind.INT16,
        TokenKind.INT32,
        TokenKind.INT64,
        TokenKind.INTNATIVE,
        TokenKind.ILLEGAL, /* Placeholder for TYPE_IDEAL_INT */
        TokenKind.UINT8,
        TokenKind.UINT16,
        TokenKind.UINT32,
        TokenKind.UINT64,
        TokenKind.UINTNATIVE,
        TokenKind.FLOAT16,
        TokenKind.FLOAT32,
        TokenKind.FLOAT64,
        TokenKind.ILLEGAL, /* Placeholder for TYPE_IDEAL_FLOAT */
        TokenKind.RUNE,
        TokenKind.NOTHING,
        TokenKind.BOOLEAN
    ]

    static func getPrimitiveTypeTokenKind(i: UInt16): TokenKind {
        let sz = PRIMITIVE_TYPE_KIND_TO_TOKEN_KIND.size
        return if (Int64(i) < sz) {
            PRIMITIVE_TYPE_KIND_TO_TOKEN_KIND[Int64(i)]
        } else {
            TokenKind.ILLEGAL
        }
    }

    static func getLiteralConstKind(i: UInt16): TokenKind {
        let sz = LIT_CONST_KIND_TO_TOKEN_KIND.size
        return if (Int64(i) < sz) {
            LIT_CONST_KIND_TO_TOKEN_KIND[Int64(i)]
        } else {
            TokenKind.ILLEGAL
        }
    }

    static func getStringKind(i: UInt16): TokenKind {
        let sz = STRING_KIND_TO_TOKEN_KIND.size
        return if (Int64(i) < sz) {
            STRING_KIND_TO_TOKEN_KIND[Int64(i)]
        } else {
            TokenKind.ILLEGAL
        }
    }
}
