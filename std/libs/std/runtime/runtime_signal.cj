/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package std.runtime

import std.sync.*
import std.collection.*
import std.collection.concurrent.*

public type SignalHandlerFunc = (Int32) -> Bool

private let mtx = Mutex()

class SignalManager {
    static const MAX_SIG_NUM = 32
    static let sigSlot = Array<ArrayList<SignalHandlerFunc>>(MAX_SIG_NUM, {i => ArrayList<SignalHandlerFunc>()})
    static let paction = LibC.malloc<SignalAction>(count: 1)
    static init(){
        let action = SignalAction(signalHandler)
        unsafe {
            paction.write(action)
        }
    }
}

public func registerSignalHandler(sig: Signal, handler: SignalHandlerFunc) {
    // todo func check

    if (Int64(sig.value) >= SignalManager.MAX_SIG_NUM) {
        throw IllegalArgumentException("Signal value must < ${SignalManager.MAX_SIG_NUM}")
    }
    let slot = SignalManager.sigSlot[Int64(sig.value)]
    synchronized(mtx) {
        if (slot.size == 0) {
            regSigChain(sig)
        }
        slot.add(handler) // todo 不需要注册？
    }

}

@C
func signalHandler(sig: Int32, _: CPointer<Unit>, _: CPointer<Unit>): Bool {
    if (Int64(sig) >= SignalManager.MAX_SIG_NUM) {
        return false
    }
    let slot = SignalManager.sigSlot[Int64(sig)]
    synchronized(mtx) {
        for (f in slot) {
            let b = f(sig)
            if (b) {
                return true
            }
        }
    }
    return false
}

func regSigChain(sig: Signal) {
    unsafe {
        CJ_MCC_AddSignalHandler(sig.value, SignalManager.paction)
    }
}


type SigHandlerCFunc = CFunc<(Int32, CPointer<Unit>, CPointer<Unit>) -> Bool>

@C
struct SignalAction {
    let saHandler: SigHandlerCFunc
    let scMask = 0u64
    let scFlags = 0u64
    init(fn: SigHandlerCFunc) {
        saHandler = fn
    }
}


foreign func CJ_MCC_AddSignalHandler(signal: Int32, sa: CPointer<SignalAction>): Unit

foreign func CJ_MCC_RemoveSignalHandler(signal: Int32, fn: SigHandlerCFunc): Unit


public struct Signal {
    public static const SIGHUP = Signal(0x1, "hangup")

    public static const SIGINT = Signal(0x2, "interrupt")

    public static const SIGQUIT = Signal(0x3, "quit")

    public static const SIGILL = Signal(0x4, "illegal instruction")

    public static const SIGTRAP = Signal(0x5, "trace/breakpoint trap")

    public static const SIGABRT = Signal(0x6, "aborted")

    @When[os == "macOS"]
    public static const SIGEMT = Signal(0x7, "Signal Emulator Trap")

    public static const SIGKILL = Signal(0x9, "killed")

    @When[os == "macOS"]
    public static const SIGSYS = Signal(0xc, "Bad system call")

    public static const SIGPIPE = Signal(0xd, "broken pipe")

    public static const SIGALRM = Signal(0xe, "alarm clock")

    public static const SIGTERM = Signal(0xf, "terminated")

    let value: Int32
    let comment: String
    const init(value: Int32, comment: String) {
        this.value = value
        this.comment = comment
    }
}