







package std.core


@FastNative
foreign func CJ_CORE_AtExitCallbackListLock(): Unit

@FastNative
foreign func CJ_CORE_AtExitCallbackListUnlook(): Unit
class AtexitCallbackNode {
    var atexitCallback: () -> Unit
    var next: ?AtexitCallbackNode = None

    init(callback: () -> Unit) {
        atexitCallback = callback
    }
}

var atexitCallbackHead: ?AtexitCallbackNode = None
var callbacksRunningFlag: Bool = false
protected func CJ_CORE_AddAtexitCallback(callback: () -> Unit): Unit {
    if (callbacksRunningFlag) {
        return
    }

    var newNode = AtexitCallbackNode(callback)
    unsafe { CJ_CORE_AtExitCallbackListLock() }
    match (atexitCallbackHead) {
        case Some(_) => newNode.next = atexitCallbackHead
        case None => ()
    }
    atexitCallbackHead = Option<AtexitCallbackNode>.Some(newNode)
    unsafe { CJ_CORE_AtExitCallbackListUnlook() }
}
protected func CJ_CORE_ExecAtexitCallbacks(): Unit {
    if (callbacksRunningFlag) {
        return
    }
    unsafe { CJ_CORE_AtExitCallbackListLock() }
    if (callbacksRunningFlag) {
        unsafe { CJ_CORE_AtExitCallbackListUnlook() }
        return
    }
    callbacksRunningFlag = true
    var currPos = atexitCallbackHead
    try {
        while (true) {
            match (currPos) {
                case Some(node) =>
                    node.atexitCallback()
                    currPos = node.next
                case None => break
            }
        }
        atexitCallbackHead = None
    } catch (t: Exception) {
        t.printStackTrace()
    } catch (t: Error) {
        t.printStackTrace()
    } finally {
        unsafe { CJ_CORE_AtExitCallbackListUnlook() }
    }
}
