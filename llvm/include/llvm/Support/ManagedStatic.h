//===-- llvm/Support/ManagedStatic.h - Static Global wrapper ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the ManagedStatic class and the llvm_shutdown() function.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_MANAGED_STATIC_H
#define LLVM_SUPPORT_MANAGED_STATIC_H

#include "llvm/System/Atomic.h"
#include "llvm/System/Threading.h"

namespace llvm {

/// object_creator - Helper method for ManagedStatic.
template<class C>
void* object_creator() {
  return new C();
}

/// object_deleter - Helper method for ManagedStatic.
///
template<class C>
void object_deleter(void *Ptr) {
  delete (C*)Ptr;
}

/// ManagedStaticBase - Common base class for ManagedStatic instances.
class ManagedStaticBase {
protected:
  // This should only be used as a static variable, which guarantees that this
  // will be zero initialized.
  mutable void *Ptr;
  mutable void (*DeleterFn)(void*);
  mutable const ManagedStaticBase *Next;

  void RegisterManagedStatic(void *(*creator)(), void (*deleter)(void*)) const;
public:
  /// isConstructed - Return true if this object has not been created yet.
  bool isConstructed() const { return Ptr != 0; }

  void destroy() const;
};

/// ManagedStatic - This transparently changes the behavior of global statics to
/// be lazily constructed on demand (good for reducing startup times of dynamic
/// libraries that link in LLVM components) and for making destruction be
/// explicit through the llvm_shutdown() function call.
///
template<class C>
class ManagedStatic : public ManagedStaticBase {
public:

  // Accessors.
  C &operator*() {
    void* tmp = Ptr;
    sys::MemoryFence();
    if (!tmp) RegisterManagedStatic(object_creator<C>, object_deleter<C>);

    return *static_cast<C*>(Ptr);
  }
  C *operator->() {
    void* tmp = Ptr;
    sys::MemoryFence();
    if (!tmp) RegisterManagedStatic(object_creator<C>, object_deleter<C>);

    return static_cast<C*>(Ptr);
  }
  const C &operator*() const {
    void* tmp = Ptr;
    sys::MemoryFence();
    if (!tmp) RegisterManagedStatic(object_creator<C>, object_deleter<C>);

    return *static_cast<C*>(Ptr);
  }
  const C *operator->() const {
    void* tmp = Ptr;
    sys::MemoryFence();
    if (!tmp) RegisterManagedStatic(object_creator<C>, object_deleter<C>);

    return static_cast<C*>(Ptr);
  }
};

template<void (*CleanupFn)(void*)>
class ManagedCleanup : public ManagedStaticBase {
public:
  void Register() { RegisterManagedStatic(0, CleanupFn); }
};

/// llvm_shutdown - Deallocate and destroy all ManagedStatic variables.
void llvm_shutdown();


/// llvm_shutdown_obj - This is a simple helper class that calls
/// llvm_shutdown() when it is destroyed.
struct llvm_shutdown_obj {
  llvm_shutdown_obj() { }
  explicit llvm_shutdown_obj(bool multithreaded) {
    if (multithreaded) llvm_start_multithreaded();
  }
  ~llvm_shutdown_obj() { llvm_shutdown(); }
};

}

#endif
