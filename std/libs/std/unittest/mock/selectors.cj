






package std.unittest.mock






public class CardinalitySelector<A> where A <: ActionSelector {
    /*
     * @noThrow
     */
    CardinalitySelector(
        let sc: Scenario,
        let factory: (Scenario) -> A
    ) {}



    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func anyTimes(): Unit {
        sc.setCardinality(Cardinality.atLeastTimes(0))
    }



    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func once(): Continuation<A> {
        sc.setCardinality(Cardinality.once())
        Continuation<A>(sc, factory)
    }


    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func atLeastOnce(): Unit {
        sc.setCardinality(Cardinality.atLeastOnce())
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func times(expectedTimes: Int64): Continuation<A> {
        sc.setCardinality(Cardinality.times(expectedTimes))
        Continuation<A>(sc, factory)
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func times(min!: Int64, max!: Int64): Unit {
        sc.setCardinality(Cardinality.times(min: min, max: max))
    }



    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func atLeastTimes(minTimesExpected: Int64): Unit {
        sc.setCardinality(Cardinality.atLeastTimes(minTimesExpected))
    }
}






public class Continuation<A> where A <: ActionSelector {
    /*
     * @noThrow
     */
    Continuation(
        let previousSc: Scenario,
        let factory: (Scenario) -> A
    ) {}


    /*
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     * @throws IllegalSynchronizationStateException
     */
    public func then(): A {
        let continuationSc = MockFramework.session {
            session: MockSession => previousSc.parentChain.addScenario(session)
        }
        factory(continuationSc)
    }
}
