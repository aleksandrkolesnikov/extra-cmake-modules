# - Try to find Strigi
# Once done this will define
#
#  STRIGI_FOUND - system has Strigi
#  STRIGI_INCLUDE_DIR - the Strigi include directory
#  STRIGI_STREAMANALYZER_LIBRARY - Link these to use Strigi streamanalyzer
#  STRIGI_STREAMS_LIBRARY - Link these to use Strigi streams
#  STRIGI_LIBRARIES - Link these to use both Strigi libraries


set(STRIGI_MIN_VERSION "0.5.3")

if (WIN32)
  file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _program_FILES_DIR)
endif(WIN32)

find_path(STRIGI_INCLUDE_DIR strigi/streamanalyzer.h
  PATHS
  $ENV{STRIGI_HOME}/include
  ${CMAKE_INSTALL_PREFIX}/include
  ${_program_FILES_DIR}/strigi/include
)

find_library(STRIGI_STREAMANALYZER_LIBRARY NAMES streamanalyzer
  PATHS
  $ENV{STRIGI_HOME}/lib
  ${CMAKE_INSTALL_PREFIX}/lib
  ${_program_FILES_DIR}/strigi/lib
)

find_library(STRIGI_STREAMS_LIBRARY NAMES streams
  PATHS
  $ENV{STRIGI_HOME}/lib
  ${CMAKE_INSTALL_PREFIX}/lib
  ${_program_FILES_DIR}/strigi/lib
)

if (NOT WIN32 AND NOT HAVE_STRIGI_VERSION)
  include(UsePkgConfig)
  pkgconfig(libstreamanalyzer _dummyIncDir _dummyLinkDir _dummyLinkFlags _dummyCflags)

  # if pkgconfig found strigi, check the version, otherwise print a warning
  if(_dummyLinkFlags)

    exec_program(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=${STRIGI_MIN_VERSION}
        libstreamanalyzer RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )

    if(NOT _return_VALUE STREQUAL "0")
      message(STATUS "pkg-config query failed. did you set $PKG_CONFIG_PATH to the directory where strigi libstreamanalyzer.pc is installed?")
      message(FATAL_ERROR "Didn't find strigi >= ${STRIGI_MIN_VERSION}")
    else(NOT _return_VALUE STREQUAL "0")
      set(HAVE_STRIGI_VERSION TRUE CACHE BOOL "Have strigi version returned by pkgconfig")
      if(NOT Strigi_FIND_QUIETLY)
        message(STATUS "Found Strigi >= ${STRIGI_MIN_VERSION}")
      endif(NOT Strigi_FIND_QUIETLY)
    endif(NOT _return_VALUE STREQUAL "0")
  else(_dummyLinkFlags)
    message(STATUS "pkgconfig didn't find strigi, couldn't check strigi version")
  endif(_dummyLinkFlags)
endif (NOT WIN32 AND NOT HAVE_STRIGI_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Strigi  
                                  "Couldn't find Strigi streams library in $ENV{STRIGI_HOME}/lib, ${CMAKE_INSTALL_PREFIX}/lib, ${_program_FILES_DIR}/strigi/lib"  
                                  STRIGI_STREAMS_LIBRARY  STRIGI_STREAMANALYZER_LIBRARY  STRIGI_INCLUDE_DIR)
