/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

#include <stdatomic.h>
#include <stdlib.h>

#ifdef WIN32
#include <windows.h>
#include <wchar.h>
#endif  // WIN32

#ifdef __arm__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Watomic-alignment"
#endif

static atomic_flag g_atexitCallbackListLocker = ATOMIC_FLAG_INIT;
extern void CJ_CORE_AtExitCallbackListLock(void)
{
    while (atomic_flag_test_and_set(&g_atexitCallbackListLocker)) {
    }
}
extern void CJ_CORE_AtExitCallbackListUnlook(void)
{
    atomic_flag_clear(&g_atexitCallbackListLocker);
}

#ifdef WIN32
extern void CJ_CORE_Abort(void)
{
    // 1. Disable the message box for abort()
    _set_abort_behavior(0, _WRITE_ABORT_MSG | _CALL_REPORTFAULT);
    
    // 2. Tell the system not to display critical-error-handler message box
    SetErrorMode(SEM_FAILCRITICALERRORS | SEM_NOGPFAULTERRORBOX);
    
    // 3. If in Debug mode, also disable the report window
    #ifdef _DEBUG
    _CrtSetReportMode(_CRT_ERROR, _CRTDBG_MODE_DEBUG);
    #endif

    abort();
}
#else
extern void CJ_CORE_Abort(void)
{
    abort();
}
#endif

#ifdef __arm__
#pragma GCC diagnostic pop
#endif