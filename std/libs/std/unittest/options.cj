






package std.unittest

import std.random.Random
import std.unittest.prop_test.RandomSource

              /*
               * @noThrow
               */
public struct KeyHelp <: KeyFor<Bool> {
    public static prop help: KeyHelp {
        /*
         * @noThrow
         */
        get() {
            KeyHelp()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "help"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyNoColor <: KeyFor<Bool> {
    public static prop noColor: KeyNoColor {
        /*
         * @noThrow
         */
        get() {
            KeyNoColor()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "noColor"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyFromTopLevel <: KeyFor<Bool> {
    public static prop fromTopLevel: KeyFromTopLevel {
        /*
         * @noThrow
         */
        get() {
            KeyFromTopLevel()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "fromTopLevel"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyRandomSeed <: KeyFor<Int64> {
    public static prop randomSeed: KeyRandomSeed {
        /*
         * @noThrow
         */
        get() {
            KeyRandomSeed()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "randomSeed"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyWarmup <: KeyFor<Int64> & KeyFor<Duration> {
    public static prop warmup: KeyWarmup {
        /*
         * @noThrow
         */
        get() {
            KeyWarmup()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "warmup"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyMinDuration <: KeyFor<Duration> {
    public static prop minDuration: KeyMinDuration {
        /*
         * @noThrow
         */
        get() {
            KeyMinDuration()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "minDuration"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyExplicitGC <: KeyFor<ExplicitGcType> {
    public static prop explicitGC: KeyExplicitGC {
        /*
         * @noThrow
         */
        get() {
            KeyExplicitGC()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "explicitGC"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyMinBatches <: KeyFor<Int64> {
    public static prop minBatches: KeyMinBatches {
        /*
         * @noThrow
         */
        get() {
            KeyMinBatches()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "minBatches"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyBatchSize <: KeyFor<Int64> & KeyFor<Range<Int64>> {
    public static prop batchSize: KeyBatchSize {
        /*
         * @noThrow
         */
        get() {
            KeyBatchSize()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "batchSize"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyParallel <: KeyFor<Bool> & KeyFor<String> & KeyFor<Int64> {
    public static prop parallel: KeyParallel {
        /*
         * @noThrow
         */
        get() {
            KeyParallel()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "parallel"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyGenerationSteps <: KeyFor<Int64> {
    public static prop generationSteps: KeyGenerationSteps {
        /*
         * @noThrow
         */
        get() {
            KeyGenerationSteps()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "generationSteps"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyReductionSteps <: KeyFor<Int64> {
    public static prop reductionSteps: KeyReductionSteps {
        /*
         * @noThrow
         */
        get() {
            KeyReductionSteps()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "reductionSteps"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeySkip <: KeyFor<Bool> {
    public static prop skip: KeySkip {
        /*
         * @noThrow
         */
        get() {
            KeySkip()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "skip"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyCoverageGuided <: KeyFor<Bool> {
    public static prop coverageGuided: KeyCoverageGuided {
        /*
         * @noThrow
         */
        get() {
            KeyCoverageGuided()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "coverageGuided"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyCoverageGuidedInitialSeeds <: KeyFor<Int64> {
    public static prop coverageGuidedInitialSeeds: KeyCoverageGuidedInitialSeeds {
        /*
         * @noThrow
         */
        get() {
            KeyCoverageGuidedInitialSeeds()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "coverageGuidedInitialSeeds"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyCoverageGuidedMaxCandidates <: KeyFor<Int64> {
    public static prop coverageGuidedMaxCandidates: KeyCoverageGuidedMaxCandidates {
        /*
         * @noThrow
         */
        get() {
            KeyCoverageGuidedMaxCandidates()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "coverageGuidedMaxCandidates"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyCoverageGuidedBaselineScore <: KeyFor<Int64> {
    public static prop coverageGuidedBaselineScore: KeyCoverageGuidedBaselineScore {
        /*
         * @noThrow
         */
        get() {
            KeyCoverageGuidedBaselineScore()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "coverageGuidedBaselineScore"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyCoverageGuidedNewCoverageScore <: KeyFor<Int64> {
    public static prop coverageGuidedNewCoverageScore: KeyCoverageGuidedNewCoverageScore {
        /*
         * @noThrow
         */
        get() {
            KeyCoverageGuidedNewCoverageScore()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "coverageGuidedNewCoverageScore"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyCoverageGuidedNewCoverageBonus <: KeyFor<Int64> {
    public static prop coverageGuidedNewCoverageBonus: KeyCoverageGuidedNewCoverageBonus {
        /*
         * @noThrow
         */
        get() {
            KeyCoverageGuidedNewCoverageBonus()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "coverageGuidedNewCoverageBonus"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyBench <: KeyFor<Bool> {
    public static prop bench: KeyBench {
        /*
         * @noThrow
         */
        get() {
            KeyBench()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "bench"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyTimeout <: KeyFor<Duration> {
    public static prop timeout: KeyTimeout {
        /*
         * @noThrow
         */
        get() {
            KeyTimeout()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "timeout"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyTimeoutEach <: KeyFor<String> {
    public static prop timeoutEach: KeyTimeoutEach {
        /*
         * @noThrow
         */
        get() {
            KeyTimeoutEach()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "timeoutEach"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyTimeoutHandler <: KeyFor<(TestCaseInfo) -> Unit> {
    public static prop timeoutHandler: KeyTimeoutHandler {
        /*
         * @noThrow
         */
        get() {
            KeyTimeoutHandler()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "timeoutHandler"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyCaptureOutput <: KeyFor<Bool> {
    public static prop captureOutput: KeyCaptureOutput {
        /*
         * @noThrow
         */
        get() {
            KeyCaptureOutput()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "captureOutput"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyNoCaptureOutput <: KeyFor<Bool> {
    public static prop noCaptureOutput: KeyNoCaptureOutput {
        /*
         * @noThrow
         */
        get() {
            KeyNoCaptureOutput()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "noCaptureOutput"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyShowAllOutput <: KeyFor<Bool> {
    public static prop showAllOutput: KeyShowAllOutput {
        /*
         * @noThrow
         */
        get() {
            KeyShowAllOutput()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "showAllOutput"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyVerbose <: KeyFor<Bool> {
    public static prop verbose: KeyVerbose {
        /*
         * @noThrow
         */
        get() {
            KeyVerbose()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "verbose"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyMeasurement <: KeyFor<Measurement> {
    public static prop measurement: KeyMeasurement {
        /*
         * @noThrow
         */
        get() {
            KeyMeasurement()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "measurement"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyMeasurementInfo <: KeyFor<MeasurementInfo> {
    public static prop measurementInfo: KeyMeasurementInfo {
        /*
         * @noThrow
         */
        get() {
            KeyMeasurementInfo()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "measurementInfo"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyInternalTestrunnerInputPath <: KeyFor<String> {
    public static prop internalTestrunnerInputPath: KeyInternalTestrunnerInputPath {
        /*
         * @noThrow
         */
        get() {
            KeyInternalTestrunnerInputPath()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "internalTestrunnerInputPath"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyDeathAware <: KeyFor<Bool> {
    public static prop deathAware: KeyDeathAware {
        /*
         * @noThrow
         */
        get() {
            KeyDeathAware()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "deathAware"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyBaseline <: KeyFor<String> {
    public static prop baseline: KeyBaseline {
        /*
         * @noThrow
         */
        get() {
            KeyBaseline()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "baseline"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyFilter <: KeyFor<String> {
    public static prop filter: KeyFilter {
        /*
         * @noThrow
         */
        get() {
            KeyFilter()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "filter"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyIncludeTags <: KeyFor<String> {
    public static prop includeTags: KeyIncludeTags {
        /*
         * @noThrow
         */
        get() {
            KeyIncludeTags()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "includeTags"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyExcludeTags <: KeyFor<String> {
    public static prop excludeTags: KeyExcludeTags {
        /*
         * @noThrow
         */
        get() {
            KeyExcludeTags()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "excludeTags"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyReportPath <: KeyFor<String> {
    public static prop reportPath: KeyReportPath {
        /*
         * @noThrow
         */
        get() {
            KeyReportPath()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "reportPath"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyReportFormat <: KeyFor<String> {
    public static prop reportFormat: KeyReportFormat {
        /*
         * @noThrow
         */
        get() {
            KeyReportFormat()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "reportFormat"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyBaselinePath <: KeyFor<String> {
    public static prop baselinePath: KeyBaselinePath {
        /*
         * @noThrow
         */
        get() {
            KeyBaselinePath()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "baselinePath"
        }
    }
}

       /*
        * @noThrow
        */
struct KeyInternalWorkerId <: KeyFor<Int64> {
    public static prop internalWorkerId: KeyInternalWorkerId {
        /*
         * @noThrow
         */
        get() {
            KeyInternalWorkerId()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "internalWorkerId"
        }
    }
}

       /*
        * @noThrow
        */
struct KeyInternalNWorkers <: KeyFor<Int64> {
    public static prop internalNWorkers: KeyInternalNWorkers {
        /*
         * @noThrow
         */
        get() {
            KeyInternalNWorkers()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "internalNWorkers"
        }
    }
}

       /*
        * @noThrow
        */
struct KeyInternalWorkerSkipNTests <: KeyFor<Int64> {
    public static prop internalWorkerSkipNTests: KeyInternalWorkerSkipNTests {
        /*
         * @noThrow
         */
        get() {
            KeyInternalWorkerSkipNTests()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "internalWorkerSkipNTests"
        }
    }
}

       /*
        * @noThrow
        */
struct KeyInternalMainProcessPort <: KeyFor<UInt16> {
    public static prop internalMainProcessPort: KeyInternalMainProcessPort {
        /*
         * @noThrow
         */
        get() {
            KeyInternalMainProcessPort()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "internalMainProcessPort"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyDryRun <: KeyFor<Bool> {
    public static prop dryRun: KeyDryRun {
        /*
         * @noThrow
         */
        get() {
            KeyDryRun()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "dryRun"
        }
    }
}

              /*
               * @noThrow
               */
public struct KeyShowTags <: KeyFor<Bool> {
    public static prop showTags: KeyShowTags {
        /*
         * @noThrow
         */
        get() {
            KeyShowTags()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "showTags"
        }
    }
}



       /*
        * @noThrow
        */
struct KeyNoProgress <: KeyFor<Bool> {
    public static prop noProgress: KeyNoProgress {
        /*
         * @noThrow
         */
        get() {
            KeyNoProgress()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "noProgress"
        }
    }
}



       /*
        * @noThrow
        */
struct KeyProgressBrief <: KeyFor<Bool> {
    public static prop progressBrief: KeyProgressBrief {
        /*
         * @noThrow
         */
        get() {
            KeyProgressBrief()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "progressBrief"
        }
    }
}




       /*
        * @noThrow
        */
struct KeyProgressEntriesLimit <: KeyFor<Int64> {
    public static prop progressEntriesLimit: KeyProgressEntriesLimit {
        /*
         * @noThrow
         */
        get() {
            KeyProgressEntriesLimit()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "progressEntriesLimit"
        }
    }
}
