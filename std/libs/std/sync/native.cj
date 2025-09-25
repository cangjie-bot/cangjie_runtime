







package std.sync


@Intrinsic
/*
 * @noThrow
 */
func mutexInit(mutex: Mutex): Bool

@Intrinsic
/*
 * @noThrow
 */
func mutexLock(mutex: Mutex): Unit

@Intrinsic
/*
 * @noThrow
 */
func mutexTryLock(mutex: Mutex): Bool

@Intrinsic
/*
 * @noThrow
 */
func mutexCheckStatus(mutex: Mutex): Bool

@Intrinsic
/*
 * @noThrow
 */
func mutexUnlock(mutex: Mutex): Unit


@Intrinsic
/*
 * @noThrow
 */
func monitorWait(monitor: Monitor, timeout: Int64): Bool

@Intrinsic
/*
 * @noThrow
 */
func monitorNotify(monitor: Monitor): Unit

@Intrinsic
/*
 * @noThrow
 */
func monitorNotifyAll(monitor: Monitor): Unit


@Intrinsic
/*
 * @noThrow
 */
func multiConditionMonitorWait(multiConditionMonitor: MultiConditionMonitor, obj: Object, timeout: Int64): Bool

@Intrinsic
/*
 * @noThrow
 */
func multiConditionMonitorNotify(multiConditionMonitor: MultiConditionMonitor, obj: Object): Unit

@Intrinsic
/*
 * @noThrow
 */
func multiConditionMonitorNotifyAll(multiConditionMonitor: MultiConditionMonitor, obj: Object): Unit


@Intrinsic
/*
 * @noThrow
 */
func waitQueueInit(obj: WaitQueue): Bool


@Intrinsic
/*
 * @noThrow
 */
func monitorInit(obj: Monitor): Bool
