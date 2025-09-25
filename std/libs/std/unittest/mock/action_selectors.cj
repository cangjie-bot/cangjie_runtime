






package std.unittest.mock

import std.collection.ArrayList


public sealed abstract class ActionSelector {
    /*
     * @noThrow
     */
    ActionSelector(
        let sc: Scenario
    ) {}

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func mustBeSpy(actionName: String) {
        match (sc.parentChain.objectKind) {
            case Spy => ()
            case Mock => StubMisconfiguration().fail(sc.parentChain, OnlySpyCanCallOriginal(actionName))
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func throwsImpl(exception: Exception) {
        sc.setAction(Action.Throw { exception })
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func throwsFactoryImpl(exceptionFactory: () -> Exception) {
        requireVerifiable("throws(exceptionFactory)")
        sc.setAction(Action.Throw(exceptionFactory))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func returnsImpl<TRet>(value: TRet) {
        sc.setAction(Action.Return { value })
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func returnsFactoryImpl<TRet>(factory: () -> TRet) {
        requireVerifiable("returns(valueFactory)")
        sc.setAction(Action.Return { factory() })
    }

    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func returnsCollectionImpl<TRet>(values: Collection<TRet>) {
        requireVerifiable("returnsConsecutively")
        let copy = values.toArray()
        let iterator = copy.iterator()
        sc.setAction(Action.Return({ =>
            iterator.next().getOrThrow()
        }))
        sc.setCardinality(Cardinality.times(copy.size))
    }


    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func fails(): Unit {
        sc.setAction(Action.Fail)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    private func requireVerifiable(actionName: String) {
        if (!sc.parentChain.isVerifiable()) {
            StubModeViolation().statefulStubAction(actionName, sc.parentChain)
        }
    }
}


public class MethodActionSelector<TRet> <: ActionSelector {
    /*
     * @noThrow
     */
    MethodActionSelector(
        sc: Scenario
    ) {
        super(sc)
    }

    /*
     * @noThrow
     */
    func cardinalitySelector(): CardinalitySelector<MethodActionSelector<TRet>> {
        CardinalitySelector<MethodActionSelector<TRet>>(sc) { newSc =>
            MethodActionSelector<TRet>(newSc)
        }
    }

    /*
     * @noThrow
     */
    func continuation(): Continuation<MethodActionSelector<TRet>> {
        Continuation<MethodActionSelector<TRet>>(sc) { newSc =>
            MethodActionSelector<TRet>(newSc)
        }
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func throws(exception: Exception): CardinalitySelector<MethodActionSelector<TRet>> {
        throwsImpl(exception)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func throws(exceptionFactory: () -> Exception): CardinalitySelector<MethodActionSelector<TRet>> {
        throwsFactoryImpl(exceptionFactory)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returns(value: TRet): CardinalitySelector<MethodActionSelector<TRet>> {
        returnsImpl(value)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returns(valueFactory: () -> TRet): CardinalitySelector<MethodActionSelector<TRet>> {
        returnsFactoryImpl(valueFactory)
        cardinalitySelector()
    }





    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returnsConsecutively(values: Array<TRet>): Continuation<MethodActionSelector<TRet>> {
        returnsCollectionImpl(values)
        continuation()
    }





    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returnsConsecutively(values: ArrayList<TRet>): Continuation<MethodActionSelector<TRet>> {
        returnsCollectionImpl(values)
        continuation()
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func callsOriginal(): CardinalitySelector<MethodActionSelector<TRet>> {
        mustBeSpy("callsOriginal")
        sc.setAction(Action.CallOriginal)
        cardinalitySelector()
    }
}


public class GetterActionSelector<TRet> <: ActionSelector {
    /*
     * @noThrow
     */
    GetterActionSelector(
        sc: Scenario
    ) {
        super(sc)
    }

    /*
     * @noThrow
     */
    func cardinalitySelector(): CardinalitySelector<GetterActionSelector<TRet>> {
        CardinalitySelector<GetterActionSelector<TRet>>(sc) { newSc =>
            GetterActionSelector<TRet>(newSc)
        }
    }

    /*
     * @noThrow
     */
    func continuation(): Continuation<GetterActionSelector<TRet>> {
        Continuation<GetterActionSelector<TRet>>(sc) { newSc =>
            GetterActionSelector<TRet>(newSc)
        }
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func throws(exception: Exception): CardinalitySelector<GetterActionSelector<TRet>> {
        throwsImpl(exception)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func throws(exceptionFactory: () -> Exception): CardinalitySelector<GetterActionSelector<TRet>> {
        throwsFactoryImpl(exceptionFactory)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returns(value: TRet): CardinalitySelector<GetterActionSelector<TRet>> {
        returnsImpl(value)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returns(valueFactory: () -> TRet): CardinalitySelector<GetterActionSelector<TRet>> {
        returnsFactoryImpl(valueFactory)
        cardinalitySelector()
    }





    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returnsConsecutively(values: Array<TRet>): Continuation<GetterActionSelector<TRet>> {
        returnsCollectionImpl(values)
        continuation()
    }





    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returnsConsecutively(values: ArrayList<TRet>): Continuation<GetterActionSelector<TRet>> {
        returnsCollectionImpl(values)
        continuation()
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func getsOriginal(): CardinalitySelector<GetterActionSelector<TRet>> {
        mustBeSpy("getsOriginal")
        sc.setAction(Action.CallOriginal)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func getsField(field: SyntheticField<TRet>): CardinalitySelector<GetterActionSelector<TRet>> {
        sc.setAction(Action.GetField(field.description))
        cardinalitySelector()
    }
}


public class SetterActionSelector<TArg> <: ActionSelector {
    /*
     * @noThrow
     */
    SetterActionSelector(
        sc: Scenario
    ) {
        super(sc)
    }

    /*
     * @noThrow
     */
    func cardinalitySelector(): CardinalitySelector<SetterActionSelector<TArg>> {
        CardinalitySelector<SetterActionSelector<TArg>>(sc) { newSc =>
            SetterActionSelector<TArg>(newSc)
        }
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func throws(exception: Exception): CardinalitySelector<SetterActionSelector<TArg>> {
        throwsImpl(exception)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func throws(exceptionFactory: () -> Exception): CardinalitySelector<SetterActionSelector<TArg>> {
        throwsFactoryImpl(exceptionFactory)
        cardinalitySelector()
    }



    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func doesNothing(): CardinalitySelector<SetterActionSelector<TArg>> {
        sc.setAction(Action.Return { () })
        cardinalitySelector()
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func setsOriginal(): CardinalitySelector<SetterActionSelector<TArg>> {
        mustBeSpy("setsOriginal")
        sc.setAction(Action.CallOriginal)
        cardinalitySelector()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func setsField(field: SyntheticField<TArg>): CardinalitySelector<SetterActionSelector<TArg>> {
        sc.setAction(Action.SetField(field.description))
        cardinalitySelector()
    }
}

extend MethodActionSelector<Unit> {



    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func returns(): CardinalitySelector<MethodActionSelector<Unit>> {
        returnsImpl(())
        cardinalitySelector()
    }
}
