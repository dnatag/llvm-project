// RUN: not llvm-mc -triple aarch64-none-linux-gnu -mattr=+neon < %s 2> %t
// RUN: FileCheck --check-prefix=CHECK-ERROR < %t %s

//------------------------------------------------------------------------------
// Vector Integer Add/sub
//------------------------------------------------------------------------------

        // Mismatched vector types
        add v0.16b, v1.8b, v2.8b
        sub v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         add v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sub v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                              ^

//------------------------------------------------------------------------------
// Vector Floating-Point Add/sub
//------------------------------------------------------------------------------

        // Mismatched and invalid vector types
        fadd v0.2d, v1.2s, v2.2s
        fsub v0.4s, v1.2s, v2.4s
        fsub v0.8b, v1.8b, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fadd v0.2d, v1.2s, v2.2s
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fsub v0.4s, v1.2s, v2.4s
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fsub v0.8b, v1.8b, v2.8b
// CHECK-ERROR:                  ^

//----------------------------------------------------------------------
// Vector Integer Mul
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
        mul v0.16b, v1.8b, v2.8b
        mul v0.2d, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         mul v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         mul v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                ^

//----------------------------------------------------------------------
// Vector Floating-Point Mul/Div
//----------------------------------------------------------------------
        // Mismatched vector types
        fmul v0.16b, v1.8b, v2.8b
        fdiv v0.2s, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fmul v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fdiv v0.2s, v1.2d, v2.2d
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Vector And Orr Eor Bsl Bit Bif, Orn, Bic,
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        and v0.8b, v1.16b, v2.8b
        orr v0.4h, v1.4h, v2.4h
        eor v0.2s, v1.2s, v2.2s
        bsl v0.8b, v1.16b, v2.8b
        bsl v0.2s, v1.2s, v2.2s
        bit v0.2d, v1.2d, v2.2d
        bif v0.4h, v1.4h, v2.4h
        orn v0.8b, v1.16b, v2.16b
        bic v0.2d, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         and v0.8b, v1.16b, v2.8b
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         orr v0.4h, v1.4h, v2.4h
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         eor v0.2s, v1.2s, v2.2s
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         bsl v0.8b, v1.16b, v2.8b
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         bsl v0.2s, v1.2s, v2.2s
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         bit v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         bif v0.4h, v1.4h, v2.4h
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         orn v0.8b, v1.16b, v2.16b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         bic v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                ^

//----------------------------------------------------------------------
// Vector Integer Multiply-accumulate and Multiply-subtract
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
        mla v0.16b, v1.8b, v2.8b
        mls v0.2d, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         mla v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         mls v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                ^

//----------------------------------------------------------------------
// Vector Floating-Point Multiply-accumulate and Multiply-subtract
//----------------------------------------------------------------------
        // Mismatched vector types
        fmla v0.2s, v1.2d, v2.2d
        fmls v0.16b, v1.8b, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fmla v0.2s, v1.2d, v2.2d
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fmls v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                         ^


//----------------------------------------------------------------------
// Vector Move Immediate Shifted
// Vector Move Inverted Immediate Shifted
// Vector Bitwise Bit Clear (AND NOT) - immediate
// Vector Bitwise OR - immedidate
//----------------------------------------------------------------------
      // out of range immediate (0 to 0xff)
      movi v0.2s, #-1
      mvni v1.4s, #256
      // out of range shift (0, 8, 16, 24 and 0, 8)
      bic v15.4h, #1, lsl #7
      orr v31.2s, #1, lsl #25
      movi v5.4h, #10, lsl #16
      // invalid vector type (2s, 4s, 4h, 8h)
      movi v5.8b, #1, lsl #8

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          movi v0.2s, #-1
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         mvni v1.4s, #256
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         bic v15.4h, #1, lsl #7
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         orr v31.2s, #1, lsl #25
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         movi v5.4h, #10, lsl #16
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         movi v5.8b, #1, lsl #8
// CHECK-ERROR:                         ^
//----------------------------------------------------------------------
// Vector Move Immediate Masked
// Vector Move Inverted Immediate Masked
//----------------------------------------------------------------------
      // out of range immediate (0 to 0xff)
      movi v0.2s, #-1, msl #8
      mvni v7.4s, #256, msl #16
      // out of range shift (8, 16)
      movi v3.2s, #1, msl #0
      mvni v17.4s, #255, msl #32
      // invalid vector type (2s, 4s)
      movi v5.4h, #31, msl #8

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         movi v0.2s, #-1, msl #8
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         mvni v7.4s, #256, msl #16
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         movi v3.2s, #1, msl #0
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         mvni v17.4s, #255, msl #32
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         movi v5.4h, #31, msl #8
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Vector Immediate - per byte
//----------------------------------------------------------------------
        // out of range immediate (0 to 0xff)
        movi v0.8b, #-1
        movi v1.16b, #256

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         movi v0.8b, #-1
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         movi v1.16b, #256
// CHECK-ERROR:                      ^

//----------------------------------------------------------------------
// Scalar Floating-point Reciprocal Estimate
//----------------------------------------------------------------------

    frecpe s19, h14
    frecpe d13, s13

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frecpe s19, h14
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frecpe d13, s13
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Floating-point Reciprocal Exponent
//----------------------------------------------------------------------

    frecpx s18, h10
    frecpx d16, s19

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frecpx s18, h10
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frecpx d16, s19
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Floating-point Reciprocal Square Root Estimate
//----------------------------------------------------------------------

    frsqrte s22, h13
    frsqrte d21, s12

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frsqrte s22, h13
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frsqrte d21, s12
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Vector Move Immediate - bytemask, per doubleword
//---------------------------------------------------------------------
        // invalid bytemask (0x00 or 0xff)
        movi v0.2d, #0x10ff00ff00ff00ff

// CHECK:ERROR: error: invalid operand for instruction
// CHECK:ERROR:         movi v0.2d, #0x10ff00ff00ff00ff
// CHECK:ERROR:                     ^

//----------------------------------------------------------------------
// Vector Move Immediate - bytemask, one doubleword
//----------------------------------------------------------------------
        // invalid bytemask (0x00 or 0xff)
        movi v0.2d, #0xffff00ff001f00ff

// CHECK:ERROR: error: invalid operand for instruction
// CHECK:ERROR:         movi v0.2d, #0xffff00ff001f00ff
// CHECK:ERROR:                     ^
//----------------------------------------------------------------------
// Vector Floating Point Move Immediate
//----------------------------------------------------------------------
        // invalid vector type (2s, 4s, 2d)
         fmov v0.4h, #1.0

// CHECK:ERROR: error: invalid operand for instruction
// CHECK:ERROR:         fmov v0.4h, #1.0
// CHECK:ERROR:              ^

//----------------------------------------------------------------------
// Vector Move -  register
//----------------------------------------------------------------------
      // invalid vector type (8b, 16b)
      mov v0.2s, v31.8b
// CHECK:ERROR: error: invalid operand for instruction
// CHECK:ERROR:         mov v0.2s, v31.8b
// CHECK:ERROR:                ^

//----------------------------------------------------------------------
// Vector Absolute Difference and Accumulate (Signed, Unsigned)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types (2d)
        saba v0.16b, v1.8b, v2.8b
        uaba v0.2d, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         saba v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uaba v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                ^

//----------------------------------------------------------------------
// Vector Absolute Difference and Accumulate (Signed, Unsigned)
// Vector Absolute Difference (Signed, Unsigned)

        // Mismatched and invalid vector types (2d)
        uaba v0.16b, v1.8b, v2.8b
        saba v0.2d, v1.2d, v2.2d
        uabd v0.4s, v1.2s, v2.2s
        sabd v0.4h, v1.8h, v8.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uaba v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         saba v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uabd v0.4s, v1.2s, v2.2s
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sabd v0.4h, v1.8h, v8.8h
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Vector Absolute Difference (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fabd v0.2s, v1.4s, v2.2d
        fabd v0.4h, v1.4h, v2.4h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fabd v0.2s, v1.4s, v2.2d
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fabd v0.4h, v1.4h, v2.4h
// CHECK-ERROR:                 ^
//----------------------------------------------------------------------
// Vector Multiply (Polynomial)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
         pmul v0.8b, v1.8b, v2.16b
         pmul v0.2s, v1.2s, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         pmul v0.8b, v1.8b, v2.16b
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         pmul v0.2s, v1.2s, v2.2s
// CHECK-ERROR:                 ^

//----------------------------------------------------------------------
// Scalar Integer Add and Sub
//----------------------------------------------------------------------

      // Mismatched registers
         add d0, s1, d2
         sub s1, d1, d2

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         add d0, s1, d2
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sub s1, d1, d2
// CHECK-ERROR:             ^

//----------------------------------------------------------------------
// Vector Reciprocal Step (Floating Point)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
         frecps v0.4s, v1.2d, v2.4s
         frecps v0.8h, v1.8h, v2.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frecps v0.4s, v1.2d, v2.4s
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frecps v0.8h, v1.8h, v2.8h
// CHECK-ERROR:                  ^

//----------------------------------------------------------------------
// Vector Reciprocal Square Root Step (Floating Point)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
         frsqrts v0.2d, v1.2d, v2.2s
         frsqrts v0.4h, v1.4h, v2.4h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frsqrts v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        frsqrts v0.4h, v1.4h, v2.4h
// CHECK-ERROR:                   ^


//----------------------------------------------------------------------
// Vector Absolute Compare Mask Less Than Or Equal (Floating Point)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
        facge v0.2d, v1.2s, v2.2d
        facge v0.4h, v1.4h, v2.4h
        facle v0.8h, v1.4h, v2.4h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        facge v0.2d, v1.2s, v2.2d
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        facge v0.4h, v1.4h, v2.4h
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        facle v0.8h, v1.4h, v2.4h
// CHECK-ERROR:                 ^
//----------------------------------------------------------------------
// Vector Absolute Compare Mask Less Than (Floating Point)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
        facgt v0.2d, v1.2d, v2.4s
        facgt v0.8h, v1.8h, v2.8h
        faclt v0.8b, v1.8b, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        facgt v0.2d, v1.2d, v2.4s
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        facgt v0.8h, v1.8h, v2.8h
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        faclt v0.8b, v1.8b, v2.8b
// CHECK-ERROR:                 ^


//----------------------------------------------------------------------
// Vector Compare Mask Equal (Integer)
//----------------------------------------------------------------------

         // Mismatched vector types
         cmeq c0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmeq c0.2d, v1.2d, v2.2s
// CHECK-ERROR:                              ^

//----------------------------------------------------------------------
// Vector Compare Mask Higher or Same (Unsigned Integer)
// Vector Compare Mask Less or Same (Unsigned Integer)
// CMLS is alias for CMHS with operands reversed.
//----------------------------------------------------------------------

         // Mismatched vector types
         cmhs c0.4h, v1.8b, v2.8b
         cmls c0.16b, v1.16b, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmhs c0.4h, v1.8b, v2.8b
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmls c0.16b, v1.16b, v2.2d
// CHECK-ERROR:                                ^

//----------------------------------------------------------------------
// Vector Compare Mask Greater Than or Equal (Integer)
// Vector Compare Mask Less Than or Equal (Integer)
// CMLE is alias for CMGE with operands reversed.
//----------------------------------------------------------------------

         // Mismatched vector types
         cmge c0.8h, v1.8b, v2.8b
         cmle c0.4h, v1.2s, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmge c0.8h, v1.8b, v2.8b
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmle c0.4h, v1.2s, v2.2s
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Vector Compare Mask Higher (Unsigned Integer)
// Vector Compare Mask Lower (Unsigned Integer)
// CMLO is alias for CMHI with operands reversed.
//----------------------------------------------------------------------

         // Mismatched vector types
         cmhi c0.4s, v1.4s, v2.16b
         cmlo c0.8b, v1.8b, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmhi c0.4s, v1.4s, v2.16b
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmlo c0.8b, v1.8b, v2.2s
// CHECK-ERROR:                               ^

//----------------------------------------------------------------------
// Vector Compare Mask Greater Than (Integer)
// Vector Compare Mask Less Than (Integer)
// CMLT is alias for CMGT with operands reversed.
//----------------------------------------------------------------------

         // Mismatched vector types
         cmgt c0.8b, v1.4s, v2.16b
         cmlt c0.8h, v1.16b, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmgt c0.8b, v1.4s, v2.16b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmlt c0.8h, v1.16b, v2.4s
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Vector Compare Mask Bitwise Test (Integer)
//----------------------------------------------------------------------

         // Mismatched vector types
         cmtst c0.16b, v1.16b, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmtst c0.16b, v1.16b, v2.4s
// CHECK-ERROR:                                  ^

//----------------------------------------------------------------------
// Vector Compare Mask Equal (Floating Point)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
        fcmeq v0.2d, v1.2s, v2.2d
        fcmeq v0.16b, v1.16b, v2.16b
        fcmeq v0.8b, v1.4h, v2.4h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmeq v0.2d, v1.2s, v2.2d
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmeq v0.16b, v1.16b, v2.16b
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmeq v0.8b, v1.4h, v2.4h
// CHECK-ERROR:                 ^

//----------------------------------------------------------------------
// Vector Compare Mask Greater Than Or Equal (Floating Point)
// Vector Compare Mask Less Than Or Equal (Floating Point)
// FCMLE is alias for FCMGE with operands reversed.
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
         fcmge v31.4s, v29.2s, v28.4s
         fcmge v3.8b, v8.2s, v12.2s
         fcmle v17.8h, v15.2d, v13.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmge v31.4s, v29.2s, v28.4s
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmge v3.8b, v8.2s, v12.2s
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmle v17.8h, v15.2d, v13.2d
// CHECK-ERROR:                 ^

//----------------------------------------------------------------------
// Vector Compare Mask Greater Than (Floating Point)
// Vector Compare Mask Less Than (Floating Point)
// FCMLT is alias for FCMGT with operands reversed.
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
         fcmgt v0.2d, v31.2s, v16.2s
         fcmgt v4.4s, v7.4s, v15.4h
         fcmlt v29.2d, v5.2d, v2.16b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmgt v0.2d, v31.2s, v16.2s
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected floating-point constant #0.0 or invalid register type
// CHECK-ERROR:        fcmgt v4.4s, v7.4s, v15.4h
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: expected floating-point constant #0.0 or invalid register type
// CHECK-ERROR:        fcmlt v29.2d, v5.2d, v2.16b
// CHECK-ERROR:                                ^

//----------------------------------------------------------------------
// Vector Compare Mask Equal to Zero (Integer)
//----------------------------------------------------------------------
        // Mismatched vector types and invalid imm
         // Mismatched vector types
         cmeq c0.2d, v1.2s, #0
         cmeq c0.2d, v1.2d, #1

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmeq c0.2d, v1.2s, #0
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmeq c0.2d, v1.2d, #1
// CHECK-ERROR:                            ^

//----------------------------------------------------------------------
// Vector Compare Mask Greater Than or Equal to Zero (Signed Integer)
//----------------------------------------------------------------------
        // Mismatched vector types and invalid imm
         cmge c0.8h, v1.8b, #0
         cmge c0.4s, v1.4s, #-1

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmge c0.8h, v1.8b, #0
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmge c0.4s, v1.4s, #-1
// CHECK-ERROR:                             ^

//----------------------------------------------------------------------
// Vector Compare Mask Greater Than Zero (Signed Integer)
//----------------------------------------------------------------------
        // Mismatched vector types and invalid imm
         cmgt c0.8b, v1.4s, #0
         cmgt c0.8b, v1.8b, #-255

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmgt c0.8b, v1.4s, #0
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmgt c0.8b, v1.8b, #-255
// CHECK-ERROR:                             ^

//----------------------------------------------------------------------
// Vector Compare Mask Less Than or Equal To Zero (Signed Integer)
//----------------------------------------------------------------------
        // Mismatched vector types and invalid imm
         cmle c0.4h, v1.2s, #0
         cmle c0.16b, v1.16b, #16

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        cmle c0.4h, v1.2s, #0
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmle c0.16b, v1.16b, #16
// CHECK-ERROR:                               ^
//----------------------------------------------------------------------
// Vector Compare Mask Less Than Zero (Signed Integer)
//----------------------------------------------------------------------
        // Mismatched vector types and invalid imm
         cmlt c0.8h, v1.16b, #0
         cmlt c0.8h, v1.8h, #-15

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmlt c0.8h, v1.16b, #0
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         cmlt c0.8h, v1.8h, #-15
// CHECK-ERROR:                             ^

//----------------------------------------------------------------------
// Vector Compare Mask Equal to Zero (Floating Point)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types, invalid imm
        fcmeq v0.2d, v1.2s, #0.0
        fcmeq v0.16b, v1.16b, #0.0
        fcmeq v0.8b, v1.4h, #1.0
        fcmeq v0.8b, v1.4h, #1

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmeq v0.2d, v1.2s, #0.0
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmeq v0.16b, v1.16b, #0.0
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmeq v0.8b, v1.4h, #1.0
// CHECK-ERROR:                             ^
// CHECK-ERROR: error:  Expected floating-point immediate
// CHECK-ERROR:        fcmeq v0.8b, v1.4h, #1
// CHECK-ERROR:                             ^
//----------------------------------------------------------------------
// Vector Compare Mask Greater Than or Equal to Zero (Floating Point)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types, invalid imm
         fcmge v31.4s, v29.2s, #0.0
         fcmge v3.8b, v8.2s, #0.0
         fcmle v17.8h, v15.2d, #-1.0
         fcmle v17.8h, v15.2d, #0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmge v31.4s, v29.2s, #0.0
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmge v3.8b, v8.2s, #0.0
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmle v17.8h, v15.2d, #-1.0
// CHECK-ERROR:                               ^
// CHECK-ERROR: error:  Expected floating-point immediate
// CHECK-ERROR:        fcmle v17.8h, v15.2d, #0
// CHECK-ERROR:                               ^
//----------------------------------------------------------------------
// Vector Compare Mask Greater Than Zero (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types, invalid imm
         fcmgt v0.2d, v31.2s, #0.0
         fcmgt v4.4s, v7.4h, #0.0
         fcmlt v29.2d, v5.2d, #255.0
         fcmlt v29.2d, v5.2d, #255

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmgt v0.2d, v31.2s, #0.0
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmgt v4.4s, v7.4h, #0.0
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected floating-point constant #0.0 or invalid register type
// CHECK-ERROR:        fcmlt v29.2d, v5.2d, #255.0
// CHECK-ERROR:                              ^
// CHECK-ERROR: error:  Expected floating-point immediate
// CHECK-ERROR:        fcmlt v29.2d, v5.2d, #255
// CHECK-ERROR:                              ^

//----------------------------------------------------------------------
// Vector Compare Mask Less Than or Equal To Zero (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types, invalid imm
         fcmge v31.4s, v29.2s, #0.0
         fcmge v3.8b, v8.2s, #0.0
         fcmle v17.2d, v15.2d, #15.0
         fcmle v17.2d, v15.2d, #15

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmge v31.4s, v29.2s, #0.0
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmge v3.8b, v8.2s, #0.0
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: expected floating-point constant #0.0 or invalid register type
// CHECK-ERROR:        fcmle v17.2d, v15.2d, #15.0
// CHECK-ERROR:                               ^
// CHECK-ERROR: error:  Expected floating-point immediate
// CHECK-ERROR:        fcmle v17.2d, v15.2d, #15
// CHECK-ERROR:                              ^

//----------------------------------------------------------------------
// Vector Compare Mask Less Than Zero (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types, invalid imm
         fcmgt v0.2d, v31.2s, #0.0
         fcmgt v4.4s, v7.4h, #0.0
         fcmlt v29.2d, v5.2d, #16.0
         fcmlt v29.2d, v5.2d, #2

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmgt v0.2d, v31.2s, #0.0
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fcmgt v4.4s, v7.4h, #0.0
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected floating-point constant #0.0 or invalid register type
// CHECK-ERROR:        fcmlt v29.2d, v5.2d, #16.0
// CHECK-ERROR:                              ^
// CHECK-ERROR: error:  Expected floating-point immediate
// CHECK-ERROR:        fcmlt v29.2d, v5.2d, #2
// CHECK-ERROR:                              ^

/-----------------------------------------------------------------------
// Vector Integer Halving Add (Signed)
// Vector Integer Halving Add (Unsigned)
// Vector Integer Halving Sub (Signed)
// Vector Integer Halving Sub (Unsigned)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types (2d)
        shadd v0.2d, v1.2d, v2.2d
        uhadd v4.2s, v5.2s, v5.4h
        shsub v11.4h, v12.8h, v13.4h
        uhsub v31.16b, v29.8b, v28.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        shadd v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uhadd v4.2s, v5.2s, v5.4h
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        shsub v11.4h, v12.8h, v13.4h
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uhsub v31.16b, v29.8b, v28.8b
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Vector Integer Rouding Halving Add (Signed)
// Vector Integer Rouding Halving Add (Unsigned)
//----------------------------------------------------------------------

        // Mismatched and invalid vector types (2d)
        srhadd v0.2s, v1.2s, v2.2d
        urhadd v0.16b, v1.16b, v2.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        srhadd v0.2s, v1.2s, v2.2d
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        urhadd v0.16b, v1.16b, v2.8h
// CHECK-ERROR:                                  ^

//----------------------------------------------------------------------
// Vector Integer Saturating Add (Signed)
// Vector Integer Saturating Add (Unsigned)
// Vector Integer Saturating Sub (Signed)
// Vector Integer Saturating Sub (Unsigned)
//----------------------------------------------------------------------

        // Mismatched vector types
        sqadd v0.2s, v1.2s, v2.2d
        uqadd v31.8h, v1.4h, v2.4h
        sqsub v10.8h, v1.16b, v2.16b
        uqsub v31.8b, v1.8b, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqadd v0.2s, v1.2s, v2.2d
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqadd v31.8h, v1.4h, v2.4h
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqsub v10.8h, v1.16b, v2.16b
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqsub v31.8b, v1.8b, v2.4s
// CHECK-ERROR:                                ^

//----------------------------------------------------------------------
// Scalar Integer Saturating Add (Signed)
// Scalar Integer Saturating Add (Unsigned)
// Scalar Integer Saturating Sub (Signed)
// Scalar Integer Saturating Sub (Unsigned)
//----------------------------------------------------------------------

      // Mismatched registers
         sqadd d0, s31, d2
         uqadd s0, s1, d2
         sqsub b0, b2, s18
         uqsub h1, h2, d2

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqadd d0, s31, d2
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqadd s0, s1, d2
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqsub b0, b2, s18
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqsub h1, h2, d2
// CHECK-ERROR:                      ^

//----------------------------------------------------------------------
// Scalar Integer Saturating Doubling Multiply Half High (Signed)
//----------------------------------------------------------------------

    sqdmulh h10, s11, h12
    sqdmulh s20, h21, s2

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmulh h10, s11, h12
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmulh s20, h21, s2
// CHECK-ERROR:                     ^

//------------------------------------------------------------------------
// Scalar Integer Saturating Rounding Doubling Multiply Half High (Signed)
//------------------------------------------------------------------------

    sqrdmulh h10, s11, h12
    sqrdmulh s20, h21, s2

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqrdmulh h10, s11, h12
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqrdmulh s20, h21, s2
// CHECK-ERROR:                      ^

//----------------------------------------------------------------------
// Vector Shift Left (Signed and Unsigned Integer)
//----------------------------------------------------------------------
        // Mismatched vector types
        sshl v0.4s, v15.2s, v16.2s
        ushl v1.16b, v25.16b, v6.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sshl v0.4s, v15.2s, v16.2s
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ushl v1.16b, v25.16b, v6.8h
// CHECK-ERROR:                                 ^

//----------------------------------------------------------------------
// Vector Saturating Shift Left (Signed and Unsigned Integer)
//----------------------------------------------------------------------
        // Mismatched vector types
        sqshl v0.2s, v15.4s, v16.2d
        uqshl v1.8b, v25.4h, v6.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqshl v0.2s, v15.4s, v16.2d 
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqshl v1.8b, v25.4h, v6.8h
// CHECK-ERROR:                         ^

//----------------------------------------------------------------------
// Vector Rouding Shift Left (Signed and Unsigned Integer)
//----------------------------------------------------------------------
        // Mismatched vector types
        srshl v0.8h, v15.8h, v16.16b
        urshl v1.2d, v25.2d, v6.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        srshl v0.8h, v15.8h, v16.16b
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        urshl v1.2d, v25.2d, v6.4s
// CHECK-ERROR:                                ^

//----------------------------------------------------------------------
// Vector Saturating Rouding Shift Left (Signed and Unsigned Integer)
//----------------------------------------------------------------------
        // Mismatched vector types
        sqrshl v0.2s, v15.8h, v16.16b
        uqrshl v1.4h, v25.4h,  v6.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqrshl v0.2s, v15.8h, v16.16b
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqrshl v1.4h, v25.4h,  v6.2d
// CHECK-ERROR:                                  ^

//----------------------------------------------------------------------
// Scalar Integer Shift Left (Signed, Unsigned)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        sshl d0, d1, s2
        ushl b2, b0, b1

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sshl d0, d1, s2
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ushl b2, b0, b1
// CHECK-ERROR:             ^

//----------------------------------------------------------------------
// Scalar Integer Saturating Shift Left (Signed, Unsigned)
//----------------------------------------------------------------------

        // Mismatched vector types
        sqshl b0, s1, b0
        uqshl h0, b1, h0
        sqshl s0, h1, s0
        uqshl d0, b1, d0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqshl b0, s1, b0
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqshl h0, b1, h0
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqshl s0, h1, s0
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqshl d0, b1, d0
// CHECK-ERROR:                  ^

//----------------------------------------------------------------------
// Scalar Integer Rouding Shift Left (Signed, Unsigned)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        srshl h0, h1, h2
        urshl s0, s1, s2

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        srshl h0, h1, h2
// CHECK-ERROR:              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        urshl s0, s1, s2
// CHECK-ERROR:              ^


//----------------------------------------------------------------------
// Scalar Integer Saturating Rounding Shift Left (Signed, Unsigned)
//----------------------------------------------------------------------

        // Mismatched vector types
        sqrshl b0, b1, s0
        uqrshl h0, h1, b0
        sqrshl s0, s1, h0
        uqrshl d0, d1, b0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqrshl b0, b1, s0
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqrshl h0, h1, b0
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqrshl s0, s1, h0
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqrshl d0, d1, b0
// CHECK-ERROR:                       ^


//----------------------------------------------------------------------
// Vector Maximum (Signed, Unsigned)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        smax v0.2d, v1.2d, v2.2d
        umax v0.4h, v1.4h, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smax v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umax v0.4h, v1.4h, v2.2s
// CHECK-ERROR:                              ^

//----------------------------------------------------------------------
// Vector Minimum (Signed, Unsigned)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        smin v0.2d, v1.2d, v2.2d
        umin v0.2s, v1.2s, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smin v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umin v0.2s, v1.2s, v2.8b
// CHECK-ERROR:                             ^


//----------------------------------------------------------------------
// Vector Maximum (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fmax v0.2s, v1.2s, v2.4s
        fmax v0.8b, v1.8b, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmax v0.2s, v1.2s, v2.4s
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmax v0.8b, v1.8b, v2.8b
// CHECK-ERROR:                ^
//----------------------------------------------------------------------
// Vector Minimum (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fmin v0.4s, v1.4s, v2.2d
        fmin v0.8h, v1.8h, v2.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmin v0.4s, v1.4s, v2.2d
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmin v0.8h, v1.8h, v2.8h
// CHECK-ERROR:                ^

//----------------------------------------------------------------------
// Vector maxNum (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fmaxnm v0.2s, v1.2s, v2.2d
        fmaxnm v0.4h, v1.8h, v2.4h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxnm v0.2s, v1.2s, v2.2d
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxnm v0.4h, v1.8h, v2.4h
// CHECK-ERROR:                  ^

//----------------------------------------------------------------------
// Vector minNum (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fminnm v0.4s, v1.2s, v2.4s
        fminnm v0.16b, v0.16b, v0.16b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminnm v0.4s, v1.2s, v2.4s
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminnm v0.16b, v0.16b, v0.16b
// CHECK-ERROR:                  ^


//----------------------------------------------------------------------
// Vector Maximum Pairwise (Signed, Unsigned)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        smaxp v0.2d, v1.2d, v2.2d
        umaxp v0.4h, v1.4h, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smaxp v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umaxp v0.4h, v1.4h, v2.2s
// CHECK-ERROR:                               ^

//----------------------------------------------------------------------
// Vector Minimum Pairwise (Signed, Unsigned)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        sminp v0.2d, v1.2d, v2.2d
        uminp v0.2s, v1.2s, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sminp v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uminp v0.2s, v1.2s, v2.8b
// CHECK-ERROR:                               ^


//----------------------------------------------------------------------
// Vector Maximum Pairwise (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fmaxp v0.2s, v1.2s, v2.4s
        fmaxp v0.8b, v1.8b, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxp v0.2s, v1.2s, v2.4s
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxp v0.8b, v1.8b, v2.8b
// CHECK-ERROR:                 ^
//----------------------------------------------------------------------
// Vector Minimum Pairwise (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fminp v0.4s, v1.4s, v2.2d
        fminp v0.8h, v1.8h, v2.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminp v0.4s, v1.4s, v2.2d
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminp v0.8h, v1.8h, v2.8h
// CHECK-ERROR:                 ^

//----------------------------------------------------------------------
// Vector maxNum Pairwise (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fmaxnmp v0.2s, v1.2s, v2.2d
        fmaxnmp v0.4h, v1.8h, v2.4h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxnmp v0.2s, v1.2s, v2.2d
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxnmp v0.4h, v1.8h, v2.4h
// CHECK-ERROR:                   ^

//----------------------------------------------------------------------
// Vector minNum Pairwise (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        fminnmp v0.4s, v1.2s, v2.4s
        fminnmp v0.16b, v0.16b, v0.16b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminnmp v0.4s, v1.2s, v2.4s
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminnmp v0.16b, v0.16b, v0.16b
// CHECK-ERROR:                   ^


//----------------------------------------------------------------------
// Vector Add Pairwise (Integer)
//----------------------------------------------------------------------

        // Mismatched vector types
        addp v0.16b, v1.8b, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         addp v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                         ^

//----------------------------------------------------------------------
// Vector Add Pairwise (Floating Point)
//----------------------------------------------------------------------
        // Mismatched and invalid vector types
        faddp v0.16b, v1.8b, v2.8b
        faddp v0.2d, v1.2d, v2.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         faddp v0.16b, v1.8b, v2.8b
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         faddp v0.2d, v1.2d, v2.8h
// CHECK-ERROR:                                ^


//----------------------------------------------------------------------
// Vector Saturating Doubling Multiply High
//----------------------------------------------------------------------
         // Mismatched and invalid vector types
         sqdmulh v2.4h, v25.8h, v3.4h
         sqdmulh v12.2d, v5.2d, v13.2d
         sqdmulh v3.8b, v1.8b, v30.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqdmulh v2.4h, v25.8h, v3.4h
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqdmulh v12.2d, v5.2d, v13.2d
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqdmulh v3.8b, v1.8b, v30.8b
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Vector Saturating Rouding Doubling Multiply High
//----------------------------------------------------------------------
         // Mismatched and invalid vector types
         sqrdmulh v2.2s, v25.4s, v3.4s
         sqrdmulh v12.16b, v5.16b, v13.16b
         sqrdmulh v3.4h, v1.4h, v30.2d


// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrdmulh v2.2s, v25.4s, v3.4s
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrdmulh v12.16b, v5.16b, v13.16b
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrdmulh v3.4h, v1.4h, v30.2d
// CHECK-ERROR:                                    ^

//----------------------------------------------------------------------
// Vector Multiply Extended
//----------------------------------------------------------------------
         // Mismatched and invalid vector types
      fmulx v21.2s, v5.2s, v13.2d
      fmulx v1.4h, v25.4h, v3.4h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fmulx v21.2s, v5.2s, v13.2d
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fmulx v1.4h, v25.4h, v3.4h
// CHECK-ERROR:                  ^

//------------------------------------------------------------------------------
// Vector Shift Left by Immediate
//------------------------------------------------------------------------------
         // Mismatched vector types and out of range
         shl v0.4s, v15,2s, #3
         shl v0.2d, v17.4s, #3
         shl v0.8b, v31.8b, #-1
         shl v0.8b, v31.8b, #8
         shl v0.4s, v21.4s, #32
         shl v0.2d, v1.2d, #64

// CHECK-ERROR: error: expected comma before next operand
// CHECK-ERROR:         shl v0.4s, v15,2s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         shl v0.2d, v17.4s, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:         shl v0.8b, v31.8b, #-1
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:         shl v0.8b, v31.8b, #8
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:         shl v0.4s, v21.4s, #32
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:         shl v0.2d, v1.2d, #64
// CHECK-ERROR:                           ^

//----------------------------------------------------------------------
// Vector Shift Left Long by Immediate
//----------------------------------------------------------------------
        // Mismatched vector types
        sshll v0.4s, v15.2s, #3
        ushll v1.16b, v25.16b, #6
        sshll2 v0.2d, v3.8s, #15
        ushll2 v1.4s, v25.4s, #7

        // Out of range 
        sshll v0.8h, v1.8b, #-1
        sshll v0.8h, v1.8b, #9
        ushll v0.4s, v1.4h, #17
        ushll v0.2d, v1.2s, #33
        sshll2 v0.8h, v1.16b, #9
        sshll2 v0.4s, v1.8h, #17
        ushll2 v0.2d, v1.4s, #33

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sshll v0.4s, v15.2s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ushll v1.16b, v25.16b, #6
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sshll2 v0.2d, v3.8s, #15
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ushll2 v1.4s, v25.4s, #7
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:        sshll v0.8h, v1.8b, #-1
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:        sshll v0.8h, v1.8b, #9
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:        ushll v0.4s, v1.4h, #17
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:        ushll v0.2d, v1.2s, #33
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:        sshll2 v0.8h, v1.16b, #9
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:        sshll2 v0.4s, v1.8h, #17
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:        ushll2 v0.2d, v1.4s, #33
// CHECK-ERROR:                             ^


//------------------------------------------------------------------------------
// Vector shift right by immediate
//------------------------------------------------------------------------------
         sshr v0.8b, v1.8h, #3
         sshr v0.4h, v1.4s, #3
         sshr v0.2s, v1.2d, #3
         sshr v0.16b, v1.16b, #9
         sshr v0.8h, v1.8h, #17
         sshr v0.4s, v1.4s, #33
         sshr v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sshr v0.8b, v1.8h, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sshr v0.4h, v1.4s, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sshr v0.2s, v1.2d, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         sshr v0.16b, v1.16b, #9
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         sshr v0.8h, v1.8h, #17
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         sshr v0.4s, v1.4s, #33
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         sshr v0.2d, v1.2d, #65
// CHECK-ERROR:                            ^

//------------------------------------------------------------------------------
// Vector  shift right by immediate
//------------------------------------------------------------------------------
         ushr v0.8b, v1.8h, #3
         ushr v0.4h, v1.4s, #3
         ushr v0.2s, v1.2d, #3
         ushr v0.16b, v1.16b, #9
         ushr v0.8h, v1.8h, #17
         ushr v0.4s, v1.4s, #33
         ushr v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ushr v0.8b, v1.8h, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ushr v0.4h, v1.4s, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ushr v0.2s, v1.2d, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         ushr v0.16b, v1.16b, #9
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         ushr v0.8h, v1.8h, #17
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         ushr v0.4s, v1.4s, #33
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         ushr v0.2d, v1.2d, #65
// CHECK-ERROR:                            ^

//------------------------------------------------------------------------------
// Vector shift right and accumulate by immediate
//------------------------------------------------------------------------------
         ssra v0.8b, v1.8h, #3
         ssra v0.4h, v1.4s, #3
         ssra v0.2s, v1.2d, #3
         ssra v0.16b, v1.16b, #9
         ssra v0.8h, v1.8h, #17
         ssra v0.4s, v1.4s, #33
         ssra v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ssra v0.8b, v1.8h, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ssra v0.4h, v1.4s, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ssra v0.2s, v1.2d, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         ssra v0.16b, v1.16b, #9
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         ssra v0.8h, v1.8h, #17
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         ssra v0.4s, v1.4s, #33
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         ssra v0.2d, v1.2d, #65
// CHECK-ERROR:                            ^

//------------------------------------------------------------------------------
// Vector  shift right and accumulate by immediate
//------------------------------------------------------------------------------
         usra v0.8b, v1.8h, #3
         usra v0.4h, v1.4s, #3
         usra v0.2s, v1.2d, #3
         usra v0.16b, v1.16b, #9
         usra v0.8h, v1.8h, #17
         usra v0.4s, v1.4s, #33
         usra v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         usra v0.8b, v1.8h, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         usra v0.4h, v1.4s, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         usra v0.2s, v1.2d, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         usra v0.16b, v1.16b, #9
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         usra v0.8h, v1.8h, #17
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         usra v0.4s, v1.4s, #33
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         usra v0.2d, v1.2d, #65
// CHECK-ERROR:                            ^

//------------------------------------------------------------------------------
// Vector rounding shift right by immediate
//------------------------------------------------------------------------------
         srshr v0.8b, v1.8h, #3
         srshr v0.4h, v1.4s, #3
         srshr v0.2s, v1.2d, #3
         srshr v0.16b, v1.16b, #9
         srshr v0.8h, v1.8h, #17
         srshr v0.4s, v1.4s, #33
         srshr v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         srshr v0.8b, v1.8h, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         srshr v0.4h, v1.4s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         srshr v0.2s, v1.2d, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         srshr v0.16b, v1.16b, #9
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         srshr v0.8h, v1.8h, #17
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         srshr v0.4s, v1.4s, #33
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         srshr v0.2d, v1.2d, #65
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Vecotr rounding shift right by immediate
//------------------------------------------------------------------------------
         urshr v0.8b, v1.8h, #3
         urshr v0.4h, v1.4s, #3
         urshr v0.2s, v1.2d, #3
         urshr v0.16b, v1.16b, #9
         urshr v0.8h, v1.8h, #17
         urshr v0.4s, v1.4s, #33
         urshr v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         urshr v0.8b, v1.8h, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         urshr v0.4h, v1.4s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         urshr v0.2s, v1.2d, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         urshr v0.16b, v1.16b, #9
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         urshr v0.8h, v1.8h, #17
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         urshr v0.4s, v1.4s, #33
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         urshr v0.2d, v1.2d, #65
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Vector rounding shift right and accumulate by immediate
//------------------------------------------------------------------------------
         srsra v0.8b, v1.8h, #3
         srsra v0.4h, v1.4s, #3
         srsra v0.2s, v1.2d, #3
         srsra v0.16b, v1.16b, #9
         srsra v0.8h, v1.8h, #17
         srsra v0.4s, v1.4s, #33
         srsra v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         srsra v0.8b, v1.8h, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         srsra v0.4h, v1.4s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         srsra v0.2s, v1.2d, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         srsra v0.16b, v1.16b, #9
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         srsra v0.8h, v1.8h, #17
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         srsra v0.4s, v1.4s, #33
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         srsra v0.2d, v1.2d, #65
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Vector rounding shift right and accumulate by immediate
//------------------------------------------------------------------------------
         ursra v0.8b, v1.8h, #3
         ursra v0.4h, v1.4s, #3
         ursra v0.2s, v1.2d, #3
         ursra v0.16b, v1.16b, #9
         ursra v0.8h, v1.8h, #17
         ursra v0.4s, v1.4s, #33
         ursra v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ursra v0.8b, v1.8h, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ursra v0.4h, v1.4s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ursra v0.2s, v1.2d, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         ursra v0.16b, v1.16b, #9
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         ursra v0.8h, v1.8h, #17
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         ursra v0.4s, v1.4s, #33
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         ursra v0.2d, v1.2d, #65
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Vector shift right and insert by immediate
//------------------------------------------------------------------------------
         sri v0.8b, v1.8h, #3
         sri v0.4h, v1.4s, #3
         sri v0.2s, v1.2d, #3
         sri v0.16b, v1.16b, #9
         sri v0.8h, v1.8h, #17
         sri v0.4s, v1.4s, #33
         sri v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sri v0.8b, v1.8h, #3
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sri v0.4h, v1.4s, #3
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sri v0.2s, v1.2d, #3
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         sri v0.16b, v1.16b, #9
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         sri v0.8h, v1.8h, #17
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         sri v0.4s, v1.4s, #33
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         sri v0.2d, v1.2d, #65
// CHECK-ERROR:                           ^

//------------------------------------------------------------------------------
// Vector shift left and insert by immediate
//------------------------------------------------------------------------------
         sli v0.8b, v1.8h, #3
         sli v0.4h, v1.4s, #3
         sli v0.2s, v1.2d, #3
         sli v0.16b, v1.16b, #8
         sli v0.8h, v1.8h, #16
         sli v0.4s, v1.4s, #32
         sli v0.2d, v1.2d, #64

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sli v0.8b, v1.8h, #3
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sli v0.4h, v1.4s, #3
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sli v0.2s, v1.2d, #3
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:         sli v0.16b, v1.16b, #8
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:         sli v0.8h, v1.8h, #16
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:         sli v0.4s, v1.4s, #32
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:         sli v0.2d, v1.2d, #64
// CHECK-ERROR:                           ^

//------------------------------------------------------------------------------
// Vector saturating shift left unsigned by immediate
//------------------------------------------------------------------------------
         sqshlu v0.8b, v1.8h, #3
         sqshlu v0.4h, v1.4s, #3
         sqshlu v0.2s, v1.2d, #3
         sqshlu v0.16b, v1.16b, #8
         sqshlu v0.8h, v1.8h, #16
         sqshlu v0.4s, v1.4s, #32
         sqshlu v0.2d, v1.2d, #64

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshlu v0.8b, v1.8h, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshlu v0.4h, v1.4s, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshlu v0.2s, v1.2d, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:         sqshlu v0.16b, v1.16b, #8
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:         sqshlu v0.8h, v1.8h, #16
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:         sqshlu v0.4s, v1.4s, #32
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:         sqshlu v0.2d, v1.2d, #64
// CHECK-ERROR:                              ^

//------------------------------------------------------------------------------
// Vector saturating shift left by immediate
//------------------------------------------------------------------------------
         sqshl v0.8b, v1.8h, #3
         sqshl v0.4h, v1.4s, #3
         sqshl v0.2s, v1.2d, #3
         sqshl v0.16b, v1.16b, #8
         sqshl v0.8h, v1.8h, #16
         sqshl v0.4s, v1.4s, #32
         sqshl v0.2d, v1.2d, #64

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshl v0.8b, v1.8h, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshl v0.4h, v1.4s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshl v0.2s, v1.2d, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:         sqshl v0.16b, v1.16b, #8
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:         sqshl v0.8h, v1.8h, #16
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:         sqshl v0.4s, v1.4s, #32
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:         sqshl v0.2d, v1.2d, #64
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Vector saturating shift left by immediate
//------------------------------------------------------------------------------
         uqshl v0.8b, v1.8h, #3
         uqshl v0.4h, v1.4s, #3
         uqshl v0.2s, v1.2d, #3
         uqshl v0.16b, v1.16b, #8
         uqshl v0.8h, v1.8h, #16
         uqshl v0.4s, v1.4s, #32
         uqshl v0.2d, v1.2d, #64

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqshl v0.8b, v1.8h, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqshl v0.4h, v1.4s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqshl v0.2s, v1.2d, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:         uqshl v0.16b, v1.16b, #8
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:         uqshl v0.8h, v1.8h, #16
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:         uqshl v0.4s, v1.4s, #32
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:         uqshl v0.2d, v1.2d, #64
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Vector shift right narrow by immediate
//------------------------------------------------------------------------------
         shrn v0.8b, v1.8b, #3
         shrn v0.4h, v1.4h, #3
         shrn v0.2s, v1.2s, #3
         shrn2 v0.16b, v1.8h, #17
         shrn2 v0.8h, v1.4s, #33
         shrn2 v0.4s, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         shrn v0.8b, v1.8b, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         shrn v0.4h, v1.4h, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         shrn v0.2s, v1.2s, #3
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         shrn2 v0.16b, v1.8h, #17
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         shrn2 v0.8h, v1.4s, #33
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         shrn2 v0.4s, v1.2d, #65
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Vector saturating shift right unsigned narrow by immediate
//------------------------------------------------------------------------------
         sqshrun v0.8b, v1.8b, #3
         sqshrun v0.4h, v1.4h, #3
         sqshrun v0.2s, v1.2s, #3
         sqshrun2 v0.16b, v1.8h, #17
         sqshrun2 v0.8h, v1.4s, #33
         sqshrun2 v0.4s, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshrun v0.8b, v1.8b, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshrun v0.4h, v1.4h, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshrun v0.2s, v1.2s, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         sqshrun2 v0.16b, v1.8h, #17
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         sqshrun2 v0.8h, v1.4s, #33
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         sqshrun2 v0.4s, v1.2d, #65
// CHECK-ERROR:                                ^

//------------------------------------------------------------------------------
// Vector rounding shift right narrow by immediate
//------------------------------------------------------------------------------
         rshrn v0.8b, v1.8b, #3
         rshrn v0.4h, v1.4h, #3
         rshrn v0.2s, v1.2s, #3
         rshrn2 v0.16b, v1.8h, #17
         rshrn2 v0.8h, v1.4s, #33
         rshrn2 v0.4s, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         rshrn v0.8b, v1.8b, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         rshrn v0.4h, v1.4h, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         rshrn v0.2s, v1.2s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         rshrn2 v0.16b, v1.8h, #17
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         rshrn2 v0.8h, v1.4s, #33
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         rshrn2 v0.4s, v1.2d, #65
// CHECK-ERROR:                              ^

//------------------------------------------------------------------------------
// Vector saturating shift right rounded unsigned narrow by immediate
//------------------------------------------------------------------------------
         sqrshrun v0.8b, v1.8b, #3
         sqrshrun v0.4h, v1.4h, #3
         sqrshrun v0.2s, v1.2s, #3
         sqrshrun2 v0.16b, v1.8h, #17
         sqrshrun2 v0.8h, v1.4s, #33
         sqrshrun2 v0.4s, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrshrun v0.8b, v1.8b, #3
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrshrun v0.4h, v1.4h, #3
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrshrun v0.2s, v1.2s, #3
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         sqrshrun2 v0.16b, v1.8h, #17
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         sqrshrun2 v0.8h, v1.4s, #33
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         sqrshrun2 v0.4s, v1.2d, #65
// CHECK-ERROR:                                 ^

//------------------------------------------------------------------------------
// Vector saturating shift right narrow by immediate
//------------------------------------------------------------------------------
         sqshrn v0.8b, v1.8b, #3
         sqshrn v0.4h, v1.4h, #3
         sqshrn v0.2s, v1.2s, #3
         sqshrn2 v0.16b, v1.8h, #17
         sqshrn2 v0.8h, v1.4s, #33
         sqshrn2 v0.4s, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshrn v0.8b, v1.8b, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshrn v0.4h, v1.4h, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqshrn v0.2s, v1.2s, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         sqshrn2 v0.16b, v1.8h, #17
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         sqshrn2 v0.8h, v1.4s, #33
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         sqshrn2 v0.4s, v1.2d, #65
// CHECK-ERROR:                               ^

//------------------------------------------------------------------------------
// Vector saturating shift right narrow by immediate
//------------------------------------------------------------------------------
         uqshrn v0.8b, v1.8b, #3
         uqshrn v0.4h, v1.4h, #3
         uqshrn v0.2s, v1.2s, #3
         uqshrn2 v0.16b, v1.8h, #17
         uqshrn2 v0.8h, v1.4s, #33
         uqshrn2 v0.4s, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqshrn v0.8b, v1.8b, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqshrn v0.4h, v1.4h, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqshrn v0.2s, v1.2s, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         uqshrn2 v0.16b, v1.8h, #17
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         uqshrn2 v0.8h, v1.4s, #33
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         uqshrn2 v0.4s, v1.2d, #65
// CHECK-ERROR:                               ^

//------------------------------------------------------------------------------
// Vector saturating shift right rounded narrow by immediate
//------------------------------------------------------------------------------
         sqrshrn v0.8b, v1.8b, #3
         sqrshrn v0.4h, v1.4h, #3
         sqrshrn v0.2s, v1.2s, #3
         sqrshrn2 v0.16b, v1.8h, #17
         sqrshrn2 v0.8h, v1.4s, #33
         sqrshrn2 v0.4s, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrshrn v0.8b, v1.8b, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrshrn v0.4h, v1.4h, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         sqrshrn v0.2s, v1.2s, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         sqrshrn2 v0.16b, v1.8h, #17
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         sqrshrn2 v0.8h, v1.4s, #33
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         sqrshrn2 v0.4s, v1.2d, #65
// CHECK-ERROR:                                ^

//------------------------------------------------------------------------------
// Vector saturating shift right rounded narrow by immediate
//------------------------------------------------------------------------------
         uqrshrn v0.8b, v1.8b, #3
         uqrshrn v0.4h, v1.4h, #3
         uqrshrn v0.2s, v1.2s, #3
         uqrshrn2 v0.16b, v1.8h, #17
         uqrshrn2 v0.8h, v1.4s, #33
         uqrshrn2 v0.4s, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqrshrn v0.8b, v1.8b, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqrshrn v0.4h, v1.4h, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         uqrshrn v0.2s, v1.2s, #3
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:         uqrshrn2 v0.16b, v1.8h, #17
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:         uqrshrn2 v0.8h, v1.4s, #33
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         uqrshrn2 v0.4s, v1.2d, #65
// CHECK-ERROR:                                ^

//------------------------------------------------------------------------------
// Fixed-point convert to floating-point
//------------------------------------------------------------------------------
         scvtf v0.2s, v1.2d, #3
         scvtf v0.4s, v1.4h, #3
         scvtf v0.2d, v1.2s, #3
         ucvtf v0.2s, v1.2s, #33
         ucvtf v0.4s, v1.4s, #33
         ucvtf v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         scvtf v0.2s, v1.2d, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         scvtf v0.4s, v1.4h, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         scvtf v0.2d, v1.2s, #3
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         ucvtf v0.2s, v1.2s, #33
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         ucvtf v0.4s, v1.4s, #33
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         ucvtf v0.2d, v1.2d, #65
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Floating-point convert to fixed-point
//------------------------------------------------------------------------------
         fcvtzs v0.2s, v1.2d, #3
         fcvtzs v0.4s, v1.4h, #3
         fcvtzs v0.2d, v1.2s, #3
         fcvtzu v0.2s, v1.2s, #33
         fcvtzu v0.4s, v1.4s, #33
         fcvtzu v0.2d, v1.2d, #65

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fcvtzs v0.2s, v1.2d, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fcvtzs v0.4s, v1.4h, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         fcvtzs v0.2d, v1.2s, #3
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         fcvtzu v0.2s, v1.2s, #33
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:         fcvtzu v0.4s, v1.4s, #33
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:         fcvtzu v0.2d, v1.2d, #65
// CHECK-ERROR:                              ^

//----------------------------------------------------------------------
// Vector operation on 3 operands with different types
//----------------------------------------------------------------------

        // Mismatched and invalid vector types
        saddl v0.8h, v1.8h, v2.8b
        saddl v0.4s, v1.4s, v2.4h
        saddl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddl v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        saddl2 v0.4s, v1.8s, v2.8h
        saddl2 v0.8h, v1.16h, v2.16b
        saddl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddl2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        uaddl v0.8h, v1.8h, v2.8b
        uaddl v0.4s, v1.4s, v2.4h
        uaddl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddl v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        uaddl2 v0.8h, v1.16h, v2.16b
        uaddl2 v0.4s, v1.8s, v2.8h
        uaddl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddl2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        ssubl v0.8h, v1.8h, v2.8b
        ssubl v0.4s, v1.4s, v2.4h
        ssubl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubl v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        ssubl2 v0.8h, v1.16h, v2.16b
        ssubl2 v0.4s, v1.8s, v2.8h
        ssubl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubl2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        usubl v0.8h, v1.8h, v2.8b
        usubl v0.4s, v1.4s, v2.4h
        usubl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubl v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        usubl2 v0.8h, v1.16h, v2.16b
        usubl2 v0.4s, v1.8s, v2.8h
        usubl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubl2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        sabal v0.8h, v1.8h, v2.8b
        sabal v0.4s, v1.4s, v2.4h
        sabal v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabal v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabal v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabal v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        sabal2 v0.8h, v1.16h, v2.16b
        sabal2 v0.4s, v1.8s, v2.8h
        sabal2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabal2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabal2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabal2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        uabal v0.8h, v1.8h, v2.8b
        uabal v0.4s, v1.4s, v2.4h
        uabal v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabal v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabal v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabal v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        uabal2 v0.8h, v1.16h, v2.16b
        uabal2 v0.4s, v1.8s, v2.8h
        uabal2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabal2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabal2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabal2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        sabdl v0.8h, v1.8h, v2.8b
        sabdl v0.4s, v1.4s, v2.4h
        sabdl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabdl v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabdl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabdl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        sabdl2 v0.8h, v1.16h, v2.16b
        sabdl2 v0.4s, v1.8s, v2.8h
        sabdl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabdl2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabdl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sabdl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        uabdl v0.8h, v1.8h, v2.8b
        uabdl v0.4s, v1.4s, v2.4h
        uabdl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabdl v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabdl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabdl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        uabdl2 v0.8h, v1.16h, v2.16b
        uabdl2 v0.4s, v1.8s, v2.8h
        uabdl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabdl2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabdl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uabdl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        smlal v0.8h, v1.8h, v2.8b
        smlal v0.4s, v1.4s, v2.4h
        smlal v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        smlal2 v0.8h, v1.16h, v2.16b
        smlal2 v0.4s, v1.8s, v2.8h
        smlal2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        umlal v0.8h, v1.8h, v2.8b
        umlal v0.4s, v1.4s, v2.4h
        umlal v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        umlal2 v0.8h, v1.16h, v2.16b
        umlal2 v0.4s, v1.8s, v2.8h
        umlal2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        smlsl v0.8h, v1.8h, v2.8b
        smlsl v0.4s, v1.4s, v2.4h
        smlsl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        smlsl2 v0.8h, v1.16h, v2.16b
        smlsl2 v0.4s, v1.8s, v2.8h
        smlsl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        umlsl v0.8h, v1.8h, v2.8b
        umlsl v0.4s, v1.4s, v2.4h
        umlsl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        umlsl2 v0.8h, v1.16h, v2.16b
        umlsl2 v0.4s, v1.8s, v2.8h
        umlsl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        smull v0.8h, v1.8h, v2.8b
        smull v0.4s, v1.4s, v2.4h
        smull v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        smull2 v0.8h, v1.16h, v2.16b
        smull2 v0.4s, v1.8s, v2.8h
        smull2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

        umull v0.8h, v1.8h, v2.8b
        umull v0.4s, v1.4s, v2.4h
        umull v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                        ^

        umull2 v0.8h, v1.16h, v2.16b
        umull2 v0.4s, v1.8s, v2.8h
        umull2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                      ^

//------------------------------------------------------------------------------
// Long - Variant 2
//------------------------------------------------------------------------------

        sqdmlal v0.4s, v1.4s, v2.4h
        sqdmlal v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                          ^

        sqdmlal2 v0.4s, v1.8s, v2.8h
        sqdmlal2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                        ^

        // Mismatched vector types
        sqdmlal v0.8h, v1.8b, v2.8b
        sqdmlal2 v0.8h, v1.16b, v2.16b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal v0.8h, v1.8b, v2.8b
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal2 v0.8h, v1.16b, v2.16b
// CHECK-ERROR:                    ^

        sqdmlsl v0.4s, v1.4s, v2.4h
        sqdmlsl v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                          ^

        sqdmlsl2 v0.4s, v1.8s, v2.8h
        sqdmlsl2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                        ^

        // Mismatched vector types
        sqdmlsl v0.8h, v1.8b, v2.8b
        sqdmlsl2 v0.8h, v1.16b, v2.16b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl v0.8h, v1.8b, v2.8b
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl2 v0.8h, v1.16b, v2.16b
// CHECK-ERROR:                    ^


        sqdmull v0.4s, v1.4s, v2.4h
        sqdmull v0.2d, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull v0.4s, v1.4s, v2.4h
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull v0.2d, v1.2d, v2.2s
// CHECK-ERROR:                          ^

        sqdmull2 v0.4s, v1.8s, v2.8h
        sqdmull2 v0.2d, v1.4d, v2.4s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull2 v0.4s, v1.8s, v2.8h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull2 v0.2d, v1.4d, v2.4s
// CHECK-ERROR:                        ^

        // Mismatched vector types
        sqdmull v0.8h, v1.8b, v2.8b
        sqdmull2 v0.8h, v1.16b, v2.16b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull v0.8h, v1.8b, v2.8b
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull2 v0.8h, v1.16b, v2.16b
// CHECK-ERROR:                    ^


//------------------------------------------------------------------------------
// Long - Variant 3
//------------------------------------------------------------------------------

        pmull v0.8h, v1.8h, v2.8b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        pmull v0.8h, v1.8h, v2.8b
// CHECK-ERROR:                        ^

        // Mismatched vector types
        pmull v0.4s, v1.4h, v2.4h
        pmull v0.2d, v1.2s, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        pmull v0.4s, v1.4h, v2.4h
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        pmull v0.2d, v1.2s, v2.2s
// CHECK-ERROR:                 ^


        pmull2 v0.8h, v1.16h, v2.16b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        pmull2 v0.8h, v1.16h, v2.16b
// CHECK-ERROR:                      ^

        // Mismatched vector types
        pmull2 v0.4s, v1.8h v2.8h
        pmull2 v0.2d, v1.4s, v2.4s

// CHECK-ERROR: error: expected comma before next operand
// CHECK-ERROR:        pmull2 v0.4s, v1.8h v2.8h
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        pmull2 v0.2d, v1.4s, v2.4s
// CHECK-ERROR:                  ^

//------------------------------------------------------------------------------
// Widen
//------------------------------------------------------------------------------

        saddw v0.8h, v1.8h, v2.8h
        saddw v0.4s, v1.4s, v2.4s
        saddw v0.2d, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddw v0.8h, v1.8h, v2.8h
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddw v0.4s, v1.4s, v2.4s
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddw v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                               ^

        saddw2 v0.8h, v1.8h, v2.16h
        saddw2 v0.4s, v1.4s, v2.8s
        saddw2 v0.2d, v1.2d, v2.4d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddw2 v0.8h, v1.8h, v2.16h
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddw2 v0.4s, v1.4s, v2.8s
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddw2 v0.2d, v1.2d, v2.4d
// CHECK-ERROR:                             ^

        uaddw v0.8h, v1.8h, v2.8h
        uaddw v0.4s, v1.4s, v2.4s
        uaddw v0.2d, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddw v0.8h, v1.8h, v2.8h
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddw v0.4s, v1.4s, v2.4s
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddw v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                               ^

        uaddw2 v0.8h, v1.8h, v2.16h
        uaddw2 v0.4s, v1.4s, v2.8s
        uaddw2 v0.2d, v1.2d, v2.4d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddw2 v0.8h, v1.8h, v2.16h
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddw2 v0.4s, v1.4s, v2.8s
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddw2 v0.2d, v1.2d, v2.4d
// CHECK-ERROR:                             ^

        ssubw v0.8h, v1.8h, v2.8h
        ssubw v0.4s, v1.4s, v2.4s
        ssubw v0.2d, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubw v0.8h, v1.8h, v2.8h
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubw v0.4s, v1.4s, v2.4s
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubw v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                               ^

        ssubw2 v0.8h, v1.8h, v2.16h
        ssubw2 v0.4s, v1.4s, v2.8s
        ssubw2 v0.2d, v1.2d, v2.4d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubw2 v0.8h, v1.8h, v2.16h
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubw2 v0.4s, v1.4s, v2.8s
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ssubw2 v0.2d, v1.2d, v2.4d
// CHECK-ERROR:                             ^

        usubw v0.8h, v1.8h, v2.8h
        usubw v0.4s, v1.4s, v2.4s
        usubw v0.2d, v1.2d, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubw v0.8h, v1.8h, v2.8h
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubw v0.4s, v1.4s, v2.4s
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubw v0.2d, v1.2d, v2.2d
// CHECK-ERROR:                               ^

        usubw2 v0.8h, v1.8h, v2.16h
        usubw2 v0.4s, v1.4s, v2.8s
        usubw2 v0.2d, v1.2d, v2.4d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubw2 v0.8h, v1.8h, v2.16h
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubw2 v0.4s, v1.4s, v2.8s
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usubw2 v0.2d, v1.2d, v2.4d
// CHECK-ERROR:                             ^

//------------------------------------------------------------------------------
// Narrow
//------------------------------------------------------------------------------

        addhn v0.8b, v1.8h, v2.8d
        addhn v0.4h, v1.4s, v2.4h
        addhn v0.2s, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        addhn v0.8b, v1.8h, v2.8d
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        addhn v0.4h, v1.4s, v2.4h
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        addhn v0.2s, v1.2d, v2.2s
// CHECK-ERROR:                               ^

        addhn2 v0.16b, v1.8h, v2.8b
        addhn2 v0.8h, v1.4s, v2.4h
        addhn2 v0.4s, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        addhn2 v0.16b, v1.8h, v2.8b
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        addhn2 v0.8h, v1.4s, v2.4h
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        addhn2 v0.4s, v1.2d, v2.2s
// CHECK-ERROR:                                ^

        raddhn v0.8b, v1.8h, v2.8b
        raddhn v0.4h, v1.4s, v2.4h
        raddhn v0.2s, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        raddhn v0.8b, v1.8h, v2.8b
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        raddhn v0.4h, v1.4s, v2.4h
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        raddhn v0.2s, v1.2d, v2.2s
// CHECK-ERROR:                                ^

        raddhn2 v0.16b, v1.8h, v2.8b
        raddhn2 v0.8h, v1.4s, v2.4h
        raddhn2 v0.4s, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        raddhn2 v0.16b, v1.8h, v2.8b
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        raddhn2 v0.8h, v1.4s, v2.4h
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        raddhn2 v0.4s, v1.2d, v2.2s
// CHECK-ERROR:                                 ^

        rsubhn v0.8b, v1.8h, v2.8b
        rsubhn v0.4h, v1.4s, v2.4h
        rsubhn v0.2s, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        rsubhn v0.8b, v1.8h, v2.8b
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        rsubhn v0.4h, v1.4s, v2.4h
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        rsubhn v0.2s, v1.2d, v2.2s
// CHECK-ERROR:                                ^

        rsubhn2 v0.16b, v1.8h, v2.8b
        rsubhn2 v0.8h, v1.4s, v2.4h
        rsubhn2 v0.4s, v1.2d, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        rsubhn2 v0.16b, v1.8h, v2.8b
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        rsubhn2 v0.8h, v1.4s, v2.4h
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        rsubhn2 v0.4s, v1.2d, v2.2s
// CHECK-ERROR:                                 ^

//----------------------------------------------------------------------
// Scalar Reduce Add Pairwise (Integer)
//----------------------------------------------------------------------
         // invalid vector types
      addp s0, d1.2d
      addp d0, d1.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          addp s0, d1.2d
// CHECK-ERROR:               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          addp d0, d1.2s
// CHECK-ERROR:                      ^

//----------------------------------------------------------------------
// Scalar Reduce Add Pairwise (Floating Point)
//----------------------------------------------------------------------
         // invalid vector types
      faddp s0, d1.2d
      faddp d0, d1.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          faddp s0, d1.2d
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          faddp d0, d1.2s
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Reduce Maximum Pairwise (Floating Point)
//----------------------------------------------------------------------
         // mismatched and invalid vector types
      fmaxp s0, v1.2d
      fmaxp d31, v2.2s
      fmaxp h3, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fmaxp s0, v1.2d
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fmaxp d31, v2.2s
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fmaxp h3, v2.2s
// CHECK-ERROR:                ^


//----------------------------------------------------------------------
// Scalar Reduce Minimum Pairwise (Floating Point)
//----------------------------------------------------------------------
         // mismatched and invalid vector types
      fminp s0, v1.4h
      fminp d31, v2.8h
      fminp b3, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fminp s0, v1.4h
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fminp d31, v2.8h
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fminp b3, v2.2s
// CHECK-ERROR:                ^


//----------------------------------------------------------------------
// Scalar Reduce maxNum Pairwise (Floating Point)
//----------------------------------------------------------------------
         // mismatched and invalid vector types
      fmaxnmp s0, v1.8b
      fmaxnmp d31, v2.16b
      fmaxnmp v1.2s, v2.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fmaxnmp s0, v1.8b
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fmaxnmp d31, v2.16b
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: too few operands for instruction
// CHECK-ERROR:          fmaxnmp v1.2s, v2.2s
// CHECK-ERROR:          ^

//----------------------------------------------------------------------
// Scalar Reduce minNum Pairwise (Floating Point)
//----------------------------------------------------------------------
         // mismatched and invalid vector types
      fminnmp s0, v1.2d
      fminnmp d31, v2.4s
      fminnmp v1.4s, v2.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fminnmp s0, v1.2d
// CHECK-ERROR:                         ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fminnmp d31, v2.4s
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fminnmp v1.4s, v2.2d
// CHECK-ERROR:          ^

      mla v0.2d, v1.2d, v16.d[1]
      mla v0.2s, v1.2s, v2.s[4]
      mla v0.4s, v1.4s, v2.s[4]
      mla v0.2h, v1.2h, v2.h[1]
      mla v0.4h, v1.4h, v2.h[8]
      mla v0.8h, v1.8h, v2.h[8]
      mla v0.4h, v1.4h, v16.h[2]
      mla v0.8h, v1.8h, v16.h[2]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mla v0.2d, v1.2d, v16.d[1]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mla v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mla v0.4s, v1.4s, v2.s[4]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mla v0.2h, v1.2h, v2.h[1]
// CHECK-ERROR:            ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mla v0.4h, v1.4h, v2.h[8]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mla v0.8h, v1.8h, v2.h[8]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mla v0.4h, v1.4h, v16.h[2]
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mla v0.8h, v1.8h, v16.h[2]
// CHECK-ERROR:                              ^

      mls v0.2d, v1.2d, v16.d[1]
      mls v0.2s, v1.2s, v2.s[4]
      mls v0.4s, v1.4s, v2.s[4]
      mls v0.2h, v1.2h, v2.h[1]
      mls v0.4h, v1.4h, v2.h[8]
      mls v0.8h, v1.8h, v2.h[8]
      mls v0.4h, v1.4h, v16.h[2]
      mls v0.8h, v1.8h, v16.h[2]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mls v0.2d, v1.2d, v16.d[1]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mls v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mls v0.4s, v1.4s, v2.s[4]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mls v0.2h, v1.2h, v2.h[1]
// CHECK-ERROR:            ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mls v0.4h, v1.4h, v2.h[8]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mls v0.8h, v1.8h, v2.h[8]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mls v0.4h, v1.4h, v16.h[2]
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mls v0.8h, v1.8h, v16.h[2]
// CHECK-ERROR:                              ^

      fmla v0.4h, v1.4h, v2.h[2]
      fmla v0.8h, v1.8h, v2.h[2]
      fmla v0.2s, v1.2s, v2.s[4]
      fmla v0.2s, v1.2s, v22.s[4]
      fmla v3.4s, v8.4s, v2.s[4]
      fmla v3.4s, v8.4s, v22.s[4]
      fmla v0.2d, v1.2d, v2.d[2]
      fmla v0.2d, v1.2d, v22.d[2]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmla v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmla v0.8h, v1.8h, v2.h[2]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmla v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmla v0.2s, v1.2s, v22.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmla v3.4s, v8.4s, v2.s[4]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmla v3.4s, v8.4s, v22.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmla v0.2d, v1.2d, v2.d[2]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmla v0.2d, v1.2d, v22.d[2]
// CHECK-ERROR:                                 ^

      fmls v0.4h, v1.4h, v2.h[2]
      fmls v0.8h, v1.8h, v2.h[2]
      fmls v0.2s, v1.2s, v2.s[4]
      fmls v0.2s, v1.2s, v22.s[4]
      fmls v3.4s, v8.4s, v2.s[4]
      fmls v3.4s, v8.4s, v22.s[4]
      fmls v0.2d, v1.2d, v2.d[2]
      fmls v0.2d, v1.2d, v22.d[2]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmls v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmls v0.8h, v1.8h, v2.h[2]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmls v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmls v0.2s, v1.2s, v22.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmls v3.4s, v8.4s, v2.s[4]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmls v3.4s, v8.4s, v22.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmls v0.2d, v1.2d, v2.d[2]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmls v0.2d, v1.2d, v22.d[2]
// CHECK-ERROR:                                 ^

      smlal v0.4h, v1.4h, v2.h[2]
      smlal v0.4s, v1.4h, v2.h[8]
      smlal v0.4s, v1.4h, v16.h[2]
      smlal v0.2s, v1.2s, v2.s[4]
      smlal v0.2d, v1.2s, v2.s[4]
      smlal v0.2d, v1.2s, v22.s[4]
      smlal2 v0.4h, v1.8h, v1.h[2]
      smlal2 v0.4s, v1.8h, v1.h[8]
      smlal2 v0.4s, v1.8h, v16.h[2]
      smlal2 v0.2s, v1.4s, v1.s[2]
      smlal2 v0.2d, v1.4s, v1.s[4]
      smlal2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlal v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal v0.4s, v1.4h, v16.h[2]
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlal v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlal v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlal v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal2 v0.4h, v1.8h, v1.h[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlal2 v0.4s, v1.8h, v1.h[8]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal2 v0.4s, v1.8h, v16.h[2]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlal2 v0.2s, v1.4s, v1.s[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlal2 v0.2d, v1.4s, v1.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlal2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                   ^

      smlsl v0.4h, v1.4h, v2.h[2]
      smlsl v0.4s, v1.4h, v2.h[8]
      smlsl v0.4s, v1.4h, v16.h[2]
      smlsl v0.2s, v1.2s, v2.s[4]
      smlsl v0.2d, v1.2s, v2.s[4]
      smlsl v0.2d, v1.2s, v22.s[4]
      smlsl2 v0.4h, v1.8h, v1.h[2]
      smlsl2 v0.4s, v1.8h, v1.h[8]
      smlsl2 v0.4s, v1.8h, v16.h[2]
      smlsl2 v0.2s, v1.4s, v1.s[2]
      smlsl2 v0.2d, v1.4s, v1.s[4]
      smlsl2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlsl v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl v0.4s, v1.4h, v16.h[2]
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlsl v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlsl v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlsl v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl2 v0.4h, v1.8h, v1.h[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlsl2 v0.4s, v1.8h, v1.h[8]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl2 v0.4s, v1.8h, v16.h[2]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smlsl2 v0.2s, v1.4s, v1.s[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlsl2 v0.2d, v1.4s, v1.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smlsl2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                   ^

      umlal v0.4h, v1.4h, v2.h[2]
      umlal v0.4s, v1.4h, v2.h[8]
      umlal v0.4s, v1.4h, v16.h[2]
      umlal v0.2s, v1.2s, v2.s[4]
      umlal v0.2d, v1.2s, v2.s[4]
      umlal v0.2d, v1.2s, v22.s[4]
      umlal2 v0.4h, v1.8h, v1.h[2]
      umlal2 v0.4s, v1.8h, v1.h[8]
      umlal2 v0.4s, v1.8h, v16.h[2]
      umlal2 v0.2s, v1.4s, v1.s[2]
      umlal2 v0.2d, v1.4s, v1.s[4]
      umlal2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlal v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal v0.4s, v1.4h, v16.h[2]
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlal v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlal v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlal v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal2 v0.4h, v1.8h, v1.h[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlal2 v0.4s, v1.8h, v1.h[8]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal2 v0.4s, v1.8h, v16.h[2]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlal2 v0.2s, v1.4s, v1.s[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlal2 v0.2d, v1.4s, v1.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlal2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                   ^

      umlsl v0.4h, v1.4h, v2.h[2]
      umlsl v0.4s, v1.4h, v2.h[8]
      umlsl v0.4s, v1.4h, v16.h[2]
      umlsl v0.2s, v1.2s, v2.s[4]
      umlsl v0.2d, v1.2s, v2.s[4]
      umlsl v0.2d, v1.2s, v22.s[4]
      umlsl2 v0.4h, v1.8h, v1.h[2]
      umlsl2 v0.4s, v1.8h, v1.h[8]
      umlsl2 v0.4s, v1.8h, v16.h[2]
      umlsl2 v0.2s, v1.4s, v1.s[2]
      umlsl2 v0.2d, v1.4s, v1.s[4]
      umlsl2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlsl v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl v0.4s, v1.4h, v16.h[2]
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlsl v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlsl v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlsl v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl2 v0.4h, v1.8h, v1.h[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlsl2 v0.4s, v1.8h, v1.h[8]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl2 v0.4s, v1.8h, v16.h[2]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umlsl2 v0.2s, v1.4s, v1.s[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlsl2 v0.2d, v1.4s, v1.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umlsl2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                   ^

      sqdmlal v0.4h, v1.4h, v2.h[2]
      sqdmlal v0.4s, v1.4h, v2.h[8]
      sqdmlal v0.4s, v1.4h, v16.h[2]
      sqdmlal v0.2s, v1.2s, v2.s[4]
      sqdmlal v0.2d, v1.2s, v2.s[4]
      sqdmlal v0.2d, v1.2s, v22.s[4]
      sqdmlal2 v0.4h, v1.8h, v1.h[2]
      sqdmlal2 v0.4s, v1.8h, v1.h[8]
      sqdmlal2 v0.4s, v1.8h, v16.h[2]
      sqdmlal2 v0.2s, v1.4s, v1.s[2]
      sqdmlal2 v0.2d, v1.4s, v1.s[4]
      sqdmlal2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlal v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal v0.4s, v1.4h, v16.h[2]
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlal v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlal v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlal v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal2 v0.4h, v1.8h, v1.h[2]
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlal2 v0.4s, v1.8h, v1.h[8]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal2 v0.4s, v1.8h, v16.h[2]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal2 v0.2s, v1.4s, v1.s[2]
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlal2 v0.2d, v1.4s, v1.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlal2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                     ^

      sqdmlsl v0.4h, v1.4h, v2.h[2]
      sqdmlsl v0.4s, v1.4h, v2.h[8]
      sqdmlsl v0.4s, v1.4h, v16.h[2]
      sqdmlsl v0.2s, v1.2s, v2.s[4]
      sqdmlsl v0.2d, v1.2s, v2.s[4]
      sqdmlsl v0.2d, v1.2s, v22.s[4]
      sqdmlsl2 v0.4h, v1.8h, v1.h[2]
      sqdmlsl2 v0.4s, v1.8h, v1.h[8]
      sqdmlsl2 v0.4s, v1.8h, v16.h[2]
      sqdmlsl2 v0.2s, v1.4s, v1.s[2]
      sqdmlsl2 v0.2d, v1.4s, v1.s[4]
      sqdmlsl2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlsl v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl v0.4s, v1.4h, v16.h[2]
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlsl v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlsl v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlsl v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl2 v0.4h, v1.8h, v1.h[2]
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlsl2 v0.4s, v1.8h, v1.h[8]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl2 v0.4s, v1.8h, v16.h[2]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl2 v0.2s, v1.4s, v1.s[2]
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlsl2 v0.2d, v1.4s, v1.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmlsl2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                     ^

      mul v0.4h, v1.4h, v2.h[8]
      mul v0.4h, v1.4h, v16.h[8]
      mul v0.8h, v1.8h, v2.h[8]
      mul v0.8h, v1.8h, v16.h[8]
      mul v0.2s, v1.2s, v2.s[4]
      mul v0.2s, v1.2s, v22.s[4]
      mul v0.4s, v1.4s, v2.s[4]
      mul v0.4s, v1.4s, v22.s[4]
      mul v0.2d, v1.2d, v2.d[1]

// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mul v0.4h, v1.4h, v2.h[8]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mul v0.4h, v1.4h, v16.h[8]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mul v0.8h, v1.8h, v2.h[8]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mul v0.8h, v1.8h, v16.h[8]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mul v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mul v0.2s, v1.2s, v22.s[4]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mul v0.4s, v1.4s, v2.s[4]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        mul v0.4s, v1.4s, v22.s[4]
// CHECK-ERROR:                                ^

      fmul v0.4h, v1.4h, v2.h[4]
      fmul v0.2s, v1.2s, v2.s[4]
      fmul v0.2s, v1.2s, v22.s[4]
      fmul v0.4s, v1.4s, v2.s[4]
      fmul v0.4s, v1.4s, v22.s[4]
      fmul v0.2d, v1.2d, v2.d[2]
      fmul v0.2d, v1.2d, v22.d[2]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        mul v0.2d, v1.2d, v2.d[1]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmul v0.4h, v1.4h, v2.h[4]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmul v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmul v0.2s, v1.2s, v22.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmul v0.4s, v1.4s, v2.s[4]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmul v0.4s, v1.4s, v22.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmul v0.2d, v1.2d, v2.d[2]
// CHECK-ERROR:                                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmul v0.2d, v1.2d, v22.d[2]
// CHECK-ERROR:                                 ^

      fmulx v0.4h, v1.4h, v2.h[4]
      fmulx v0.2s, v1.2s, v2.s[4]
      fmulx v0.2s, v1.2s, v22.s[4]
      fmulx v0.4s, v1.4s, v2.s[4]
      fmulx v0.4s, v1.4s, v22.s[4]
      fmulx v0.2d, v1.2d, v2.d[2]
      fmulx v0.2d, v1.2d, v22.d[2]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmulx v0.4h, v1.4h, v2.h[4]
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmulx v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmulx v0.2s, v1.2s, v22.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmulx v0.4s, v1.4s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmulx v0.4s, v1.4s, v22.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmulx v0.2d, v1.2d, v2.d[2]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        fmulx v0.2d, v1.2d, v22.d[2]
// CHECK-ERROR:                                  ^

      smull v0.4h, v1.4h, v2.h[2]
      smull v0.4s, v1.4h, v2.h[8]
      smull v0.4s, v1.4h, v16.h[4]
      smull v0.2s, v1.2s, v2.s[2]
      smull v0.2d, v1.2s, v2.s[4]
      smull v0.2d, v1.2s, v22.s[4]
      smull2 v0.4h, v1.8h, v2.h[2]
      smull2 v0.4s, v1.8h, v2.h[8]
      smull2 v0.4s, v1.8h, v16.h[4]
      smull2 v0.2s, v1.4s, v2.s[2]
      smull2 v0.2d, v1.4s, v2.s[4]
      smull2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smull v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull v0.4s, v1.4h, v16.h[4]
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull v0.2s, v1.2s, v2.s[2]
// CHECK-ERROR:              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smull v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smull v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull2 v0.4h, v1.8h, v2.h[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smull2 v0.4s, v1.8h, v2.h[8]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull2 v0.4s, v1.8h, v16.h[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smull2 v0.2s, v1.4s, v2.s[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smull2 v0.2d, v1.4s, v2.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        smull2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                   ^

      umull v0.4h, v1.4h, v2.h[2]
      umull v0.4s, v1.4h, v2.h[8]
      umull v0.4s, v1.4h, v16.h[4]
      umull v0.2s, v1.2s, v2.s[2]
      umull v0.2d, v1.2s, v2.s[4]
      umull v0.2d, v1.2s, v22.s[4]
      umull2 v0.4h, v1.8h, v2.h[2]
      umull2 v0.4s, v1.8h, v2.h[8]
      umull2 v0.4s, v1.8h, v16.h[4]
      umull2 v0.2s, v1.4s, v2.s[2]
      umull2 v0.2d, v1.4s, v2.s[4]
      umull2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umull v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull v0.4s, v1.4h, v16.h[4]
// CHECK-ERROR:                            ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull v0.2s, v1.2s, v2.s[2]
// CHECK-ERROR:              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umull v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umull v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull2 v0.4h, v1.8h, v2.h[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umull2 v0.4s, v1.8h, v2.h[8]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull2 v0.4s, v1.8h, v16.h[4]
// CHECK-ERROR:                                 ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umull2 v0.2s, v1.4s, v2.s[2]
// CHECK-ERROR:               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umull2 v0.2d, v1.4s, v2.s[4]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        umull2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                   ^

      sqdmull v0.4h, v1.4h, v2.h[2]
      sqdmull v0.4s, v1.4h, v2.h[8]
      sqdmull v0.4s, v1.4h, v16.h[4]
      sqdmull v0.2s, v1.2s, v2.s[2]
      sqdmull v0.2d, v1.2s, v2.s[4]
      sqdmull v0.2d, v1.2s, v22.s[4]
      sqdmull2 v0.4h, v1.8h, v2.h[2]
      sqdmull2 v0.4s, v1.8h, v2.h[8]
      sqdmull2 v0.4s, v1.8h, v16.h[4]
      sqdmull2 v0.2s, v1.4s, v2.s[2]
      sqdmull2 v0.2d, v1.4s, v2.s[4]
      sqdmull2 v0.2d, v1.4s, v22.s[4]

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull v0.4h, v1.4h, v2.h[2]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmull v0.4s, v1.4h, v2.h[8]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull v0.4s, v1.4h, v16.h[4]
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull v0.2s, v1.2s, v2.s[2]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmull v0.2d, v1.2s, v2.s[4]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmull v0.2d, v1.2s, v22.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull2 v0.4h, v1.8h, v2.h[2]
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmull2 v0.4s, v1.8h, v2.h[8]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull2 v0.4s, v1.8h, v16.h[4]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull2 v0.2s, v1.4s, v2.s[2]
// CHECK-ERROR:                 ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmull2 v0.2d, v1.4s, v2.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmull2 v0.2d, v1.4s, v22.s[4]
// CHECK-ERROR:                                     ^

      sqdmulh v0.4h, v1.4h, v2.h[8]
      sqdmulh v0.4h, v1.4h, v16.h[2]
      sqdmulh v0.8h, v1.8h, v2.h[8]
      sqdmulh v0.8h, v1.8h, v16.h[2]
      sqdmulh v0.2s, v1.2s, v2.s[4]
      sqdmulh v0.2s, v1.2s, v22.s[4]
      sqdmulh v0.4s, v1.4s, v2.s[4]
      sqdmulh v0.4s, v1.4s, v22.s[4]
      sqdmulh v0.2d, v1.2d, v22.d[1]

// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmulh v0.4h, v1.4h, v2.h[8]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmulh v0.4h, v1.4h, v16.h[2]
// CHECK-ERROR:                              ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmulh v0.8h, v1.8h, v2.h[8]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmulh v0.8h, v1.8h, v16.h[2]
// CHECK-ERROR:                                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmulh v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmulh v0.2s, v1.2s, v22.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmulh v0.4s, v1.4s, v2.s[4]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqdmulh v0.4s, v1.4s, v22.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmulh v0.2d, v1.2d, v22.d[1]
// CHECK-ERROR:                   ^

      sqrdmulh v0.4h, v1.4h, v2.h[8]
      sqrdmulh v0.4h, v1.4h, v16.h[2]
      sqrdmulh v0.8h, v1.8h, v2.h[8]
      sqrdmulh v0.8h, v1.8h, v16.h[2]
      sqrdmulh v0.2s, v1.2s, v2.s[4]
      sqrdmulh v0.2s, v1.2s, v22.s[4]
      sqrdmulh v0.4s, v1.4s, v2.s[4]
      sqrdmulh v0.4s, v1.4s, v22.s[4]
      sqrdmulh v0.2d, v1.2d, v22.d[1]

// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqrdmulh v0.4h, v1.4h, v2.h[8]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqrdmulh v0.4h, v1.4h, v16.h[2]
// CHECK-ERROR:                               ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqrdmulh v0.8h, v1.8h, v2.h[8]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqrdmulh v0.8h, v1.8h, v16.h[2]
// CHECK-ERROR:                                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqrdmulh v0.2s, v1.2s, v2.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqrdmulh v0.2s, v1.2s, v22.s[4]
// CHECK-ERROR:                                     ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqrdmulh v0.4s, v1.4s, v2.s[4]
// CHECK-ERROR:                                    ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:        sqrdmulh v0.4s, v1.4s, v22.s[4]
// CHECK-ERROR:                                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqrdmulh v0.2d, v1.2d, v22.d[1]
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Across vectors
//----------------------------------------------------------------------

        saddlv b0, v1.8b
        saddlv b0, v1.16b
        saddlv h0, v1.4h
        saddlv h0, v1.8h
        saddlv s0, v1.2s
        saddlv s0, v1.4s
        saddlv d0, v1.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddlv b0, v1.8b
// CHECK-ERROR:               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddlv b0, v1.16b
// CHECK-ERROR:               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddlv h0, v1.4h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddlv h0, v1.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddlv s0, v1.2s
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddlv s0, v1.4s
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        saddlv d0, v1.2s
// CHECK-ERROR:                   ^

        uaddlv b0, v1.8b
        uaddlv b0, v1.16b
        uaddlv h0, v1.4h
        uaddlv h0, v1.8h
        uaddlv s0, v1.2s
        uaddlv s0, v1.4s
        uaddlv d0, v1.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddlv b0, v1.8b
// CHECK-ERROR:               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddlv b0, v1.16b
// CHECK-ERROR:               ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddlv h0, v1.4h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddlv h0, v1.8h
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddlv s0, v1.2s
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddlv s0, v1.4s
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uaddlv d0, v1.2s
// CHECK-ERROR:                   ^

        smaxv s0, v1.2s
        sminv s0, v1.2s
        umaxv s0, v1.2s
        uminv s0, v1.2s
        addv s0, v1.2s

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smaxv s0, v1.2s
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sminv s0, v1.2s
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umaxv s0, v1.2s
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uminv s0, v1.2s
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        addv s0, v1.2s
// CHECK-ERROR:                 ^

        smaxv d0, v1.2d
        sminv d0, v1.2d
        umaxv d0, v1.2d
        uminv d0, v1.2d
        addv d0, v1.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        smaxv d0, v1.2d
// CHECK-ERROR:              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sminv d0, v1.2d
// CHECK-ERROR:              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        umaxv d0, v1.2d
// CHECK-ERROR:              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uminv d0, v1.2d
// CHECK-ERROR:              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        addv d0, v1.2d
// CHECK-ERROR:             ^

        fmaxnmv b0, v1.16b
        fminnmv b0, v1.16b
        fmaxv b0, v1.16b
        fminv b0, v1.16b

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxnmv b0, v1.16b
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminnmv b0, v1.16b
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxv b0, v1.16b
// CHECK-ERROR:              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminv b0, v1.16b
// CHECK-ERROR:              ^

        fmaxnmv h0, v1.8h
        fminnmv h0, v1.8h
        fmaxv h0, v1.8h
        fminv h0, v1.8h

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxnmv h0, v1.8h
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminnmv h0, v1.8h
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxv h0, v1.8h
// CHECK-ERROR:              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminv h0, v1.8h
// CHECK-ERROR:              ^

        fmaxnmv d0, v1.2d
        fminnmv d0, v1.2d
        fmaxv d0, v1.2d
        fminv d0, v1.2d

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxnmv d0, v1.2d
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminnmv d0, v1.2d
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fmaxv d0, v1.2d
// CHECK-ERROR:              ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        fminv d0, v1.2d
// CHECK-ERROR:              ^

//----------------------------------------------------------------------
// Floating-point Multiply Extended
//----------------------------------------------------------------------

    fmulx s20, h22, s15
    fmulx d23, d11, s1

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fmulx s20, h22, s15
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fmulx d23, d11, s1
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Floating-point Reciprocal Step
//----------------------------------------------------------------------

    frecps s21, s16, h13
    frecps d22, s30, d21

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          frecps s21, s16, h13
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          frecps d22, s30, d21
// CHECK-ERROR:                      ^

//----------------------------------------------------------------------
// Floating-point Reciprocal Square Root Step
//----------------------------------------------------------------------

    frsqrts s21, h5, s12
    frsqrts d8, s22, d18

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          frsqrts s21, h5, s12
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          frsqrts d8, s22, d18
// CHECK-ERROR:                      ^

//----------------------------------------------------------------------
// Vector load/store multiple N-element structure (class SIMD lselem)
//----------------------------------------------------------------------
         ld1 {x3}, [x2]
         ld1 {v4}, [x0]
         ld1 {v32.16b}, [x0]
         ld1 {v15.8h}, [x32]
// CHECK-ERROR: error: expected vector type register
// CHECK-ERROR:        ld1 {x3}, [x2]
// CHECK-ERROR:             ^
// CHECK-ERROR: error: expected vector type register
// CHECK-ERROR:        ld1 {v4}, [x0]
// CHECK-ERROR:             ^
// CHECK-ERROR: error: expected vector type register
// CHECK-ERROR:        ld1 {v32.16b}, [x0]
// CHECK-ERROR:             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ld1 {v15.8h}, [x32]
// CHECK-ERROR:                       ^

         ld1 {v0.16b, v2.16b}, [x0]
         ld1 {v0.8h, v1.8h, v2.8h, v3.8h, v4.8h}, [x0]
         ld1 v0.8b, v1.8b}, [x0]
         ld1 {v0.8h-v4.8h}, [x0]
         ld1 {v1.8h-v1.8h}, [x0]
         ld1 {v15.8h-v17.4h}, [x15]
         ld1 {v0.8b-v2.8b, [x0]
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        ld1 {v0.16b, v2.16b}, [x0]
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid number of vectors
// CHECK-ERROR:        ld1 {v0.8h, v1.8h, v2.8h, v3.8h, v4.8h}, [x0]
// CHECK-ERROR:                                         ^
// CHECK-ERROR: error: '{' expected
// CHECK-ERROR:        ld1 v0.8b, v1.8b}, [x0]
// CHECK-ERROR:            ^
// CHECK-ERROR: error: invalid number of vectors
// CHECK-ERROR:        ld1 {v0.8h-v4.8h}, [x0]
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid number of vectors
// CHECK-ERROR:        ld1 {v1.8h-v1.8h}, [x0]
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: expected the same vector layout
// CHECK-ERROR:        ld1 {v15.8h-v17.4h}, [x15]
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: '}' expected
// CHECK-ERROR:        ld1 {v0.8b-v2.8b, [x0]
// CHECK-ERROR:                        ^

         ld2 {v15.8h, v16.4h}, [x15]
         ld2 {v0.8b, v2.8b}, [x0]
         ld2 {v15.4h, v16.4h, v17.4h}, [x32]
         ld2 {v15.8h-v16.4h}, [x15]
         ld2 {v0.2d-v2.2d}, [x0]
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        ld2 {v15.8h, v16.4h}, [x15]
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        ld2 {v0.8b, v2.8b}, [x0]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ld2 {v15.4h, v16.4h, v17.4h}, [x32]
// CHECK-ERROR:            ^
// CHECK-ERROR: error: expected the same vector layout
// CHECK-ERROR:        ld2 {v15.8h-v16.4h}, [x15]
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ld2 {v0.2d-v2.2d}, [x0]
// CHECK-ERROR:            ^

         ld3 {v15.8h, v16.8h, v17.4h}, [x15]
         ld3 {v0.8b, v1,8b, v2.8b, v3.8b}, [x0]
         ld3 {v0.8b, v2.8b, v3.8b}, [x0]
         ld3 {v15.8h-v17.4h}, [x15]
         ld3 {v31.4s-v2.4s}, [sp]
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        ld3 {v15.8h, v16.8h, v17.4h}, [x15]
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected vector type register
// CHECK-ERROR:        ld3 {v0.8b, v1,8b, v2.8b, v3.8b}, [x0]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        ld3 {v0.8b, v2.8b, v3.8b}, [x0]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: expected the same vector layout
// CHECK-ERROR:        ld3 {v15.8h-v17.4h}, [x15]
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ld3 {v31.4s-v2.4s}, [sp]
// CHECK-ERROR:            ^

         ld4 {v15.8h, v16.8h, v17.4h, v18.8h}, [x15]
         ld4 {v0.8b, v2.8b, v3.8b, v4.8b}, [x0]
         ld4 {v15.4h, v16.4h, v17.4h, v18.4h, v19.4h}, [x31]
         ld4 {v15.8h-v18.4h}, [x15]
         ld4 {v31.2s-v1.2s}, [x31]
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        ld4 {v15.8h, v16.8h, v17.4h, v18.8h}, [x15]
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        ld4 {v0.8b, v2.8b, v3.8b, v4.8b}, [x0]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid number of vectors
// CHECK-ERROR:        ld4 {v15.4h, v16.4h, v17.4h, v18.4h, v19.4h}, [x31]
// CHECK-ERROR:                                             ^
// CHECK-ERROR: error: expected the same vector layout
// CHECK-ERROR:        ld4 {v15.8h-v18.4h}, [x15]
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ld4 {v31.2s-v1.2s}, [x31]
// CHECK-ERROR:            ^

         st1 {x3}, [x2]
         st1 {v4}, [x0]
         st1 {v32.16b}, [x0]
         st1 {v15.8h}, [x32]
// CHECK-ERROR: error: expected vector type register
// CHECK-ERROR:        st1 {x3}, [x2]
// CHECK-ERROR:             ^
// CHECK-ERROR: error: expected vector type register
// CHECK-ERROR:        st1 {v4}, [x0]
// CHECK-ERROR:             ^
// CHECK-ERROR: error: expected vector type register
// CHECK-ERROR:        st1 {v32.16b}, [x0]
// CHECK-ERROR:             ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        st1 {v15.8h}, [x32]
// CHECK-ERROR:                       ^

         st1 {v0.16b, v2.16b}, [x0]
         st1 {v0.8h, v1.8h, v2.8h, v3.8h, v4.8h}, [x0]
         st1 v0.8b, v1.8b}, [x0]
         st1 {v0.8h-v4.8h}, [x0]
         st1 {v1.8h-v1.8h}, [x0]
         st1 {v15.8h-v17.4h}, [x15]
         st1 {v0.8b-v2.8b, [x0]
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        st1 {v0.16b, v2.16b}, [x0]
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid number of vectors
// CHECK-ERROR:        st1 {v0.8h, v1.8h, v2.8h, v3.8h, v4.8h}, [x0]
// CHECK-ERROR:                                         ^
// CHECK-ERROR: error: '{' expected
// CHECK-ERROR:        st1 v0.8b, v1.8b}, [x0]
// CHECK-ERROR:            ^
// CHECK-ERROR: error: invalid number of vectors
// CHECK-ERROR:        st1 {v0.8h-v4.8h}, [x0]
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid number of vectors
// CHECK-ERROR:        st1 {v1.8h-v1.8h}, [x0]
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: expected the same vector layout
// CHECK-ERROR:        st1 {v15.8h-v17.4h}, [x15]
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: '}' expected
// CHECK-ERROR:        st1 {v0.8b-v2.8b, [x0]
// CHECK-ERROR:                        ^

         st2 {v15.8h, v16.4h}, [x15]
         st2 {v0.8b, v2.8b}, [x0]
         st2 {v15.4h, v16.4h, v17.4h}, [x30]
         st2 {v15.8h-v16.4h}, [x15]
         st2 {v0.2d-v2.2d}, [x0]
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        st2 {v15.8h, v16.4h}, [x15]
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        st2 {v0.8b, v2.8b}, [x0]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        st2 {v15.4h, v16.4h, v17.4h}, [x30]
// CHECK-ERROR:            ^
// CHECK-ERROR: error: expected the same vector layout
// CHECK-ERROR:        st2 {v15.8h-v16.4h}, [x15]
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        st2 {v0.2d-v2.2d}, [x0]
// CHECK-ERROR:            ^

         st3 {v15.8h, v16.8h, v17.4h}, [x15]
         st3 {v0.8b, v1,8b, v2.8b, v3.8b}, [x0]
         st3 {v0.8b, v2.8b, v3.8b}, [x0]
         st3 {v15.8h-v17.4h}, [x15]
         st3 {v31.4s-v2.4s}, [sp]
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        st3 {v15.8h, v16.8h, v17.4h}, [x15]
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: expected vector type register
// CHECK-ERROR:        st3 {v0.8b, v1,8b, v2.8b, v3.8b}, [x0]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        st3 {v0.8b, v2.8b, v3.8b}, [x0]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: expected the same vector layout
// CHECK-ERROR:        st3 {v15.8h-v17.4h}, [x15]
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        st3 {v31.4s-v2.4s}, [sp]
// CHECK-ERROR:            ^

         st4 {v15.8h, v16.8h, v17.4h, v18.8h}, [x15]
         st4 {v0.8b, v2.8b, v3.8b, v4.8b}, [x0]
         st4 {v15.4h, v16.4h, v17.4h, v18.4h, v19.4h}, [x31]
         st4 {v15.8h-v18.4h}, [x15]
         st4 {v31.2s-v1.2s}, [x31]
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        st4 {v15.8h, v16.8h, v17.4h, v18.8h}, [x15]
// CHECK-ERROR:                             ^
// CHECK-ERROR: error: invalid space between two vectors
// CHECK-ERROR:        st4 {v0.8b, v2.8b, v3.8b, v4.8b}, [x0]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid number of vectors
// CHECK-ERROR:        st4 {v15.4h, v16.4h, v17.4h, v18.4h, v19.4h}, [x31]
// CHECK-ERROR:                                             ^
// CHECK-ERROR: error: expected the same vector layout
// CHECK-ERROR:        st4 {v15.8h-v18.4h}, [x15]
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        st4 {v31.2s-v1.2s}, [x31]
// CHECK-ERROR:            ^

         ins v2.b[16], w1
         ins v7.h[8], w14
         ins v20.s[5], w30
         ins v1.d[2], x7
         ins v2.b[3], b1
         ins v7.h[2], h14
         ins v20.s[1], s30
         ins v1.d[0], d7

// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:         ins v2.b[16], w1
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:         ins v7.h[8], w14
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:         ins v20.s[5], w30
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: lane number incompatible with layout
// CHECK-ERROR:         ins v1.d[2], x7
// CHECK-ERROR:                  ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ins v2.b[3], b1
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ins v7.h[2], h14
// CHECK-ERROR:                      ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ins v20.s[1], s30
// CHECK-ERROR:                       ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ins v1.d[0], d7
// CHECK-ERROR:                      ^

         smov w1, v0.b[16]
         smov w14, v6.h[8]
         smov x1, v0.b[16]
         smov x14, v6.h[8]
         smov x20, v9.s[5]
         smov w1, v0.d[0]
         smov w14, v6.d[1]
         smov x1, v0.d[0]
         smov x14, v6.d[1]
         smov x20, v9.d[0]

// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         smov w1, v0.b[16]
// CHECK-ERROR                       ^
// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         smov w14, v6.h[8]
// CHECK-ERROR                        ^
// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         smov x1, v0.b[16]
// CHECK-ERROR                       ^
// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         smov x14, v6.h[8]
// CHECK-ERROR                        ^
// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         smov x20, v9.s[5]
// CHECK-ERROR                        ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         smov w1, v0.d[0]
// CHECK-ERROR                     ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         smov w14, v6.d[1]
// CHECK-ERROR                      ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         smov x1, v0.d[0]
// CHECK-ERROR                     ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         smov x14, v6.d[1]
// CHECK-ERROR                      ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         smov x20, v9.d[0]
// CHECK-ERROR                      ^

         umov w1, v0.b[16]
         umov w14, v6.h[8]
         umov w20, v9.s[5]
         umov x7, v18.d[3]
         umov w1, v0.d[0]
         umov s20, v9.s[2]
         umov d7, v18.d[1]

// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         umov w1, v0.b[16]
// CHECK-ERROR                       ^
// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         umov w14, v6.h[8]
// CHECK-ERROR                        ^
// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         umov w20, v9.s[5]
// CHECK-ERROR                        ^
// CHECK-ERROR error: lane number incompatible with layout
// CHECK-ERROR         umov x7, v18.d[3]
// CHECK-ERROR                        ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         umov w1, v0.d[0]
// CHECK-ERROR                     ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         umov s20, v9.s[2]
// CHECK-ERROR              ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         umov d7, v18.d[1]
// CHECK-ERROR              ^

         Ins v1.h[2], v3.b[6]
         Ins v6.h[7], v7.s[2]
         Ins v15.d[0], v22.s[2]
         Ins v0.d[0], v4.b[1]

// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         Ins v1.h[2], v3.b[6]
// CHECK-ERROR                         ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         Ins v6.h[7], v7.s[2]
// CHECK-ERROR                         ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         Ins v15.d[0], v22.s[2]
// CHECK-ERROR                           ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         Ins v0.d[0], v4.b[1]
// CHECK-ERROR                         ^

         dup v1.8h, v2.b[2]
         dup v11.4s, v7.h[7]
         dup v17.2d, v20.s[0]
         dup v1.16b, v2.h[2]
         dup v11.8h, v7.s[3]
         dup v17.4s, v20.d[0]
         dup v5.2d, v1.b[1]

// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v1.8h, v2.b[2]
// CHECK-ERROR                       ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v11.4s, v7.h[7]
// CHECK-ERROR                        ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v17.2d, v20.s[0]
// CHECK-ERROR                         ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v1.16b, v2.h[2]
// CHECK-ERROR                        ^
// CHECK-ERROR invalid operand for instruction
// CHECK-ERROR         dup v11.8h, v7.s[3]
// CHECK-ERROR                        ^
// CHECK-ERROR invalid operand for instruction
// CHECK-ERROR         dup v17.4s, v20.d[0]
// CHECK-ERROR                         ^
// CHECK-ERROR invalid operand for instruction
// CHECK-ERROR         dup v5.2d, v1.b[1]
// CHECK-ERROR                       ^

         dup v1.8b, b1
         dup v11.4h, h14
         dup v17.2s, s30
         dup v1.16b, d2
         dup v11.8s, w16
         dup v17.4d, w28
         dup v5.2d, w0

// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v1.8b, b1
// CHECK-ERROR                    ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v11.4h, h14
// CHECK-ERROR                     ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v17.2s, s30
// CHECK-ERROR                     ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v1.16b, d2
// CHECK-ERROR                     ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v11.8s, w16
// CHECK-ERROR             ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v17.4d, w28
// CHECK-ERROR             ^
// CHECK-ERROR error: invalid operand for instruction
// CHECK-ERROR         dup v5.2d, w0
// CHECK-ERROR                    ^

//----------------------------------------------------------------------
// Scalar Compare Bitwise Equal
//----------------------------------------------------------------------

         cmeq b20, d21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmeq b20, d21, d22
// CHECK-ERROR:               ^

//----------------------------------------------------------------------
// Scalar Compare Bitwise Equal To Zero
//----------------------------------------------------------------------

         cmeq d20, b21, #0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmeq d20, b21, #0
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Compare Unsigned Higher Or Same
//----------------------------------------------------------------------

         cmhs b20, d21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmhs b20, d21, d22
// CHECK-ERROR:               ^

        
//----------------------------------------------------------------------
// Scalar Compare Signed Greather Than Or Equal
//----------------------------------------------------------------------

         cmge b20, d21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmge b20, d21, d22
// CHECK-ERROR:               ^

//----------------------------------------------------------------------
// Scalar Compare Signed Greather Than Or Equal To Zero
//----------------------------------------------------------------------

         cmge d20, b21, #0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmge d20, b21, #0
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Compare Unsigned Higher
//----------------------------------------------------------------------

         cmhi b20, d21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmhi b20, d21, d22
// CHECK-ERROR:               ^

//----------------------------------------------------------------------
// Scalar Compare Signed Greater Than
//----------------------------------------------------------------------

         cmgt b20, d21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmgt b20, d21, d22
// CHECK-ERROR:               ^

//----------------------------------------------------------------------
// Scalar Compare Signed Greater Than Zero
//----------------------------------------------------------------------

         cmgt d20, b21, #0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmgt d20, b21, #0
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Compare Signed Less Than Or Equal To Zero
//----------------------------------------------------------------------

         cmle d20, b21, #0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmle d20, b21, #0
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Compare Less Than Zero
//----------------------------------------------------------------------

         cmlt d20, b21, #0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmlt d20, b21, #0
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Compare Bitwise Test Bits
//----------------------------------------------------------------------

         cmtst b20, d21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          cmtst b20, d21, d22
// CHECK-ERROR:                ^

//----------------------------------------------------------------------
// Scalar Floating-point Compare Mask Equal
//----------------------------------------------------------------------

         fcmeq s10, h11, s12
         fcmeq d20, s21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmeq s10, h11, s12
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmeq d20, s21, d22
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Compare Mask Equal To Zero
//----------------------------------------------------------------------

         fcmeq h10, s11, #0.0
         fcmeq d20, s21, #0.0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmeq h10, s11, #0.0
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmeq d20, s21, #0.0
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Compare Mask Greater Than Or Equal
//----------------------------------------------------------------------

         fcmge s10, h11, s12
         fcmge d20, s21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmge s10, h11, s12
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmge d20, s21, d22
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Compare Mask Greater Than Or Equal To Zero
//----------------------------------------------------------------------

         fcmge h10, s11, #0.0
         fcmge d20, s21, #0.0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmge h10, s11, #0.0
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmge d20, s21, #0.0
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Compare Mask Greather Than
//----------------------------------------------------------------------

         fcmgt s10, h11, s12
         fcmgt d20, s21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmgt s10, h11, s12
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmgt d20, s21, d22
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Compare Mask Greather Than Zero
//----------------------------------------------------------------------

         fcmgt h10, s11, #0.0
         fcmgt d20, s21, #0.0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmgt h10, s11, #0.0
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmgt d20, s21, #0.0
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Compare Mask Less Than Or Equal To Zero
//----------------------------------------------------------------------

         fcmle h10, s11, #0.0
         fcmle d20, s21, #0.0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmle h10, s11, #0.0
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmle d20, s21, #0.0
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Compare Mask Less Than
//----------------------------------------------------------------------

         fcmlt h10, s11, #0.0
         fcmlt d20, s21, #0.0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmlt h10, s11, #0.0
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          fcmlt d20, s21, #0.0
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Absolute Compare Mask Greater Than Or Equal
//----------------------------------------------------------------------

         facge s10, h11, s12
         facge d20, s21, d22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          facge s10, h11, s12
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          facge d20, s21, d22
// CHECK-ERROR:                     ^

//----------------------------------------------------------------------
// Scalar Floating-point Absolute Compare Mask Greater Than
//----------------------------------------------------------------------

         facgt s10, h11, s12
         facgt d20, d21, s22

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          facgt s10, h11, s12
// CHECK-ERROR:                     ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:          facgt d20, d21, s22
// CHECK-ERROR:                          ^
        
//----------------------------------------------------------------------
// Scalar Signed Saturating Accumulated of Unsigned Value
//----------------------------------------------------------------------

        suqadd b0, h1
        suqadd h0, s1
        suqadd s0, d1
        suqadd d0, b0

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        suqadd b0, h1
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        suqadd h0, s1
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        suqadd s0, d1
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        suqadd d0, b0
// CHECK-ERROR:                   ^

//----------------------------------------------------------------------
// Scalar Unsigned Saturating Accumulated of Signed Value
//----------------------------------------------------------------------

        usqadd b0, h1
        usqadd h0, s1
        usqadd s0, d1
        usqadd d0, b1

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usqadd b0, h1
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usqadd h0, s1
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usqadd s0, d1
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        usqadd d0, b1
// CHECK-ERROR:                   ^

//----------------------------------------------------------------------
// Scalar Absolute Value
//----------------------------------------------------------------------

    abs d29, s24

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        abs d29, s24
// CHECK-ERROR:                 ^

//----------------------------------------------------------------------
// Scalar Negate
//----------------------------------------------------------------------

    neg d29, s24

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        neg d29, s24
// CHECK-ERROR:                 ^

//----------------------------------------------------------------------
// Signed Saturating Doubling Multiply-Add Long
//----------------------------------------------------------------------

    sqdmlal s17, h27, s12
    sqdmlal d19, s24, d12

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal s17, h27, s12
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlal d19, s24, d12
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Signed Saturating Doubling Multiply-Subtract Long
//----------------------------------------------------------------------

    sqdmlsl s14, h12, s25
    sqdmlsl d12, s23, d13

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl s14, h12, s25
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmlsl d12, s23, d13
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Signed Saturating Doubling Multiply Long
//----------------------------------------------------------------------

    sqdmull s12, h22, s12
    sqdmull d15, s22, d12

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull s12, h22, s12
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqdmull d15, s22, d12
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Scalar Signed Saturating Extract Unsigned Narrow
//----------------------------------------------------------------------

    sqxtun b19, b14
    sqxtun h21, h15
    sqxtun s20, s12

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqxtun b19, b14
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqxtun h21, h15
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqxtun s20, s12
// CHECK-ERROR:                    ^

//----------------------------------------------------------------------
// Scalar Signed Saturating Extract Signed Narrow
//----------------------------------------------------------------------

    sqxtn b18, b18
    sqxtn h20, h17
    sqxtn s19, s14

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqxtn b18, b18
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqxtn h20, h17
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sqxtn s19, s14
// CHECK-ERROR:                   ^


//----------------------------------------------------------------------
// Scalar Unsigned Saturating Extract Narrow
//----------------------------------------------------------------------

    uqxtn b18, b18
    uqxtn h20, h17
    uqxtn s19, s14

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqxtn b18, b18
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqxtn h20, h17
// CHECK-ERROR:                   ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        uqxtn s19, s14
// CHECK-ERROR:                   ^

//----------------------------------------------------------------------
// Scalar Signed Shift Right (Immediate)
//----------------------------------------------------------------------
        sshr d15, d16, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        sshr d15, d16, #99
// CHECK-ERROR:                       ^

        sshr d15, s16, #31

// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        sshr d15, s16, #31
// CHECK-ERROR:                  ^

//----------------------------------------------------------------------
// Scalar Unsigned Shift Right (Immediate)
//----------------------------------------------------------------------

        ushr d10, d17, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        ushr d10, d17, #99
// CHECK-ERROR:                       ^

//----------------------------------------------------------------------
// Scalar Signed Rounding Shift Right (Immediate)
//----------------------------------------------------------------------

        srshr d19, d18, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        srshr d19, d18, #99
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Scalar Unigned Rounding Shift Right (Immediate)
//----------------------------------------------------------------------

        urshr d20, d23, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        urshr d20, d23, #99
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Scalar Signed Shift Right and Accumulate (Immediate)
//----------------------------------------------------------------------

        ssra d18, d12, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        ssra d18, d12, #99
// CHECK-ERROR:                       ^

//----------------------------------------------------------------------
// Scalar Unsigned Shift Right and Accumulate (Immediate)
//----------------------------------------------------------------------

        usra d20, d13, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        usra d20, d13, #99
// CHECK-ERROR:                       ^

//----------------------------------------------------------------------
// Scalar Signed Rounding Shift Right and Accumulate (Immediate)
//----------------------------------------------------------------------

        srsra d15, d11, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        srsra d15, d11, #99
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Scalar Unsigned Rounding Shift Right and Accumulate (Immediate)
//----------------------------------------------------------------------

        ursra d18, d10, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        ursra d18, d10, #99
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Scalar Shift Left (Immediate)
//----------------------------------------------------------------------

        shl d7, d10, #99

// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:        shl d7, d10, #99
// CHECK-ERROR:                     ^

        shl d7, s16, #31
        
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        shl d7, s16, #31
// CHECK-ERROR:                ^

//----------------------------------------------------------------------
// Signed Saturating Shift Left (Immediate)
//----------------------------------------------------------------------

        sqshl b11, b19, #99
        sqshl h13, h18, #99
        sqshl s14, s17, #99
        sqshl d15, d16, #99

// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:        sqshl b11, b19, #99
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:        sqshl h13, h18, #99
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:        sqshl s14, s17, #99
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:        sqshl d15, d16, #99
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Unsigned Saturating Shift Left (Immediate)
//----------------------------------------------------------------------

        uqshl b18, b15, #99
        uqshl h11, h18, #99
        uqshl s14, s19, #99
        uqshl d15, d12, #99

// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:        uqshl b18, b15, #99
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:        uqshl h11, h18, #99
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:        uqshl s14, s19, #99
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:        uqshl d15, d12, #99
// CHECK-ERROR:                        ^

//----------------------------------------------------------------------
// Signed Saturating Shift Left Unsigned (Immediate)
//----------------------------------------------------------------------

        sqshlu b15, b18, #99
        sqshlu h19, h17, #99
        sqshlu s16, s14, #99
        sqshlu d11, d13, #99

// CHECK-ERROR: error: expected integer in range [0, 7]
// CHECK-ERROR:        sqshlu  b15, b18, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [0, 15]
// CHECK-ERROR:        sqshlu  h19, h17, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [0, 31]
// CHECK-ERROR:        sqshlu  s16, s14, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:        sqshlu  d11, d13, #99
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Shift Right And Insert (Immediate)
//----------------------------------------------------------------------

        sri d10, d12, #99

// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        sri d10, d12, #99
// CHECK-ERROR:                      ^

//----------------------------------------------------------------------
// Shift Left And Insert (Immediate)
//----------------------------------------------------------------------

        sli d10, d14, #99

// CHECK-ERROR: error: expected integer in range [0, 63]
// CHECK-ERROR:        sli d10, d14, #99
// CHECK-ERROR:                      ^

//----------------------------------------------------------------------
// Signed Saturating Shift Right Narrow (Immediate)
//----------------------------------------------------------------------

        sqshrn b10, h15, #99
        sqshrn h17, s10, #99
        sqshrn s18, d10, #99

// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:        sqshrn  b10, h15, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:        sqshrn  h17, s10, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        sqshrn  s18, d10, #99
// CHECK-ERROR:                          ^
        
//----------------------------------------------------------------------
// Unsigned Saturating Shift Right Narrow (Immediate)
//----------------------------------------------------------------------

        uqshrn b12, h10, #99
        uqshrn h10, s14, #99
        uqshrn s10, d12, #99

// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:        uqshrn  b12, h10, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:        uqshrn  h10, s14, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        uqshrn  s10, d12, #99
// CHECK-ERROR:                          ^
        
//----------------------------------------------------------------------
// Signed Saturating Rounded Shift Right Narrow (Immediate)
//----------------------------------------------------------------------

        sqrshrn b10, h13, #99
        sqrshrn h15, s10, #99
        sqrshrn s15, d12, #99

// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:        sqrshrn b10, h13, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:        sqrshrn h15, s10, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        sqrshrn s15, d12, #99
// CHECK-ERROR:                          ^
        
//----------------------------------------------------------------------
// Unsigned Saturating Rounded Shift Right Narrow (Immediate)
//----------------------------------------------------------------------

        uqrshrn b10, h12, #99
        uqrshrn h12, s10, #99
        uqrshrn s10, d10, #99

// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:        uqrshrn b10, h12, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:        uqrshrn h12, s10, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        uqrshrn s10, d10, #99
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Signed Saturating Shift Right Unsigned Narrow (Immediate)
//----------------------------------------------------------------------

        sqshrun b15, h10, #99
        sqshrun h20, s14, #99
        sqshrun s10, d15, #99

// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:        sqshrun b15, h10, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:        sqshrun h20, s14, #99
// CHECK-ERROR:                          ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        sqshrun s10, d15, #99
// CHECK-ERROR:                          ^

//----------------------------------------------------------------------
// Signed Saturating Rounded Shift Right Unsigned Narrow (Immediate)
//----------------------------------------------------------------------

        sqrshrun b17, h10, #99
        sqrshrun h10, s13, #99
        sqrshrun s22, d16, #99

// CHECK-ERROR: error: expected integer in range [1, 8]
// CHECK-ERROR:        sqrshrun b17, h10, #99
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [1, 16]
// CHECK-ERROR:        sqrshrun h10, s13, #99
// CHECK-ERROR:                           ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        sqrshrun s22, d16, #99
// CHECK-ERROR:                           ^

//----------------------------------------------------------------------
// Scalar Signed Fixed-point Convert To Floating-Point (Immediate)
//----------------------------------------------------------------------

    scvtf s22, s13, #0
    scvtf s22, s13, #33
    scvtf d21, d12, #65
    scvtf d21, s12, #31
        
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        scvtf s22, s13, #0
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        scvtf s22, s13, #33
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        scvtf d21, d12, #65
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        scvtf d21, s12, #31
// CHECK-ERROR:                   ^

//----------------------------------------------------------------------
// Scalar Unsigned Fixed-point Convert To Floating-Point (Immediate)
//----------------------------------------------------------------------

    ucvtf s22, s13, #34
    ucvtf d21, d14, #65
    ucvtf d21, s14, #64
        
// CHECK-ERROR: error: expected integer in range [1, 32]
// CHECK-ERROR:        ucvtf s22, s13, #34
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: expected integer in range [1, 64]
// CHECK-ERROR:        ucvtf d21, d14, #65
// CHECK-ERROR:                        ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:        ucvtf d21, s14, #64
// CHECK-ERROR:                   ^
