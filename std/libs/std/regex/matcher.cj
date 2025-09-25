







package std.regex



@Deprecated[message: "APIs in Matcher have been moved to Regex."]
public class Matcher {
    private var input: String
    private var regex: Regex
    private var begin: Int64 = 0
    private var end: Int64

    private var iterator: FindIterator

    private var replacedOption: Option<String> = None
    private var replaceRegexOption: Option<Regex> = None
    private var replaceIteraorOption: Option<FindIterator> = None
    private var replaceOffsetOption: Option<Int64> = None

    public init(regex: Regex, input: String) {
        this.regex = regex
        this.input = input
        this.iterator = FindIterator(regex, input, group: true)
        end = input.size
    }



    public func fullMatch(): Option<MatchData> {
        let inputCString = unsafe { LibC.mallocCString(input) }
        if (inputCString.isNull()) {
            throw RegexException("Failed to mallocCString.")
        }
        let pcre2md = unsafe { CJ_REGEX_CreateMatchData(this.regex.re) }
        if (pcre2md.isNull()) {
            release(inputCString)
            throw RegexException("Create match_data for pattern `${this.regex.pattern}` failed.")
        }
        let result: Option<MatchData>
        try {
            result = regex.find(input, inputCString, pcre2md, this.begin, group: true)
        } finally {
            release(inputCString)
            release(pcre2md)
        }
        if (let Some(md) <- result) {
            if (md.matchString().size != this.input.size) {
                return None
            }
        }
        return result
    }



    public func matchStart(): Option<MatchData> {
        let inputCString = unsafe { LibC.mallocCString(input) }
        if (inputCString.isNull()) {
            throw RegexException("Failed to mallocCString.")
        }
        let pcre2md = unsafe { CJ_REGEX_CreateMatchData(this.regex.re) }
        if (pcre2md.isNull()) {
            release(inputCString)
            throw RegexException("Create match_data for pattern `${this.regex.pattern}` failed.")
        }
        let result: Option<MatchData>
        try {
            result = regex.find(input, inputCString, pcre2md, this.begin, group: true)
        } finally {
            release(inputCString)
            release(pcre2md)
        }
        if (let Some(md) <- result) {
            if (this.input.startsWith(md.matchString())) {
                return md
            }
        }
        return None
    }

    private func checkBounds(mdOption: Option<MatchData>): Bool {
        if (let Some(md) <- mdOption) {
            let position = md.matchPosition()
            if (this.begin <= position.start && this.end >= position.end) {
                return true
            }
        }
        return false
    }











    public func find(): Option<MatchData> {
        let mdOption = iterator.next()
        if (checkBounds(mdOption)) {
            return mdOption
        }
        return None
    }







    public func find(index: Int64): Option<MatchData> {
        if (index < 0 || index >= input.size) {
            throw IndexOutOfBoundsException("Invalid index: ${index} against size: ${input.size}.")
        }
        setRegion(index, this.input.size)
        return find()
    }


    public func findAll(): Option<Array<MatchData>> {
        let list = regex.findAll(input, group: true)
        return if (list.isEmpty()) {
            None
        } else {
            list
        }
    }



    public func allCount(): Int64 {
        return regex.allCount(input, this.begin, this.end)
    }









    public func replace(replacement: String): String {
        var replaced = this.replacedOption ?? input
        let replaceRegex = this.replaceRegexOption ?? Regex(regex.string(), regex.flags)
        let replaceIteraor = this.replaceIteraorOption ?? FindIterator(replaceRegex, input, group: false)
        replaceIteraor.offset = this.begin
        var replaceOffset = replaceOffsetOption ?? 0
        let sb = if (replaced.size == 0) {
            StringBuilder()
        } else {
            StringBuilder(replaced.size)
        }
        var replaceEnd = 0
        if (let Some(md) <- replaceIteraor.next()) {
            let position = md.matchPosition()
            this.begin = position.end
            let replaceStart = position.start + replaceOffset
            sb.append(replaced[0..replaceStart])
            sb.append(replacement)
            replaceEnd = position.end + replaceOffset

            let matchLength = position.end - position.start
            replaceOffsetOption = replaceOffset + replacement.size - matchLength
        } else {
            return replaced
        }
        sb.append(replaced[replaceEnd..])
        replaced = sb.toString()
        replacedOption = replaced
        return replaced
    }













    public func replace(replacement: String, index: Int64): String {
        if (index < 0 || index >= input.size) {
            throw IndexOutOfBoundsException("Invalid index: ${index} against size: ${input.size}.")
        }
        setRegion(index, input.size)
        return regex.replace(input, replacement, index)
    }


    public func replaceAll(replacement: String): String {
        return replaceAll(replacement, -1)
    }







    public func replaceAll(replacement: String, limit: Int64): String {
        return regex.replaceAll(input, replacement, limit)
    }





    public func split(): Array<String> {
        return regex.split(input)
    }










    public func split(limit: Int64): Array<String> {
        return regex.split(input, limit)
    }









    public func setRegion(beginIndex: Int64, endIndex: Int64): Matcher {
        if (beginIndex < 0 || beginIndex > input.size) {
            throw IndexOutOfBoundsException("Begin ${beginIndex}.")
        }
        if (endIndex < 0 || endIndex > input.size) {
            throw IndexOutOfBoundsException("End ${endIndex}.")
        }
        if (beginIndex > endIndex) {
            throw IndexOutOfBoundsException("End ${endIndex} must be greater than or equal to Start ${beginIndex}.")
        }

        begin = beginIndex
        end = endIndex
        iterator.offset = beginIndex

        return this
    }


    public func region(): Position {
        Position(begin, end)
    }







    public func resetRegion(): Matcher {
        begin = 0
        end = input.size
        iterator.offset = begin
        replaceOffsetOption = None
        replaceIteraorOption = None
        replaceRegexOption = None
        replacedOption = None
        return this
    }






    public func resetString(input: String): Matcher {
        this.input = input
        this.iterator = FindIterator(regex, input, group: true)
        resetRegion()
        return this
    }




    public func getString(): String {
        return this.input
    }
}
