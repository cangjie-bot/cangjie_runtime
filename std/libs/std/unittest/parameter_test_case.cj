






package std.unittest

import std.random.Random
import std.unittest.prop_test.RandomSource

extend Configuration {
    mut prop randomSeed: ?Int64 {
        /*
         * @throws IndexOutOfBoundsException
         */
        get(){ get(KeyRandomSeed.randomSeed) }
        /*
         * @throws IllegalArgumentException
         * @throws UnittestOptionValidationException
         * @throws IndexOutOfBoundsException
         */
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
        /*
         * @throws IndexOutOfBoundsException
         */
        get() { get<RandomSource>(KeyRandom.random) }
        /*
         * @throws IllegalArgumentException
         * @throws UnittestOptionValidationException
         * @throws IndexOutOfBoundsException
         */
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
    /*
     * @throws IllegalArgumentException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
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
        /*
         * @throws IndexOutOfBoundsException
         */
        get() { get(KeyGenerationSteps.generationSteps) ?? 200 }
    }
    prop reductionSteps: Int64 {
        /*
         * @throws IndexOutOfBoundsException
         */
        get() { get(KeyReductionSteps.reductionSteps) ?? 200 }
    }
}
