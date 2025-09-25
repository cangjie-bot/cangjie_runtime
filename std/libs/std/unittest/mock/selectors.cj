






package std.unittest.mock






public class CardinalitySelector<A> where A <: ActionSelector {
    CardinalitySelector(
        let sc: Scenario,
        let factory: (Scenario) -> A
    ) {}



    public func anyTimes(): Unit {
        sc.setCardinality(Cardinality.atLeastTimes(0))
    }



    public func once(): Continuation<A> {
        sc.setCardinality(Cardinality.once())
        Continuation<A>(sc, factory)
    }


    public func atLeastOnce(): Unit {
        sc.setCardinality(Cardinality.atLeastOnce())
    }




    public func times(expectedTimes: Int64): Continuation<A> {
        sc.setCardinality(Cardinality.times(expectedTimes))
        Continuation<A>(sc, factory)
    }





    public func times(min!: Int64, max!: Int64): Unit {
        sc.setCardinality(Cardinality.times(min: min, max: max))
    }



    public func atLeastTimes(minTimesExpected: Int64): Unit {
        sc.setCardinality(Cardinality.atLeastTimes(minTimesExpected))
    }
}






public class Continuation<A> where A <: ActionSelector {
    Continuation(
        let previousSc: Scenario,
        let factory: (Scenario) -> A
    ) {}


    public func then(): A {
        let continuationSc = MockFramework.session {
            session: MockSession => previousSc.parentChain.addScenario(session)
        }
        factory(continuationSc)
    }
}
