/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package std.runtime

@When[backend == "cjnative"]
@Intrinsic
func getThreadNumber(): UIntNative

@When[backend == "cjnative"]
@Intrinsic
func getBlockingThreadNumber(): UIntNative

@When[backend == "cjnative"]
@Intrinsic
func getNativeThreadNumber(): UIntNative

@When[backend == "cjnative"]
@Deprecated[message: "All static Properties are converted to public functions."]
public struct ThreadInfo {
    /**
     * Get current number of threads.
     */
    public static prop threadCount: UIntNative {
        get() {
            getThreadCount()
        }
    }
    /**
     * Get the number of blocked threads.
     */
    public static prop blockingThreadCount: UIntNative {
        get() {
            getBlockingThreadCount()
        }
    }
    /**
     * Get the actual number of physical threads.
     */
    public static prop nativeThreadCount: UIntNative {
        get() {
            getNativeThreadCount()
        }
    }
}

@When[backend == "cjnative"]
public func getThreadCount(): UIntNative {
    return getThreadNumber()
}

@When[backend == "cjnative"]
public func getBlockingThreadCount(): UIntNative {
    return getBlockingThreadNumber()
}

@When[backend == "cjnative"]
public func getNativeThreadCount(): UIntNative {
    return getNativeThreadNumber()
}
