







package std.sync


@Intrinsic
func mutexInit(mutex: Mutex): Bool

@Intrinsic
func mutexLock(mutex: Mutex): Unit

@Intrinsic
func mutexTryLock(mutex: Mutex): Bool

@Intrinsic
func mutexCheckStatus(mutex: Mutex): Bool

@Intrinsic
func mutexUnlock(mutex: Mutex): Unit


@Intrinsic
func monitorWait(monitor: Monitor, timeout: Int64): Bool

@Intrinsic
func monitorNotify(monitor: Monitor): Unit

@Intrinsic
func monitorNotifyAll(monitor: Monitor): Unit


@Intrinsic
func multiConditionMonitorWait(multiConditionMonitor: MultiConditionMonitor, obj: Object, timeout: Int64): Bool

@Intrinsic
func multiConditionMonitorNotify(multiConditionMonitor: MultiConditionMonitor, obj: Object): Unit

@Intrinsic
func multiConditionMonitorNotifyAll(multiConditionMonitor: MultiConditionMonitor, obj: Object): Unit


@Intrinsic
func waitQueueInit(obj: WaitQueue): Bool


@Intrinsic
func monitorInit(obj: Monitor): Bool
