//===-------------------- UnwindRegistersRestore.s ------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//


#if __i386__
  .text
  .globl __ZN9libunwind13Registers_x866jumptoEv
  .private_extern __ZN9libunwind13Registers_x866jumptoEv
__ZN9libunwind13Registers_x866jumptoEv:
#
# void libunwind::Registers_x86::jumpto()
#
# On entry:
#  +                       +
#  +-----------------------+
#  + thread_state pointer  +
#  +-----------------------+
#  + return address        +
#  +-----------------------+   <-- SP
#  +                       +
  movl   4(%esp), %eax
  # set up eax and ret on new stack location
  movl  28(%eax), %edx # edx holds new stack pointer
  subl  $8,%edx
  movl  %edx, 28(%eax)
  movl  0(%eax), %ebx
  movl  %ebx, 0(%edx)
  movl  40(%eax), %ebx
  movl  %ebx, 4(%edx)
  # we now have ret and eax pushed onto where new stack will be
  # restore all registers
  movl   4(%eax), %ebx
  movl   8(%eax), %ecx
  movl  12(%eax), %edx
  movl  16(%eax), %edi
  movl  20(%eax), %esi
  movl  24(%eax), %ebp
  movl  28(%eax), %esp
  # skip ss
  # skip eflags
  pop    %eax  # eax was already pushed on new stack
  ret        # eip was already pushed on new stack
  # skip cs
  # skip ds
  # skip es
  # skip fs
  # skip gs

#elif __x86_64__

  .text
  .globl __ZN9libunwind16Registers_x86_646jumptoEv
  .private_extern __ZN9libunwind16Registers_x86_646jumptoEv
__ZN9libunwind16Registers_x86_646jumptoEv:
#
# void libunwind::Registers_x86_64::jumpto()
#
# On entry, thread_state pointer is in rdi

  movq  56(%rdi), %rax # rax holds new stack pointer
  subq  $16, %rax
  movq  %rax, 56(%rdi)
  movq  32(%rdi), %rbx  # store new rdi on new stack
  movq  %rbx, 0(%rax)
  movq  128(%rdi), %rbx # store new rip on new stack
  movq  %rbx, 8(%rax)
  # restore all registers
  movq    0(%rdi), %rax
  movq    8(%rdi), %rbx
  movq   16(%rdi), %rcx
  movq   24(%rdi), %rdx
  # restore rdi later
  movq   40(%rdi), %rsi
  movq   48(%rdi), %rbp
  # restore rsp later
  movq   64(%rdi), %r8
  movq   72(%rdi), %r9
  movq   80(%rdi), %r10
  movq   88(%rdi), %r11
  movq   96(%rdi), %r12
  movq  104(%rdi), %r13
  movq  112(%rdi), %r14
  movq  120(%rdi), %r15
  # skip rflags
  # skip cs
  # skip fs
  # skip gs
  movq  56(%rdi), %rsp  # cut back rsp to new location
  pop    %rdi      # rdi was saved here earlier
  ret            # rip was saved here


#elif __ppc__

  .text
  .globl __ZN9libunwind13Registers_ppc6jumptoEv
  .private_extern __ZN9libunwind13Registers_ppc6jumptoEv
__ZN9libunwind13Registers_ppc6jumptoEv:
;
; void libunwind::Registers_ppc::jumpto()
;
; On entry:
;  thread_state pointer is in r3
;

  ; restore integral registerrs
  ; skip r0 for now
  ; skip r1 for now
  lwz     r2, 16(r3)
  ; skip r3 for now
  ; skip r4 for now
  ; skip r5 for now
  lwz     r6, 32(r3)
  lwz     r7, 36(r3)
  lwz     r8, 40(r3)
  lwz     r9, 44(r3)
  lwz    r10, 48(r3)
  lwz    r11, 52(r3)
  lwz    r12, 56(r3)
  lwz    r13, 60(r3)
  lwz    r14, 64(r3)
  lwz    r15, 68(r3)
  lwz    r16, 72(r3)
  lwz    r17, 76(r3)
  lwz    r18, 80(r3)
  lwz    r19, 84(r3)
  lwz    r20, 88(r3)
  lwz    r21, 92(r3)
  lwz    r22, 96(r3)
  lwz    r23,100(r3)
  lwz    r24,104(r3)
  lwz    r25,108(r3)
  lwz    r26,112(r3)
  lwz    r27,116(r3)
  lwz    r28,120(r3)
  lwz    r29,124(r3)
  lwz    r30,128(r3)
  lwz    r31,132(r3)

  ; restore float registers
  lfd    f0, 160(r3)
  lfd    f1, 168(r3)
  lfd    f2, 176(r3)
  lfd    f3, 184(r3)
  lfd    f4, 192(r3)
  lfd    f5, 200(r3)
  lfd    f6, 208(r3)
  lfd    f7, 216(r3)
  lfd    f8, 224(r3)
  lfd    f9, 232(r3)
  lfd    f10,240(r3)
  lfd    f11,248(r3)
  lfd    f12,256(r3)
  lfd    f13,264(r3)
  lfd    f14,272(r3)
  lfd    f15,280(r3)
  lfd    f16,288(r3)
  lfd    f17,296(r3)
  lfd    f18,304(r3)
  lfd    f19,312(r3)
  lfd    f20,320(r3)
  lfd    f21,328(r3)
  lfd    f22,336(r3)
  lfd    f23,344(r3)
  lfd    f24,352(r3)
  lfd    f25,360(r3)
  lfd    f26,368(r3)
  lfd    f27,376(r3)
  lfd    f28,384(r3)
  lfd    f29,392(r3)
  lfd    f30,400(r3)
  lfd    f31,408(r3)

  ; restore vector registers if any are in use
  lwz    r5,156(r3)  ; test VRsave
  cmpwi  r5,0
  beq    Lnovec

  subi  r4,r1,16
  rlwinm  r4,r4,0,0,27  ; mask low 4-bits
  ; r4 is now a 16-byte aligned pointer into the red zone
  ; the _vectorRegisters may not be 16-byte aligned so copy via red zone temp buffer


#define LOAD_VECTOR_UNALIGNEDl(_index) \
  andis.  r0,r5,(1<<(15-_index))  @\
  beq    Ldone  ## _index     @\
  lwz    r0, 424+_index*16(r3)  @\
  stw    r0, 0(r4)        @\
  lwz    r0, 424+_index*16+4(r3)  @\
  stw    r0, 4(r4)        @\
  lwz    r0, 424+_index*16+8(r3)  @\
  stw    r0, 8(r4)        @\
  lwz    r0, 424+_index*16+12(r3)@\
  stw    r0, 12(r4)        @\
  lvx    v ## _index,0,r4    @\
Ldone  ## _index:

#define LOAD_VECTOR_UNALIGNEDh(_index) \
  andi.  r0,r5,(1<<(31-_index))  @\
  beq    Ldone  ## _index    @\
  lwz    r0, 424+_index*16(r3)  @\
  stw    r0, 0(r4)        @\
  lwz    r0, 424+_index*16+4(r3)  @\
  stw    r0, 4(r4)        @\
  lwz    r0, 424+_index*16+8(r3)  @\
  stw    r0, 8(r4)        @\
  lwz    r0, 424+_index*16+12(r3)@\
  stw    r0, 12(r4)        @\
  lvx    v ## _index,0,r4    @\
  Ldone  ## _index:


  LOAD_VECTOR_UNALIGNEDl(0)
  LOAD_VECTOR_UNALIGNEDl(1)
  LOAD_VECTOR_UNALIGNEDl(2)
  LOAD_VECTOR_UNALIGNEDl(3)
  LOAD_VECTOR_UNALIGNEDl(4)
  LOAD_VECTOR_UNALIGNEDl(5)
  LOAD_VECTOR_UNALIGNEDl(6)
  LOAD_VECTOR_UNALIGNEDl(7)
  LOAD_VECTOR_UNALIGNEDl(8)
  LOAD_VECTOR_UNALIGNEDl(9)
  LOAD_VECTOR_UNALIGNEDl(10)
  LOAD_VECTOR_UNALIGNEDl(11)
  LOAD_VECTOR_UNALIGNEDl(12)
  LOAD_VECTOR_UNALIGNEDl(13)
  LOAD_VECTOR_UNALIGNEDl(14)
  LOAD_VECTOR_UNALIGNEDl(15)
  LOAD_VECTOR_UNALIGNEDh(16)
  LOAD_VECTOR_UNALIGNEDh(17)
  LOAD_VECTOR_UNALIGNEDh(18)
  LOAD_VECTOR_UNALIGNEDh(19)
  LOAD_VECTOR_UNALIGNEDh(20)
  LOAD_VECTOR_UNALIGNEDh(21)
  LOAD_VECTOR_UNALIGNEDh(22)
  LOAD_VECTOR_UNALIGNEDh(23)
  LOAD_VECTOR_UNALIGNEDh(24)
  LOAD_VECTOR_UNALIGNEDh(25)
  LOAD_VECTOR_UNALIGNEDh(26)
  LOAD_VECTOR_UNALIGNEDh(27)
  LOAD_VECTOR_UNALIGNEDh(28)
  LOAD_VECTOR_UNALIGNEDh(29)
  LOAD_VECTOR_UNALIGNEDh(30)
  LOAD_VECTOR_UNALIGNEDh(31)

Lnovec:
  lwz    r0, 136(r3) ; __cr
  mtocrf  255,r0
  lwz    r0, 148(r3) ; __ctr
  mtctr  r0
  lwz    r0, 0(r3)  ; __ssr0
  mtctr  r0
  lwz    r0, 8(r3)  ; do r0 now
  lwz    r5,28(r3)  ; do r5 now
  lwz    r4,24(r3)  ; do r4 now
  lwz    r1,12(r3)  ; do sp now
  lwz    r3,20(r3)  ; do r3 last
  bctr

#elif __arm64__

  .text
  .globl __ZN9libunwind15Registers_arm646jumptoEv
  .private_extern __ZN9libunwind15Registers_arm646jumptoEv
__ZN9libunwind15Registers_arm646jumptoEv:
;
; void libunwind::Registers_arm64::jumpto()
;
; On entry:
;  thread_state pointer is in x0
;
  ; skip restore of x0,x1 for now
  ldp    x2, x3,  [x0, #0x010]
  ldp    x4, x5,  [x0, #0x020]
  ldp    x6, x7,  [x0, #0x030]
  ldp    x8, x9,  [x0, #0x040]
  ldp    x10,x11, [x0, #0x050]
  ldp    x12,x13, [x0, #0x060]
  ldp    x14,x15, [x0, #0x070]
  ldp    x16,x17, [x0, #0x080]
  ldp    x18,x19, [x0, #0x090]
  ldp    x20,x21, [x0, #0x0A0]
  ldp    x22,x23, [x0, #0x0B0]
  ldp    x24,x25, [x0, #0x0C0]
  ldp    x26,x27, [x0, #0x0D0]
  ldp    x28,fp,  [x0, #0x0E0]
  ldr    lr,      [x0, #0x100]  ; restore pc into lr
  ldr    x1,      [x0, #0x0F8]
  mov    sp,x1          ; restore sp

  ldp    d0, d1,  [x0, #0x110]
  ldp    d2, d3,  [x0, #0x120]
  ldp    d4, d5,  [x0, #0x130]
  ldp    d6, d7,  [x0, #0x140]
  ldp    d8, d9,  [x0, #0x150]
  ldp    d10,d11, [x0, #0x160]
  ldp    d12,d13, [x0, #0x170]
  ldp    d14,d15, [x0, #0x180]
  ldp    d16,d17, [x0, #0x190]
  ldp    d18,d19, [x0, #0x1A0]
  ldp    d20,d21, [x0, #0x1B0]
  ldp    d22,d23, [x0, #0x1C0]
  ldp    d24,d25, [x0, #0x1D0]
  ldp    d26,d27, [x0, #0x1E0]
  ldp    d28,d29, [x0, #0x1F0]
  ldr    d30,     [x0, #0x200]
  ldr    d31,     [x0, #0x208]

  ldp    x0, x1,  [x0, #0x000]  ; restore x0,x1
  ret    lr            ; jump to pc




#endif

