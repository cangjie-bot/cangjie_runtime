






package std.unittest

import std.sync.ReentrantMutex
import std.unittest.common.*
import std.process.Process

foreign func EnableANSITerminal(): Bool

foreign func DisableANSITerminal(): Bool

var isConsoleUtf8: Bool = true

open class TerminalPrettyPrinter <: PrettyPrinter {



    private static let globalAnsiLock = ReentrantMutex()
    private static var globalAnsiEnabled: ?Bool = None

    private static var _instance: ?TerminalPrettyPrinter = None
    private static let lock = ReentrantMutex()

    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     * @throws IllegalSynchronizationStateException
     */
    private static func globalInitializeAnsi(): Bool {
        synchronized(globalAnsiLock) {
            match (globalAnsiEnabled) {
                case Some(bound) => return bound
                case _ => ()
            }
            let tryEnable = unsafe { EnableANSITerminal() }
            if (tryEnable) {
                Process.current.atExit {unsafe { DisableANSITerminal() }}
            }
            globalAnsiEnabled = tryEnable
            return tryEnable
        }
    }

    private static let ESC = "\u{1B}"
    private static let ESC_C_DEFAULT_MODE = "${ESC}[0m"
    private static let ESC_C_RED_MODE = "${ESC}[31m"
    private static let ESC_C_GREEN_MODE = "${ESC}[32m"
    private static let ESC_C_YELLOW_MODE = "${ESC}[33m"
    private static let ESC_C_BLUE_MODE = "${ESC}[34m"
    private static let ESC_C_MAGENTA_MODE = "${ESC}[35m"
    private static let ESC_C_CYAN_MODE = "${ESC}[36m"
    private static let ESC_C_GRAY_MODE = "${ESC}[90m"
    /*
     * @noThrow
     */
    private static func escLinesUp(lines: Int64) { "${ESC}[${lines}F" }
    /*
     * @noThrow
     */
    private static func escLinesDown(lines: Int64) { "${ESC}[${lines}E" }
    /*
     * @noThrow
     */
    private static func escCursorHorizontalPos(column: Int64) { "${ESC}[${column}G" }
    /*
     * @noThrow
     */
    private static func escCursorRight(shift: Int64) { "${ESC}[${shift}C" }
    private static let ESC_CURSOR_SAVE = "${ESC}7"
    private static let ESC_CURSOR_RESTORE = "${ESC}8"
    private static let ESC_CURSOR_HIDE = "${ESC}[?25l"
    private static let ESC_CURSOR_SHOW = "${ESC}[?25h"
    /*
     * @noThrow
     */
    private static func escSetScrollableMargins(start: Int64, endInclusive: Int64) { "${ESC}[${start};${endInclusive}r" }
    /*
     * @noThrow
     */
    private static func escSetScrollableMarginsEnd(endInclusive!: Int64) { "${ESC}[1;${endInclusive}r" }
    /*
     * @noThrow
     */
    private static func escSetScrollableMarginsStart(start!: Int64) { "${ESC}[${start};r" }
    private static let ESC_RESET_SCROLLABLE_MARGINS = "${ESC}[;r"
    private static let ESC_CLEAR_AHEAD = "${ESC}[0J"
    private static let ESC_CLEAR_LINE = "${ESC}[2K"

    private let areColorsEnabled: Bool
    private let areOtherAnsiEnabled: Bool



    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     * @throws IllegalSynchronizationStateException
     */
    TerminalPrettyPrinter(isColored: Bool, isOtherAnsiAble!: Bool = true) {
        let isAnsiEnabled = globalInitializeAnsi()
        this.areColorsEnabled = isColored && isAnsiEnabled
        this.areOtherAnsiEnabled = isOtherAnsiAble && isAnsiEnabled
        isConsoleUtf8 = setUtf8OutputCP()
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ProcessException
     * @throws IllegalSynchronizationStateException
     */
    init(configuration: Configuration) {
        this(!(configuration.get(KeyNoColor.noColor) ?? false))
    }


    prop terminalHeight: ?UInt64 {
        /*
         * @noThrow
         */
        get() {
            match (unsafe { GetTerminalHeight() }) {
                case 0u64 => None
                case x => x
            }
        }
    }


    prop terminalWidth: ?UInt64 {
        /*
         * @noThrow
         */
        get() {
            match (unsafe { GetTerminalWidth() }) {
                case 0u64 => None
                case x => x
            }
        }
    }

    /*
     * @throws IllegalSynchronizationStateException
     */
    func exclusive<T>(action: (TerminalPrettyPrinter) -> T): T {
        synchronized(lock) {
            action(this)
        }
    }


    /*
     * @throws OutOfMemoryError
     */
    func up(lines: Int64) {
        if (!areOtherAnsiEnabled || lines <= 0) { return }
        put(escLinesUp(lines))
    }


    /*
     * @throws OutOfMemoryError
     */
    func down(lines: Int64) {
        if (!areOtherAnsiEnabled || lines <= 0) { return }
        put(escLinesDown(lines))
    }

    /*
     * @throws OutOfMemoryError
     */
    func toBottom() {
        down(9999)
    }

    /*
     * @throws OutOfMemoryError
     */
    func setColumn(column!: Int64 = 1) {
        if (!areOtherAnsiEnabled) { return }
        put(escCursorHorizontalPos(column))
    }

    /*
     * @throws OutOfMemoryError
     */
    func saveCursorPos() {
        if (!areOtherAnsiEnabled) { return }
        put(ESC_CURSOR_SAVE)
        flush()
    }

    /*
     * @throws OutOfMemoryError
     */
    func restoreCursorPos() {
        if (!areOtherAnsiEnabled) { return }
        put(ESC_CURSOR_RESTORE)
        flush()
    }

    /*
     * @throws OutOfMemoryError
     */
    func hideCursor() {
        if (!areOtherAnsiEnabled) { return }
        put(ESC_CURSOR_HIDE)
        flush()
    }

    /*
     * @throws OutOfMemoryError
     */
    func showCursor() {
        if (!areOtherAnsiEnabled) { return }
        put(ESC_CURSOR_SHOW)
        flush()
    }

    /*
     * @throws OutOfMemoryError
     */
    func setScrollableMargins(start!: ?Int64 = None, end!: ?Int64 = None) {
        if (!areOtherAnsiEnabled) { return }

        match ((start, end)) {
            case (None, None) => put(ESC_RESET_SCROLLABLE_MARGINS)
            case (Some(s), None) => put(escSetScrollableMarginsStart(start: s))
            case (None, Some(e)) => put(escSetScrollableMarginsEnd(endInclusive: e))
            case (Some(s), Some(e)) => put(escSetScrollableMargins(s, e))
        }
        flush()
    }

    /*
     * @throws OutOfMemoryError
     */
    func clearAhead() {
        if (!areOtherAnsiEnabled) { return }
        put(ESC_CLEAR_AHEAD)
    }

    /*
     * @throws OutOfMemoryError
     */
    func clearLine() {
        if (!areOtherAnsiEnabled) { return }
        put(ESC_CLEAR_LINE)
    }

    /*
     * @throws OutOfMemoryError
     */
    protected override open func put(s: String): Unit {
        print(s)
    }

    /*
     * @throws OutOfMemoryError
     */
    protected func flush(): Unit {
        print("", flush: true)
    }

    /*
     * @throws OutOfMemoryError
     */
    protected override func setColor(color: Color): Unit {
        if (!areColorsEnabled) {
            return
        }

        let command = match (color) {
            case RED => ESC_C_RED_MODE
            case GREEN => ESC_C_GREEN_MODE
            case YELLOW => ESC_C_YELLOW_MODE
            case BLUE => ESC_C_BLUE_MODE
            case CYAN => ESC_C_CYAN_MODE
            case MAGENTA => ESC_C_MAGENTA_MODE
            case GRAY => ESC_C_GRAY_MODE
            case DEFAULT_COLOR => ESC_C_DEFAULT_MODE
        }
        put(command)
    }

    static prop instance: TerminalPrettyPrinter {
        /*
         * @throws IllegalMemoryException
         * @throws Exception
         * @throws UnittestCliOptionsFormatException
         * @throws getOrThrow
         * @throws JsonException
         * @throws OutOfMemoryError
         * @throws IllegalArgumentException
         * @throws RegexException
         * @throws UnittestOptionValidationException
         * @throws IndexOutOfBoundsException
         * @throws ArithmeticException
         * @throws ProcessException
         * @throws IllegalSynchronizationStateException
         */
        get() {
            synchronized(lock) {
                match (_instance) {
                    case Some(inst) => inst
                    case None =>
                        let defaultConfig = defaultConfiguration()
                        let inst = TerminalPrettyPrinter(defaultConfig)
                        _instance = inst
                        inst
                }
            }
        }
    }

    /*
     * @throws OutOfMemoryError
     */
    public func fillLimitedSpace(spaceSize: Int64, body: () -> Unit): PrettyPrinter {
        if (areOtherAnsiEnabled && areColorsEnabled) {
            put(ESC_CURSOR_SAVE)
        }
        body()
        if (areOtherAnsiEnabled && areColorsEnabled) {
            put(ESC_CURSOR_RESTORE)
            put(escCursorRight(spaceSize))
        }
        return this
    }

    /*
     * @throws IllegalMemoryException
     * @throws Exception
     * @throws UnittestCliOptionsFormatException
     * @throws getOrThrow
     * @throws JsonException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws RegexException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws ProcessException
     * @throws IllegalSynchronizationStateException
     */
    static func fromDefaultConfiguration(): TerminalPrettyPrinter {
        instance
    }
}

@When[os != "Windows"]
/*
 * @noThrow
 */
func setUtf8OutputCP(): Bool { true }

@When[os == "Windows"]
foreign func SetConsoleOutputCP(cp: UInt32): UInt32

@When[os == "Windows"]
func setUtf8OutputCP(): Bool {
    const CP_UTF8: UInt32 = 65001
    unsafe { SetConsoleOutputCP(CP_UTF8) != 0 }
}

foreign func GetTerminalWidth(): UInt64

foreign func GetTerminalHeight(): UInt64
