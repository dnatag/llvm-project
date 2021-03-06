//===-- DNBError.cpp --------------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//  Created by Greg Clayton on 6/26/07.
//
//===----------------------------------------------------------------------===//

#include "DNBError.h"
#include "CFString.h"
#include "DNBLog.h"
#include "PThreadMutex.h"

#ifdef WITH_SPRINGBOARD
#include <SpringBoardServices/SpringBoardServer.h>
#endif

const char *
DNBError::AsString() const
{
    if (Success())
        return NULL;

    if (m_str.empty())
    {
        const char *s = NULL;
        switch (m_flavor)
        {
        case MachKernel:
            s = ::mach_error_string (m_err);
            break;

        case POSIX:
            s = ::strerror (m_err);
            break;

#ifdef WITH_SPRINGBOARD
        case SpringBoard:
            {
                CFStringRef statusStr = SBSApplicationLaunchingErrorString (m_err);
                if (CFString::UTF8 (statusStr, m_str) == NULL)
                    m_str.clear();
            }
            break;
#endif
        default:
            break;
        }
        if (s)
            m_str.assign(s);
    }
    if (m_str.empty())
        return NULL;
    return m_str.c_str();
}

void
DNBError::LogThreadedIfError(const char *format, ...) const
{
    if (Fail())
    {
        char *arg_msg = NULL;
        va_list args;
        va_start (args, format);
        ::vasprintf (&arg_msg, format, args);
        va_end (args);

        if (arg_msg != NULL)
        {
            const char *err_str = AsString();
            if (err_str == NULL)
                err_str = "???";
            DNBLogThreaded ("error: %s err = %s (0x%8.8x)", arg_msg, err_str, m_err);
            free (arg_msg);
        }
    }
}

void
DNBError::LogThreaded(const char *format, ...) const
{
    char *arg_msg = NULL;
    va_list args;
    va_start (args, format);
    ::vasprintf (&arg_msg, format, args);
    va_end (args);

    if (arg_msg != NULL)
    {
        if (Fail())
        {
            const char *err_str = AsString();
            if (err_str == NULL)
                err_str = "???";
            DNBLogThreaded ("error: %s err = %s (0x%8.8x)", arg_msg, err_str, m_err);
        }
        else
        {
            DNBLogThreaded ("%s err = 0x%8.8x", arg_msg, m_err);
        }
        free (arg_msg);
    }
}
