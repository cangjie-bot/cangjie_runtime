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
#if 0 

typedef struct mach_header mach_header_target;
typedef struct segment_command segment_command_target;
typedef struct section section_target;
static const uint32_t MH_MAGIC_TARGET = MH_MAGIC;
static const uint32_t LC_SEGMENT_TARGET = LC_SEGMENT;

#elif 1

typedef struct mach_header_64 mach_header_target;
typedef struct segment_command_64 segment_command_target;
typedef struct section_64 section_target;
static const uint32_t MH_MAGIC_TARGET = MH_MAGIC_64;
static const uint32_t LC_SEGMENT_TARGET = LC_SEGMENT_64;

#else

#error "Impossible MACHSIZE"

#endif

class ObjCException {
public:
    ObjCException() {}
    ~ObjCException() = default;
    static void ReportBacktraceToIosIpsLog(ExceptionWrapper& eWrapper);
private:
    static mach_header_target* FindCoreFoundationMachHeader();
    static char* FindExceptionBacktraceSectionAddr(unsigned long *bufferSize);
    static void WriteBacktraceToBuffer(ExceptionWrapper& eWrapper, char* buffer, unsigned long bufferSize);
    template <int n>
    static bool BufferEqualsString(const char(&buffer)[n], const char* str) {
        return strncmp(buffer, str, n) == 0;
    }
}
} // namespace MapleRuntime
#endif // MRT_OBJC_EXCEPTION_H
