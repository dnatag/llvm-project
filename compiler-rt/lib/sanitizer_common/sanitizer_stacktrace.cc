//===-- sanitizer_stacktrace.cc -------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file is shared between AddressSanitizer and ThreadSanitizer
// run-time libraries.
//===----------------------------------------------------------------------===//

#include "sanitizer_common.h"
#include "sanitizer_flags.h"
#include "sanitizer_procmaps.h"
#include "sanitizer_stacktrace.h"
#include "sanitizer_symbolizer.h"

namespace __sanitizer {

uptr StackTrace::GetPreviousInstructionPc(uptr pc) {
#ifdef __arm__
  // Cancel Thumb bit.
  pc = pc & (~1);
#endif
#if defined(__powerpc__) || defined(__powerpc64__)
  // PCs are always 4 byte aligned.
  return pc - 4;
#elif defined(__sparc__)
  return pc - 8;
#else
  return pc - 1;
#endif
}

static void PrintStackFramePrefix(uptr frame_num, uptr pc) {
  Printf("    #%zu 0x%zx", frame_num, pc);
}

void StackTrace::PrintStack(const uptr *addr, uptr size,
                            SymbolizeCallback symbolize_callback) {
  if (addr == 0) {
    Printf("<empty stack>\n\n");
    return;
  }
  MemoryMappingLayout proc_maps(/*cache_enabled*/true);
  InternalScopedBuffer<char> buff(GetPageSizeCached() * 2);
  InternalScopedBuffer<AddressInfo> addr_frames(64);
  uptr frame_num = 0;
  for (uptr i = 0; i < size && addr[i]; i++) {
    // PCs in stack traces are actually the return addresses, that is,
    // addresses of the next instructions after the call.
    uptr pc = GetPreviousInstructionPc(addr[i]);
    uptr addr_frames_num = 0;  // The number of stack frames for current
                               // instruction address.
    if (symbolize_callback) {
      if (symbolize_callback((void*)pc, buff.data(), buff.size())) {
        addr_frames_num = 1;
        PrintStackFramePrefix(frame_num, pc);
        // We can't know anything about the string returned by external
        // symbolizer, but if it starts with filename, try to strip path prefix
        // from it.
        Printf(" %s\n",
               StripPathPrefix(buff.data(), common_flags()->strip_path_prefix));
        frame_num++;
      }
    }
    if (common_flags()->symbolize && addr_frames_num == 0) {
      // Use our own (online) symbolizer, if necessary.
      if (Symbolizer *sym = Symbolizer::GetOrNull())
        addr_frames_num =
            sym->SymbolizeCode(pc, addr_frames.data(), addr_frames.size());
      for (uptr j = 0; j < addr_frames_num; j++) {
        AddressInfo &info = addr_frames[j];
        PrintStackFramePrefix(frame_num, pc);
        if (info.function) {
          Printf(" in %s", info.function);
        }
        if (info.file) {
          Printf(" ");
          PrintSourceLocation(info.file, info.line, info.column);
        } else if (info.module) {
          Printf(" ");
          PrintModuleAndOffset(info.module, info.module_offset);
        }
        Printf("\n");
        info.Clear();
        frame_num++;
      }
    }
    if (addr_frames_num == 0) {
      // If online symbolization failed, try to output at least module and
      // offset for instruction.
      PrintStackFramePrefix(frame_num, pc);
      uptr offset;
      if (proc_maps.GetObjectNameAndOffset(pc, &offset,
                                           buff.data(), buff.size(),
                                           /* protection */0)) {
        Printf(" ");
        PrintModuleAndOffset(buff.data(), offset);
      }
      Printf("\n");
      frame_num++;
    }
  }
  // Always print a trailing empty line after stack trace.
  Printf("\n");
}

uptr StackTrace::GetCurrentPc() {
  return GET_CALLER_PC();
}

void StackTrace::FastUnwindStack(uptr pc, uptr bp,
                                 uptr stack_top, uptr stack_bottom,
                                 uptr max_depth) {
  if (max_depth == 0) {
    size = 0;
    return;
  }
  trace[0] = pc;
  size = 1;
  uhwptr *frame = (uhwptr *)bp;
  uhwptr *prev_frame = frame - 1;
  if (stack_top < 4096) return;  // Sanity check for stack top.
  // Avoid infinite loop when frame == frame[0] by using frame > prev_frame.
  while (frame > prev_frame &&
         frame < (uhwptr *)stack_top - 2 &&
         frame > (uhwptr *)stack_bottom &&
         IsAligned((uptr)frame, sizeof(*frame)) &&
         size < max_depth) {
    uhwptr pc1 = frame[1];
    if (pc1 != pc) {
      trace[size++] = (uptr) pc1;
    }
    prev_frame = frame;
    frame = (uhwptr *)frame[0];
  }
}

void StackTrace::PopStackFrames(uptr count) {
  CHECK(size >= count);
  size -= count;
  for (uptr i = 0; i < size; i++) {
    trace[i] = trace[i + count];
  }
}

}  // namespace __sanitizer
