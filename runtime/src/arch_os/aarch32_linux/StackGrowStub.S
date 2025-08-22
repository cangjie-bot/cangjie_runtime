// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#define cfi_adjust_cfa_offset(off)	.cfi_adjust_cfa_offset off
#define cfi_rel_offset(reg, off)	.cfi_rel_offset reg, off
#define cfi_restore(reg)		.cfi_restore reg
#define cfi_def_cfa_register(reg)	.cfi_def_cfa_register reg

#define SignalStubFrameSize           (192)

// This signal handler stub relies on MRT_PrepareToHandleSignal to put continuation pc in x17.
// Continuation pc describes the control flow after signal handling completes.

    .text
    .align 2
    .global CJ_MCC_StackGrowStub
    .type CJ_MCC_StackGrowStub, %function
CJ_MCC_StackGrowStub:
    .cfi_startproc
    .cfi_return_column lr
    sub  sp, sp, #SignalStubFrameSize
    cfi_adjust_cfa_offset (SignalStubFrameSize)
    str  r11, [sp]
    str  lr, [sp, #4]
    cfi_rel_offset (r11, 0)
    cfi_rel_offset (lr, 4)

    mov  r11, sp
    cfi_def_cfa_register (r11)

    // save all non callee-saved registers which may be contaminated by calling
    // the real signal handler.
    str  r0, [sp, #8]
    str  r1, [sp, #12]
    str  r2, [sp, #16]
    str  r3, [sp, #20]
    str  r4, [sp, #24]
    str  r5, [sp, #28]
    str  r6, [sp, #32]
    str  r7, [sp, #36]
    str  r8, [sp, #40]
    str  r9, [sp, #44]
    str  r10, [sp, #48]
    str  r12, [sp, #52]

    cfi_rel_offset (r0, 8)
    cfi_rel_offset (r1, 12)
    cfi_rel_offset (r2, 16)
    cfi_rel_offset (r3, 20)
    cfi_rel_offset (r4, 24)
    cfi_rel_offset (r5, 28)
    cfi_rel_offset (r6, 32)
    cfi_rel_offset (r7, 36)
    cfi_rel_offset (r8, 40)
    cfi_rel_offset (r9, 44)
    cfi_rel_offset (r10, 48)
    cfi_rel_offset (r12, 52)

    mrs  lr, cpsr
    str  lr, [sp, #56]

    vstr  d0, [sp, #64]
    vstr  d1, [sp, #72]
    vstr  d2, [sp, #80]
    vstr  d3, [sp, #88]
    vstr  d4, [sp, #96]
    vstr  d5, [sp, #104]
    vstr  d6, [sp, #112]
    vstr  d7, [sp, #120]
    vstr  d8, [sp, #128]
    vstr  d9, [sp, #136]
    vstr  d10, [sp, #144]
    vstr  d11, [sp, #152]
    vstr  d12, [sp, #160]
    vstr  d13, [sp, #168]
    vstr  d14, [sp, #176]
    vstr  d15, [sp, #184]

    mov  r1, r11
    mov  r2, #1
    adr  r0, .L_unwindPCForSignalHandlerStub
    mov  r3, r10
    bl  MRT_UpdateUwContext

    mov  r0, r11
    ldr  r1, [sp]
    // ? adjuestedSize depend on llvm
    ldr  r2, [sp, #4]
    bl  MRT_StackGrow

    .global unwindPCForStackGrowStub
unwindPCForStackGrowStub:
    add  r11, r11, r0
    add  sp, sp, r0
    bl  MRT_FreeOldStack

    bl  MRT_GetThreadLocalData
    str  r0, [sp, #48]

    bl MRT_DeleteC2NContext

.L_noexception:
    vldr  d0, [sp, #64]
    vldr  d1, [sp, #72]
    vldr  d2, [sp, #80]
    vldr  d3, [sp, #88]
    vldr  d4, [sp, #96]
    vldr  d5, [sp, #104]
    vldr  d6, [sp, #112]
    vldr  d7, [sp, #120]
    vldr  d8, [sp, #128]
    vldr  d9, [sp, #136]
    vldr  d10, [sp, #144]
    vldr  d11, [sp, #152]
    vldr  d12, [sp, #160]
    vldr  d13, [sp, #168]
    vldr  d14, [sp, #176]
    vldr  d15, [sp, #184]

    ldr  r0, [sp, #8]
    ldr  r1, [sp, #12]
    ldr  r2, [sp, #16]
    ldr  r3, [sp, #20]
    ldr  r4, [sp, #24]
    ldr  r5, [sp, #28]
    ldr  r6, [sp, #32]
    ldr  r7, [sp, #36]
    ldr  r8, [sp, #40]
    ldr  r9, [sp, #44]
    ldr  r10, [sp, #48]
    ldr  r12, [sp, #52]
    cfi_restore (r0)
    cfi_restore (r1)
    cfi_restore (r2)
    cfi_restore (r3)
    cfi_restore (r4)
    cfi_restore (r5)
    cfi_restore (r6)
    cfi_restore (r7)
    cfi_restore (r8)
    cfi_restore (r9)
    cfi_restore (r10)
    cfi_restore (r12)

    ldr  lr, [sp, #56]
    msr  cpsr, lr

    ldr  r11, [sp]
    ldr  lr, [sp, #4]
    cfi_restore (r11)
    cfi_restore (lr)

    add  sp, sp, #SignalStubFrameSize
    cfi_adjust_cfa_offset (-SignalStubFrameSize)

    bx  lr
    .cfi_endproc
    .size CJ_MCC_StackGrowStub, .-CJ_MCC_StackGrowStub
