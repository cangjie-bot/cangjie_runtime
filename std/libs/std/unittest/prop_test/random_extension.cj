






package std.unittest.prop_test

import std.random.Random


extend Random {
    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func pick<T>(choices: Array<T>): T {
        choices[nextInt64(choices.size)]
    }
    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func pickWeighted<T>(choices: WeightTable<T>): T {
        choices[nextInt64(Int64(choices.total))]
    }
}

class WeightTable<T> {
    public let total: UInt64
    public WeightTable(let choices: Array<(UInt64, T)>) {
        var temp: UInt64 = 0
        for ((w, _) in choices) {
            temp += w
        }
        this.total = temp
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func [](index: Int64): T {
        var temp = UInt64(index)
        for ((n, g) in choices) {
            if (temp < n) {
                return g
            }

            temp -= n
        }
        return choices[choices.size - 1][1]
    }
}
