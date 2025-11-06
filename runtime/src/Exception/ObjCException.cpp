// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


#include "ObjCException.h"

#include <dlfcn.h>
#include <CoreFoundation/CoreFoundation.h>
#include <cinttypes>

namespace MapleRuntime {
#if MACHSIZE == 32

typedef struct mach_header mach_header_target;
typedef struct segment_command segment_command_target;
typedef struct section section_target;
static const uint32_t MH_MAGIC_TARGET = MH_MAGIC;
static const uint32_t LC_SEGMENT_TARGET = LC_SEGMENT;

#elif MACHSIZE == 64

typedef struct mach_header_64 mach_header_target;
typedef struct segment_command_64 segment_command_target;
typedef struct section_64 section_target;
static const uint32_t MH_MAGIC_TARGET = MH_MAGIC_64;
static const uint32_t LC_SEGMENT_TARGET = LC_SEGMENT_64;

#else

#error "Impossible MACHSIZE"

#endif

mach_header_target* ObjCException::FindCoreFoundationMachHeader() {
    Dl_info info;
    if (dladdr(reinterpret_cast<void*>(&CFRunLoopRun), &info) ==0) {
        LOG(RTLOG_ERROR, "can not find CFRunLoopRun function");
        return nullptr;
    } else {
        return reinterpret_cast<mach_header_target*>(info.dli_fbase);
    }
}

char* ObjCException::FindExceptionBacktraceSectionAddr(unsigned long *bufferSize) {
    mach_header_target* header = FindCoreFoundationMachHeader();
    if (header == nullptr) {
        LOG(RTLOG_ERROR, "can not find mach_header_target");
        return nullptr;
    }
    if (header->magic != MH_MAGIC_TARGET) {
        LOG(RTLOG_ERROR, "Head magic is error");
        return nullptr;
    }
    uintptr_t textVmaddr = 0;

    load_command* loadCommand = reinterpret_cast<load_command*>(header + 1);
    for (uint32_t loadCommandIndex = 0; loadCommandIndex < header->ncmds; ++loadCommandIndex) {
        if (loadCommand->cmd == LC_SEGMENT_TARGET) {
            segment_command_target* segmentCommand = reinterpret_cast<segment_command_target*>(loadCommand);
            if (BufferEqualsString(segmentCommand->segname, "__TEXT")) {
                textVmaddr = segmentCommand->vmaddr;
            }

            if (BufferEqualsString(segmentCommand->segname, "__DATA")) {
                section_target* sections = reinterpret_cast<section_target*>(segmentCommand + 1);
                for (uint32_t sectionIndex = 0; sectionIndex < segmentCommand->nsects; ++sectionIndex) {
                    section_target* section = &sections[sectionIndex];

                    if (BufferEqualsString(section->sectname, "__cf_except_bt") && BufferEqualsString(section->segname, "__DATA")) {
                        *bufferSize = section->size;
                        return reinterpret_cast<char*>(reinterpret_cast<uintptr_t>(header) + section->addr - textVmaddr);
                    }
                }
            }
         }

         loadCommand = reinterpret_cast<load_command*>(reinterpret_cast<uintptr_t>(loadCommand) + loadCommand->cmdsize);
    }

    return nullptr;
}

void ObjCException::WriteBacktraceToBuffer(ExceptionWrapper& eWrapper, char* buffer, unsigned long bufferSize) {
    if (bufferSize < 2) {
        LOG(RTLOG_ERROR, "The buffer size required for backtrace is less than 2.");
        return;
    }

    std::vector<uint64_t>& liteFrameInfos = eWrapper.GetLiteFrameInfos();
    char* bufferPointer = buffer;
    unsigned long remainingBytes = bufferSize;

    *(bufferPointer++) = '(';
    --remainingBytes;

    uint32_t count = 0;
    for (auto frameInfo : liteFrameInfos) {
        if (count % 3 == 0) {
            int bytes = snprintf(bufferPointer, remainingBytes, "0x%" PRIxPTR " ", static_cast<uintptr_t>(frameInfo));

            if (bytes < 0 || static_cast<unsigned long>(bytes) >= remainingBytes) {
                break;
            }

            bufferPointer += bytes;
            remainingBytes -= bytes;
	}
	count++;
    }

    *(bufferPointer - 1) = ')'; // Replace last space.
    *bufferPointer = '\0';
}

void ObjCException::ReportBacktraceToIosIpsLog(ExceptionWrapper& eWrapper) {
    unsigned long bufferSize = 0;
    char* buffer = FindExceptionBacktraceSectionAddr(&bufferSize);
    if (buffer == nullptr) {
        return;
    }
    WriteBacktraceToBuffer(eWrapper, buffer, bufferSize);
}
} // namespace MapleRuntime
