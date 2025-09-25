









package std.argopt

import std.collection.*








@Deprecated[message: "Use global function `public func parseArguments(args: Array<String>, specs: Array<ArgumentSpec>): ParsedArguments` instead."]
public class ArgOpt {

    
    private var utils: ParserHelper

    
    private var arguments: Arguments









    public init(shortArgFormat: String) {
        this(Arguments.NULL, shortArgFormat, Arguments.NULL)
    }










    public init(longArgList: Array<String>) {
        this(Arguments.NULL, "", longArgList)
    }











    public init(shortArgFormat: String, longArgList: Array<String>) {
        this(Arguments.NULL, shortArgFormat, longArgList)
    }
































    public init(args: Array<String>, shortArgFormat: String, longArgList: Array<String>) {
        this.arguments = Arguments()
        this.utils = ParserHelper(this.arguments)
        this.utils.argsParser(args, shortArgFormat, longArgList)
    }











    public func getArg(arg: String): Option<String> {
        if (arg.isEmpty()) {
            return Option<String>.None
        }

        let argMap: HashMap<String, String> = utils.getArgsMap()
        let argStr: String = if (arg.size == 1 && arg != "-") {
            "-${arg}"
        } else if ((arg.size > 2 && !arg.startsWith("--")) || !arg.startsWith("-")) {
            "--${arg}"
        } else {
            arg
        }
        return argMap.get(argStr)
    }






    public func getUnparseArgs(): Array<String> {
        let argsList: ArrayList<Int8> = utils.getArgsList()
        if (argsList.size == 0) {
            return this.arguments.getUnparseArgs()
        }
        var countZero: Int64 = 0
        var arrIndex: Int64 = 0
        for (i in 0..argsList.size) {
            if (argsList[i] != 0) {
                continue
            }
            countZero++
        }
        this.arguments.setUnparseArgs(Array<String>(countZero, repeat: ""))
        for (i in 0..argsList.size) {
            if (argsList[i] != 0) {
                continue
            }
            this.arguments.getUnparseArgs()[arrIndex] = this.arguments.getMyArgs()[i]
            arrIndex++
        }
        return this.arguments.getUnparseArgs()
    }






    public func getArgumentsMap(): HashMap<String, String> {
        return this.utils.getArgsMap()
    }
}






class Arguments {

    
    static let NULL: Array<String> = Array<String>()

    
    private var myArgs: Array<String> = NULL

    
    private var unparseArgs: Array<String> = NULL

    func setMyArgs(Args: Array<String>) {
        this.myArgs = Args
    }

    func setUnparseArgs(unparseArgs: Array<String>) {
        this.unparseArgs = unparseArgs
    }

    func getMyArgs(): Array<String> {
        return myArgs
    }

    func getUnparseArgs(): Array<String> {
        return unparseArgs
    }
}




enum ErrorType {
    IllegalArgument
    | IndexOutOfBounds
    | Runtime
}




class ParserHelper {

    
    private let argMap: HashMap<String, String> = HashMap<String, String>()

    
    private var argsList: ArrayList<Int8> = ArrayList<Int8>()

    
    private var arguments: Arguments

    
    private static let exceptionPrompt = "Invalid string, please check the parameter: "






    init(argument: Arguments) {
        this.arguments = argument
    }






    func getArgsMap(): HashMap<String, String> {
        return this.argMap.clone()
    }






    func getArgsList(): ArrayList<Int8> {
        return this.argsList
    }













    func argsParser(args: Array<String>, shortArgFormat: String, longArgList: Array<String>): Unit {
        let shortStr: String = checkShortStr(shortArgFormat)
        let longOpts: Array<String> = checkLongOpt(longArgList)
        let size: Int64 = args.size
        this.arguments.setMyArgs(args)
        this.argsList = ArrayList<Int8>(size, {_ => 0})

        var i: Int64 = 0
        while (i < size) {
            let arg: String = args[i]
            if (arg.startsWith("-") && arg != "-" && arg != "--") {
                let (long, unParse): (Int64, Bool) = if (arg.startsWith("--")) {
                    this.doLongParser(longOpts, args, i)
                } else {
                    this.doShortParser(shortStr, args, i)
                }
                if (unParse) {
                    i++
                    continue
                }
                for (j in 0..long where j + i < size) {
                    this.argsList[i + j] = 1
                }
                i = i + long
                continue
            }
            i++
        }
    }

    private func doLongParser(longOpts: Array<String>, args: Array<String>, i: Int64): (Int64, Bool) {
        var key: String = args[i]
        let split = key.indexOf("=") ?? -1
        var optArg: String = ""
        var long: Int64 = 1
        if (split > -1) {
            if (split + 1 < key.size) {
                optArg = key[split + 1..]
            }
            key = key[0..split]
        }
        var unParse: Bool = true
        var hasArg: Bool = false
        for (itemStr in longOpts) {
            let split: Int64 = itemStr.indexOf("=") ?? -1
            var item: String = itemStr
            if (split > -1) {
                item = itemStr[0..=split]
            }
            let isFinished = (item.startsWith(key) && (item == key || item == key + "=")) ||
                !item.startsWith("--") && ("--" + item).startsWith(key) && ("--" + item == key || "--" + item == key +
                "=")
            if (isFinished) {
                unParse = false
                hasArg = item.endsWith("=")
                break
            }
        }
        if (unParse || (!hasArg && split != -1)) {
            return (long, true)
        }
        if (hasArg && split == -1) {
            if (i + 1 >= args.size) {
                return (long, true)
            }
            optArg = args[i + 1]
            long++
        }
        this.argMap.add(key, optArg)
        return (long, false)
    }

    private func doShortParser(shortStr: String, args: Array<String>, i: Int64): (Int64, Bool) {
        var size: Int64 = shortStr.size
        var key: String = args[i][0..2]
        let index: Int64 = shortStr.indexOf(key[1]) ?? -1
        if (index >= 0) {
            let hasArg: Bool = if (index + 1 >= size) {
                false
            } else {
                shortStr[index + 1] == b':'
            }
            if (!hasArg) {
                if (args[i].size == 2) {
                    this.argMap.add(key, "")
                    return (1, false)
                }
                return (1, true)
            }
            if (args[i] == key) {
                if (i + 1 >= args.size) {
                    return (1, true)
                }
                this.argMap.add(key, args[i + 1])
                return (2, false)
            }
            this.argMap.add(key, args[i][2..])
            return (1, false)
        }
        return (1, true)
    }


    private func checkShortStr(shortStr: String): String {
        for (item in shortStr.runes()) {
            if (item == r':' || item.isAsciiLetter()) {
                continue
            }
            throw IllegalArgumentException("${exceptionPrompt}${shortStr}\n")
        }
        return shortStr
    }


    private func checkLongOpt(longOpts: Array<String>): Array<String> {
        for (item in longOpts) {
            if (item.isEmpty()) {
                continue
            }
            let isDoubleSign: Bool = item.startsWith("--")
            let isSingleSign: Bool = !isDoubleSign && item.startsWith("-")
            let itemCharArray = item.toRuneArray()
            let size: Int64 = itemCharArray.size
            if (isDoubleSign && size >= 3 && itemCharArray[2].isAsciiLetter()) {
                continue
            }
            if (isSingleSign && size >= 2 && itemCharArray[1].isAsciiLetter()) {
                continue
            }
            if (itemCharArray[0].isAsciiLetter()) {
                continue
            }
            throw IllegalArgumentException("${exceptionPrompt}${item}\n")
        }
        return longOpts
    }
}

public enum ArgumentMode <: ToString & Equatable<ArgumentMode> {
    | NoValue
    | RequiredValue
    | OptionalValue

    public func toString(): String {
        match (this) {
            case NoValue => "NoValue"
            case RequiredValue => "RequiredValue"
            case OptionalValue => "OptionalValue"
        }
    }

    public operator func ==(that: ArgumentMode): Bool {
        this.toString() == that.toString()
    }
}

public enum ArgumentSpec {
    | Short(Rune, ArgumentMode)
    | Short(Rune, ArgumentMode, (String) -> Unit)
    | Long(String, ArgumentMode)
    | Long(String, ArgumentMode, (String) -> Unit)
    | Full(String, Rune, ArgumentMode)
    | Full(String, Rune, ArgumentMode, (String) -> Unit)
    | NonOptions((Array<String>) -> Unit)

    prop name: (?String, ?Rune) {
        get() {
            match (this) {
                case Short(r, _) => (None, r)
                case Short(r, _, _) => (None, r)
                case Long(s, _) => (s, None)
                case Long(s, _, _) => (s, None)
                case Full(s, r, _) => (s, r)
                case Full(s, r, _, _) => (s, r)
                case NonOptions(_) => (None, None)
            }
        }
    }

    prop mode: ArgumentMode {
        get() {
            match (this) {
                case Short(_, m) => m
                case Short(_, m, _) => m
                case Long(_, m) => m
                case Long(_, m, _) => m
                case Full(_, _, m) => m
                case Full(_, _, m, _) => m
                case NonOptions(_) => throw NoneValueException()
            }
        }
    }

    prop optionAction: ?(String) -> Unit {
        get() {
            match (this) {
                case Short(_, _, action) => action
                case Long(_, _, action) => action
                case Full(_, _, _, action) => action
                case _ => None
            }
        }
    }

    prop nonOptionAction: ?(Array<String>) -> Unit {
        get() {
            match (this) {
                case NonOptions(action) => action
                case _ => None
            }
        }
    }
}

public struct ParsedArguments {
    var _options: HashMap<String, String>
    var _nonOptions: Array<String>

    init(options: HashMap<String, String>, nonOptions: Array<String>) {
        _options = options
        _nonOptions = nonOptions
    }

    public prop options: ReadOnlyMap<String, String> {
        get() {
            _options
        }
    }

    public prop nonOptions: Array<String> {
        get() {
            _nonOptions
        }
    }
}

enum ParseState {
    Start | Option | NonOption | End
}

class ArgParser {
    let _options: HashMap<String, String> = HashMap<String, String>()
    let _nonOptions: ArrayList<String> = ArrayList<String>()
    let _longOptionSpecs: HashMap<String, ArgumentSpec> = HashMap<String, ArgumentSpec>()
    let _shortOptionSpecs: HashMap<Rune, ArgumentSpec> = HashMap<Rune, ArgumentSpec>()
    var _nonOptionSpecs: ?ArgumentSpec = None
    var _index = 0

    func checkDuplicateShortOption(r: Rune) {
        if (_shortOptionSpecs.contains(r) || _longOptionSpecs.contains(String(r))) {
            throw IllegalArgumentException("Duplicated option ${r} founded.")
        }
    }
    func checkDuplicateLongOption(s: String) {
        if (_longOptionSpecs.contains(s) || (s.size == 1 && _shortOptionSpecs.contains(Rune(s[0])))) {
            throw IllegalArgumentException("Duplicated option: ${s} founded.")
        }
    }

    func addSpec(spec: ArgumentSpec): Unit {
        match (spec) {
            case Short(r, _) =>
                checkDuplicateShortOption(r)
                _shortOptionSpecs.add(r, spec)
            case Short(r, _, _) =>
                checkDuplicateShortOption(r)
                _shortOptionSpecs.add(r, spec)
            case Long(s, m) =>
                checkDuplicateLongOption(s)
                _longOptionSpecs.add(s, spec)
            case Long(s, _, _) =>
                checkDuplicateLongOption(s)
                _longOptionSpecs.add(s, spec)
            case Full(s, r, _) =>
                checkDuplicateShortOption(r)
                checkDuplicateLongOption(s)
                _longOptionSpecs.add(s, spec)
                _shortOptionSpecs.add(r, spec)
            case Full(s, r, _, _) =>
                checkDuplicateShortOption(r)
                checkDuplicateLongOption(s)
                _longOptionSpecs.add(s, spec)
                _shortOptionSpecs.add(r, spec)
            case NonOptions(action) => _nonOptionSpecs = spec
        }
    }

    func addOptionAndExecuteAction(key: String, val: String, spec: ArgumentSpec) {
        _options.add(key, val)
        spec.optionAction?(val)
    }

    func parseLongOption(arg: String, next: ?String): Bool {
        let splited: Array<String> = arg.split("=", 2)

        return if (let Some(spec) <- _longOptionSpecs.get(splited[0])) {
            match ((spec.mode, splited.size == 1)) {
                case (OptionalValue, true) => addOptionAndExecuteAction(splited[0], "", spec)
                case (OptionalValue, false) => addOptionAndExecuteAction(splited[0], splited[1], spec)
                case (RequiredValue, true) =>
                    addOptionAndExecuteAction(splited[0],
                        next ?? throw ArgumentParseException("Missing option value for ${splited[0]}."), spec)
                    _index += 1
                case (RequiredValue, false) => addOptionAndExecuteAction(splited[0], splited[1], spec)
                case (NoValue, true) => addOptionAndExecuteAction(splited[0], "", spec)
                case (NoValue, false) => throw ArgumentParseException("Unexcepted value for ${splited[0]}.")
            }
            true
        } else {
            false
        }
    }
    func generateNoValueSpecForShortOption(runeArray: Array<Rune>): ArrayList<ArgumentSpec> {
        let arr: ArrayList<ArgumentSpec> = ArrayList<ArgumentSpec>()
        let set = HashSet<Rune>()
        for ((idx, c) in enumerate(runeArray.iterator())) {
            if (let Some(spec) <- _shortOptionSpecs.get(c) && !set.contains(c) && !_options.contains(c.toString()) &&
                spec.mode == NoValue) {
                arr.add(spec)
                set.add(c)
            } else {
                break
            }
        }
        arr
    }
    func parseNoValueForShortOption(runeArray: Array<Rune>, next: ?String) {
        let noValueSpecs = generateNoValueSpecForShortOption(runeArray)

        for (spec in noValueSpecs) {
            let key = spec.name[1]?.toString() ?? ""
            addOptionAndExecuteAction(key, "", spec)
        }

        let cur = runeArray[0]
        if (runeArray.size - 1 == noValueSpecs.size) {
            let spec = _shortOptionSpecs.get(runeArray[runeArray.size - 1]) ?? throw ArgumentParseException(
                "Unknown option: ${cur}.")
            match (spec.mode) {
                case OptionalValue => addOptionAndExecuteAction(spec.name[1]?.toString() ?? "", "", spec)
                case RequiredValue =>
                    let value = next ?? throw ArgumentParseException("Missing option value for ${cur}.")
                    _index += 1
                    addOptionAndExecuteAction(spec.name[1]?.toString() ?? "", value, spec)
                case NoValue => throw ArgumentParseException("Should never reach here becauese of previously check.")
            }
        } else if (runeArray.size - 1 > noValueSpecs.size) {
            let spec = _shortOptionSpecs.get(runeArray[noValueSpecs.size]) ?? throw ArgumentParseException(
                "Unknown option: ${runeArray[noValueSpecs.size]}.")
            if (spec.mode == RequiredValue && noValueSpecs.size < runeArray.size - 2) {
                addOptionAndExecuteAction(spec.name[1]?.toString() ?? "", String(runeArray[noValueSpecs.size + 1..]),
                    spec)
            } else if (spec.mode == OptionalValue) {
                addOptionAndExecuteAction(spec.name[1]?.toString() ?? "", String(runeArray[noValueSpecs.size + 1..]),
                    spec)
            } else {
                throw ArgumentParseException("Unknown option: ${runeArray[noValueSpecs.size]}.")
            }
        }
    }

    func parseShortOption(arg: String, next: ?String) {
        let runeArray = arg.toRuneArray()
        let runeSize = runeArray.size
        let cur = runeArray.get(0).getOrThrow()

        if (let Some(spec) <- _shortOptionSpecs.get(cur)) {
            match (spec.mode) {
                case OptionalValue =>
                    let value = if (runeSize > 1) {
                        String(runeArray[1..])
                    } else {
                        ""
                    }
                    addOptionAndExecuteAction(cur.toString(), value, spec)
                case RequiredValue =>
                    let value = if (runeSize == 1) {
                        _index += 1
                        next ?? throw ArgumentParseException("Missing option value for ${cur}.")
                    } else {
                        String(runeArray[1..])
                    }
                    addOptionAndExecuteAction(cur.toString(), value, spec)
                case NoValue => parseNoValueForShortOption(runeArray, next)
            }
        } else {
            throw ArgumentParseException("Unknown option: ${arg}.")
        }
    }
    func parseOption(arg: String, next: ?String, longOptionOnly!: Bool = false) {
        if (arg.size == 0) {
            throw ArgumentParseException("Option cannot be empty.")
        }

        if (!parseLongOption(arg, next)) {
            if (longOptionOnly) {
                throw ArgumentParseException("Unknown option: ${arg}.")
            }
            parseShortOption(arg, next)
        }
    }

    func parse(args: Array<String>, specs: Array<ArgumentSpec>): ParsedArguments {
        specs |> forEach(addSpec)

        var state = ParseState.Start
        while (_index < args.size) {
            let cur = args[_index]
            match (state) {
                case ParseState.Start =>
                    if (cur == "--") {
                        state = ParseState.End
                    } else if (cur[0] == b'-') {
                        state = ParseState.Option
                        _index -= 1
                    } else {
                        state = ParseState.NonOption
                        _index -= 1
                    }
                case ParseState.Option =>
                    if (cur.startsWith("--")) {
                        parseOption(cur[2..], args.get(_index + 1), longOptionOnly: true)
                    } else if (cur.startsWith("-")) {
                        parseOption(cur[1..], args.get(_index + 1))
                    } else {
                        throw ArgumentParseException("Illegal option format for ${cur}.")
                    }
                    state = ParseState.Start
                case ParseState.NonOption =>
                    _nonOptions.add(cur)
                    state = ParseState.Start
                case ParseState.End => _nonOptions.add(cur)
            }
            _index += 1
        }
        _nonOptionSpecs?.nonOptionAction?(_nonOptions.toArray())
        return ParsedArguments(_options, _nonOptions.toArray())
    }
}

public class ArgumentParseException <: Exception {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "ArgumentParseException"
    }
}

public func parseArguments(args: Array<String>, specs: Array<ArgumentSpec>): ParsedArguments {
    ArgParser().parse(args, specs)
}
