// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#define cfi_adjust_cfa_offset(off)      .cfi_adjust_cfa_offset off
#define cfi_rel_offset(reg, off)        .cfi_rel_offset reg, off
#define cfi_restore(reg)                .cfi_restore reg
#define cfi_def_cfa_register(reg)       .cfi_def_cfa_register reg

// CJThread structure offsets
#define CJTHREAD_THREAD_OFFSET      0x10
#define CJTHREAD_CONTEXT_OFFSET     0x18

// CJThreadContext structure offsets for aarch64
#define CONTEXT_X18                 0x00
#define CONTEXT_X19                 0x08
#define CONTEXT_X20                 0x10
#define CONTEXT_X21                 0x18
#define CONTEXT_X22                 0x20
#define CONTEXT_X23                 0x28
#define CONTEXT_X24                 0x30
#define CONTEXT_X25                 0x38
#define CONTEXT_X26                 0x40
#define CONTEXT_X27                 0x48
#define CONTEXT_X28                 0x50
#define CONTEXT_X29_FP              0x58
#define CONTEXT_X30_LR              0x60
#define CONTEXT_PC                  0x68
#define CONTEXT_SP                  0x70
#define CONTEXT_D8                  0x78
#define CONTEXT_D9                  0x80
#define CONTEXT_D10                 0x88
#define CONTEXT_D11                 0x90
#define CONTEXT_D12                 0x98
#define CONTEXT_D13                 0xa0
#define CONTEXT_D14                 0xa8
#define CONTEXT_D15                 0xb0
#define CONTEXT_FPCR                0xb8

// Thread structure offset to context
#define THREAD_CONTEXT_OFFSET       0x78

// Frame size (must be 16-byte aligned)
#define ExclusiveScopeFrameSize     (16 * 16)

// ==============================================================================
// CJ_MCC_ExclusiveScope: from cjthread switch OS thread and exclusive this thread
// ==============================================================================
//
//   void* CJ_MCC_ExclusiveScope(void* executeClosure, void* closurePtr)
//                                    x0              x1
//
// 1. call MCC_NewExclusiveCJThread to create exclusive cjthread
// 2. switch to OS thread
// 3. call ExclusiveExecutor to execute closure
// 4. switch to normal cjthread

    .text
    .align 2
    .global CJ_MCC_ExclusiveScope
    .type CJ_MCC_ExclusiveScope, @function
CJ_MCC_ExclusiveScope:
    .cfi_startproc
#if defined(ENABLE_BACKWARD_PTRAUTH_CFI)
    paciasp
#endif
    // Save frame pointer and link register
    stp     x29, x30, [sp, #-ExclusiveScopeFrameSize]!
    cfi_adjust_cfa_offset(ExclusiveScopeFrameSize)
    cfi_rel_offset(x29, 0)
    cfi_rel_offset(x30, 8)
    mov     x29, sp
    cfi_def_cfa_register(x29)

    // Save callee-saved registers
    stp     x19, x20, [sp, #0x10]
    cfi_rel_offset(x19, 0x10)
    cfi_rel_offset(x20, 0x18)
    stp     x21, x22, [sp, #0x20]
    cfi_rel_offset(x21, 0x20)
    cfi_rel_offset(x22, 0x28)
    stp     x23, x24, [sp, #0x30]
    cfi_rel_offset(x23, 0x30)
    cfi_rel_offset(x24, 0x38)
    stp     x25, x26, [sp, #0x40]
    cfi_rel_offset(x25, 0x40)
    cfi_rel_offset(x26, 0x48)
    stp     x27, x28, [sp, #0x50]
    cfi_rel_offset(x27, 0x50)
    cfi_rel_offset(x28, 0x58)

    // Save floating point callee-saved registers
    stp     d8, d9, [sp, #0x60]
    stp     d10, d11, [sp, #0x70]
    stp     d12, d13, [sp, #0x80]
    stp     d14, d15, [sp, #0x90]

    // Save arguments
    // x19 = executeClosure, x20 = closurePtr
    mov     x19, x0
    mov     x20, x1

    // MCC_NewExclusiveCJThread(executeClosure, closurePtr, futureTi)
    //                              x0           x1          x2
    mov     x0, x19         // executeClosure
    mov     x1, x20         // closurePtr
    mov     x2, xzr         // futureTi = 0
    bl      MCC_NewExclusiveCJThread

    // Check if newCJThread is valid
    cbz     x0, .L_exc_create_failed
    mov     x21, x0         // x21 = newCJThread

    // Get current CJThread handle
    bl      CJ_CJThreadGetHandle
    cbz     x0, .L_exc_no_cjthread
    mov     x22, x0         // x22 = oldCJThread

    // thread = oldCJThread->thread
    ldr     x23, [x22, #CJTHREAD_THREAD_OFFSET]
    cbz     x23, .L_exc_no_thread
    // x23 = thread

    // Save C2N context
    adr     x0, unwindPCForExclusiveStub
    mov     x1, x29         // fa (frame address)
    mov     x2, x28         // tlData
    bl      MRT_SaveC2NContext

    .global unwindPCForExclusiveStub
unwindPCForExclusiveStub:

    // Enter safe region
    mov     x0, #0
    bl      MRT_EnterSaferegion
    mov     x24, x0         // x24 = enterSafe

    // Save current sp
    mov     x25, sp

    // ==================== save cjthread context ====================
    add     x26, x22, #CJTHREAD_CONTEXT_OFFSET  // x26 = &oldCJThread->context

    // Save callee-saved registers to oldCJThread context
    str     x18, [x26, #CONTEXT_X18]
    str     x19, [x26, #CONTEXT_X19]
    str     x20, [x26, #CONTEXT_X20]
    str     x21, [x26, #CONTEXT_X21]
    str     x22, [x26, #CONTEXT_X22]
    str     x23, [x26, #CONTEXT_X23]
    str     x24, [x26, #CONTEXT_X24]
    str     x25, [x26, #CONTEXT_X25]
    str     x26, [x26, #CONTEXT_X26]
    str     x27, [x26, #CONTEXT_X27]
    str     x28, [x26, #CONTEXT_X28]
    str     x29, [x26, #CONTEXT_X29_FP]
    str     x30, [x26, #CONTEXT_X30_LR]
    adr     x0, .L_exc_return_point
    str     x0, [x26, #CONTEXT_PC]
    mov     x0, sp
    str     x0, [x26, #CONTEXT_SP]

    // Save floating point registers
    str     d8,  [x26, #CONTEXT_D8]
    str     d9,  [x26, #CONTEXT_D9]
    str     d10, [x26, #CONTEXT_D10]
    str     d11, [x26, #CONTEXT_D11]
    str     d12, [x26, #CONTEXT_D12]
    str     d13, [x26, #CONTEXT_D13]
    str     d14, [x26, #CONTEXT_D14]
    str     d15, [x26, #CONTEXT_D15]
    mrs     x0, fpcr
    str     w0, [x26, #CONTEXT_FPCR]

    // ==================== switch to OS thread ====================
    add     x27, x23, #THREAD_CONTEXT_OFFSET    // x27 = &thread->context

    // Restore thread sp
    ldr     x0, [x27, #CONTEXT_SP]
    mov     sp, x0

    // Restore fpcr
    ldr     w0, [x27, #CONTEXT_FPCR]
    msr     fpcr, x0

    // Allocate some stack space and align to 16 bytes
    sub     sp, sp, #128
    and     sp, sp, #~0xF

    // ExclusiveExecutor(oldCJThread, thread, newCJThread)
    //                      x0          x1      x2
    mov     x0, x22
    mov     x1, x23
    mov     x2, x21
    bl      ExclusiveExecutor

    // Save return value
    mov     x19, x0
    mov     x20, d0

.L_exc_return_point:
    // Restore sp from saved value
    mov     sp, x25

    // Save return value
    str     x19, [sp, #0xa0]
    str     d0, [sp, #0xa8]

    // ==================== LeaveSaferegion ====================
    cbz     x24, .L_exc_skip_leave
    bl      MRT_LeaveSaferegion
    bl      MRT_GetThreadLocalData
    mov     x19, x0
.L_exc_skip_leave:

    // Delete C2N context
    mov     x0, x19
    bl      MRT_DeleteC2NContext

    // Restore return value
    ldr     x0, [sp, #0xa0]
    ldr     d0, [sp, #0xa8]

    b       .L_exc_cleanup

// ==================== exception ====================
.L_exc_create_failed:
.L_exc_no_cjthread:
.L_exc_no_thread:
    mov     x0, xzr

.L_exc_cleanup:
    // Restore floating point callee-saved registers
    ldp     d8, d9, [sp, #0x60]
    ldp     d10, d11, [sp, #0x70]
    ldp     d12, d13, [sp, #0x80]
    ldp     d14, d15, [sp, #0x90]

    // Restore callee-saved registers
    ldp     x19, x20, [sp, #0x10]
    cfi_restore(x19)
    cfi_restore(x20)
    ldp     x21, x22, [sp, #0x20]
    cfi_restore(x21)
    cfi_restore(x22)
    ldp     x23, x24, [sp, #0x30]
    cfi_restore(x23)
    cfi_restore(x24)
    ldp     x25, x26, [sp, #0x40]
    cfi_restore(x25)
    cfi_restore(x26)
    ldp     x27, x28, [sp, #0x50]
    cfi_restore(x27)
    cfi_restore(x28)

    // Restore frame pointer and link register
    ldp     x29, x30, [sp], #ExclusiveScopeFrameSize
    cfi_adjust_cfa_offset(-ExclusiveScopeFrameSize)
    cfi_restore(x29)
    cfi_restore(x30)

#if defined(ENABLE_BACKWARD_PTRAUTH_CFI)
    autiasp
#endif
    ret

    .cfi_endproc
    .size CJ_MCC_ExclusiveScope, .-CJ_MCC_ExclusiveScope


// ==============================================================================
// ExecuteCangjieStubFull: Execute Cangjie closure with new ThreadLocalData
// ==============================================================================
//
//   void* ExecuteCangjieStubFull(void* sret, void* arg1, void* closureObj, 
//                                void* executeClosure, void* threadData)
//                                 x0         x1          x2          x3          x4
//
// Update x28 with threadData before executing closure

    .text
    .align 2
    .global ExecuteCangjieStubFull
    .type ExecuteCangjieStubFull, @function
ExecuteCangjieStubFull:
    .cfi_startproc
#if defined(ENABLE_BACKWARD_PTRAUTH_CFI)
    paciasp
#endif
    stp     x29, x30, [sp, #-96]!
    cfi_adjust_cfa_offset(96)
    cfi_rel_offset(x29, 0)
    cfi_rel_offset(x30, 8)
    mov     x29, sp
    cfi_def_cfa_register(x29)

    // Save callee-saved registers
    stp     x19, x20, [sp, #0x10]
    cfi_rel_offset(x19, 0x10)
    cfi_rel_offset(x20, 0x18)
    stp     x21, x22, [sp, #0x20]
    cfi_rel_offset(x21, 0x20)
    cfi_rel_offset(x22, 0x28)
    stp     x27, x28, [sp, #0x30]
    cfi_rel_offset(x27, 0x30)
    cfi_rel_offset(x28, 0x38)

    // Save arguments
    mov     x19, x0         // sret
    mov     x20, x2         // closureObj
    mov     x21, x3         // executeClosure
    mov     x22, x4         // threadData

    // Update x28 with new ThreadLocalData
    mov     x28, x4

    // SaveTopManagedContext
    mov     x0, x29
    bl      MRT_SaveTopManagedContextToN2CStub

    // Prepare arguments for closure call
    mov     x0, x19         // sret
    mov     x1, x20         // closureObj

    // Get func from executeClosure (func is at offset 8)
    ldr     x9, [x21, #8]

    // Call closure
    blr     x9

    .global unwindPCForExclusiveStubFull
unwindPCForExclusiveStubFull:

    // Save return value
    mov     x19, x0

    // RestoreTopManagedContext
    mov     x0, x29
    bl      MRT_RestoreTopManagedContextFromN2CStub

    // Restore return value
    mov     x0, x19

    // Restore callee-saved registers
    ldp     x19, x20, [sp, #0x10]
    cfi_restore(x19)
    cfi_restore(x20)
    ldp     x21, x22, [sp, #0x20]
    cfi_restore(x21)
    cfi_restore(x22)
    ldp     x27, x28, [sp, #0x30]
    cfi_restore(x27)
    cfi_restore(x28)

    // Restore frame pointer and link register
    ldp     x29, x30, [sp], #96
    cfi_adjust_cfa_offset(-96)
    cfi_restore(x29)
    cfi_restore(x30)

#if defined(ENABLE_BACKWARD_PTRAUTH_CFI)
    autiasp
#endif
    ret

    .cfi_endproc
    .size ExecuteCangjieStubFull, .-ExecuteCangjieStubFull
