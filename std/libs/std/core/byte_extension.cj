







package std.core

const ASCII_UPPER_TO_LOWER_DIFF: UInt8 = 0x20

extend Byte {


    /*
     * @noThrow
     */
    public func isAsciiLetter(): Bool {
        return (this >= b'A' && this <= b'Z') || (this >= b'a' && this <=
            b'z')
    }


    /*
     * @noThrow
     */
    public func isAsciiNumber(): Bool {
        return this >= b'0' && this <= b'9'
    }


    /*
     * @noThrow
     */
    public func isAsciiHex(): Bool {
        return this.isAsciiNumber() || (this >= b'a' && this <= b'f') || (this >= b'A' &&
            this <= b'F')
    }


    /*
     * @noThrow
     */
    public func isAsciiOct(): Bool {
        return this >= b'0' && this <= b'7'
    }


    /*
     * @noThrow
     */
    public func isAsciiPunctuation(): Bool {
        return (this >= b'!' && this <= b'/') || (this >= b':' && this <= b'@') ||
               (this >= b'[' && this <= b'`') || (this >= b'{' && this <= b'~')
    }


    /*
     * @noThrow
     */
    public func isAsciiGraphic(): Bool {
        return this >= b'!' && this <= b'~'
    }


    /*
     * @noThrow
     */
    public func isAsciiControl(): Bool {
        return this <= 0x1F || this == 0x7F
    }


    /*
     * @noThrow
     */
    public func isAsciiNumberOrLetter(): Bool {
        return this.isAsciiLetter() || this.isAsciiNumber()
    }

    
    /*
     * @noThrow
     */
    public func isAsciiLowerCase(): Bool {
        return this >= b'a' && this <= b'z'
    }

    
    /*
     * @noThrow
     */
    public func isAsciiUpperCase(): Bool {
        return this >= b'A' && this <= b'Z'
    }

    
    /*
     * @noThrow
     */
    public func isAscii(): Bool {
        return this <= 0x7F
    }



    /*
     * @noThrow
     */
    public func isAsciiWhiteSpace(): Bool {
        return (this >= 0x09 && this <= 0x0D) || this == 0x20
    }

    
    /*
     * @noThrow
     */
    public func toAsciiUpperCase(): Byte {
        return if (this.isAsciiLowerCase()) {
            this - ASCII_UPPER_TO_LOWER_DIFF
        } else {
            this
        }
    }

    
    /*
     * @noThrow
     */
    public func toAsciiLowerCase(): Byte {
        return if (this.isAsciiUpperCase()) {
            this + ASCII_UPPER_TO_LOWER_DIFF
        } else {
            this
        }
    }
}
