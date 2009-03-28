// RUN: clang-cc -fsyntax-only -verify -arch x86_64 %s

int complete_array_from_init[] = { 1, 2, [10] = 5, 1, 2, [5] = 2, 6 };

int complete_array_from_init_check[((sizeof(complete_array_from_init) / sizeof(int)) == 13)? 1 : -1];

int iarray[10] = {
  [0] = 1,
  [1 ... 5] = 2,
  [ 6 ... 6 ] = 3,
  [ 8 ... 7 ] = 4, // expected-error{{array designator range [8, 7] is empty}}
  [10] = 5,
  [-1] = 6 // expected-error{{array designator value '-1' is negative}}
};

int iarray2[10] = {
  [10] = 1, // expected-error{{array designator index (10) exceeds array bounds (10)}}
};

int iarray3[10] = {
  [3] 2, // expected-warning{{use of GNU 'missing =' extension in designator}}
  [5 ... 12] = 2 // expected-error{{array designator index (12) exceeds array bounds (10)}}
};

struct point {
  double x;
  double y;
};

struct point p1 = { 
  .y = 1.0, 
  x: 2.0, // expected-warning{{}}
  .a = 4.0, // expected-error{{field designator 'a' does not refer to any field in type 'struct point'}}
};

struct point p2 = {
  [1] = 1.0 // expected-error{{array designator cannot initialize non-array type}}
};

struct point array[10] = { 
  [0].x = 1.0,
  [1].y = 2.0,
  [2].z = 3.0, // expected-error{{field designator 'z' does not refer to any field in type 'struct point'}}
};

struct point array2[10] = {
  [10].x = 2.0, // expected-error{{array designator index (10) exceeds array bounds (10)}}
  [4 ... 5].y = 2.0,
  [4 ... 6] = { .x = 3, .y = 4.0 }
};

struct point array3[10] = {
  .x = 5 // expected-error{{field designator cannot initialize a non-struct, non-union type}}
};

struct rect {
  struct point top_left;
  struct point bottom_right;
};

struct rect window = { .top_left.x = 1.0 };

struct rect windows[] = {
  [2].top_left = { 1.0, 2.0 },
  [4].bottom_right = { .y = 1.0 },
  { { .y = 7.0, .x = 8.0 }, { .x = 5.0 } },
  [3] = { .top_left = { 1.1, 2.2 }, .bottom_right = { .y = 1.1 } }
};

int windows_size[((sizeof(windows) / sizeof(struct rect)) == 6)? 1 : -1];

struct rect windows_bad[3] = {
  [2].top_left = { { .x = 1.1 } }, // expected-error{{designator in initializer for scalar type}}
  [1].top_left = { .x = 1.1 }
};

struct gui {
  struct rect windows[10];
};

struct gui gui[] = {
  [5].windows[3].top_left.x = { 7.0 } // expected-warning{{braces around scalar initializer}}
};

struct translator {
  struct wonky { int * ptr; } wonky ;
  struct rect window;
  struct point offset;
} tran = {
  .window = { .top_left = { 1.0, 2.0 } },
  { .x = 5.0, .y = 6.0 },
  .wonky = { 0 }
};

int anint;
struct {int x,*y;} z[] = {[0].x = 2, &z[0].x};

struct outer { struct inner { int x, *y; } in, *inp; } zz[] = {
  [0].in.x = 2, &zz[0].in.x, &zz[0].in,
  0, &anint, &zz[1].in,
  [3].in = { .y = &anint, .x = 17 },
  [7].in.y = &anint, &zz[0].in,
  [4].in.y = &anint, [5].in.x = 12
};

int zz_sizecheck[sizeof(zz) / sizeof(struct outer) == 8? 1 : -1 ];

struct disklabel_ops {
  struct {} type;
  int labelsize;
};

struct disklabel_ops disklabel64_ops = {
  .labelsize = sizeof(struct disklabel_ops)
};

// PR clang/3378
int bitwidth[] = { [(long long int)1] = 5, [(short int)2] = 2 };
int a[]= { [sizeof(int)] = 0 };
int a2[]= { [0 ... sizeof(int)] = 0 };

// Test warnings about initializers overriding previous initializers
struct X {
  int a, b, c;
};

int counter = 0;
int get8() { ++counter; return 8; }

void test() {
  struct X xs[] = { 
    [0] = (struct X){1, 2}, // expected-note{{previous initialization is here}}
    [0].c = 3,  // expected-warning{{subobject initialization overrides initialization of other fields within its enclosing subobject}}
    (struct X) {4, 5, 6}, // expected-note{{previous initialization is here}}
    [1].b = get8(), // expected-warning{{subobject initialization overrides initialization of other fields within its enclosing subobject}}
    [0].b = 8
  };
}

// FIXME: How do we test that this initializes the long properly?
union { char c; long l; } u1 = { .l = 0xFFFF };

extern float global_float;

struct XX { int a, *b; };
struct XY { int before; struct XX xx, *xp; float* after; } xy[] = {
  0, 0, &xy[0].xx.a, &xy[0].xx, &global_float,
  [1].xx = 0, &xy[1].xx.a, &xy[1].xx, &global_float,
  0, // expected-note{{previous initialization is here}}
  0, // expected-note{{previous initialization is here}}
  [2].before = 0, // expected-warning{{initializer overrides prior initialization of this subobject}}
  0, // expected-warning{{initializer overrides prior initialization of this subobject}}
  &xy[2].xx.a, &xy[2].xx, &global_float
};

// PR3519
struct foo {
  int arr[10];
};

struct foo Y[10] = {
  [1] .arr [1] = 2,
  [4] .arr [2] = 4
};

struct bar {
  struct foo f;
  float *arr[10];
};

extern float f;
struct bar saloon = {
  .f.arr[3] = 1,
  .arr = { &f }
};

typedef unsigned char u_char;
typedef unsigned short u_short;

union wibble {
        u_char  arr1[6];
        u_short arr2[3];
};

const union wibble wobble = { .arr2[0] = 0xffff,
                              .arr2[1] = 0xffff,
                              .arr2[2] = 0xffff };

const union wibble wobble2 = { .arr2 = {4, 5, 6}, 7 }; // expected-warning{{excess elements in union initializer}}
