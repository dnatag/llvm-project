//===-- ThreadKDP.h ---------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef liblldb_ThreadKDP_h_
#define liblldb_ThreadKDP_h_

#include <string>

#include "lldb/Target/Process.h"
#include "lldb/Target/Thread.h"

class ProcessKDP;

class ThreadKDP : public lldb_private::Thread
{
public:
    ThreadKDP (const lldb::ProcessSP &process_sp, 
               lldb::tid_t tid);

    virtual
    ~ThreadKDP ();

    virtual bool
    WillResume (lldb::StateType resume_state);

    virtual void
    RefreshStateAfterStop();

    virtual const char *
    GetName ();

    virtual const char *
    GetQueueName ();

    virtual lldb::RegisterContextSP
    GetRegisterContext ();

    virtual lldb::RegisterContextSP
    CreateRegisterContextForFrame (lldb_private::StackFrame *frame);

    virtual void
    ClearStackFrames ();

    void
    Dump (lldb_private::Log *log, uint32_t index);

    static bool
    ThreadIDIsValid (lldb::tid_t thread);

    bool
    ShouldStop (bool &step_more);

    const char *
    GetBasicInfoAsString ();

    void
    SetName (const char *name)
    {
        if (name && name[0])
            m_thread_name.assign (name);
        else
            m_thread_name.clear();
    }

    lldb::addr_t
    GetThreadDispatchQAddr ()
    {
        return m_thread_dispatch_qaddr;
    }

    void
    SetThreadDispatchQAddr (lldb::addr_t thread_dispatch_qaddr)
    {
        m_thread_dispatch_qaddr = thread_dispatch_qaddr;
    }

protected:
    
    friend class ProcessKDP;

    //------------------------------------------------------------------
    // Member variables.
    //------------------------------------------------------------------
    std::string m_thread_name;
    std::string m_dispatch_queue_name;
    lldb::addr_t m_thread_dispatch_qaddr;
    //------------------------------------------------------------------
    // Member variables.
    //------------------------------------------------------------------

    virtual lldb::StopInfoSP
    GetPrivateStopReason ();


};

#endif  // liblldb_ThreadKDP_h_
