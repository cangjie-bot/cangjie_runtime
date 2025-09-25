






package std.unittest.prop_test

import std.random.Random


public interface Generator<T> {


    func next(): T
}

class OneValueGenerator<T> <: Generator<T> {
    OneValueGenerator(let value: T) {}

    public override func next(): T {
        value
    }
}

class FunctionGenerator<T> <: Generator<T> {
    FunctionGenerator(let body: () -> T) {}

    public override func next(): T {
        body()
    }
}

class ArrayGenerator<T> <: Generator<T> {
    ArrayGenerator(let random: RandomSource, let array: Array<T>) {}

    public override func next(): T {
        array[random.nextInt64(array.size)]
    }
}

class SelectionGenerator<T> <: Generator<T> {
    private let total: UInt64

    SelectionGenerator(let random: RandomSource, let variants: Array<(UInt64, Generator<T>)>) {
        var total: UInt64 = 0
        for ((v, _) in variants) {
            total += v
        }
        this.total = total
    }

    public override func next(): T {
        var pick = random.nextUInt64(total)
        for ((n, g) in variants) {
            if (pick < n) {
                return g.next()
            }

            pick -= n
        }
        variants[variants.size - 1][1].next()
    }
}

class RangeGenerator<T> <: Generator<T> {
    let l: T
    let r: T
    RangeGenerator(l: T, r: T, let body: (T, T) -> T) {
        this.l = l
        this.r = r
    }
    public override func next(): T {
        body(l, r)
    }
}


public class Generators {


    public static func generate<T>(l: T, r: T, body: (T, T) -> T): Generator<T> {
        RangeGenerator(l, r, body)
    }


    public static func single<T>(value: T): Generator<T> {
        FunctionGenerator({=> value})
    }


    public static func generate<T>(body: () -> T): Generator<T> {
        FunctionGenerator(body)
    }


    public static func iterable<T>(random: RandomSource, collection: Array<T>): Generator<T> {
        ArrayGenerator<T>(random, collection)
    }



    public static func weighted<T>(random: RandomSource, variants: Array<(UInt64, Generator<T>)>): Generator<T> {
        SelectionGenerator<T>(random, variants)
    }



    public static func pick<T>(random: RandomSource, variants: Array<Generator<T>>): Generator<T> {
        SelectionGenerator<T>(random, Array(variants.size) {i: Int64 => (UInt64(1), variants[i])})
    }


    public static func lookup<T>(random: RandomSource): Generator<T> where T <: Arbitrary<T> {
        T.arbitrary(random)
    }


    public static func mapped<T, R>(random: RandomSource, body: (T) -> R): Generator<R> where T <: Arbitrary<T> {
        let base = lookup<T>(random)
        generate {body(base.next())}
    }


    public static func mapped<T1, T2, R>(random: RandomSource, body: (T1, T2) -> R): Generator<R> where T1 <: Arbitrary<T1>,
        T2 <: Arbitrary<T2> {
        let v1 = lookup<T1>(random)
        let v2 = lookup<T2>(random)
        generate {body(v1.next(), v2.next())}
    }


    public static func mapped<T1, T2, T3, R>(random: RandomSource, body: (T1, T2, T3) -> R): Generator<R> where T1 <: Arbitrary<T1>,
        T2 <: Arbitrary<T2>, T3 <: Arbitrary<T3> {
        let v1 = lookup<T1>(random)
        let v2 = lookup<T2>(random)
        let v3 = lookup<T3>(random)
        generate {body(v1.next(), v2.next(), v3.next())}
    }


    public static func mapped<T1, T2, T3, T4, R>(random: RandomSource, body: (T1, T2, T3, T4) -> R): Generator<R> where T1 <: Arbitrary<T1>,
        T2 <: Arbitrary<T2>, T3 <: Arbitrary<T3>, T4 <: Arbitrary<T4> {
        let v1 = lookup<T1>(random)
        let v2 = lookup<T2>(random)
        let v3 = lookup<T3>(random)
        let v4 = lookup<T4>(random)
        generate {body(v1.next(), v2.next(), v3.next(), v4.next())}
    }
}
