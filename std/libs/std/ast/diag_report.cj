







package std.ast


public enum DiagReportLevel {
    | ERROR
    | WARNING

    /*
     * @noThrow
     */
    public func level(): Int32 {
        let num = match (this) {
            case ERROR => 0
            case WARNING => 1
        }
        return Int32(num)
    }
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 * @throws ASTException
 */
public func diagReport(level: DiagReportLevel, tokens: Tokens, message: String, hint: String): Unit {
    let macroObjPtr = match (MACRO_OBJECT.get()) {
        case Some(v) => v
        case None => return
    }

    if (tokens.size != 0) {
        let fileID = tokens[0].pos.fileID
        for (token in tokens) {
            if (token.pos.fileID != fileID) {
                throw ASTException("Input tokens are not from a single file.")
            }
        }

        let beginPos = tokens[0].pos
        let endPos = tokens[tokens.size - 1].pos
        if (beginPos.line > endPos.line || beginPos.line == endPos.line && beginPos.column > endPos.column) {
            throw ASTException("Illegal input tokens.")
        }
    }

    let tokensBytes: Array<UInt8> = tokens.toBytes()
    var ret: UInt8 = 0;
    unsafe {
        try (pTokensBytes = unsafePointerCastFromUint8Array(tokensBytes).asResource(), pLevel = LibC
            .malloc<Int32>()
            .asResource(), pMessage = LibC.mallocCString(message).asResource(), pHint = LibC
            .mallocCString(hint)
            .asResource()) {
            pLevel.value.write(level.level())
            ret = CJ_AST_DiagReport(macroObjPtr, pLevel.value, pTokensBytes.value, pMessage.value, pHint.value)
        }
    }

    let rangeError: UInt8 = 1
    let fileIDError: UInt8 = 2
    match {
        case ret == rangeError => throw ASTException("The range of input tokens is out of the macro call range.")
        case ret == fileIDError => throw ASTException("Input tokens is not from the macro call.")
        case _ => ()
    }
}
