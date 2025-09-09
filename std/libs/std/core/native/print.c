/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

#include <inttypes.h>
#include <math.h>
#include <stdio.h>
#include "core.h"

#ifdef WIN32
#include <wchar.h>
#include <windows.h>
#endif

#ifdef __OHOS__
#include "hilog/log.h"
static const char * const OHOS_TAG = "Cangjie-Log";
static const char * const OHOS_STR_FMT = "%{public}s";
static const unsigned int OHOS_DOMAIN = 0xD003901;
#endif

#ifndef INT32_MAX
#define INT32_MAX 2147483647
#endif // INT32_MAX

#ifndef __OHOS__
static const char * const NEW_LINE = "\n";

static int64_t PrintUtf8(FILE* handle, const uint8_t* str, int64_t len, bool newLine)
{
    (void)fwrite(str, sizeof(uint8_t), (size_t)len, handle);

    if (newLine) {
        (void)fwrite(NEW_LINE, 1, 1, handle);
    }
    return 0;
}
#endif

#ifdef WIN32
// WIN32
// The Windows platform needs to determine whether to redirect to a file.
static int64_t ConsoleWriteW(HANDLE fd, const uint8_t* str, const int64_t len, bool newLine)
{
    int64_t remainingLen = len;
    size_t writelen = 0;
    while (remainingLen > 0) {
        if (remainingLen < INT32_MAX) {
            writelen = (size_t)remainingLen;
        } else {
            writelen = INT32_MAX;
        }
        int wstrlen = MultiByteToWideChar(CP_UTF8, 0, str, len, NULL, 0);
        wchar_t* wstr = (wchar_t*)malloc(sizeof(wchar_t) * wstrlen);
        if (wstr == NULL) {
            return -1;
        }
        MultiByteToWideChar(CP_UTF8, 0, str, len, wstr, wstrlen);
        // win32 API
        (void)WriteConsoleW(fd, wstr, wstrlen, NULL, NULL);
        free(wstr);
        remainingLen -= writelen;
    }

    if (newLine) {
        (void)WriteConsoleW(fd, L"\n", 1, NULL, NULL);
    }
    return 0;
}

static int64_t ConsoleWriteFile(HANDLE fd, const uint8_t* str, const int64_t len, bool newLine)
{
    (void)WriteFile(fd, str, len, NULL, NULL);
    if (newLine) {
        (void)WriteFile(fd, "\n", 1, NULL, NULL);
    }
    return 0;
}
#endif // WIN32

extern int64_t CJ_CORE_PrintUTF8(const uint8_t* str, int64_t len, bool newLine, bool flush)
{
    int64_t ret = 0;
#ifdef WIN32
    HANDLE handler = GetStdHandle(STD_OUTPUT_HANDLE);
    if (GetFileType(handler) == FILE_TYPE_CHAR) {
        // a character file, typically an LPT device or a console
        ret = ConsoleWriteW(handler, str, len, newLine);
    } else {
        ret = PrintUtf8(stdout, str, len, newLine);
    }
#elif __OHOS__
    uint8_t* s = (uint8_t*)malloc(sizeof(uint8_t) * (len + 1));
    if (s == NULL) {
        return 0;
    }
    for (int64_t i = 0; i < len; i++) {
        s[i] = str[i];
    }
    s[len] = '\0';
    if (OH_LOG_IsLoggable(OHOS_DOMAIN, OHOS_TAG, LOG_INFO)) {
        ret = OH_LOG_Print(LOG_APP, LOG_INFO, OHOS_DOMAIN, OHOS_TAG, OHOS_STR_FMT, s);
    }
    free(s);
#else
    ret = PrintUtf8(stdout, str, len, newLine);
#endif

#ifndef __OHOS__
    if (flush) {
        (void)fflush(stdout);
    }
#endif
    return ret;
}

extern int64_t CJ_CORE_ErrorPrintUTF8(const uint8_t* str, int64_t len, bool newLine, bool flush)
{
    int64_t ret = 0;
#ifdef WIN32
    HANDLE handler = GetStdHandle(STD_ERROR_HANDLE);
    if (GetFileType(handler) == FILE_TYPE_CHAR) {
        // a character file, typically an LPT device or a console
        ret = ConsoleWriteW(handler, str, len, newLine);
    } else {
        ret = PrintUtf8(stderr, str, len, newLine);
    }
#elif __OHOS__
    uint8_t* s = (uint8_t*)malloc(sizeof(uint8_t) * (len + 1));
    if (s == NULL) {
        return 0;
    }
    for (int64_t i = 0; i < len; i++) {
        s[i] = str[i];
    }
    s[len] = '\0';
    if (OH_LOG_IsLoggable(OHOS_DOMAIN, OHOS_TAG, LOG_ERROR)) {
        ret = OH_LOG_Print(LOG_APP, LOG_ERROR, OHOS_DOMAIN, OHOS_TAG, OHOS_STR_FMT, s);
    }
    free(s);
#else
    ret = PrintUtf8(stderr, str, len, newLine);
#endif

#ifndef __OHOS__
    if (flush) {
        (void)fflush(stderr);
    }
#endif
    return ret;
}

extern void CJ_CORE_PrintBool(bool b, bool newLine, bool flush)
{
#ifndef __OHOS__
    if (b) {
        (void)fwrite("true", 1, 4, stdout); // the number of bytes of true is 4.
    } else {
        (void)fwrite("false", 1, 5, stdout); // The number of bytes of false is 5.
    }
    if (newLine) {
        (void)fwrite(NEW_LINE, 1, 1, stdout);
    }
    if (flush) {
        (void)fflush(stdout);
    }
#else
    if (OH_LOG_IsLoggable(OHOS_DOMAIN, OHOS_TAG, LOG_INFO)) {
        if (b) {
            OH_LOG_Print(LOG_APP, LOG_INFO, OHOS_DOMAIN, OHOS_TAG, OHOS_STR_FMT, "true");
        } else {
            OH_LOG_Print(LOG_APP, LOG_INFO, OHOS_DOMAIN, OHOS_TAG, OHOS_STR_FMT, "false");
        }
    }
#endif
}

extern void CJ_CORE_PrintChar(uint32_t c, bool newLine, bool flush)
{
    uint8_t out[16] = {0};
#ifndef __OHOS__
    /*
     * CJ_CORE_FromCharToUtf8 can't return -1. because The value
     * of Cangjie Rune is a Unicode scalar value.
     */
    int64_t s = CJ_CORE_FromCharToUtf8(c, out);
    (void)PrintUtf8(stdout, out, s, newLine);

    if (flush) {
        (void)fflush(stdout);
    }
#else
    CJ_CORE_FromCharToUtf8(c, out);
    if (OH_LOG_IsLoggable(OHOS_DOMAIN, OHOS_TAG, LOG_INFO)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, OHOS_DOMAIN, OHOS_TAG, OHOS_STR_FMT, out);
    }
#endif
}

extern void CJ_CORE_PrintSigned(int64_t i, bool newLine, bool flush)
{
#ifndef __OHOS__
    (void)printf("%" PRId64, i);
    if (newLine) {
        (void)fwrite(NEW_LINE, 1, 1, stdout);
    }
    if (flush) {
        (void)fflush(stdout);
    }
#else
    if (OH_LOG_IsLoggable(OHOS_DOMAIN, OHOS_TAG, LOG_INFO)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, OHOS_DOMAIN, OHOS_TAG, "%{public}" PRId64, i);
    }
#endif
}

extern void CJ_CORE_PrintUnsigned(uint64_t u, bool newLine, bool flush)
{
#ifndef __OHOS__
    (void)printf("%" PRIu64, u);
    if (newLine) {
        (void)fwrite(NEW_LINE, 1, 1, stdout);
    }
    if (flush) {
        (void)fflush(stdout);
    }
#else
    if (OH_LOG_IsLoggable(OHOS_DOMAIN, OHOS_TAG, LOG_INFO)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, OHOS_DOMAIN, OHOS_TAG, "%{public}" PRIu64, u);
    }
#endif
}

extern void CJ_CORE_PrintFloat(double f, bool newLine, bool flush)
{
#ifndef __OHOS__
    if (isnan(f)) {
        // Nan doesn't have a sign in cangjie. So, we should always print nan.
        (void)printf("nan");
    } else {
        (void)printf("%f", f);
    }
    if (newLine) {
        (void)fwrite(NEW_LINE, 1, 1, stdout);
    }
    if (flush) {
        (void)fflush(stdout);
    }
#else
    if (OH_LOG_IsLoggable(OHOS_DOMAIN, OHOS_TAG, LOG_INFO)) {
        if (isnan(f)) {
            // Nan doesn't have a sign in cangjie. So, we should always print nan.
            OH_LOG_Print(LOG_APP, LOG_INFO, OHOS_DOMAIN, OHOS_TAG, OHOS_STR_FMT, "nan");
        } else {
            OH_LOG_Print(LOG_APP, LOG_INFO, OHOS_DOMAIN, OHOS_TAG, "%{public}f", f);
        }
    }
#endif
}

extern void CJ_CORE_PrintOomHint(void)
{
    static const char * const OOM_HINT = "An exception has occurred:\n    Out of memory\n";
    (void)fwrite(OOM_HINT, sizeof(uint8_t), strlen(OOM_HINT), stderr);
}
