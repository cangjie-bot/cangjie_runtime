






package std.unittest

import std.random.Random
import std.unittest.prop_test.RandomSource

extend Configuration {
    /**
     * @throws [set] UnittestOptionValidationException
     * @throws [set] IllegalArgumentException
     * @throws [get|set] IndexOutOfBoundsException
     */
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
    /**
     * @throws [set] UnittestOptionValidationException
     * @throws [set] IllegalArgumentException
     * @throws [get|set] IndexOutOfBoundsException
     */
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

    /**
     * @throws IllegalArgumentException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
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

        /**
         * @throws IndexOutOfBoundsException
         */
    prop generationSteps: Int64 {
        get() { get(KeyGenerationSteps.generationSteps) ?? 200 }
    }
        /**
         * @throws IndexOutOfBoundsException
         */
    prop reductionSteps: Int64 {
        get() { get(KeyReductionSteps.reductionSteps) ?? 200 }
    }
}
