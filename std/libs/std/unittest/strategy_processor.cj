






package std.unittest

import std.collection.*
import std.unittest.common.toStringOrPlaceholder

public class FlatMapProcessor<T, R> <: DataStrategyProcessor<R> {
    var provider: RememberingDataProvider<R> = RememberingDataProvider("", [])
    /*
     * @noThrow
     */
    FlatMapProcessor(let orig: DataStrategyProcessor<T>, let mapper: (T) -> DataProvider<R>) {}

    protected prop isInfinite: Bool {
        /*
         * @noThrow
         */
        get() { orig.isInfinite }
    }

    /*
     * @noThrow
     */
    protected func provide(configuration: Configuration): Iterable<R> {
        orig.provide(configuration).iterator() |> flatMap{ x: T =>
            let prov = RememberingDataProvider("map", mapper(x))
            this.provider = prov
            prov.provide()
        }
    }

    /*
     * @noThrow
     */
    protected func shrinkLastItem(configuration: Configuration, engine: LazyCyclicNode): Iterable<R> {
        orig.shrinkLastItem(configuration, engine).iterator() |> flatMap{ x: T =>
            let prov = RememberingDataProvider("map", mapper(x))
            this.provider = prov
            prov.provide()
        }
    }

    /*
     * @noThrow
     */
    protected func lastItemInfo(): Array<InputParameter> {
        orig.lastItemInfo().concat([provider.info])
    }

    /*
     * @throws NoneValueException
     */
    protected func lastItem(_: Configuration): R {
        provider.current.getOrThrow()
    }
}

public class FlatMapStrategyProcessor<T, R> <: DataStrategyProcessor<R> {
    var provider: RememberingDataProvider<R> = RememberingDataProvider("", [])
    var strategy: DataStrategy<R> = []
    /*
     * @noThrow
     */
    FlatMapStrategyProcessor(let orig: DataStrategyProcessor<T>, let mapper: (T) -> DataStrategy<R>) {}

    protected prop isInfinite: Bool {
        /*
         * @noThrow
         */
        get() { orig.isInfinite || strategy.isInfinite }
    }

    /*
     * @noThrow
     */
    protected func provide(configuration: Configuration): Iterable<R> {
        orig.provide(configuration).iterator() |> flatMap{ x: T =>
            this.strategy = mapper(x)
            let prov = RememberingDataProvider("map", strategy.provider(configuration))
            this.provider = prov
            prov.provide()
        }
    }

    /*
     * @throws NoneValueException
     */
    protected func shrinkLastItem(configuration: Configuration, engine: LazyCyclicNode): Iterable<R> {
        let shrinkIter = strategy.shrinker(configuration).shrink(provider.current.getOrThrow()).iterator()
        let it = RememberingLazyIterable(shrinkIter, provider)
        engine.add(it)
        it
    }

    /*
     * @noThrow
     */
    protected func lastItemInfo(): Array<InputParameter> {
        [provider.info]
    }

    /*
     * @throws NoneValueException
     */
    protected func lastItem(_: Configuration): R { provider.current.getOrThrow() }
}

public class MapProcessor<T, R> <: DataStrategyProcessor<R> {
    /*
     * @noThrow
     */
    MapProcessor(let orig: DataStrategyProcessor<T>, let mapper: (T, Configuration) -> R) {}

    protected prop isInfinite: Bool {
        /*
         * @noThrow
         */
        get() { orig.isInfinite }
    }

    /*
     * @noThrow
     */
    protected func provide(configuration: Configuration): Iterable<R> {
        orig.provide(configuration) |> map { item => mapper(item, configuration) }
    }

    /*
     * @noThrow
     */
    protected func shrinkLastItem(configuration: Configuration, engine: LazyCyclicNode): Iterable<R> {
        orig.shrinkLastItem(configuration, engine) |> map { item => mapper(item, configuration) }
    }

    /*
     * @noThrow
     */
    protected func lastItemInfo(): Array<InputParameter> {
        orig.lastItemInfo()
    }

    /*
     * @noThrow
     */
    protected func lastItem(configuration: Configuration): R {
        mapper(orig.lastItem(configuration), configuration)
    }
}

public class CartesianProductProcessor<T0, T1> <: DataStrategyProcessor<(T0, T1)> {
    /*
     * @noThrow
     */
    public CartesianProductProcessor(let left: DataStrategyProcessor<T0>, let right: DataStrategyProcessor<T1>) {}

    /*
     * @noThrow
     */
    protected func provide(configuration: Configuration): Iterable<(T0, T1)> {
        cartesianFiniteIterator(configuration)
    }

    protected prop isInfinite: Bool {
        /*
         * @noThrow
         */
        get() { left.isInfinite || right.isInfinite }
    }

    /*
     * @noThrow
     */
    protected func shrinkLastItem(configuration: Configuration, engine: LazyCyclicNode): Iterable<(T0, T1)> {
        let (leftLast, rightLast) = lastItem(configuration)
        IterableMix(
            left.shrinkLastItem(configuration, engine) |> map<T0, (T0, T1)> {x => (x, rightLast)},
            right.shrinkLastItem(configuration, engine) |> map<T1, (T0, T1)> {y => (leftLast, y)}
        )
    }

    /*
     * @noThrow
     */
    protected func lastItemInfo(): Array<InputParameter> {
        left.lastItemInfo()
            .concat(right.lastItemInfo())
    }

    /*
     * @noThrow
     */
    protected func lastItem(configuration: Configuration): (T0, T1) {
        (left.lastItem(configuration), right.lastItem(configuration))
    }

    /*
     * @noThrow
     */
    private func cartesianFiniteIterator(configuration: Configuration): Iterator<(T0, T1)> {
        CartesianProductIterator(left.provide(configuration).iterator(), { => right.provide(configuration).iterator() })
    }
}

class CartesianProductIterator<A, B> <: Iterator<(A, B)> {
    var leftElement: ?A
    var right: Iterator<B>

    /*
     * @noThrow
     */
    CartesianProductIterator(let left: Iterator<A>, let rightGen: () -> Iterator<B>) {
        this.right = rightGen()
        this.leftElement = left.next()
    }

    /*
     * @noThrow
     */
    private func nextLeft(): ?A {
        leftElement = left.next()
        return leftElement
    }

    /*
     * @noThrow
     */
    private func nextRight(): ?B {
        let rightElement = right.next()
        if (rightElement.isNone()) {
            nextLeft() ?? return None
            right = rightGen()
            return right.next()
        } else {
            return rightElement
        }
    }

    /*
     * @noThrow
     */
    public override func next(): ?(A, B) {
        let b = nextRight() ?? return None
        let a = leftElement ?? return None
        return (a, b)
    }
}

public class SimpleProcessor<T> <: DataStrategyProcessor<T> {
    var dataProvider: RememberingDataProvider<T> = RememberingDataProvider<T>("", [])
    /*
     * @noThrow
     */
    public SimpleProcessor(let buildDelegate: () -> DataStrategy<T>, let name: String) {}

    private var _delegate = Option<DataStrategy<T>>.None
    private prop strategy: DataStrategy<T> {
        /*
         * @noThrow
         */
        get() {
            match (_delegate) {
                case None => let val = buildDelegate(); _delegate = val; val
                case Some(val) => val
            }
        }
    }

    protected prop isInfinite: Bool {
        /*
         * @noThrow
         */
        get() { strategy.isInfinite }
    }

    /*
     * @noThrow
     */
    protected func provide(configuration: Configuration): Iterable<T> {
        let dp = RememberingDataProvider(name, strategy.provider(configuration))
        dataProvider = dp
        return dp.provide().iterator()
    }

    /*
     * @throws NoneValueException
     */
    protected func shrinkLastItem(configuration: Configuration, engine: LazyCyclicNode): Iterable<T> {
        let shrinkIter = strategy.shrinker(configuration).shrink(lastItem(configuration)).iterator()
        let it = RememberingLazyIterable(shrinkIter, dataProvider)
        engine.add(it)
        it
    }

    /*
     * @noThrow
     */
    protected func lastItemInfo(): Array<InputParameter> {
        [dataProvider.info]
    }

    /*
     * @throws NoneValueException
     */
    protected func lastItem(_: Configuration): T {
        dataProvider.current.getOrThrow()
    }
}

class RememberingDataProvider<T> <: DataProvider<T> {
    var info: InputParameter
    var current: Option<T> = None
    /*
     * @noThrow
     */
    RememberingDataProvider(name: String, let delegate: DataProvider<T>) {
        info = InputParameter(name)
    }
    /*
     * @noThrow
     */
    public func provide(): Iterable<T> {
        RememberingIterable<T>(delegate.provide().iterator(), this)
    }
}
class RememberingIterable<T> <: Iterator<T> {
    /*
     * @noThrow
     */
    RememberingIterable(let delegate: Iterator<T>, let source: RememberingDataProvider<T>) {}

    /*
     * @noThrow
     */
    public func next(): ?T {
        let current = delegate.next()
        source.current = current
        if (let Some(c) <- current) {
            source.info.update(c)
        }
        current
    }
}

class RememberingLazyIterator<T> <: Iterator<T> {
    /*
     * @noThrow
     */
    RememberingLazyIterator(let delegate: RememberingLazyIterable<T>) {}

    /*
     * @noThrow
     */
    public func next(): ?T {
        let result = delegate.currentItem
        if (let Some(current) <- delegate.currentItem) {
            delegate.storage.current = current
            delegate.storage.info.update(current)
            delegate.currentItem = None
        }
        result
    }
}

class RememberingLazyIterable<T> <: LazyCyclicNode & Iterable<T> {
    var currentItem: ?T = None
    var origLastItem: T

    /*
     * @throws NoneValueException
     */
    RememberingLazyIterable(let delegate: Iterator<T>, let storage: RememberingDataProvider<T>) {
        this.origLastItem = storage.current.getOrThrow()
        this.initialize()
    }

    /*
     * @noThrow
     */
    public func recover() {
        storage.current = origLastItem
        storage.info.update(origLastItem)
    }

    /*
     * @noThrow
     */
    public func advance(): ?Unit {
        currentItem = delegate.next()
        if (currentItem.isNone()) {
            return None
        }
    }

    /*
     * @noThrow
     */
    public func iterator(): Iterator<T> { RememberingLazyIterator(this) }
}
class IterableMix<T> <: Iterator<T> {
    /*
     * @noThrow
     */
    IterableMix(let delegate1: Iterator<T>, let delegate2: Iterator<T>) {}

    /*
     * @noThrow
     */
    public func next(): ?T {
        delegate1.next() ?? delegate2.next()
    }
}
class LazyCyclicNodeEngine<T> <: Iterator<T> {
    /*
     * @noThrow
     */
    LazyCyclicNodeEngine(var current: LazyCyclicNode, let iter: Iterator<T>) {}

    /*
     * @noThrow
     */
    public func next(): ?T {
        advance() ?? return None
        iter.next()
    }

    /*
     * @noThrow
     */
    public func advance(): ?Unit {
        current.prev.recover()
        var val = current.advance()
        while (val.isNone() && !refEq(current, current.next_)) {
            current = current.removeSelf()
            val = current.advance()
        }
        current = current.next_
        val
    }
}



public open class LazyCyclicNode {
    var next_: LazyCyclicNode = unsafe { zeroValue() }
    var prev: LazyCyclicNode = unsafe { zeroValue() }

    /*
     * @noThrow
     */
    func initialize(): LazyCyclicNode {
        this.next_ = this
        this.prev = this
        this
    }

    /*
     * @noThrow
     */
    protected open func advance(): ?Unit { None }

    /*
     * @noThrow
     */
    protected open func recover(): Unit {}

    /*
     * @noThrow
     */
    func add(other: LazyCyclicNode) {
        let prevNext = this.next_
        this.next_ = other
        prevNext.prev = other
        other.next_ = prevNext
        other.prev = this
    }
    /*
     * @noThrow
     */
    func removeSelf(): LazyCyclicNode {
        let prev = this.prev
        let next = this.next_

        prev.next_ = next
        next.prev = prev
        next
    }
}
public class InputParameter {
    var position: Int64 = -1
    var repr: String = ""
    /*
     * @noThrow
     */
    InputParameter(let name: String) {}
    /*
     * @noThrow
     */
    func update<T>(param: T) {
        position += 1
        repr = toStringOrPlaceholder(param)
    }
}

type ShrinkResult = (RunStepResult)


sealed abstract class DataStrategyProcessor<T> {
    private var genIterator: Iterator<T> = Array<T>().iterator()
    var currentReduction = 0
    /*
     * @noThrow
     */
    DataStrategyProcessor() {}

    protected prop isInfinite: Bool

    /*
     * @noThrow
     */
    protected func provide(configuration: Configuration): Iterable<T>

    /*
     * @noThrow
     */
    protected func shrinkLastItem(configuration: Configuration, engine: LazyCyclicNode): Iterable<T>

    /*
     * @noThrow
     */
    protected func lastItemInfo(): Array<InputParameter>

    /*
     * @noThrow
     */
    protected func lastItem(configuration: Configuration): T

    /*
     * @noThrow
     */
    func nextIteration(configuration: Configuration) {
        this.genIterator = provide(configuration).iterator()
    }

    /*
     * @noThrow
     */
    func processNextWith(
        _: Configuration,
        runSingle: (T, Array<InputParameter>) -> RunStepResult
    ): ProcessorResult {
        try {
            let value = genIterator.next() ?? return NoItems
            let result = runSingle(value, lastItemInfo())
            if (result.hasFailures()) {
                return Failure(lastItemInfo(), result)
            } else {
                return Success(result)
            }
        } catch (e: Exception) {
            return StrategyError(e)
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func shrink(
        configuration: Configuration,
        runSingle: (T, Array<InputParameter>) -> RunStepResult
    ): ?ProcessorResult {
        try {
            this.currentReduction = 0
            let shrunkInfo = doShrinkWith(configuration, runSingle) ?? return None
            Failure(lastItemInfo(), shrunkInfo)
        } catch (e: Exception) {
            StrategyError(e)
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    private func doShrinkWith(
        configuration: Configuration,
        runSingle: (T, Array<InputParameter>) -> RunStepResult
    ): ?ShrinkResult {
        var result = None<ShrinkResult>

        let reductionSteps = configuration.reductionSteps
        var fuel = reductionSteps
        while (fuel > 0) {
            let node = LazyCyclicNode().initialize()
            let shrinkIter = shrinkLastItem(configuration, node).iterator()
            let shrink = LazyCyclicNodeEngine(node, shrinkIter)

            var noCandidates = true
            var nextShrinked = shrink.next()
            while (let Some(shrinked) <- nextShrinked) {
                if (fuel <= 0) {
                    break
                }

                fuel--
                currentReduction++

                let info = lastItemInfo()
                let stepResult = runSingle(shrinked, info)
                if (stepResult.hasFailures()) {
                    result = stepResult
                    noCandidates = false
                    break
                }

                nextShrinked = shrink.next()
            }
            if (noCandidates) {
                break
            }
        }
        return result
    }

    /*
     * @noThrow
     */
    public func intoBenchmark(
        caseName!: String,
        configuration!: Configuration,
        doRun!: (T, Int64, Int64) -> Float64
    ): Benchmark {
        Benchmark.createWithExplicitLoop<T>(caseName, this, configuration, doRun)
    }

    /*
     * @noThrow
     */
    public func intoUnitTestCase(
        caseName!: String,
        configuration!: Configuration,
        doRun!: (T) -> Unit
    ): UnitTestCase {
        UnitTestCase.createParameterized<T>(caseName, this, configuration: configuration, body: doRun)
    }




    /*
     * @noThrow
     */
    public static func start(s: DataStrategy<T>, name: String): SimpleProcessor<T> {
        SimpleProcessor<T>({ => s }, name)
    }
    /*
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func start<U>(f: () -> DataStrategy<U>, name: String): DataStrategyProcessor<U>
        where U <: BenchInputProvider<T>
    {
        SimpleProcessor<U>(f, name).mapWithConfig { input, configuration =>
            if (input is BatchSizeOneInputProvider<T>) {
                configuration.batchSize(1)
            }
            input
        }
    }
    /*
     * @noThrow
     */
    public static func start(f: () -> DataStrategy<T>, name: String, x!: Int64 = 0): SimpleProcessor<T> {
        let _ = x
        SimpleProcessor<T>(f, name)
    }
    /*
     * @noThrow
     */
    public static func start(f: () -> DataStrategyProcessor<T>, _: String): DataStrategyProcessor<T> {
        f()
    }
    /*
     * @noThrow
     */
    public static func start<U>(f: () -> DataStrategyProcessor<U>, _: String, x!: Int64 = 0): DataStrategyProcessor<U>
        where U <: BenchInputProvider<T>
    {
        let _ = x
        f()
    }
}

extend<T> DataStrategyProcessor<T> {



    /*
     * @noThrow
     */
    public func map<R>(f: (T) -> R): MapProcessor<T, R> {
        MapProcessor<T, R>(this, { x, _ => f(x) })
    }



    /*
     * @noThrow
     */
    public func mapWithConfig<R>(f: (T, Configuration) -> R): MapProcessor<T, R> {
        MapProcessor<T, R>(this, { x, configuration => f(x, configuration)})
    }



    /*
     * @noThrow
     */
    public func flatMap<R>(f: (T) -> DataProvider<R>): FlatMapProcessor<T, R> {
        FlatMapProcessor<T, R>(this, f)
    }



    /*
     * @noThrow
     */
    public func flatMapStrategy<R>(f: (T) -> DataStrategy<R>): FlatMapStrategyProcessor<T, R> {
        FlatMapStrategyProcessor<T, R>(this, f)
    }



    /*
     * @noThrow
     */
    public func product<R>(p: DataStrategyProcessor<R>): CartesianProductProcessor<T, R> {
        CartesianProductProcessor<T, R>(this, p)
    }



    /*
     * @noThrow
     */
    public func productWithUnit<P>(p: P): MapProcessor<(T, Unit), T> where P <: DataStrategyProcessor<Unit> {
        CartesianProductProcessor<T, Unit>(this, p)
            .map{ x => x[0] }
    }
}

enum ProcessorResult {
      /*
       * @noThrow
       */
    | Success(RunStepResult)
      /*
       * @noThrow
       */
    | Failure(Array<InputParameter>, RunStepResult)
    | NoItems
      /*
       * @noThrow
       */
    | StrategyError(Exception)
}
