






package std.unittest

import std.random.Random
import std.unittest.prop_test.RandomSource

extend Configuration {
    mut prop randomSeed: ?Int64 {
        get(){ get(KeyRandomSeed.randomSeed) }
        set(value) {
            match (value) {
                case None => remove(KeyRandomSeed.randomSeed)
                case Some(v) =>
                    set(KeyRandomSeed.randomSeed, v)
            }
            return
        }
    }
    mut prop random: ?RandomSource {
        get() { get<RandomSource>(KeyRandom.random) }
        set(value) {
            match (value) {
                case None =>
                    remove<RandomSource>(KeyRandom.random)
                case Some(v) =>
                    set<RandomSource>(KeyRandom.random, v)
            }
            return
        }
    }

    @OverflowWrapping
    func initRandom() {
        let random = if (let Some(seed) <- get(KeyRandomSeed.randomSeed)) {
            Random(UInt64(seed))
        } else {
            Random()
        }
        set(KeyRandomSeed.randomSeed, Int64(random.seed))
        set<RandomSource>(KeyRandom.random, random)
    }

    prop generationSteps: Int64 {
        get() { get(KeyGenerationSteps.generationSteps) ?? 200 }
    }
    prop reductionSteps: Int64 {
        get() { get(KeyReductionSteps.reductionSteps) ?? 200 }
    }
}
