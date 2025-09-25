






package std.unittest

import std.time.DateTime
public interface BenchmarkInputMarker {}

public interface BenchInputProvider<T> <: BenchmarkInputMarker {
    @Frozen
    mut func reset(max: Int64) {
        let _ = max
    }
    @Frozen
    mut func get(idx: Int64): T
}
public struct ImmutableInputProvider<T> <: BenchInputProvider<T> {
    @Frozen
    public ImmutableInputProvider(let data: T) {}

    @Frozen
    public mut func get(_: Int64): T { data }

    @Frozen
    public static func createOrExisting(arg: T, x!: Int64 = 0): ImmutableInputProvider<T> {
        let _ = x
        ImmutableInputProvider(arg)
    }

    @Frozen
    public static func createOrExisting<U>(arg: U): U where U <: BenchInputProvider<T> {
        arg
    }
}
public struct BatchInputProvider<T> <: BenchInputProvider<T> {
    var data: Array<T> = []

    @Frozen
    public BatchInputProvider(let builder: () -> T) {}

    @Frozen
    public mut func reset(max: Int64) {
        if (data.size >= max) {
            for (i in 0..data.size) {
                data[i] = builder()
            }
        } else {
            let x = builder
            data = Array(max, { _ => x() })
        }
    }

    @Frozen
    public mut func get(idx: Int64): T { data[idx] }
}



public struct BatchSizeOneInputProvider<T> <: BenchInputProvider<T> {
    var data: T

    @Frozen
    public BatchSizeOneInputProvider(let builder: () -> T) {
        data = builder()
    }

    @Frozen
    public mut func reset(max: Int64) {
        if (max > 1) {
            throw IllegalStateException("Please set `batchSize` parameter equal to 1 in @Configure.")
        }
        data = builder()
    }

    @Frozen
    public mut func get(_: Int64): T { data }
}


public struct GenerateEachInputProvider<T> <: BenchInputProvider<T> {
    @Frozen
    public GenerateEachInputProvider(let builder: () -> T) {}

    @Frozen
    public mut func reset(_: Int64) {}

    @Frozen
    public mut func get(_: Int64): T { builder() }
}

struct SimpleBenchWrapper<T> <: BenchmarkWrapper {
    SimpleBenchWrapper(let input: T, let f: (T, Int64, Int64) -> Float64) {}

    public func measureLoopOnce(times: Int64, max: Int64): Float64 {
        f(input, times, max)
    }

    public func timeLoopOnce(times: Int64, max: Int64): Float64 {
        let tmp = DateTime.now()
        f(input, times, max)
        Float64((DateTime.now() - tmp).toNanoseconds())
    }
}
interface BenchmarkWrapper {
    func measureLoopOnce(times: Int64, max: Int64): Float64

    func timeLoopOnce(times: Int64, max: Int64): Float64
}

public interface BenchmarkConfig {
    func batchSize(b: Int64): Unit
    func batchSize(x: Range<Int64>): Unit
    func warmup(x: Int64): Unit
    func warmup(x: Duration): Unit
    func minDuration(x: Duration): Unit
    func explicitGC(x: ExplicitGcType): Unit
    func minBatches(x: Int64): Unit
}

extend Configuration <: BenchmarkConfig {
    public func batchSize(b: Int64) {
        batchSize(b..=b)
    }

    public func batchSize(x: Range<Int64>) {
        if (x.end < 1 || x.end > MAX_BATCH_SIZE) {
            throw IllegalArgumentException("batch size must be in range from 1 to ${MAX_BATCH_SIZE}")
        }
        this.set(KeyBatchSize.batchSize, x)
    }

    public func warmup(x: Int64) {
        this.set(KeyWarmup.warmup, x)
    }

    public func warmup(x: Duration) {
        this.set(KeyWarmup.warmup, x)
    }

    public func minDuration(x: Duration) {
        this.set(KeyMinDuration.minDuration, x)
    }

    public func explicitGC(x: ExplicitGcType) {
        this.set(KeyExplicitGC.explicitGC, x)
    }

    public func minBatches(x: Int64) {
        this.set(KeyMinBatches.minBatches, x)
    }
}
