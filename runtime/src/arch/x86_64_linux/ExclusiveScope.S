// ... existing code ...
    .size CJ_MCC_C2NStub, .-CJ_MCC_C2NStub


#define CJTHREAD_THREAD_OFFSET      0x10
#define CJTHREAD_CONTEXT_OFFSET     0x18

#define CONTEXT_RSP                 0x00
#define CONTEXT_RBP                 0x08
#define CONTEXT_RBX                 0x10
#define CONTEXT_RIP                 0x18
#define CONTEXT_R12                 0x20
#define CONTEXT_R13                 0x28
#define CONTEXT_R14                 0x30
#define CONTEXT_R15                 0x38
#define CONTEXT_MXCSR               0x40
#define CONTEXT_FPU_CW              0x44

#define THREAD_CONTEXT_OFFSET       0x78
#define ExclusiveScopeFrameSize     (8 * 22)


// ==============================================================================
// CJ_MCC_ExclusiveScope: 从 cjthread 栈切换到 OS thread 栈执行独占任务
// ==============================================================================
//
// 入参:
//   void* CJ_MCC_ExclusiveScope(void* executeClosure, void* closurePtr,
//                               void* futureTi, void* reserved)
//                                    rdi              rsi
//                                    rdx              rcx
//
// 内部调用:
//   MCC_NewExclusiveCJThread(executeClosure, closurePtr, futureTi) -> newCJThread
//   ExclusiveExecutor(oldCJThread, thread, newCJThread)
//
// 流程:
// 1. 调用 MCC_NewExclusiveCJThread 创建 newCJThread (在 Saferegion 外)
// 2. 获取 oldCJThread, thread
// 3. EnterSaferegion
// 4. 切换到 OS thread 栈
// 5. 调用 ExclusiveExecutor
// 6. 切回 cjthread 栈
// 7. LeaveSaferegion
// 8. 返回

    .text
    .align 2
    .global CJ_MCC_ExclusiveScope
    .type CJ_MCC_ExclusiveScope, @function
CJ_MCC_ExclusiveScope:
    .cfi_startproc
    
    // ==================== 建立栈帧 ====================
    pushq   %rbp
    .cfi_def_cfa_offset 16
    .cfi_offset %rbp, -16
    movq    %rsp, %rbp
    .cfi_def_cfa_register %rbp
    subq    $ExclusiveScopeFrameSize, %rsp

    // 保存 callee-saved 寄存器
    movq    %r15, -8(%rbp)
    movq    %r14, -16(%rbp)
    movq    %r13, -24(%rbp)
    movq    %r12, -32(%rbp)
    movq    %rbx, -40(%rbp)
    .cfi_rel_offset %rbx, -40
    .cfi_rel_offset %r12, -32
    .cfi_rel_offset %r13, -24
    .cfi_rel_offset %r14, -16
    .cfi_rel_offset %r15, -8

    // 保存入参 (reserved 不传给 MCC_NewExclusiveCJThread)
    movq    %rdi, -48(%rbp)     // executeClosure
    movq    %rsi, -56(%rbp)     // closurePtr
    movq    %rdx, -64(%rbp)     // futureTi
    movq    %rcx, -72(%rbp)     // reserved (备用)

    // ==================== 1. 创建 newCJThread ====================
    // MCC_NewExclusiveCJThread(executeClosure, closurePtr, futureTi)
    //                              rdi           rsi        rdx
    movq    -48(%rbp), %rdi     // executeClosure
    movq    -56(%rbp), %rsi     // closurePtr
    movq    -64(%rbp), %rdx     // futureTi
    callq   MCC_NewExclusiveCJThread@PLT
    
    testq   %rax, %rax
    jz      .L_exc_create_failed
    movq    %rax, -160(%rbp)    // newCJThread

    // ==================== 2. 获取 oldCJThread ====================
    callq   CJ_CJThreadGetHandle
    testq   %rax, %rax
    jz      .L_exc_no_cjthread
    movq    %rax, -80(%rbp)     // oldCJThread

    // thread = oldCJThread->thread
    movq    CJTHREAD_THREAD_OFFSET(%rax), %r12
    testq   %r12, %r12
    jz      .L_exc_no_thread
    movq    %r12, -88(%rbp)     // thread

    // ==================== 3. 保存 EXCLUSIVE 上下文 ====================
    movq    %rbp,  %rsi                  // rsi = fa (frame address)
    // Get the current pc address through the following two assembly instructions.
    call    .L_exc_get_pc
.L_exc_get_pc:
    .global unwindPCForExclusiveStub
unwindPCForExclusiveStub:
    pop     %rdi
    mov     %r15, %rdx
    callq   MRT_SaveC2NContext@PLT

    // ==================== 4. EnterSaferegion ====================
    movq    $0, %rdi
    callq   MRT_EnterSaferegion@PLT
    movq    %rax, -96(%rbp)     // enterSafe

    // 保存当前 rsp (cjthread 栈)
    movq    %rsp, -104(%rbp)

    // test log 
    movq    %rsp, %rdi
    callq   DebugLogAsm@PLT


    // ==================== 5. 保存 cjthread context ====================
    movq    -80(%rbp), %rax         // oldCJThread
    leaq    CJTHREAD_CONTEXT_OFFSET(%rax), %r14

    leaq    8(%rsp), %r11
    movq    %r11, CONTEXT_RSP(%r14)
    movq    %rbp, CONTEXT_RBP(%r14)
    movq    %rbx, CONTEXT_RBX(%r14)
    movq    (%rsp), %r11
    movq    %r11, CONTEXT_RIP(%r14)
    movq    %r12, CONTEXT_R12(%r14)
    movq    %r13, CONTEXT_R13(%r14)
    movq    -16(%rbp), %r11
    movq    %r11, CONTEXT_R14(%r14)
    movq    -8(%rbp), %r11
    movq    %r11, CONTEXT_R15(%r14)
    stmxcsr CONTEXT_MXCSR(%r14)
    fstcw   CONTEXT_FPU_CW(%r14)

    // ==================== 6. 切换到 OS thread 栈 ====================
    movq    -88(%rbp), %r12             // thread
    leaq    THREAD_CONTEXT_OFFSET(%r12), %r15
    
    movq    CONTEXT_RSP(%r15), %rsp
    ldmxcsr CONTEXT_MXCSR(%r15)
    fldcw   CONTEXT_FPU_CW(%r15)

    // 16 字节对齐
    subq    $128, %rsp
    andq    $-16, %rsp

    // test log 
    movq    %rsp, %rdi
    callq   DebugLogAsm@PLT

    // ==================== 7. 调用 ExclusiveExecutor ====================
    // ExclusiveExecutor(oldCJThread, thread, newCJThread)
    //                      rdi         rsi      rdx
    movq    -80(%rbp), %rdi     // oldCJThread
    movq    -88(%rbp), %rsi     // thread
    movq    -160(%rbp), %rdx    // newCJThread
    callq   ExclusiveExecutor@PLT

    // 保存返回值
    movq    %rax, %r13
    movapd  %xmm0, -128(%rbp)
    movapd  %xmm1, -144(%rbp)

    // ==================== 8. 切回 cjthread 栈 ====================
    movq    -104(%rbp), %rsp
    movq    %r13, -112(%rbp)

    // test log 
    movq    %rsp, %rdi
    callq   DebugLogAsm@PLT

    // ==================== 9. LeaveSaferegion ====================
    movq    -96(%rbp), %rax
    cmpq    $0, %rax
    je      .L_exc_skip_leave
    callq   MRT_LeaveSaferegion@PLT
    callq   MRT_GetThreadLocalData@PLT
    movq    %rax, %r13
.L_exc_skip_leave:

    // ==================== 10. 删除 C2N 上下文 ====================
    movq    %r13, %rdi
    callq   MRT_DeleteC2NContext@PLT

    // ==================== 11. 检查待处理异常 ====================
    movq    $0, %rdi
    callq   MRT_ThrowPendingException@PLT

    // 恢复返回值
    movq    -112(%rbp), %rax
    movapd  -128(%rbp), %xmm0
    movapd  -144(%rbp), %xmm1

    jmp     .L_exc_cleanup

// ==================== 异常路径 ====================
.L_exc_create_failed:
.L_exc_no_cjthread:
.L_exc_no_thread:
    xorq    %rax, %rax

.L_exc_cleanup:
    movq    -8(%rbp),  %r15
    movq    -16(%rbp), %r14
    movq    -24(%rbp), %r13
    movq    -32(%rbp), %r12
    movq    -40(%rbp), %rbx

    addq    $ExclusiveScopeFrameSize, %rsp
    popq    %rbp
    .cfi_def_cfa %rsp, 8
    retq

    .cfi_endproc
    .size CJ_MCC_ExclusiveScope, .-CJ_MCC_ExclusiveScope


    .text
    .align 2
    .global   ExecuteCangjieStubFull
    .type     ExecuteCangjieStubFull, @function
ExecuteCangjieStubFull:
    .cfi_startproc
    // 临时调试：确认 ExecuteCangjieStubFull 被调用
    pushq   %rdi
    pushq   %rsi
    pushq   %rdx
    pushq   %rcx
    pushq   %r8
    movq    %rcx, %rdi      // func 指针
    callq   DebugLogExcStubFull@PLT
    popq    %r8
    popq    %rcx
    popq    %rdx
    popq    %rsi
    popq    %rdi
    pushq   %rbp
    .cfi_def_cfa_offset 16
    .cfi_offset %rbp, -16
    movq    %rsp, %rbp
    .cfi_def_cfa_register %rbp
    subq    $96, %rsp

    // 1. 保存 callee-saved 寄存器（和 CJ_MCC_N2CStub 布局一致）
    movq    %r15, -8(%rbp)
    movq    %r14, -16(%rbp)
    movq    %r13, -24(%rbp)
    movq    %r12, -32(%rbp)
    movq    %rbx, -40(%rbp)
    .cfi_rel_offset %rbx, -40
    .cfi_rel_offset %r12, -32
    .cfi_rel_offset %r13, -24
    .cfi_rel_offset %r14, -16
    .cfi_rel_offset %r15, -8

    movq    %rdi, -48(%rbp)      // arg0 (closureObj)
    movq    %rsi, -56(%rbp)      // arg1 (futureTi)
    movq    %rdx, -64(%rbp)      // arg2
    movq    %rcx, -72(%rbp)      // func (函数指针)
    movq    %r8,  -80(%rbp)      // threadData

    // 2. 保存入参（只需要 rdi 和 rdx）
    movq    %rdi, -48(%rbp)      # sret (&g_ut)
    movq    %rdx, -56(%rbp)      # closureObj (注意是 rdx 不是 rsi)
    movq    %rcx, -64(%rbp)      # executeClosure 对象

    // 3. SaveTopManagedContext
    movq    %rbp, %rdi
    callq   MRT_SaveTopManagedContextToN2CStub@PLT

    // 4. 准备调用参数
    movq    -48(%rbp), %rdi      # rdi = &g_ut
    movq    -56(%rbp), %rdx      # rdx = closureObj (不要动 rsi)

    // 5. 从 executeClosure 对象取函数指针
    movq    -64(%rbp), %r11      # r11 = executeClosure 对象
    movq    8(%r11),   %r11      # r11 = slot[1] 函数指针 ($0_$g)
    // 注意：不使用 r12 保存对象引用，避免 GC 时 "register r12 is not recorded"

    // 6. 调用
    callq   *%r11
    .global unwindPCForExclusiveStubFull
unwindPCForExclusiveStubFull:

    // 7. RestoreTopManagedContext
    movq    %rbp, %rdi
    callq   MRT_RestoreTopManagedContextFromN2CStub@PLT

    // 8. 恢复寄存器和返回
    movq    -8(%rbp),  %r15
    movq    -16(%rbp), %r14
    movq    -24(%rbp), %r13
    movq    -32(%rbp), %r12
    movq    -40(%rbp), %rbx

    addq    $96, %rsp
    popq    %rbp
    .cfi_def_cfa %rsp, 8
    retq
    .cfi_endproc
    .size ExecuteCangjieStubFull, .-ExecuteCangjieStubFull