//===-- ThreadMachCore.cpp --------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//


#include "ThreadMachCore.h"

#include "llvm/Support/MachO.h"

#include "lldb/Core/ArchSpec.h"
#include "lldb/Core/DataExtractor.h"
#include "lldb/Core/StreamString.h"
#include "lldb/Core/State.h"
#include "lldb/Symbol/ObjectFile.h"
#include "lldb/Target/Process.h"
#include "lldb/Target/RegisterContext.h"
#include "lldb/Target/StopInfo.h"
#include "lldb/Target/Target.h"
#include "lldb/Target/Unwind.h"
#include "lldb/Breakpoint/Watchpoint.h"

#include "ProcessMachCore.h"
//#include "RegisterContextKDP_arm.h"
//#include "RegisterContextKDP_i386.h"
//#include "RegisterContextKDP_x86_64.h"

using namespace lldb;
using namespace lldb_private;

//----------------------------------------------------------------------
// Thread Registers
//----------------------------------------------------------------------

ThreadMachCore::ThreadMachCore (Process &process, lldb::tid_t tid) :
    Thread(process, tid),
    m_thread_name (),
    m_dispatch_queue_name (),
    m_thread_dispatch_qaddr (LLDB_INVALID_ADDRESS),
    m_thread_reg_ctx_sp ()
{
}

ThreadMachCore::~ThreadMachCore ()
{
    DestroyThread();
}

const char *
ThreadMachCore::GetName ()
{
    if (m_thread_name.empty())
        return NULL;
    return m_thread_name.c_str();
}

void
ThreadMachCore::RefreshStateAfterStop()
{
    // Invalidate all registers in our register context. We don't set "force" to
    // true because the stop reply packet might have had some register values
    // that were expedited and these will already be copied into the register
    // context by the time this function gets called. The KDPRegisterContext
    // class has been made smart enough to detect when it needs to invalidate
    // which registers are valid by putting hooks in the register read and 
    // register supply functions where they check the process stop ID and do
    // the right thing.
    const bool force = false;
    GetRegisterContext()->InvalidateIfNeeded (force);
}

bool
ThreadMachCore::ThreadIDIsValid (lldb::tid_t thread)
{
    return thread != 0;
}

lldb::RegisterContextSP
ThreadMachCore::GetRegisterContext ()
{
    if (m_reg_context_sp.get() == NULL)
        m_reg_context_sp = CreateRegisterContextForFrame (NULL);
    return m_reg_context_sp;
}

lldb::RegisterContextSP
ThreadMachCore::CreateRegisterContextForFrame (Frame *frame)
{
    lldb::RegisterContextSP reg_ctx_sp;
    uint32_t concrete_frame_idx = 0;
    
    if (frame)
        concrete_frame_idx = frame->GetConcreteFrameIndex ();

    if (concrete_frame_idx == 0)
    {
        if (!m_thread_reg_ctx_sp)
        {
            ProcessSP process_sp (GetProcess());
            
            ObjectFile *core_objfile = static_cast<ProcessMachCore *>(process_sp.get())->GetCoreObjectFile ();
            if (core_objfile)
                m_thread_reg_ctx_sp = core_objfile->GetThreadContextAtIndex (GetID(), *this);
        }
        reg_ctx_sp = m_thread_reg_ctx_sp;
    }
    else
    {
        Unwind *unwinder = GetUnwinder ();
        if (unwinder)
            reg_ctx_sp = unwinder->CreateRegisterContextForFrame (frame);
    }
    return reg_ctx_sp;
}

bool
ThreadMachCore::CalculateStopInfo ()
{
    ProcessSP process_sp (GetProcess());
    if (process_sp)
    {
        SetStopInfo(StopInfo::CreateStopReasonWithSignal (*this, SIGSTOP));
        return true;
    }
    return false;
}


