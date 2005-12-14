; RUN: llvm-as < %s | opt -scalarrepl -disable-output
target endian = big
target pointersize = 32
	%struct.rtx_def = type { [2 x ubyte], int, [1 x %union.rtunion_def] }
	%union.rtunion_def = type { uint }

implementation   ; Functions:

void %find_reloads() {
entry:
	%c_addr.i = alloca sbyte		; <sbyte*> [#uses=1]
	switch uint 0, label %return [
		 uint 36, label %label.7
		 uint 34, label %label.7
		 uint 41, label %label.5
	]

label.5:		; preds = %entry
	ret void

label.7:		; preds = %entry, %entry
	br bool false, label %then.4, label %switchexit.0

then.4:		; preds = %label.7
	%tmp.0.i = cast sbyte* %c_addr.i to int*		; <int*> [#uses=1]
	store int 44, int* %tmp.0.i
	ret void

switchexit.0:		; preds = %label.7
	ret void

return:		; preds = %entry
	ret void
}
