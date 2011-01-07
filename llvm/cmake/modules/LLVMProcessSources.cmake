include(AddFileDependencies)

macro(llvm_replace_compiler_option var old new)
  # Replaces a compiler option or switch `old' in `var' by `new'.
  # If `old' is not in `var', appends `new' to `var'.
  # Example: llvm_replace_compiler_option(CMAKE_CXX_FLAGS_RELEASE "-O3" "-O2")
  if( "${${var}}" MATCHES "(^| )${old}($| )" )
    string( REGEX REPLACE "(^| )${old}($| )" " ${new}  " ${var} "${${var}}" )
  else()
    set( ${var} "${${var}} ${new}" )
  endif()
endmacro(llvm_replace_compiler_option)

macro(add_td_sources srcs)
  file(GLOB tds *.td)
  if( tds )
    source_group("TableGen descriptions" FILES ${tds})
    set_source_files_properties(${tds} PROPERTIES HEADER_FILE_ONLY ON)
    list(APPEND ${srcs} ${tds})
  endif()
endmacro(add_td_sources)


macro(add_header_files srcs)
  file(GLOB hds *.h *.def)
  if( hds )
    set_source_files_properties(${hds} PROPERTIES HEADER_FILE_ONLY ON)
    list(APPEND ${srcs} ${hds})
  endif()
endmacro(add_header_files)


function(llvm_process_sources OUT_VAR)
  set( sources ${ARGN} )
  llvm_check_source_file_list( ${sources} )
  # Create file dependencies on the tablegenned files, if any.  Seems
  # that this is not strictly needed, as dependencies of the .cpp
  # sources on the tablegenned .inc files are detected and handled,
  # but just in case...
  foreach( s ${sources} )
    set( f ${CMAKE_CURRENT_SOURCE_DIR}/${s} )
    add_file_dependencies( ${f} ${TABLEGEN_OUTPUT} )
  endforeach(s)
  if( MSVC_IDE )
    # This adds .td and .h files to the Visual Studio solution:
    add_td_sources(sources)
    add_header_files(sources)
  endif()

  # Set common compiler options:
  if( NOT LLVM_REQUIRES_EH )
    if( CMAKE_COMPILER_IS_GNUCXX )
      add_definitions( -fno-exceptions )
    elseif( MSVC )
      string( REGEX REPLACE "[ ^]/EHsc ?" " /EHs-c- " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" )
      add_definitions( /D_HAS_EXCEPTIONS=0 )
    endif()
  endif()
  if( NOT LLVM_REQUIRES_RTTI )
    if( CMAKE_COMPILER_IS_GNUCXX )
      add_definitions( -fno-rtti )
    elseif( MSVC )
      string( REGEX REPLACE "[ ^]/GR ?" " /GR- " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" )
    endif()
  endif()

  set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" PARENT_SCOPE )
  set( ${OUT_VAR} ${sources} PARENT_SCOPE )
endfunction(llvm_process_sources)


function(llvm_check_source_file_list)
  set(listed ${ARGN})
  file(GLOB globbed *.cpp)
  foreach(g ${globbed})
    get_filename_component(fn ${g} NAME)
    list(FIND listed ${fn} idx)
    if( idx LESS 0 )
      message(SEND_ERROR "Found unknown source file ${g}
Please update ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt\n")
    endif()
  endforeach()
endfunction(llvm_check_source_file_list)
