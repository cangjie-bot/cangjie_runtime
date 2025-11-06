// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


#ifndef MRT_OBJC_EXCEPTION_H
#define MRT_OBJC_EXCEPTION_H

#include <mach-o/loader.h>

#include "Exception/Exception.h"

namespace MapleRuntime {
class ObjCException {
public:
    ObjCException() {}
    ~ObjCException() = default;
    static void ReportBacktraceToIosIpsLog(ExceptionWrapper& eWrapper);
private:
    static mach_header_target* FindCoreFoundationMachHeader();
    static char* FindExceptionBacktraceSectionAddr(unsigned long bufferSize);
    static void WriteBacktraceToBuffer(ExceptionWrapper& eWrapper, char* buffer, unsigned long bufferSize);
    template <int n>
    static bool BufferEqualsString(const char(&buffer)[n], const char* str) {
        return strncmp(buffer, str, n) == 0;
    }
}
} // namespace MapleRuntime
#endif // MRT_OBJC_EXCEPTION_H
