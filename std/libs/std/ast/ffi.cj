







package std.ast

import std.collection.ArrayList

let MACRO_OBJECT = ThreadLocal<CPointer<Unit>>()

foreign {
    func CJ_AST_ParseExpr(fptr: CPointer<Unit>, tokensBytes: CPointer<UInt8>, tokenCounter: CPointer<Int64>): CPointer<ParseRes>

    func CJ_AST_ParseDecl(fptr: CPointer<Unit>, tokensBytes: CPointer<UInt8>, tokenCounter: CPointer<Int64>): CPointer<ParseRes>

    func CJ_AST_ParsePropMemberDecl(fptr: CPointer<Unit>, tokensBytes: CPointer<UInt8>): CPointer<ParseRes>

    func CJ_AST_ParsePrimaryConstructor(fptr: CPointer<Unit>, tokensBytes: CPointer<UInt8>): CPointer<ParseRes>

    func CJ_AST_ParsePattern(fptr: CPointer<Unit>, tokensBytes: CPointer<UInt8>, tokenCounter: CPointer<Int64>): CPointer<ParseRes>

    func CJ_AST_ParseType(fptr: CPointer<Unit>, tokensBytes: CPointer<UInt8>, tokenCounter: CPointer<Int64>): CPointer<ParseRes>

    func CJ_AST_ParseTopLevel(fptr: CPointer<Unit>, tokensBytes: CPointer<UInt8>): CPointer<ParseRes>

    func CJ_AST_ParseAnnotationArguments(tokensBytes: CPointer<UInt8>): CPointer<ParseRes>

    func CJ_AST_Lex(fptr: CPointer<Unit>, code: CString): CPointer<UInt8>

    func CJ_CheckParentContext(fptr: CPointer<Unit>, parent: CString, report: Bool): Bool

    func CJ_SetItemInfo(fptr: CPointer<Unit>, key: CString, value: CPointer<Unit>, valueType: UInt8): Unit

    func CJ_GetChildMessages(fptr: CPointer<Unit>, children: CString): CPointer<CPointer<CPointer<Unit>>>

    func CJ_CheckAddSpace(tokBytes: CPointer<UInt8>, spaceFlag: CPointer<Bool>): Unit

    func CJ_AST_DiagReport(fptr: CPointer<Unit>, level: CPointer<Int32>, tokensBytes: CPointer<UInt8>, message: CString,
        hint: CString): UInt8

    func CJ_GetMacroPosition(fptr: CPointer<Unit>, fileID: CPointer<UInt32>, line: CPointer<Int32>,
        column: CPointer<Int32>): Unit

    func CJ_AST_Float64ToCPointer(num: Float64): CString
}


let BUFFER_HEADER_SIZE: Int64 = 4


/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func getInt32FromUnsafePointer(ptr: CPointer<UInt8>): Int32 {
    var buf = Array<UInt8>(BUFFER_HEADER_SIZE, {x: Int64 => unsafe { ptr.read(x) }})
    return getInt32(buf[0..4])
}

@C
struct ParseRes {
    let node: CPointer<UInt8> = CPointer<UInt8>()
    let errMsg: CString = CString(CPointer<UInt8>())
}

/*
 * @throws IllegalMemoryException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws ParseASTException
 */
unsafe func parse(input: Tokens, nativeParse: (CPointer<UInt8>) -> CPointer<ParseRes>): NodeFormat_Node {
    let tokensBytes: Array<UInt8> = input.toBytes()
    let pTokensBytes: CPointer<UInt8> = unsafePointerCastFromUint8Array(tokensBytes)
    let parseResultRaw: CPointer<ParseRes> = nativeParse(pTokensBytes)
    if (parseResultRaw.isNull()) {
        LibC.free(pTokensBytes)
        throw ParseASTException("Unable to get parseResult.")
    }
    let pNode = parseResultRaw.read().node
    let pErrorMsg = parseResultRaw.read().errMsg
    try {
        if (!pErrorMsg.isNull()) {
            let errorMsg = pErrorMsg.toString()
            if (errorMsg.size > 0) {
                LibC.free(pTokensBytes)
                LibC.free(pNode)
                throw ParseASTException(errorMsg)
            }
        }
    } finally {
        LibC.free(pErrorMsg)
        LibC.free(parseResultRaw)
    }



    let node = genNodeFormatNode(pNode, pTokensBytes)
    return node
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws ParseASTException
 * @throws IllegalMemoryException
 */
unsafe func parseFragment(
    input: Tokens,
    startFrom: Int64,
    nativeParse: CFunc<(CPointer<UInt8>, CPointer<Int64>) -> CPointer<ParseRes>>
): (NodeFormat_Node, Int64) {
    let tokensBytes: Array<UInt8> = input.toBytes(startFrom)
    let pTokensBytes: CPointer<UInt8> = unsafePointerCastFromUint8Array(tokensBytes)
    var tokenCounter: Int64 = -1
    let sizeRef = LibC.malloc<Int64>()
    if (sizeRef.isNull()) {
        LibC.free(pTokensBytes)
        throw IllegalMemoryException("parseFragment malloc failed!")
    }
    let parseResultRaw = nativeParse(pTokensBytes, sizeRef)
    if (parseResultRaw.isNull()) {
        LibC.free(pTokensBytes)
        LibC.free(sizeRef)
        throw ParseASTException("Unable to get parseResult.")
    }
    tokenCounter = sizeRef.read()
    let pNode = parseResultRaw.read().node
    let pErrorMsg = parseResultRaw.read().errMsg
    try {
        if (!pErrorMsg.isNull()) {
            let errorMsg = pErrorMsg.toString()
            if (errorMsg.size > 0) {
                LibC.free(pTokensBytes)
                LibC.free(pNode)
                throw ParseASTException(errorMsg)
            }
        }
    } finally {
        LibC.free(sizeRef)
        LibC.free(pErrorMsg)
        LibC.free(parseResultRaw)
    }



    let node = genNodeFormatNode(pNode, pTokensBytes)
    return (node, tokenCounter + startFrom)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func genNodeFormatNode(pNode: CPointer<UInt8>, pTokensBytes: CPointer<UInt8>) {
    if (pNode.isNull()) {
        unsafe { LibC.free(pTokensBytes) }
        throw IllegalArgumentException("Negative or zero length.\n")
    }
    let bufferSize: Int64 = Int64(getInt32FromUnsafePointer(pNode))
    if (bufferSize <= 0) {
        unsafe {
            LibC.free(pNode)
            LibC.free(pTokensBytes)
        }
        throw IllegalArgumentException("Negative or zero length.\n")
    }
    let flatBuf = Array<UInt8>(bufferSize, {x: Int64 => unsafe { pNode.read(x) }})
    unsafe {
        LibC.free(pNode)
        LibC.free(pTokensBytes)
    }
    return NodeFormat_Node(flatBuf[BUFFER_HEADER_SIZE..], 0)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func getTokensFromBytes(pTokenArray: CPointer<UInt8>): Tokens {
    var length: Int64 = Int64(getInt32FromUnsafePointer(pTokenArray))
    if (length <= 0) {
        throw IllegalArgumentException("Negative or zero length.\n")
    }
    var tokenArray = Array<UInt8>(length, {x: Int64 => unsafe { pTokenArray.read(x) }})
    return Tokens(tokenArray[BUFFER_HEADER_SIZE..])
}




/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public func cangjieLex(code: String): Tokens {
    return cangjieLex(code, true)
}





/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public func cangjieLex(code: String, truncated: Bool): Tokens {
    
    var pCode = unsafe { LibC.mallocCString(code) }
    if (pCode.isNull()) {
        throw IllegalMemoryException("malloc failed.")
    }
    var fPtr = CPointer<Unit>()
    if (let Some(macroObjPtr) <- MACRO_OBJECT.get()) {
        fPtr = macroObjPtr
    }
    var pTokenArray: CPointer<UInt8> = unsafe { CJ_AST_Lex(fPtr, pCode) }
    if (pTokenArray.isNull()) {
        unsafe { LibC.free(pCode) }
        throw IllegalMemoryException("malloc failed.")
    }
    let tokens: Tokens = try {
        getTokensFromBytes(pTokenArray)
    } finally {
        unsafe {
            LibC.free(pTokenArray)
            LibC.free(pCode)
        }
    }
    if (!truncated) {
        return tokens
    }
    if (tokens.size >= 1 && tokens[tokens.size - 1].kind == TokenKind.END) {
        tokens.remove(tokens.size - 1)
    }
    return tokens
}




/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws IllegalMemoryException
 */
func unsafePointerCastFromUint8Array(arr: Array<UInt8>): CPointer<UInt8> {
    let arrSize: Int64 = arr.size
    if (arrSize <= 0) {
        return CPointer<UInt8>()
    }
    var ptr: CPointer<UInt8> = unsafe { LibC.malloc<UInt8>(count: arrSize) }
    if (ptr.isNull()) {
        throw IllegalMemoryException("unsafePointerCastFromUint8Array malloc failed!")
    }
    for (i in 0..arrSize) {
        unsafe { ptr.write(i, arr[i]) }
    }
    return ptr
}


public class MacroContextException <: Exception {
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
        return "MacroAssertParentException"
    }
}








/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Error
 * @throws NoneValueException
 * @throws MacroContextException
 * @throws IllegalMemoryException
 */
public func assertParentContext(parentMacroName: String): Unit {
    unsafe {
        if (let Some(macroObjPtr) <- MACRO_OBJECT.get()) {
            var pStr = LibC.mallocCString(parentMacroName)
            if (pStr.isNull()) {
                throw IllegalMemoryException("assertParentContext malloc failed!")
            }
            var flag = CJ_CheckParentContext(macroObjPtr, pStr, true)
            LibC.free(pStr)
            if (!flag) {
                throw MacroContextException("context check for parent Macro ${parentMacroName} failed")
            }
        }
    }
}






/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public func insideParentContext(parentMacroName: String): Bool {
    unsafe {
        if (let Some(macroObjPtr) <- MACRO_OBJECT.get()) {
            var pStr = LibC.mallocCString(parentMacroName)
            if (pStr.isNull()) {
                throw IllegalMemoryException("insideParentContext malloc failed!")
            }
            var flag = CJ_CheckParentContext(macroObjPtr, pStr, false)
            LibC.free(pStr)
            return flag
        }
    }
    return false
}

let ITEM_TYPE_STRING: UInt8 = 1
let ITEM_TYPE_INT64: UInt8 = 2
let ITEM_TYPE_BOOL: UInt8 = 3
let ITEM_TYPE_TOKENS: UInt8 = 4






/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public func setItem(key: String, value: String): Unit {
    unsafe {
        if (let Some(macroObjPtr) <- MACRO_OBJECT.get()) {
            var keyStr = LibC.mallocCString(key)
            if (keyStr.isNull()) {
                throw IllegalMemoryException("setItem malloc failed!")
            }
            var strV = LibC.mallocCString(value)
            if (strV.isNull()) {
                LibC.free(keyStr)
                throw IllegalMemoryException("setItem malloc failed!")
            }
            CJ_SetItemInfo(macroObjPtr, keyStr, CPointer<Unit>(strV.getChars()), ITEM_TYPE_STRING)
        }
    }
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public func setItem(key: String, value: Int64): Unit {
    unsafe {
        if (let Some(macroObjPtr) <- MACRO_OBJECT.get()) {
            var keyStr = LibC.mallocCString(key)
            if (keyStr.isNull()) {
                throw IllegalMemoryException("setItem malloc failed!")
            }
            var intV = LibC.malloc<Int64>()
            if (intV.isNull()) {
                LibC.free(keyStr)
                throw IllegalMemoryException("setItem malloc failed!")
            }
            intV.write(value)
            CJ_SetItemInfo(macroObjPtr, keyStr, CPointer<Unit>(intV), ITEM_TYPE_INT64)
        }
    }
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public func setItem(key: String, value: Bool): Unit {
    unsafe {
        if (let Some(macroObjPtr) <- MACRO_OBJECT.get()) {
            var keyStr = LibC.mallocCString(key)
            if (keyStr.isNull()) {
                throw IllegalMemoryException("setItem malloc failed!")
            }
            var boolV = LibC.malloc<Bool>()
            if (boolV.isNull()) {
                LibC.free(keyStr)
                throw IllegalMemoryException("setItem malloc failed!")
            }
            boolV.write(value)
            CJ_SetItemInfo(macroObjPtr, keyStr, CPointer<Unit>(boolV), ITEM_TYPE_BOOL)
        }
    }
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public func setItem(key: String, value: Tokens): Unit {
    unsafe {
        if (let Some(macroObjPtr) <- MACRO_OBJECT.get()) {
            var keyStr = LibC.mallocCString(key)
            if (keyStr.isNull()) {
                throw IllegalMemoryException("setItem malloc failed!")
            }
            let tokensBytes = value.toBytes()
            var tksV: CPointer<UInt8> = unsafePointerCastFromUint8Array(tokensBytes)
            CJ_SetItemInfo(macroObjPtr, keyStr, CPointer<Unit>(tksV), ITEM_TYPE_TOKENS)
        }
    }
}

class McInfo {
    private var keyVal: CString
    private var value_: CPointer<Unit>
    private var valueType_: UInt8

    /*
     * @noThrow
     */
    init(keyVal_: CString, v: CPointer<Unit>, vType: UInt8) {
        keyVal = keyVal_
        value_ = v
        valueType_ = vType
    }

    prop keyV: CString {
        /*
         * @noThrow
         */
        get() {
            keyVal
        }
    }

    prop value: CPointer<Unit> {
        /*
         * @noThrow
         */
        get() {
            value_
        }
    }

    prop valueType: UInt8 {
        /*
         * @noThrow
         */
        get() {
            valueType_
        }
    }
}

public class MacroMessage {
    var infoMap: ArrayList<McInfo>
    /*
     * @noThrow
     */
    init(res: ArrayList<McInfo>) {
        infoMap = res
    }

    /*
     * @noThrow
     */
    private func getIndexFromKey(key: String) {
        var index = 0
        for (info in infoMap) {
            if (info.keyV.toString() == key) {
                return index
            }
            index++
        }
        return -1
    }


    /*
     * @noThrow
     */
    public func hasItem(key: String): Bool {
        return getIndexFromKey(key) != -1
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    public func getString(key: String): String {
        var keyIndex = getIndexFromKey(key)
        if (keyIndex != -1) {
            if (infoMap[keyIndex].valueType != ITEM_TYPE_STRING) {
                throw Exception("The '${key}' cannot get the String type value!\n")
            } else {
                return CString(CPointer<UInt8>(infoMap[keyIndex].value)).toString()
            }
        }
        throw Exception("Cannot get the information from inner macro by '${key}'!\n")
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    public func getInt64(key: String): Int64 {
        var keyIndex = getIndexFromKey(key)
        if (keyIndex != -1) {
            if (infoMap[keyIndex].valueType != ITEM_TYPE_INT64) {
                throw Exception("The '${key}' cannot get the Int64 type value!\n")
            } else {
                unsafe {
                    return CPointer<Int64>(infoMap[keyIndex].value).read()
                }
            }
        }
        throw Exception("Cannot get the information from inner macro by '${key}'!\n")
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    public func getBool(key: String): Bool {
        var keyIndex = getIndexFromKey(key)
        if (keyIndex != -1) {
            if (infoMap[keyIndex].valueType != ITEM_TYPE_BOOL) {
                throw Exception("The '${key}' cannot get the Bool type value!\n")
            } else {
                unsafe {
                    return CPointer<Bool>(infoMap[keyIndex].value).read()
                }
            }
        }
        throw Exception("Cannot get the information from inner macro by '${key}'!\n")
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    public func getTokens(key: String): Tokens {
        var keyIndex = getIndexFromKey(key)
        if (keyIndex != -1) {
            if (infoMap[keyIndex].valueType != ITEM_TYPE_TOKENS) {
                throw Exception("The '${key}' cannot get the Tokens type value!\n")
            } else {
                if (infoMap[keyIndex].value.isNull()) {
                    return Tokens()
                } else {
                    return getTokensFromBytes(CPointer<UInt8>(infoMap[keyIndex].value))
                }
            }
        }
        throw Exception("Cannot get the information from inner macro by '${key}'!\n")
    }
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func readCpointerToMap(cp: CPointer<CPointer<Unit>>): ArrayList<McInfo> {
    var i: Int64 = 0
    var infoMap: ArrayList<McInfo> = ArrayList<McInfo>()
    unsafe {
        while (true) {
            if (cp.read(i).isNull()) {
                break
            }
            var key = CString(CPointer<UInt8>(cp.read(i)))
            i++
            var value = cp.read(i)
            i++
            var itemType = CPointer<UInt8>(cp.read(i)).read()
            i++
            infoMap.add(McInfo(key, value, itemType))
        }
    }
    return infoMap
}





/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws Error
 * @throws NoneValueException
 * @throws IllegalMemoryException
 */
public func getChildMessages(children: String): ArrayList<MacroMessage> {
    let macroObjPtr = match (MACRO_OBJECT.get()) {
        case Some(v) => v
        case None => return ArrayList<MacroMessage>()
    }

    var childrenStr = unsafe { LibC.mallocCString(children) }
    if (childrenStr.isNull()) {
        throw IllegalMemoryException("getChildMessages malloc failed!")
    }
    var resVector: CPointer<CPointer<CPointer<Unit>>> = unsafe { CJ_GetChildMessages(macroObjPtr, childrenStr) }
    var res: ArrayList<MacroMessage> = ArrayList<MacroMessage>()
    var i: Int64 = 0
    unsafe {
        LibC.free(childrenStr)
    }
    if (resVector.isNull()) {
        return res
    }

    unsafe {
        while (true) {
            var resArray = resVector.read(i)
            if (resArray.isNull()) {
                break
            }
            i++
            res.add(MacroMessage(readCpointerToMap(resArray)))
            LibC.free(resArray)
        }
        LibC.free(resVector)
    }

    return res
}
