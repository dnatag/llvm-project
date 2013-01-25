//===- XCoreDisassembler.cpp - Disassembler for XCore -----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief This file is part of the XCore Disassembler.
///
//===----------------------------------------------------------------------===//

#include "XCore.h"
#include "XCoreRegisterInfo.h"
#include "llvm/MC/MCDisassembler.h"
#include "llvm/MC/MCFixedLenDisassembler.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/MemoryObject.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

typedef MCDisassembler::DecodeStatus DecodeStatus;

namespace {

/// \brief A disassembler class for XCore.
class XCoreDisassembler : public MCDisassembler {
  const MCRegisterInfo *RegInfo;
public:
  XCoreDisassembler(const MCSubtargetInfo &STI, const MCRegisterInfo *Info) :
    MCDisassembler(STI), RegInfo(Info) {}

  /// \brief See MCDisassembler.
  virtual DecodeStatus getInstruction(MCInst &instr,
                                      uint64_t &size,
                                      const MemoryObject &region,
                                      uint64_t address,
                                      raw_ostream &vStream,
                                      raw_ostream &cStream) const;

  const MCRegisterInfo *getRegInfo() const { return RegInfo; }
};
}

static bool readInstruction16(const MemoryObject &region,
                              uint64_t address,
                              uint64_t &size,
                              uint16_t &insn) {
  uint8_t Bytes[4];

  // We want to read exactly 2 Bytes of data.
  if (region.readBytes(address, 2, Bytes, NULL) == -1) {
    size = 0;
    return false;
  }
  // Encoded as a little-endian 16-bit word in the stream.
  insn = (Bytes[0] <<  0) | (Bytes[1] <<  8);
  return true;
}

static bool readInstruction32(const MemoryObject &region,
                              uint64_t address,
                              uint64_t &size,
                              uint32_t &insn) {
  uint8_t Bytes[4];

  // We want to read exactly 4 Bytes of data.
  if (region.readBytes(address, 4, Bytes, NULL) == -1) {
    size = 0;
    return false;
  }
  // Encoded as a little-endian 32-bit word in the stream.
  insn = (Bytes[0] << 0) | (Bytes[1] << 8) | (Bytes[2] << 16) |
         (Bytes[3] << 24);
  return true;
}

static unsigned getReg(const void *D, unsigned RC, unsigned RegNo) {
  const XCoreDisassembler *Dis = static_cast<const XCoreDisassembler*>(D);
  return *(Dis->getRegInfo()->getRegClass(RC).begin() + RegNo);
}

static DecodeStatus DecodeGRRegsRegisterClass(MCInst &Inst,
                                              unsigned RegNo,
                                              uint64_t Address,
                                              const void *Decoder);

static DecodeStatus DecodeBitpOperand(MCInst &Inst, unsigned Val,
                                      uint64_t Address, const void *Decoder);

static DecodeStatus DecodeMEMiiOperand(MCInst &Inst, unsigned Val,
                                       uint64_t Address, const void *Decoder);

static DecodeStatus Decode2RInstruction(MCInst &Inst,
                                        unsigned Insn,
                                        uint64_t Address,
                                        const void *Decoder);

static DecodeStatus DecodeR2RInstruction(MCInst &Inst,
                                         unsigned Insn,
                                         uint64_t Address,
                                         const void *Decoder);

static DecodeStatus Decode2RSrcDstInstruction(MCInst &Inst,
                                              unsigned Insn,
                                              uint64_t Address,
                                              const void *Decoder);

static DecodeStatus DecodeRUSInstruction(MCInst &Inst,
                                         unsigned Insn,
                                         uint64_t Address,
                                         const void *Decoder);

static DecodeStatus DecodeRUSBitpInstruction(MCInst &Inst,
                                             unsigned Insn,
                                             uint64_t Address,
                                             const void *Decoder);

static DecodeStatus DecodeRUSSrcDstBitpInstruction(MCInst &Inst,
                                                   unsigned Insn,
                                                   uint64_t Address,
                                                   const void *Decoder);

static DecodeStatus DecodeL2RInstruction(MCInst &Inst,
                                         unsigned Insn,
                                         uint64_t Address,
                                         const void *Decoder);

static DecodeStatus DecodeLR2RInstruction(MCInst &Inst,
                                          unsigned Insn,
                                          uint64_t Address,
                                          const void *Decoder);

static DecodeStatus Decode3RInstruction(MCInst &Inst,
                                        unsigned Insn,
                                        uint64_t Address,
                                        const void *Decoder);

static DecodeStatus Decode2RUSInstruction(MCInst &Inst,
                                          unsigned Insn,
                                          uint64_t Address,
                                          const void *Decoder);

static DecodeStatus Decode2RUSBitpInstruction(MCInst &Inst,
                                              unsigned Insn,
                                              uint64_t Address,
                                              const void *Decoder);

static DecodeStatus DecodeL3RInstruction(MCInst &Inst,
                                         unsigned Insn,
                                         uint64_t Address,
                                         const void *Decoder);

static DecodeStatus DecodeL3RSrcDstInstruction(MCInst &Inst,
                                               unsigned Insn,
                                               uint64_t Address,
                                               const void *Decoder);

static DecodeStatus DecodeL2RUSInstruction(MCInst &Inst,
                                           unsigned Insn,
                                           uint64_t Address,
                                           const void *Decoder);

static DecodeStatus DecodeL2RUSBitpInstruction(MCInst &Inst,
                                               unsigned Insn,
                                               uint64_t Address,
                                               const void *Decoder);

static DecodeStatus DecodeL6RInstruction(MCInst &Inst,
                                         unsigned Insn,
                                         uint64_t Address,
                                         const void *Decoder);

static DecodeStatus DecodeL5RInstruction(MCInst &Inst,
                                         unsigned Insn,
                                         uint64_t Address,
                                         const void *Decoder);

#include "XCoreGenDisassemblerTables.inc"

static DecodeStatus DecodeGRRegsRegisterClass(MCInst &Inst,
                                              unsigned RegNo,
                                              uint64_t Address,
                                              const void *Decoder)
{
  if (RegNo > 11)
    return MCDisassembler::Fail;
  unsigned Reg = getReg(Decoder, XCore::GRRegsRegClassID, RegNo);
  Inst.addOperand(MCOperand::CreateReg(Reg));
  return MCDisassembler::Success;
}

static DecodeStatus DecodeBitpOperand(MCInst &Inst, unsigned Val,
                                      uint64_t Address, const void *Decoder) {
  if (Val > 11)
    return MCDisassembler::Fail;
  static unsigned Values[] = {
    32 /*bpw*/, 1, 2, 3, 4, 5, 6, 7, 8, 16, 24, 32
  };
  Inst.addOperand(MCOperand::CreateImm(Values[Val]));
  return MCDisassembler::Success;
}

static DecodeStatus DecodeMEMiiOperand(MCInst &Inst, unsigned Val,
                                       uint64_t Address, const void *Decoder) {
  Inst.addOperand(MCOperand::CreateImm(Val));
  Inst.addOperand(MCOperand::CreateImm(0));
  return MCDisassembler::Success;
}

static DecodeStatus
Decode2OpInstruction(unsigned Insn, unsigned &Op1, unsigned &Op2) {
  unsigned Combined = fieldFromInstruction(Insn, 6, 5);
  if (Combined < 27)
    return MCDisassembler::Fail;
  if (fieldFromInstruction(Insn, 5, 1)) {
    if (Combined == 31)
      return MCDisassembler::Fail;
    Combined += 5;
  }
  Combined -= 27;
  unsigned Op1High = Combined % 3;
  unsigned Op2High = Combined / 3;
  Op1 = (Op1High << 2) | fieldFromInstruction(Insn, 2, 2);
  Op2 = (Op2High << 2) | fieldFromInstruction(Insn, 0, 2);
  return MCDisassembler::Success;
}

static DecodeStatus
Decode3OpInstruction(unsigned Insn, unsigned &Op1, unsigned &Op2,
                     unsigned &Op3) {
  unsigned Combined = fieldFromInstruction(Insn, 6, 5);
  if (Combined >= 27)
    return MCDisassembler::Fail;

  unsigned Op1High = Combined % 3;
  unsigned Op2High = (Combined / 3) % 3;
  unsigned Op3High = Combined / 9;
  Op1 = (Op1High << 2) | fieldFromInstruction(Insn, 4, 2);
  Op2 = (Op2High << 2) | fieldFromInstruction(Insn, 2, 2);
  Op3 = (Op3High << 2) | fieldFromInstruction(Insn, 0, 2);
  return MCDisassembler::Success;
}

static DecodeStatus
Decode2OpInstructionFail(MCInst &Inst, unsigned Insn, uint64_t Address,
                         const void *Decoder) {
  // Try and decode as a 3R instruction.
  unsigned Opcode = fieldFromInstruction(Insn, 11, 5);
  switch (Opcode) {
  case 0x0:
    Inst.setOpcode(XCore::STW_2rus);
    return Decode2RUSInstruction(Inst, Insn, Address, Decoder);
  case 0x1:
    Inst.setOpcode(XCore::LDW_2rus);
    return Decode2RUSInstruction(Inst, Insn, Address, Decoder);
  case 0x2:
    Inst.setOpcode(XCore::ADD_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x3:
    Inst.setOpcode(XCore::SUB_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x4:
    Inst.setOpcode(XCore::SHL_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x5:
    Inst.setOpcode(XCore::SHR_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x6:
    Inst.setOpcode(XCore::EQ_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x7:
    Inst.setOpcode(XCore::AND_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x8:
    Inst.setOpcode(XCore::OR_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x9:
    Inst.setOpcode(XCore::LDW_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x10:
    Inst.setOpcode(XCore::LD16S_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x11:
    Inst.setOpcode(XCore::LD8U_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x12:
    Inst.setOpcode(XCore::ADD_2rus);
    return Decode2RUSInstruction(Inst, Insn, Address, Decoder);
  case 0x13:
    Inst.setOpcode(XCore::SUB_2rus);
    return Decode2RUSInstruction(Inst, Insn, Address, Decoder);
  case 0x14:
    Inst.setOpcode(XCore::SHL_2rus);
    return Decode2RUSBitpInstruction(Inst, Insn, Address, Decoder);
  case 0x15:
    Inst.setOpcode(XCore::SHR_2rus);
    return Decode2RUSBitpInstruction(Inst, Insn, Address, Decoder);
  case 0x16:
    Inst.setOpcode(XCore::EQ_2rus);
    return Decode2RUSInstruction(Inst, Insn, Address, Decoder);
  case 0x18:
    Inst.setOpcode(XCore::LSS_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  case 0x19:
    Inst.setOpcode(XCore::LSU_3r);
    return Decode3RInstruction(Inst, Insn, Address, Decoder);
  }
  return MCDisassembler::Fail;
}

static DecodeStatus
Decode2RInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                    const void *Decoder) {
  unsigned Op1, Op2;
  DecodeStatus S = Decode2OpInstruction(Insn, Op1, Op2);
  if (S != MCDisassembler::Success)
    return Decode2OpInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
  return S;
}

static DecodeStatus
DecodeR2RInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                     const void *Decoder) {
  unsigned Op1, Op2;
  DecodeStatus S = Decode2OpInstruction(Insn, Op2, Op1);
  if (S != MCDisassembler::Success)
    return Decode2OpInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
  return S;
}

static DecodeStatus
Decode2RSrcDstInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                          const void *Decoder) {
  unsigned Op1, Op2;
  DecodeStatus S = Decode2OpInstruction(Insn, Op1, Op2);
  if (S != MCDisassembler::Success)
    return Decode2OpInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
  return S;
}

static DecodeStatus
DecodeRUSInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                     const void *Decoder) {
  unsigned Op1, Op2;
  DecodeStatus S = Decode2OpInstruction(Insn, Op1, Op2);
  if (S != MCDisassembler::Success)
    return Decode2OpInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  Inst.addOperand(MCOperand::CreateImm(Op2));
  return S;
}

static DecodeStatus
DecodeRUSBitpInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                         const void *Decoder) {
  unsigned Op1, Op2;
  DecodeStatus S = Decode2OpInstruction(Insn, Op1, Op2);
  if (S != MCDisassembler::Success)
    return Decode2OpInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeBitpOperand(Inst, Op2, Address, Decoder);
  return S;
}

static DecodeStatus
DecodeRUSSrcDstBitpInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                               const void *Decoder) {
  unsigned Op1, Op2;
  DecodeStatus S = Decode2OpInstruction(Insn, Op1, Op2);
  if (S != MCDisassembler::Success)
    return Decode2OpInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeBitpOperand(Inst, Op2, Address, Decoder);
  return S;
}

static DecodeStatus
DecodeL2OpInstructionFail(MCInst &Inst, unsigned Insn, uint64_t Address,
                          const void *Decoder) {
  // Try and decode as a L3R / L2RUS instruction.
  unsigned Opcode = fieldFromInstruction(Insn, 16, 4) |
                    fieldFromInstruction(Insn, 27, 5) << 4;
  switch (Opcode) {
  case 0x0c:
    Inst.setOpcode(XCore::STW_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x1c:
    Inst.setOpcode(XCore::XOR_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x2c:
    Inst.setOpcode(XCore::ASHR_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x3c:
    Inst.setOpcode(XCore::LDAWF_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x4c:
    Inst.setOpcode(XCore::LDAWB_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x5c:
    Inst.setOpcode(XCore::LDA16F_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x6c:
    Inst.setOpcode(XCore::LDA16B_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x7c:
    Inst.setOpcode(XCore::MUL_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x8c:
    Inst.setOpcode(XCore::DIVS_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x9c:
    Inst.setOpcode(XCore::DIVU_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x10c:
    Inst.setOpcode(XCore::ST16_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x11c:
    Inst.setOpcode(XCore::ST8_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x12c:
    Inst.setOpcode(XCore::ASHR_l2rus);
    return DecodeL2RUSBitpInstruction(Inst, Insn, Address, Decoder);
  case 0x13c:
    Inst.setOpcode(XCore::LDAWF_l2rus);
    return DecodeL2RUSInstruction(Inst, Insn, Address, Decoder);
  case 0x14c:
    Inst.setOpcode(XCore::LDAWB_l2rus);
    return DecodeL2RUSInstruction(Inst, Insn, Address, Decoder);
  case 0x15c:
    Inst.setOpcode(XCore::CRC_l3r);
    return DecodeL3RSrcDstInstruction(Inst, Insn, Address, Decoder);
  case 0x18c:
    Inst.setOpcode(XCore::REMS_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  case 0x19c:
    Inst.setOpcode(XCore::REMU_l3r);
    return DecodeL3RInstruction(Inst, Insn, Address, Decoder);
  }
  return MCDisassembler::Fail;
}

static DecodeStatus
DecodeL2RInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                               const void *Decoder) {
  unsigned Op1, Op2;
  DecodeStatus S = Decode2OpInstruction(fieldFromInstruction(Insn, 0, 16),
                                        Op1, Op2);
  if (S != MCDisassembler::Success)
    return DecodeL2OpInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
  return S;
}

static DecodeStatus
DecodeLR2RInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                               const void *Decoder) {
  unsigned Op1, Op2;
  DecodeStatus S = Decode2OpInstruction(fieldFromInstruction(Insn, 0, 16),
                                        Op1, Op2);
  if (S != MCDisassembler::Success)
    return DecodeL2OpInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  return S;
}

static DecodeStatus
Decode3RInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                    const void *Decoder) {
  unsigned Op1, Op2, Op3;
  DecodeStatus S = Decode3OpInstruction(Insn, Op1, Op2, Op3);
  if (S == MCDisassembler::Success) {
    DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op3, Address, Decoder);
  }
  return S;
}

static DecodeStatus
Decode2RUSInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                      const void *Decoder) {
  unsigned Op1, Op2, Op3;
  DecodeStatus S = Decode3OpInstruction(Insn, Op1, Op2, Op3);
  if (S == MCDisassembler::Success) {
    DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
    Inst.addOperand(MCOperand::CreateImm(Op3));
  }
  return S;
}

static DecodeStatus
Decode2RUSBitpInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                      const void *Decoder) {
  unsigned Op1, Op2, Op3;
  DecodeStatus S = Decode3OpInstruction(Insn, Op1, Op2, Op3);
  if (S == MCDisassembler::Success) {
    DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
    DecodeBitpOperand(Inst, Op3, Address, Decoder);
  }
  return S;
}

static DecodeStatus
DecodeL3RInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                     const void *Decoder) {
  unsigned Op1, Op2, Op3;
  DecodeStatus S =
    Decode3OpInstruction(fieldFromInstruction(Insn, 0, 16), Op1, Op2, Op3);
  if (S == MCDisassembler::Success) {
    DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op3, Address, Decoder);
  }
  return S;
}

static DecodeStatus
DecodeL3RSrcDstInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                           const void *Decoder) {
  unsigned Op1, Op2, Op3;
  DecodeStatus S =
  Decode3OpInstruction(fieldFromInstruction(Insn, 0, 16), Op1, Op2, Op3);
  if (S == MCDisassembler::Success) {
    DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op3, Address, Decoder);
  }
  return S;
}

static DecodeStatus
DecodeL2RUSInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                       const void *Decoder) {
  unsigned Op1, Op2, Op3;
  DecodeStatus S =
  Decode3OpInstruction(fieldFromInstruction(Insn, 0, 16), Op1, Op2, Op3);
  if (S == MCDisassembler::Success) {
    DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
    Inst.addOperand(MCOperand::CreateImm(Op3));
  }
  return S;
}

static DecodeStatus
DecodeL2RUSBitpInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                           const void *Decoder) {
  unsigned Op1, Op2, Op3;
  DecodeStatus S =
  Decode3OpInstruction(fieldFromInstruction(Insn, 0, 16), Op1, Op2, Op3);
  if (S == MCDisassembler::Success) {
    DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
    DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
    DecodeBitpOperand(Inst, Op3, Address, Decoder);
  }
  return S;
}

static DecodeStatus
DecodeL6RInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                     const void *Decoder) {
  unsigned Op1, Op2, Op3, Op4, Op5, Op6;
  DecodeStatus S =
    Decode3OpInstruction(fieldFromInstruction(Insn, 0, 16), Op1, Op2, Op3);
  if (S != MCDisassembler::Success)
    return S;
  S = Decode3OpInstruction(fieldFromInstruction(Insn, 16, 16), Op4, Op5, Op6);
  if (S != MCDisassembler::Success)
    return S;
  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op4, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op3, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op5, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op6, Address, Decoder);
  return S;
}

static DecodeStatus
DecodeL5RInstructionFail(MCInst &Inst, unsigned Insn, uint64_t Address,
                     const void *Decoder) {
  // Try and decode as a L6R instruction.
  Inst.clear();
  unsigned Opcode = fieldFromInstruction(Insn, 27, 5);
  switch (Opcode) {
  case 0x00:
    Inst.setOpcode(XCore::LMUL_l6r);
    return DecodeL6RInstruction(Inst, Insn, Address, Decoder);
  }
  return MCDisassembler::Fail;
}

static DecodeStatus
DecodeL5RInstruction(MCInst &Inst, unsigned Insn, uint64_t Address,
                     const void *Decoder) {
  unsigned Op1, Op2, Op3, Op4, Op5;
  DecodeStatus S =
    Decode3OpInstruction(fieldFromInstruction(Insn, 0, 16), Op1, Op2, Op3);
  if (S != MCDisassembler::Success)
    return DecodeL5RInstructionFail(Inst, Insn, Address, Decoder);
  S = Decode2OpInstruction(fieldFromInstruction(Insn, 16, 16), Op4, Op5);
  if (S != MCDisassembler::Success)
    return DecodeL5RInstructionFail(Inst, Insn, Address, Decoder);

  DecodeGRRegsRegisterClass(Inst, Op1, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op4, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op2, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op3, Address, Decoder);
  DecodeGRRegsRegisterClass(Inst, Op5, Address, Decoder);
  return S;
}

MCDisassembler::DecodeStatus
XCoreDisassembler::getInstruction(MCInst &instr,
                                  uint64_t &Size,
                                  const MemoryObject &Region,
                                  uint64_t Address,
                                  raw_ostream &vStream,
                                  raw_ostream &cStream) const {
  uint16_t insn16;

  if (!readInstruction16(Region, Address, Size, insn16)) {
    return Fail;
  }

  // Calling the auto-generated decoder function.
  DecodeStatus Result = decodeInstruction(DecoderTable16, instr, insn16,
                                          Address, this, STI);
  if (Result != Fail) {
    Size = 2;
    return Result;
  }

  uint32_t insn32;

  if (!readInstruction32(Region, Address, Size, insn32)) {
    return Fail;
  }

  // Calling the auto-generated decoder function.
  Result = decodeInstruction(DecoderTable32, instr, insn32, Address, this, STI);
  if (Result != Fail) {
    Size = 4;
    return Result;
  }

  return Fail;
}

namespace llvm {
  extern Target TheXCoreTarget;
}

static MCDisassembler *createXCoreDisassembler(const Target &T,
                                               const MCSubtargetInfo &STI) {
  return new XCoreDisassembler(STI, T.createMCRegInfo(""));
}

extern "C" void LLVMInitializeXCoreDisassembler() {
  // Register the disassembler.
  TargetRegistry::RegisterMCDisassembler(TheXCoreTarget,
                                         createXCoreDisassembler);
}
