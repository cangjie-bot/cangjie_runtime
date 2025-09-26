







package std.regex

const UNCAPTURED_GROUP_INDEX: Int64 = -1

public struct Position {
    static let empty = Position(0, 0)
    Position(public let start: Int64, public let end: Int64) {}

    @OverflowWrapping
    init(start: UIntNative, end: UIntNative) {
        this.start = Int64(start)
        this.end = Int64(end)
    }
}

public struct MatchData {
    /**
     * @throws IllegalArgumentException
     */
    MatchData(
        let input: String,
        let positions: Array<Position>,
        let rc: Int64,
        let nameToIndex!: (String) -> Int64 = {
            _ => throw IllegalArgumentException("Capture group not enabled.")
        }
    ) {}


    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func matchString(): String {
        let position = positions[0]
        return input[position.start..position.end]
    }




    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func matchString(group: Int64): String {
        if (positions.size == 1 && rc > 1 && group > 0) {
            throw IllegalArgumentException("Capture group not enabled.")
        }
        if (group < 0 || group >= rc) {
            throw IllegalArgumentException("Invalid group index.")
        }
        let position = positions[group]
        if (position.start == UNCAPTURED_GROUP_INDEX || position.end == UNCAPTURED_GROUP_INDEX) {
            return String.empty
        }
        return input[position.start..position.end]
    }




    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func matchString(group: String): String {
        if (positions.size == 1 && rc > 1) {
            throw IllegalArgumentException("Capture group not enabled.")
        }
        let index = nameToIndex(group)
        let position = positions[index]
        if (position.start == UNCAPTURED_GROUP_INDEX || position.end == UNCAPTURED_GROUP_INDEX) {
            return String.empty
        }
        return input[position.start..position.end]
    }




    /**
     * @throws IndexOutOfBoundsException
     */
    public func matchPosition(): Position {
        return positions[0]
    }




    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func matchPosition(group: Int64): Position {
        if (positions.size == 1 && rc > 1 && group > 0) {
            throw IllegalArgumentException("Capture group not enabled.")
        }
        if (group < 0 || group >= rc) {
            throw IllegalArgumentException("Invalid group index.")
        }
        return positions[group]
    }




    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func matchPosition(group: String): Position {
        if (positions.size == 1 && rc > 1) {
            throw IllegalArgumentException("Capture group not enabled.")
        }
        let index = nameToIndex(group)
        return positions[index]
    }

    @Deprecated[message: "Use member function `public func groupCount(): Int64` instead."]
    public func groupNumber(): Int64 {
        return groupCount()
    }


    public func groupCount(): Int64 {
        return rc - 1
    }
}
