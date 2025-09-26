






package std.unittest

import std.collection.*
import std.unittest.common.*

enum PrettyTreeStruct <: PrettyPrintable {
    Leaf(AssertExpectCheckResult)
    | Node(String, ArrayList<PrettyTreeStruct>)

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func pprint(pp: PrettyPrinter): PrettyPrinter {
        let pt = PrettyTree()
        match (this) {
            case Leaf(aecr) =>
                match (aecr.kind) {
                    case Assert => pt.append("Assert Failed: ")
                    case Expect => pt.append("Expect Failed: ")
                }
                pt.append(aecr)
            case Node(s, ppbles) => appendNode(pt, s, ppbles)
        }
        pt.pprint(pp)
        return pp
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func appendNode(pt: PrettyTree, s: String, ppbles: ArrayList<PrettyTreeStruct>) {
        pt.appendLine(s)
        pt.indentWithPrefix("│   ") {
            let iterator = ppbles.iterator()
            var val: Option<PrettyTreeStruct> = iterator.next()
            while (let Some(ppble) <- val) {
                val = iterator.next()
                if (val.isNone()) {
                    pt.appendLastWithPrefix("└── ", ppble)
                } else {
                    pt.appendWithPrefix("├── ", ppble)
                }
            }
        }
    }
}


private class PrettyTree <: PrettyPrinter & PrettyPrintable {
    let pt: PrettyText = PrettyText()

    private var treeIndent = ""
    private var needTreeIndent = false
    private let indentaions: ArrayList<String> = ArrayList([""])
    private var depth = 0

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected override func put(s: String): Unit {
        if (needTreeIndent) {
            pt.put(treeIndent)
            needTreeIndent = false
        }
        pt.put(s)
    }
    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected override func setColor(color: Color): Unit {
        pt.setColor(color)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    protected override func putNewLine(): Unit {
        if (needTreeIndent) {
            pt.put(treeIndent)
            needTreeIndent = false
        }
        pt.putNewLine()
        needTreeIndent = true
    }


        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
    private prop prefix: String {
        get() {
            let sb = StringBuilder()
            for (i in indentaions) {
                sb.append(i)
            }
            sb.toString()
        }
    }


        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
    private prop prefixNoLast: String {
        get() {
            let sb = StringBuilder()
            for (i in indentaions |> take(indentaions.size - 1)) {
                sb.append(i)
            }
            sb.toString()
        }
    }



    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func indentWithPrefix(prefix: String, body: () -> Unit): PrettyTree {
        indentaions.add(prefix)
        treeIndent = this.prefix
        depth += 1
        try {
            body()
        } finally {
            depth -= 1
            treeIndent = this.prefixNoLast
            indentaions.remove(at: indentaions.size - 1)
        }
        return this
    }


    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func appendWithPrefix(prefix: String, text: String): PrettyTree {
        if (needTreeIndent) {
            needTreeIndent = false
            put(this.prefixNoLast + prefix)
        }
        put(text)
        return this
    }



    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func appendLastWithPrefix(prefix: String, text: String): PrettyTree {
        if (needTreeIndent) {
            needTreeIndent = false
            put(this.prefixNoLast + prefix)
        }
        put(text)
        indentaions[depth] = " " * indentaions[depth].size
        treeIndent = this.prefix
        return this
    }


    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func appendWithPrefix<PP>(prefix: String, value: PP): PrettyTree where PP <: PrettyPrintable {
        if (needTreeIndent) {
            needTreeIndent = false
            put(this.prefixNoLast + prefix)
        }
        value.pprint(this)
        return this
    }



    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func appendLastWithPrefix<PP>(prefix: String, value: PP): PrettyPrinter where PP <: PrettyPrintable {
        if (needTreeIndent) {
            needTreeIndent = false
            put(this.prefixNoLast + prefix)
        }
        indentaions[depth] = " " * indentaions[depth].size
        treeIndent = this.prefix
        value.pprint(this)
        return this
    }

    public func pprint(pp: PrettyPrinter): PrettyPrinter {
        pt.pprint(pp)
        return pp
    }
}






public class AssertionCtx {
    private let _stringArgs: String
    private var _argsMap: ?HashMap<String, String> = None
    let _errors: ArrayList<PrettyTreeStruct> = ArrayList()

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    protected AssertionCtx(
        private let _passedArgs!: Array<String> = [],
        private let _caller!: String = String.empty
    ) {
        _stringArgs = _passedArgs |> collectString<String>(delimiter: ", ")
    }

    public prop caller: String {
        get() {
            _caller
        }
    }


    public prop hasErrors: Bool {
        get() {
            return !_errors.isEmpty()
        }
    }




    /**
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public func arg(key: String): String { return _argsMap?[key] ?? "<${key} not found>" }


    public prop args: String {
        get() {
            return _stringArgs
        }
    }





    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func setArgsAliases(aliases: Array<String>) {
        _argsMap = aliases.iterator().zip(_passedArgs.iterator()) |> collectHashMap
    }




    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws AssertException
     */
    public func fail(message: String): Nothing {
        let checkResult = FailCheckResult(Assert, message)
        _errors.add(Leaf(checkResult))
        throw AssertException("", checkResult)
    }




    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws AssertException
     */
    public func fail<PP>(pt: PP): Nothing where PP <: PrettyPrintable {
        let checkResult = CustomCheckResult(Assert, PrettyText.of(pt))
        _errors.add(Leaf(checkResult))
        throw AssertException("", checkResult)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func failExpect(message: String): Unit {
        let checkResult = FailCheckResult(Expect, message)
        _errors.add(Leaf(checkResult))
    }


    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func failExpect<PP>(pt: PP): Unit where PP <: PrettyPrintable {
        let checkResult = CustomCheckResult(Expect, PrettyText.of(pt))
        _errors.add(Leaf(checkResult))
    }
}


/**
 * @throws AssertException
 */
private func runAssert<T>(ctx: AssertionCtx, assert: (AssertionCtx) -> T): T {
    let result = assert(ctx)
    if (ctx.hasErrors) {
        throw AssertException("")
    }
    return result
}


private func runExpect(ctx: AssertionCtx, expect: (AssertionCtx) -> Any): Unit {
    try {
        expect(ctx)
    } catch (e: AssertException) {
    }
}











/**
 * @throws Error
 * @throws UnittestTimeoutException
 * @throws IllegalSynchronizationStateException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws AssertException
 */
public func invokeCustomAssert<T>(
    passedArgs: Array<String>,
    caller: String,
    assert: (AssertionCtx) -> T,
    optParentCtx!: ?AssertionCtx = None
): T {
    cancellationPoint()

    let ctx: AssertionCtx = AssertionCtx(_passedArgs: passedArgs, _caller: caller)

    let result: Option<T> = try {
        runAssert(ctx, assert)
    } catch (e: AssertException) {
        if (let Some(parentCtx) <- optParentCtx) {
            parentCtx._errors.add(Node(
                "@Assert[${caller}](${ctx.args}):",
                ctx._errors
            ))
            throw e
        }
        None
    }

    if (let Some(value) <- result) {
        Framework.withCurrentContext{ ctx: RunContext => ctx.checkPassed() }
        return value
    }

    let pt = PrettyText.of(Node(
        "@Assert[${caller}](${ctx.args}):",
        ctx._errors
    ))
    let checkResult = CustomCheckResult(Assert, PrettyText.of(pt))
    Framework.withCurrentContext{ ctx: RunContext => ctx.checkFailed(checkResult) }
    throw AssertException("", checkResult)
}









/**
 * @throws Error
 * @throws UnittestTimeoutException
 * @throws IllegalSynchronizationStateException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
public func invokeCustomExpect(
    passedArgs: Array<String>,
    caller: String,
    expect: (AssertionCtx) -> Any,
    optParentCtx!: ?AssertionCtx = None
): Unit {
    cancellationPoint()

    let ctx: AssertionCtx = AssertionCtx(_passedArgs: passedArgs, _caller: caller)

    runExpect(ctx, expect)

    if (let Some(parentCtx) <- optParentCtx) {
        if (ctx.hasErrors) {
            parentCtx._errors.add(Node(
                "@Expect[${caller}](${ctx.args}):",
                ctx._errors
            ))
        }
    } else {
        if (ctx.hasErrors) {
            let pt = PrettyText.of(Node(
                "@Expect[${caller}](${ctx.args}):",
                ctx._errors
            ))
            let checkResult = CustomCheckResult(Expect, PrettyText.of(pt))
            Framework.withCurrentContext{ ctx: RunContext => ctx.checkFailed(checkResult) }
        } else {
            Framework.withCurrentContext{ ctx: RunContext => ctx.checkPassed() }
        }
    }
}
