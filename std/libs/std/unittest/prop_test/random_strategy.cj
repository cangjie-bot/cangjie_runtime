






package std.unittest.prop_test

import std.collection.filter
import std.unittest.common.*

public struct KeyRandom <: KeyFor<RandomSource> {
    public static prop random: KeyRandom {
        get() {
            KeyRandom()
        }
    }

    public prop name: String {
        get() {
            "random"
        }
    }
}

class GeneratorAsIterator<T> <: Iterator<T> {
    GeneratorAsIterator(private var gen: ?Generator<T>) {}
    public override func next(): ?T {
        let result = gen?.next()
        gen = None
        return result
    }
}





public class RandomDataProvider<T> <: DataProvider<T> where T <: Arbitrary<T> {





    public RandomDataProvider(private let configuration: Configuration) {
        this.random = configuration.get<RandomSource>(KeyRandom.random) ??
                throw IllegalArgumentException("RandomDataProvider initialized without configured random generator instance")
    }



    public override func provide(): Iterable<T> {
        return GeneratorAsIterator(T.arbitrary(random))
    }

    private let random: RandomSource
}



public class RandomDataShrinker<T> <: DataShrinker<T> {




    public override func shrink(value: T): Iterable<T> {
        match (value) {
            case shrinkable: Shrink<T> => shrinkable.shrink()
            case _ => []
        }
    }
}



public class RandomDataStrategy<T> <: DataStrategy<T> where T <: Arbitrary<T> {





    public override func provider(configuration: Configuration): RandomDataProvider<T> {
        RandomDataProvider<T>(configuration)
    }



    public override func shrinker(_: Configuration): RandomDataShrinker<T> {
        RandomDataShrinker<T>()
    }



    public override prop isInfinite: Bool {
        get() { true }
    }
}




public func random<T>(): RandomDataStrategy<T> where T <: Arbitrary<T> {
    RandomDataStrategy<T>()
}

public class RandomDataProviderRange<T> <: DataProvider<T> where T <: ArbitraryRange<T> {
    public RandomDataProviderRange(private let configuration: Configuration, private let min: T, private let max: T) {
        this.random = configuration.get<RandomSource>(KeyRandom.random) ??
                throw IllegalArgumentException("RandomDataProvider initialized without configured random generator instance")
    }

    public override func provide(): Iterable<T> {
        return GeneratorAsIterator(T.arbitraryRange(random, min, max))
    }

    private let random: RandomSource
}

public class RandomDataShrinkerRange<T> <: DataShrinker<T> where T <: Comparable<T> {
    RandomDataShrinkerRange(private let min: T, private let max: T) {}

    public override func shrink(value: T): Iterable<T> {
        match (value) {
            case shrinkable: Shrink<T> => shrinkable.shrink() |> filter { it => min <= it && it <= max }
            case _ => []
        }
    }
}

public class RandomDataStrategyRange<T> <: DataStrategy<T> where T <: ArbitraryRange<T> {
    RandomDataStrategyRange(private let min: T, private let max: T) {}

    public override func provider(configuration: Configuration): RandomDataProviderRange<T> {
        RandomDataProviderRange<T>(configuration, min, max)
    }

    public override func shrinker(_: Configuration): RandomDataShrinkerRange<T> {
        RandomDataShrinkerRange<T>(min, max)
    }

    public override prop isInfinite: Bool {
        get() { true }
    }
}

public func randomInRange<T>(min!: Option<T> = None, max!: Option<T> = None): RandomDataStrategyRange<T> where T <: ArbitraryRange<T> {
    if ((min ?? T.min()) > (max ?? T.max())) {
        throw IllegalArgumentException("the interval you provided is empty")
    }
    RandomDataStrategyRange<T>(min ?? T.min(), max ?? T.max())
}
