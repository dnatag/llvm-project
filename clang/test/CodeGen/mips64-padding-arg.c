// RUN: %clang -target mipsel-unknown-linux -O3 -S -o - -emit-llvm %s | FileCheck %s -check-prefix=O32
// RUN: %clang -target mips64el-unknown-linux -O3 -S -mabi=n64 -o - -emit-llvm %s | FileCheck %s -check-prefix=N64
// RUN: %clang -target mipsel-unknown-linux -mfp64 -O3 -S -o - -emit-llvm %s | FileCheck %s -check-prefix=O32-FP64

typedef struct {
  double d;
  long double ld;
} S0;

// Insert padding to ensure arguments of type S0 are aligned to 16-byte boundaries.

// N64-LABEL: define void @foo1(i32 %a0, i64, double %a1.coerce0, i64 %a1.coerce1, i64 %a1.coerce2, i64 %a1.coerce3, double %a2.coerce0, i64 %a2.coerce1, i64 %a2.coerce2, i64 %a2.coerce3, i32 %b, i64, double %a3.coerce0, i64 %a3.coerce1, i64 %a3.coerce2, i64 %a3.coerce3)
// N64: tail call void @foo2(i32 1, i32 2, i32 %a0, i64 undef, double %a1.coerce0, i64 %a1.coerce1, i64 %a1.coerce2, i64 %a1.coerce3, double %a2.coerce0, i64 %a2.coerce1, i64 %a2.coerce2, i64 %a2.coerce3, i32 3, i64 undef, double %a3.coerce0, i64 %a3.coerce1, i64 %a3.coerce2, i64 %a3.coerce3)
// N64: declare void @foo2(i32, i32, i32, i64, double, i64, i64, i64, double, i64, i64, i64, i32, i64, double, i64, i64, i64)

extern void foo2(int, int, int, S0, S0, int, S0);

void foo1(int a0, S0 a1, S0 a2, int b, S0 a3) {
  foo2(1, 2, a0, a1, a2, 3, a3);
}

// Insert padding before long double argument.
//
// N64-LABEL: define void @foo3(i32 %a0, i64, fp128 %a1)
// N64: tail call void @foo4(i32 1, i32 2, i32 %a0, i64 undef, fp128 %a1)
// N64: declare void @foo4(i32, i32, i32, i64, fp128)

extern void foo4(int, int, int, long double);

void foo3(int a0, long double a1) {
  foo4(1, 2, a0, a1);
}

// Insert padding after hidden argument.
//
// N64-LABEL: define void @foo5(%struct.S0* noalias sret %agg.result, i64, fp128 %a0)
// N64: call void @foo6(%struct.S0* sret %agg.result, i32 1, i32 2, i64 undef, fp128 %a0)
// N64: declare void @foo6(%struct.S0* sret, i32, i32, i64, fp128)

extern S0 foo6(int, int, long double);

S0 foo5(long double a0) {
  return foo6(1, 2, a0);
}

// Do not insert padding if ABI is O32.
//
// O32-LABEL: define void @foo7(float %a0, double %a1)
// O32: declare void @foo8(float, double)

extern void foo8(float, double);

void foo7(float a0, double a1) {
  foo8(a0 + 1.0f, a1 + 2.0);
}

// O32-LABEL: define void @foo9()
// O32: declare void @foo10(i32, i32
// O32-FP64-LABEL: define void @foo9()
// O32-FP64: declare void @foo10(i32, i96

typedef struct __attribute__((aligned(16))) {
  int a;
} S16;

S16 s16;

void foo10(int, S16);

void foo9(void) {
  foo10(1, s16);
}

