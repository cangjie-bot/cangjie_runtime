






package std.unittest.prop_test

/*
 * @noThrow
 */
func coerceInRange(value: Byte, min: Byte, max: Byte) {
    if (min <= value && value <= max) { return value }
    return value % (max - min + 1) + min
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func nextIn<T>(random: RandomSource, arr: Array<T>): T {
    let ix = random.nextInt64(arr.size)
    return arr[ix]
}


@OverflowWrapping
/*
 * @noThrow
 */
func nextInRange(random: RandomSource, low: Byte, high: Byte): Byte {
    let tri = random.nextUInt8()
    if (low <= tri && tri <= high) { return tri }
    return tri % (high - low + 1) + low
}





struct UTFState {
    /*
     * @noThrow
     */
    init() {
        this.data = []
        this.ranges = []
    }
    /*
     * @throws IndexOutOfBoundsException
     */
    init(rangeTransfer: Array<(Byte, Byte, UTFState)>) {
        this.data = Array(256) { ix: Int64 =>
            let byte = UInt8(ix)
            for ((low, high, next) in rangeTransfer) {
                if (low <= byte && byte <= high) {
                    return next
                }
            }
            return UTFState()
        }
        this.ranges = Array(rangeTransfer.size) { ix =>
            let (low, high, _) = rangeTransfer[ix]
            (low, high)
        }
    }
    /*
     * @noThrow
     */
    init(low: Byte, high: Byte, next: UTFState) {
        this.data = Array(256) { ix: Int64 =>
            let byte = UInt8(ix)
            if (low <= byte && byte <= high) { next } else { UTFState() }
        }
        this.ranges = [(low, high)]
    }

    let data: Array<UTFState>
    let ranges: Array<(Byte, Byte)>

    /*
     * @noThrow
     */
    func isInvalid() { data.isEmpty() }

    /*
     * @throws IndexOutOfBoundsException
     */
    operator func ()(byte: Byte): UTFState {
        data[Int64(byte)]
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func nextByte(random: RandomSource) {
        let (low, high) = nextIn(random, ranges)
        return nextInRange(random, low, high)
    }












    static let END_STATE = UTFState()
    static let A_STATE = UTFState(0x80, 0xBF, END_STATE)
    static let B_STATE = UTFState(0x80, 0xBF, A_STATE)
    static let C_STATE = UTFState(0xA0, 0xBF, A_STATE)
    static let D_STATE = UTFState(0x80, 0x9F, A_STATE)
    static let E_STATE = UTFState(0x80, 0xBF, B_STATE)
    static let F_STATE = UTFState(0x90, 0xBF, B_STATE)
    static let G_STATE = UTFState(0x80, 0x8F, B_STATE)
    static let START_STATE = UTFState(
        (0x00, 0x7F, END_STATE),
        (0xC2, 0xDF, A_STATE),
        (0xE1, 0xEC, B_STATE),
        (0xEE, 0xEF, B_STATE),
        (0xE0, 0xE0, C_STATE),
        (0xED, 0xED, D_STATE),
        (0xF1, 0xF3, E_STATE),
        (0xF0, 0xF0, F_STATE),
        (0xF4, 0xF4, G_STATE)
    )
}

let ALNUM_CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".toArray()

/*
 * @throws IndexOutOfBoundsException
 */
func randomAlnumRune(random: RandomSource): Rune {
    let candidate = random.nextUInt8()
    match {
        case b'0' <= candidate && candidate <= b'9'
            || b'a' <= candidate && candidate <= b'z'
            || b'A' <= candidate && candidate <= b'Z' => Rune(candidate)
        case _ => Rune(ALNUM_CHARS[Int64(candidate) % ALNUM_CHARS.size])
    }
}

private const ASCII_PRINTABLE_MIN: Byte = 0x20
private const ASCII_PRINTABLE_MAX: Byte = 0x7E

/*
 * @noThrow
 */
func randomAsciiRune(random: RandomSource): Rune {
    Rune(nextInRange(random, ASCII_PRINTABLE_MIN, ASCII_PRINTABLE_MAX))
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func randomUtf8Rune(random: RandomSource): Rune {
    var state = UTFState.START_STATE
    let result = Array<Byte>(6, repeat: 0)
    var i = 0
    while (!state.isInvalid()) {
        let byte = state.nextByte(random)
        state = state(byte)
        result[i] = byte
        i++
    }

    return Rune.fromUtf8(result[..i], 0)[0]
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func randomBiasedRune(random: RandomSource): Rune {
    match (random.nextInt64(3)) {
        case 0 => randomAlnumRune(random)
        case 1 => randomAsciiRune(random)
        case 2 => randomUtf8Rune(random)
        case _ => throw IllegalArgumentException()
    }
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func randomSuggestedRune(random: RandomSource): Rune {
    let byte = random.suggestUInt8()
    if (ASCII_PRINTABLE_MIN <= byte && byte <= ASCII_PRINTABLE_MAX) {
        return Rune(byte)
    }
    return randomUtf8Rune(random)
}

/*
 * @noThrow
 */
func shrinkToAscii(charValue: Rune): Rune {
    if (charValue.isAscii()) {
        return charValue
    }
    let min = UInt32(ASCII_PRINTABLE_MIN)
    let max = UInt32(ASCII_PRINTABLE_MAX)
    let cp = UInt32(charValue) % (max - min + 1) + min
    Rune(cp)
}

/*
 * @throws IndexOutOfBoundsException
 */
func shrinkToAlnum(charValue: Rune): Rune {
    if (charValue.isAsciiLetter() || charValue.isAsciiNumber()) {
        return charValue
    }
    let alnumByte = ALNUM_CHARS[charValue.hashCode() % ALNUM_CHARS.size]
    Rune(alnumByte)
}
