







package std.core

const ASCII_UPPER_TO_LOWER_DIFF: UInt8 = 0x20

extend Byte {


    public func isAsciiLetter(): Bool {
        return (this >= b'A' && this <= b'Z') || (this >= b'a' && this <=
            b'z')
    }


    public func isAsciiNumber(): Bool {
        return this >= b'0' && this <= b'9'
    }


    public func isAsciiHex(): Bool {
        return this.isAsciiNumber() || (this >= b'a' && this <= b'f') || (this >= b'A' &&
            this <= b'F')
    }


    public func isAsciiOct(): Bool {
        return this >= b'0' && this <= b'7'
    }


    public func isAsciiPunctuation(): Bool {
        return (this >= b'!' && this <= b'/') || (this >= b':' && this <= b'@') ||
               (this >= b'[' && this <= b'`') || (this >= b'{' && this <= b'~')
    }


    public func isAsciiGraphic(): Bool {
        return this >= b'!' && this <= b'~'
    }


    public func isAsciiControl(): Bool {
        return this <= 0x1F || this == 0x7F
    }


    public func isAsciiNumberOrLetter(): Bool {
        return this.isAsciiLetter() || this.isAsciiNumber()
    }

    
    public func isAsciiLowerCase(): Bool {
        return this >= b'a' && this <= b'z'
    }

    
    public func isAsciiUpperCase(): Bool {
        return this >= b'A' && this <= b'Z'
    }

    
    public func isAscii(): Bool {
        return this <= 0x7F
    }



    public func isAsciiWhiteSpace(): Bool {
        return (this >= 0x09 && this <= 0x0D) || this == 0x20
    }

    
    public func toAsciiUpperCase(): Byte {
        return if (this.isAsciiLowerCase()) {
            this - ASCII_UPPER_TO_LOWER_DIFF
        } else {
            this
        }
    }

    
    public func toAsciiLowerCase(): Byte {
        return if (this.isAsciiUpperCase()) {
            this + ASCII_UPPER_TO_LOWER_DIFF
        } else {
            this
        }
    }
}
