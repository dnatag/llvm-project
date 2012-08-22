//===-- OptionValueBoolean.h ------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef liblldb_OptionValueBoolean_h_
#define liblldb_OptionValueBoolean_h_

// C Includes
// C++ Includes
// Other libraries and framework includes
// Project includes
#include "lldb/Interpreter/OptionValue.h"

namespace lldb_private {

class OptionValueBoolean : public OptionValue
{
public:
    OptionValueBoolean (bool value) :
        OptionValue(),
        m_current_value (value),
        m_default_value (value)
    {
    }
    OptionValueBoolean (bool current_value,
                        bool default_value) :
        OptionValue(),
        m_current_value (current_value),
        m_default_value (default_value)
    {
    }
    
    virtual 
    ~OptionValueBoolean()
    {
    }
    
    //---------------------------------------------------------------------
    // Virtual subclass pure virtual overrides
    //---------------------------------------------------------------------
    
    virtual OptionValue::Type
    GetType () const
    {
        return eTypeBoolean;
    }
    
    virtual void
    DumpValue (const ExecutionContext *exe_ctx, Stream &strm, uint32_t dump_mask);
    
    virtual Error
    SetValueFromCString (const char *value,
                         VarSetOperationType op = eVarSetOperationAssign);
    
    virtual bool
    Clear ()
    {
        m_current_value = m_default_value;
        m_value_was_set = false;
        return true;
    }
    
    //---------------------------------------------------------------------
    // Subclass specific functions
    //---------------------------------------------------------------------
    
    //------------------------------------------------------------------
    /// Convert to bool operator.
    ///
    /// This allows code to check a OptionValueBoolean in conditions.
    ///
    /// @code
    /// OptionValueBoolean bool_value(...);
    /// if (bool_value)
    /// { ...
    /// @endcode
    ///
    /// @return
    ///     /b True this object contains a valid namespace decl, \b 
    ///     false otherwise.
    //------------------------------------------------------------------
    operator bool() const
    {
        return m_current_value;
    }
    
    const bool &
    operator = (bool b)
    {
        m_current_value = b;
        return m_current_value;
    }

    bool
    GetCurrentValue() const
    {
        return m_current_value;
    }
    
    bool
    GetDefaultValue() const
    {
        return m_default_value;
    }
    
    void
    SetCurrentValue (bool value)
    {
        m_current_value = value;
    }
    
    void
    SetDefaultValue (bool value)
    {
        m_default_value = value;
    }
    
    virtual lldb::OptionValueSP
    DeepCopy () const;

protected:
    bool m_current_value;
    bool m_default_value;
};

} // namespace lldb_private

#endif  // liblldb_OptionValueBoolean_h_
