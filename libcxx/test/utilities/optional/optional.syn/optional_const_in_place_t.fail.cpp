//===----------------------------------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

// <optional>

// A program that necessitates the instantiation of template optional for
// (possibly cv-qualified) in_place_t is ill-formed.

#include <optional>

int main()
{
#if _LIBCPP_STD_VER > 11
    std::optional<const std::inplace_t> opt;
#else
#error
#endif  // _LIBCPP_STD_VER > 11
}
