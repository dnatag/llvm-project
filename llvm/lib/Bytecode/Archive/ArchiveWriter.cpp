//===-- ArchiveWriter.cpp - Write LLVM archive files ----------------------===//
// 
//                     The LLVM Compiler Infrastructure
//
// This file was developed by Reid Spencer and is distributed under the 
// University of Illinois Open Source License. See LICENSE.TXT for details.
// 
//===----------------------------------------------------------------------===//
//
// Builds up an LLVM archive file (.a) containing LLVM bytecode.
//
//===----------------------------------------------------------------------===//

#include "ArchiveInternals.h"
#include "llvm/Bytecode/Reader.h"
#include "llvm/Support/FileUtilities.h"
#include "llvm/Support/Compressor.h"
#include "llvm/System/Signals.h"
#include <fstream>
#include <iostream>
#include <iomanip>

using namespace llvm;

// Write an integer using variable bit rate encoding. This saves a few bytes
// per entry in the symbol table.
inline void writeInteger(unsigned num, std::ofstream& ARFile) {
  while (1) {
    if (num < 0x80) { // done?
      ARFile << (unsigned char)num;
      return;
    }
    
    // Nope, we are bigger than a character, output the next 7 bits and set the
    // high bit to say that there is more coming...
    ARFile << (unsigned char)(0x80 | ((unsigned char)num & 0x7F));
    num >>= 7;  // Shift out 7 bits now...
  }
}

// Compute how many bytes are taken by a given VBR encoded value. This is needed
// to pre-compute the size of the symbol table.
inline unsigned numVbrBytes(unsigned num) {

  // Note that the following nested ifs are somewhat equivalent to a binary
  // search. We split it in half by comparing against 2^14 first. This allows
  // most reasonable values to be done in 2 comparisons instead of 1 for 
  // small ones and four for large ones. We expect this to access file offsets
  // in the 2^10 to 2^24 range and symbol lengths in the 2^0 to 2^8 range, 
  // so this approach is reasonable.
  if (num < 1<<14)
    if (num < 1<<7)
      return 1;
    else
      return 2;
  if (num < 1<<21)
    return 3;

  if (num < 1<<28)
    return 4;
  return 5; // anything >= 2^28 takes 5 bytes
}

// Create an empty archive.
Archive* 
Archive::CreateEmpty(const sys::Path& FilePath ) {
  Archive* result = new Archive(FilePath,false);
  return result;
}

// Fill the ArchiveMemberHeader with the information from a member. If 
// TruncateNames is true, names are flattened to 15 chars or less. The sz field
// is provided here instead of coming from the mbr because the member might be 
// stored compressed and the compressed size is not the ArchiveMember's size. 
// Furthermore compressed files have negative size fields to identify them as 
// compressed.
bool
Archive::fillHeader(const ArchiveMember &mbr, ArchiveMemberHeader& hdr,
                    int sz, bool TruncateNames) const {

  // Set the permissions mode, uid and gid
  hdr.init();
  char buffer[32];
  sprintf(buffer, "%-8o", mbr.getMode());
  memcpy(hdr.mode,buffer,8);
  sprintf(buffer,  "%-6u", mbr.getUser());
  memcpy(hdr.uid,buffer,6);
  sprintf(buffer,  "%-6u", mbr.getGroup());
  memcpy(hdr.gid,buffer,6);

  // Set the last modification date
  uint64_t secondsSinceEpoch = mbr.getModTime().toEpochTime();
  sprintf(buffer,"%-12u", unsigned(secondsSinceEpoch));
  memcpy(hdr.date,buffer,12);

  // Get rid of trailing blanks in the name
  std::string mbrPath = mbr.getPath().get();
  size_t mbrLen = mbrPath.length();
  while (mbrLen > 0 && mbrPath[mbrLen-1] == ' ') {
    mbrPath.erase(mbrLen-1,1);
    mbrLen--;
  }

  // Set the name field in one of its various flavors.
  bool writeLongName = false;
  if (mbr.isStringTable()) {
    memcpy(hdr.name,ARFILE_STRTAB_NAME,16);
  } else if (mbr.isForeignSymbolTable()) {
    memcpy(hdr.name,ARFILE_SYMTAB_NAME,16);
  } else if (mbr.isLLVMSymbolTable()) {
    memcpy(hdr.name,ARFILE_LLVM_SYMTAB_NAME,16);
  } else if (TruncateNames) {
    const char* nm = mbrPath.c_str();
    unsigned len = mbrPath.length();
    size_t slashpos = mbrPath.rfind('/');
    if (slashpos != std::string::npos) {
      nm += slashpos + 1;
      len -= slashpos +1;
    }
    if (len > 15) 
      len = 15;
    memcpy(hdr.name,nm,len);
    hdr.name[len] = '/';
  } else if (mbrPath.length() < 16 && mbrPath.find('/') == std::string::npos) {
    memcpy(hdr.name,mbrPath.c_str(),mbrPath.length());
    hdr.name[mbrPath.length()] = '/';
  } else {
    std::string nm = "#1/";
    nm += utostr(mbrPath.length());
    memcpy(hdr.name,nm.data(),nm.length());
    if (sz < 0)
      sz -= mbrPath.length();
    else
      sz += mbrPath.length();
    writeLongName = true;
  }

  // Set the size field
  if (sz < 0) {
    buffer[0] = '-';
    sprintf(&buffer[1],"%-9u",(unsigned)-sz);
  } else {
    sprintf(buffer, "%-10u", (unsigned)sz);
  }
  memcpy(hdr.size,buffer,10);

  return writeLongName;
}

// Insert a file into the archive before some other member. This also takes care
// of extracting the necessary flags and information from the file.
void
Archive::addFileBefore(const sys::Path& filePath, iterator where) {
  assert(filePath.exists() && "Can't add a non-existent file");

  ArchiveMember* mbr = new ArchiveMember(this);

  mbr->data = 0;
  mbr->path = filePath;
  mbr->path.getStatusInfo(mbr->info);

  unsigned flags = 0;
  bool hasSlash = filePath.get().find('/') != std::string::npos;
  if (hasSlash)
    flags |= ArchiveMember::HasPathFlag;
  if (hasSlash || filePath.get().length() > 15)
    flags |= ArchiveMember::HasLongFilenameFlag;
  std::string magic;
  mbr->path.getMagicNumber(magic,4);
  switch (sys::IdentifyFileType(magic.c_str(),4)) {
    case sys::BytecodeFileType:
      flags |= ArchiveMember::BytecodeFlag;
      break;
    case sys::CompressedBytecodeFileType:
      flags |= ArchiveMember::CompressedBytecodeFlag;
      break;
    default:
      break;
  }
  mbr->flags = flags;
  members.insert(where,mbr);
}

// Write one member out to the file.
void
Archive::writeMember(
  const ArchiveMember& member,
  std::ofstream& ARFile,
  bool CreateSymbolTable,
  bool TruncateNames,
  bool ShouldCompress 
) {

  unsigned filepos = ARFile.tellp();
  filepos -= 8;

  // Get the data and its size either from the
  // member's in-memory data or directly from the file.
  size_t fSize = member.getSize();
  const char* data = (const char*)member.getData();
  sys::MappedFile* mFile = 0;
  if (!data) {
    mFile = new sys::MappedFile(member.getPath());
    data = (const char*) mFile->map();
    fSize = mFile->size();
  } 

  // Now that we have the data in memory, update the 
  // symbol table if its a bytecode file.
  if (CreateSymbolTable && 
      (member.isBytecode() || member.isCompressedBytecode())) {
    std::vector<std::string> symbols;
    std::string FullMemberName = archPath.get() + "(" + member.getPath().get() 
      + ")";
    ModuleProvider* MP = GetBytecodeSymbols(
      (const unsigned char*)data,fSize,FullMemberName, symbols);

    // If the bytecode parsed successfully
    if ( MP ) {
      for (std::vector<std::string>::iterator SI = symbols.begin(), 
           SE = symbols.end(); SI != SE; ++SI) {

        std::pair<SymTabType::iterator,bool> Res = 
          symTab.insert(std::make_pair(*SI,filepos));

        if (Res.second) {
          symTabSize += SI->length() + 
                        numVbrBytes(SI->length()) + 
                        numVbrBytes(filepos);
        }
      }
      // We don't need this module any more.
      delete MP;
    } else {
      throw std::string("Can't parse bytecode member: ") + 
             member.getPath().get();
    }
  }

  // Determine if we actually should compress this member
  bool willCompress = 
      (ShouldCompress && 
      !member.isForeignSymbolTable() &&
      !member.isLLVMSymbolTable() &&
      !member.isCompressed() && 
      !member.isCompressedBytecode());

  // Perform the compression. Note that if the file is uncompressed bytecode
  // then we turn the file into compressed bytecode rather than treating it as
  // compressed data. This is necessary since it allows us to determine that the
  // file contains bytecode instead of looking like a regular compressed data
  // member. A compressed bytecode file has its content compressed but has a
  // magic number of "llvc". This acounts for the +/-4 arithmetic in the code
  // below.
  int hdrSize;
  if (willCompress) {
    char* output = 0;
    if (member.isBytecode()) {
      data +=4;
      fSize -= 4;
    }
    fSize = Compressor::compressToNewBuffer(
              data,fSize,output,Compressor::COMP_TYPE_ZLIB);
    data = output;
    if (member.isBytecode())
      hdrSize = -fSize-4; 
    else
      hdrSize = -fSize;
  } else {
    hdrSize = fSize;
  }

  // Compute the fields of the header
  ArchiveMemberHeader Hdr;
  bool writeLongName = fillHeader(member,Hdr,hdrSize,TruncateNames);

  // Write header to archive file
  ARFile.write((char*)&Hdr, sizeof(Hdr));

  // Write the long filename if its long
  if (writeLongName) {
    ARFile.write(member.getPath().get().data(),member.getPath().get().length());
  }

  // Make sure we write the compressed bytecode magic number if we should.
  if (willCompress && member.isBytecode())
    ARFile.write("llvc",4);

  // Write the (possibly compressed) member's content to the file.
  ARFile.write(data,fSize);

  // Make sure the member is an even length
  if (ARFile.tellp() & 1 == 1)
    ARFile << ARFILE_PAD;

  // Free the compressed data, if necessary
  if (willCompress) {
    free((void*)data);
  }

  // Close the mapped file if it was opened
  if (mFile != 0) {
    mFile->unmap();
    delete mFile;
  }
}

// Write out the LLVM symbol table as an archive member to the file.
void
Archive::writeSymbolTable(std::ofstream& ARFile) {

  // Construct the symbol table's header
  ArchiveMemberHeader Hdr;
  Hdr.init();
  memcpy(Hdr.name,ARFILE_LLVM_SYMTAB_NAME,16);
  uint64_t secondsSinceEpoch = sys::TimeValue::now().toEpochTime();
  char buffer[32];
  sprintf(buffer,"%-12u", unsigned(secondsSinceEpoch));
  memcpy(Hdr.date,buffer,12);
  sprintf(buffer,"%-10u",symTabSize);
  memcpy(Hdr.size,buffer,10);

  // Write the header
  ARFile.write((char*)&Hdr, sizeof(Hdr));

  // Save the starting position of the symbol tables data content.
  unsigned startpos = ARFile.tellp();

  // Write out the symbols sequentially
  for ( Archive::SymTabType::iterator I = symTab.begin(), E = symTab.end();
        I != E; ++I)
  {
    // Write out the file index
    writeInteger(I->second, ARFile);
    // Write out the length of the symbol
    writeInteger(I->first.length(), ARFile);
    // Write out the symbol
    ARFile.write(I->first.data(), I->first.length());
  }

  // Now that we're done with the symbol table, get the ending file position
  unsigned endpos = ARFile.tellp();

  // Make sure that the amount we wrote is what we pre-computed. This is
  // critical for file integrity purposes.
  assert(endpos - startpos == symTabSize && "Invalid symTabSize computation");

  // Make sure the symbol table is even sized
  if (symTabSize % 2 != 0 )
    ARFile << ARFILE_PAD;
}

// Write the entire archive to the file specified when the archive was created.
// This writes to a temporary file first. Options are for creating a symbol 
// table, flattening the file names (no directories, 15 chars max) and 
// compressing each archive member.
void
Archive::writeToDisk(bool CreateSymbolTable, bool TruncateNames, bool Compress){
  
  // Make sure they haven't opened up the file, not loaded it,
  // but are now trying to write it which would wipe out the file.
  assert(!(members.empty() && mapfile->size() > 8) && 
         "Can't write an archive not opened for writing");

  // Create a temporary file to store the archive in
  sys::Path TmpArchive = archPath;
  TmpArchive.createTemporaryFile();

  // Make sure the temporary gets removed if we crash
  sys::RemoveFileOnSignal(TmpArchive);

  // Ensure we can remove the temporary even in the face of an exception
  try {
    // Create archive file for output.
    std::ofstream ArchiveFile(TmpArchive.c_str());
  
    // Check for errors opening or creating archive file.
    if ( !ArchiveFile.is_open() || ArchiveFile.bad() ) {
      throw std::string("Error opening archive file: ") + archPath.get();
    }

    // If we're creating a symbol table, reset it now
    if (CreateSymbolTable) {
      symTabSize = 0;
      symTab.clear();
    }

    // Write magic string to archive.
    ArchiveFile << ARFILE_MAGIC;

    // Loop over all member files, and write them out. Note that this also
    // builds the symbol table, symTab.
    for ( MembersList::iterator I = begin(), E = end(); I != E; ++I) {
      writeMember(*I,ArchiveFile,CreateSymbolTable,TruncateNames,Compress);
    }

    // Close archive file.
    ArchiveFile.close();

    // Write the symbol table
    if (CreateSymbolTable) {
      // At this point we have written a file that is a legal archive but it
      // doesn't have a symbol table in it. To aid in faster reading and to
      // ensure compatibility with other archivers we need to put the symbol
      // table first in the file. Unfortunately, this means mapping the file
      // we just wrote back in and copying it to the destination file.

      // Map in the archive we just wrote.
      sys::MappedFile arch(TmpArchive);
      const char* base = (const char*) arch.map();

      // Open the final file to write and check it.
      std::ofstream FinalFile(archPath.c_str());
      if ( !FinalFile.is_open() || FinalFile.bad() ) {
        throw std::string("Error opening archive file: ") + archPath.get();
      }

      // Write the file magic number
      FinalFile << ARFILE_MAGIC;

      // If there is a foreign symbol table, put it into the file now.
      if (foreignST) {
        writeMember(*foreignST, FinalFile, false, false, false);
      }

      // Put out the LLVM symbol table now.
      writeSymbolTable(FinalFile);

      // Copy the temporary file contents being sure to skip the file's magic
      // number.
      FinalFile.write(base + sizeof(ARFILE_MAGIC)-1, 
        arch.size()-sizeof(ARFILE_MAGIC)+1);

      // Close up shop
      FinalFile.close();
      arch.unmap();
      TmpArchive.destroyFile();

    } else {
      // We don't have to insert the symbol table, so just renaming the temp
      // file to the correct name will suffice.
      TmpArchive.renameFile(archPath);
    }
  } catch (...) {
    // Make sure we clean up.
    if (TmpArchive.exists())
      TmpArchive.destroyFile();
    throw;
  }
}
