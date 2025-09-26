






package std.unittest.prop_test

import std.collection.*
import std.math.abs


public interface Arbitrary<T> {
    static func arbitrary(random: RandomSource): Generator<T>
}







extend Unit <: Arbitrary<Unit> {
    public static func arbitrary(_: RandomSource): Generator<Unit> {
        Generators.single(())
    }
}


extend Bool <: Arbitrary<Bool> {
    public static func arbitrary(random: RandomSource): Generator<Bool> {
        Generators.generate { random.suggestBool() }
    }
}



extend Int8 <: Arbitrary<Int8> {
    public static func arbitrary(random: RandomSource): Generator<Int8> {
        Generators.generate { random.suggestInt8() }
    }
}



extend Int16 <: Arbitrary<Int16> {
    public static func arbitrary(random: RandomSource): Generator<Int16> {
        Generators.generate { random.suggestInt16() }
    }
}



extend Int32 <: Arbitrary<Int32> {
    public static func arbitrary(random: RandomSource): Generator<Int32> {
        Generators.generate { random.suggestInt32() }
    }
}



extend Int64 <: Arbitrary<Int64> {
    public static func arbitrary(random: RandomSource): Generator<Int64> {
        Generators.generate { random.suggestInt64() }
    }
}



extend IntNative <: Arbitrary<IntNative> {
    public static func arbitrary(random: RandomSource): Generator<IntNative> {
        Generators.generate { random.suggestIntNative() }
    }
}



extend UInt8 <: Arbitrary<UInt8> {
    public static func arbitrary(random: RandomSource): Generator<UInt8> {
        Generators.generate { random.suggestUInt8() }
    }
}



extend UInt16 <: Arbitrary<UInt16> {
    public static func arbitrary(random: RandomSource): Generator<UInt16> {
        Generators.generate { random.suggestUInt16() }
    }
}



extend UInt32 <: Arbitrary<UInt32> {
    public static func arbitrary(random: RandomSource): Generator<UInt32> {
        Generators.generate { random.suggestUInt32() }
    }
}



extend UInt64 <: Arbitrary<UInt64> {
    public static func arbitrary(random: RandomSource): Generator<UInt64> {
        Generators.generate { random.suggestUInt64() }
    }
}



extend UIntNative <: Arbitrary<UIntNative> {
    public static func arbitrary(random: RandomSource): Generator<UIntNative> {
        Generators.generate { random.suggestUIntNative() }
    }
}


extend Float16 <: Arbitrary<Float16> {
    public static func arbitrary(random: RandomSource): Generator<Float16> {
        Generators.generate { random.suggestFloat16() }
    }
}


extend Float32 <: Arbitrary<Float32> {
    public static func arbitrary(random: RandomSource): Generator<Float32> {
        Generators.generate { random.suggestFloat32() }
    }
}


extend Float64 <: Arbitrary<Float64> {
    public static func arbitrary(random: RandomSource): Generator<Float64> {
        Generators.generate { random.suggestFloat64() }
    }
}



extend Rune <: Arbitrary<Rune> {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func arbitrary(random: RandomSource): Generator<Rune> {
        Generators.generate { random.suggestRune() }
    }
}

let SIZE_UPPER_LIMIT = 4000

/**
 * @throws OverflowException
 */
func sizeGenerator(random: RandomSource): Generator<Int64> {
    func suggestSizeUpTo(max: Int64): Int64 {
        var size = random.nextInt64()
        if (size == Int64.Min) { size = max - 1 }
        return abs(size) % max
    }

    func approximatedNormalDist(sigma: Int64) {
        let t = sigma / 8









































































        Generators.weighted<Int64>(
            random,
            [
                (7, Generators.generate {suggestSizeUpTo(1 * t)}),
                (30, Generators.generate {suggestSizeUpTo(2 * t)}),
                (66, Generators.generate {suggestSizeUpTo(3 * t)}),
                (108, Generators.generate {suggestSizeUpTo(4 * t)}),
                (160, Generators.generate {suggestSizeUpTo(5 * t)}),
                (216, Generators.generate {suggestSizeUpTo(6 * t)}),
                (259, Generators.generate {suggestSizeUpTo(7 * t)}),
                (448, Generators.generate {suggestSizeUpTo(8 * t)}),
                (710, Generators.generate {suggestSizeUpTo(10 * t)}),
                (726, Generators.generate {suggestSizeUpTo(12 * t)}),
                (658, Generators.generate {suggestSizeUpTo(14 * t)}),
                (956, Generators.generate {suggestSizeUpTo(16 * t)}),
                (603, Generators.generate {suggestSizeUpTo(24 * t)}),
                (48, Generators.generate {suggestSizeUpTo(32 * t)}),
                (5, Generators.generate {suggestSizeUpTo(SIZE_UPPER_LIMIT)})
            ]
        )
    }

    const sigma = 256
    Generators.weighted<Int64>(
        random,
        [
            (5, Generators.single(0)),
            (5, Generators.single(1)),
            (90, approximatedNormalDist(sigma))
        ]
    )
}




extend<T> Array<T> <: Arbitrary<Array<T>> where T <: Arbitrary<T> {
    /**
     * @throws OverflowException
     */
    public static func arbitrary(random: RandomSource): Generator<Array<T>> {
        let elementGenerator = T.arbitrary(random)
        let sizeGenerator = sizeGenerator(random)

        Generators.weighted<Array<T>>(
            random,
            [
                (10, Generators.single([])),
                (10, Generators.generate {[elementGenerator.next()]}),
                (80, Generators.generate {
                    var size = sizeGenerator.next()
                    Array<T>(size) { _ => elementGenerator.next() }
                })
            ]
        )
    }
}


extend<T> ArrayList<T> <: Arbitrary<ArrayList<T>> where T <: Arbitrary<T> {
    /**
     * @throws OverflowException
     * @throws IllegalArgumentException
     */
    public static func arbitrary(random: RandomSource): Generator<ArrayList<T>> {
        let elementGenerator = T.arbitrary(random)
        let sizeGenerator = sizeGenerator(random)

        Generators.weighted<ArrayList<T>>(
            random,
            [
                (10, Generators.single(ArrayList<T>([]))),
                (10, Generators.generate { ArrayList<T>([elementGenerator.next()]) }),
                (80, Generators.generate {
                    var size = sizeGenerator.next()
                    ArrayList<T>(size) { _ => elementGenerator.next() }
                })
            ]
        )
    }
}


extend<T> HashSet<T> <: Arbitrary<HashSet<T>> where T <: Arbitrary<T> {
    /**
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     */
    public static func arbitrary(random: RandomSource): Generator<HashSet<T>> {
        let elementGenerator = T.arbitrary(random)
        let sizeGenerator = sizeGenerator(random)

        Generators.weighted<HashSet<T>>(
            random,
            [
                (10, Generators.single(HashSet<T>())),
                (10, Generators.generate { HashSet<T>([elementGenerator.next()]) }),
                (80, Generators.generate {
                    var size = sizeGenerator.next()

                    let set = HashSet<T>()
                    for (_ in 0..size) {
                        let v = elementGenerator.next()
                        set.add(v)
                    }

                    return set
                })
            ]
        )
    }
}



extend<K, V> HashMap<K, V> <: Arbitrary<HashMap<K, V>> where K <: Arbitrary<K>, V <: Arbitrary<V> {
    /**
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     */
    public static func arbitrary(random: RandomSource): Generator<HashMap<K, V>> {
        let keyGenerator = K.arbitrary(random)
        let valueGenerator = V.arbitrary(random)
        let sizeGenerator = sizeGenerator(random)

        Generators.weighted<HashMap<K, V>>(
            random,
            [
                (10, Generators.single(HashMap<K, V>())),
                (10, Generators.generate { HashMap<K, V>([(keyGenerator.next(), valueGenerator.next())]) }),
                (80, Generators.generate {
                    var size = sizeGenerator.next()

                    let hmap = HashMap<K, V>()
                    for (_ in 0..size) {
                        let k = keyGenerator.next()
                        let v = valueGenerator.next()

                        hmap[k] = v
                    }

                    return hmap
                })
            ]
        )
    }
}




extend String <: Arbitrary<String> {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func arbitrary(random: RandomSource): Generator<String> {
        Generators.mapped<Array<Rune>, String>(random) { it: Array<Rune> => String(it) }
    }
}



extend<T> Option<T> <: Arbitrary<Option<T>> where T <: Arbitrary<T> {
    public static func arbitrary(random: RandomSource): Generator<Option<T>> {
        Generators.weighted<Option<T>>(
            random,
            [
                (30, Generators.single<Option<T>>(Option<T>.None)),
                (70, Generators.mapped<T, Option<T>>(random) { it: T => it })
            ]
        )
    }
}


extend Ordering <: Arbitrary<Ordering> {
    public static func arbitrary(random: RandomSource): Generator<Ordering> {
        Generators.iterable(random, [Ordering.LT, Ordering.EQ, Ordering.GT])
    }
}




extend<R> Function0Wrapper<R> <: Arbitrary<Function0Wrapper<R>> where R <: Arbitrary<R> {
    public static func arbitrary(random: RandomSource): Generator<Function0Wrapper<R>> {
        Generators.mapped<R, Function0Wrapper<R>>(random) { it: R => Function0Wrapper { => it } }
    }
}



extend<T0, T1> TupleWrapper2<T0, T1> <: Arbitrary<TupleWrapper2<T0, T1>>
        where T0 <: Arbitrary<T0>,
              T1 <: Arbitrary<T1> {
    public static func arbitrary(random: RandomSource): Generator<TupleWrapper2<T0, T1>> {
        let gen0 = T0.arbitrary(random)
        let gen1 = T1.arbitrary(random)
        Generators.generate { TupleWrapper2((gen0.next(), gen1.next())) }
    }
}



extend<T0, T1, T2> TupleWrapper3<T0, T1, T2> <: Arbitrary<TupleWrapper3<T0, T1, T2>>
        where T0 <: Arbitrary<T0>,
              T1 <: Arbitrary<T1>,
              T2 <: Arbitrary<T2> {
    public static func arbitrary(random: RandomSource): Generator<TupleWrapper3<T0, T1, T2>> {
        let gen0 = T0.arbitrary(random)
        let gen1 = T1.arbitrary(random)
        let gen2 = T2.arbitrary(random)
        Generators.generate { TupleWrapper3((gen0.next(), gen1.next(), gen2.next())) }
    }
}



extend<T0, T1, T2, T3> TupleWrapper4<T0, T1, T2, T3> <: Arbitrary<TupleWrapper4<T0, T1, T2, T3>>
        where T0 <: Arbitrary<T0>,
              T1 <: Arbitrary<T1>,
              T2 <: Arbitrary<T2>,
              T3 <: Arbitrary<T3> {
    public static func arbitrary(random: RandomSource): Generator<TupleWrapper4<T0, T1, T2, T3>> {
        let gen0 = T0.arbitrary(random)
        let gen1 = T1.arbitrary(random)
        let gen2 = T2.arbitrary(random)
        let gen3 = T3.arbitrary(random)
        Generators.generate { TupleWrapper4((gen0.next(), gen1.next(), gen2.next(), gen3.next())) }
    }
}



extend<T0, T1, T2, T3, T4> TupleWrapper5<T0, T1, T2, T3, T4> <: Arbitrary<TupleWrapper5<T0, T1, T2, T3, T4>>
        where T0 <: Arbitrary<T0>,
              T1 <: Arbitrary<T1>,
              T2 <: Arbitrary<T2>,
              T3 <: Arbitrary<T3>,
              T4 <: Arbitrary<T4> {
    public static func arbitrary(random: RandomSource): Generator<TupleWrapper5<T0, T1, T2, T3, T4>> {
        let gen0 = T0.arbitrary(random)
        let gen1 = T1.arbitrary(random)
        let gen2 = T2.arbitrary(random)
        let gen3 = T3.arbitrary(random)
        let gen4 = T4.arbitrary(random)
        Generators.generate { TupleWrapper5((gen0.next(), gen1.next(), gen2.next(), gen3.next(), gen4.next())) }
    }
}
