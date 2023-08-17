
include ( FetchContent )

function ( vcpkg_setup )
  # check if VCPKG_ROOT is set
  if ( DEFINED ENV{VCPKG_ROOT} OR VCPKG_ROOT )

    # check if VCPKG_ROOT is valid directory
    if ( NOT EXISTS ${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake )
      message ( FATAL_ERROR "The environment variable VCPKG_ROOT=${VCPKG_ROOT} is defined, but scripts/buildsystems/vcpkg.cmake does not exist in the directory. Please check if vcpkg is installed correctly." )
    else ()
      set ( VCPKG_ROOT $ENV{VCPKG_ROOT} CACHE PATH "VCPKG root directory" FORCE )
      message ( STATUS "VCPKG_ROOT=${VCPKG_ROOT}" )
    endif ()
 
    if(NOT CMAKE_TOOLCHAIN_FILE)
      set ( CMAKE_TOOLCHAIN_FILE ${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake CACHE FILEPATH "VCPKG CMake toolchain file" FORCE )
    endif()

  else ()
    message ( STATUS "Downloading and setting up the VCPKG manager" )

    FetchContent_Declare ( vcpkg
      GIT_REPOSITORY https://github.com/Microsoft/vcpkg.git
    )

    FetchContent_GetProperties ( vcpkg )
    FetchContent_Populate ( vcpkg )


    set ( VCPKG_ROOT ${vcpkg_SOURCE_DIR} CACHE PATH "VCPKG root directory" FORCE )
    set ( CMAKE_TOOLCHAIN_FILE ${vcpkg_SOURCE_DIR}/scripts/buildsystems/vcpkg.cmake CACHE FILEPATH "VCPKG CMake toolchain file" FORCE )

    if ( CMAKE_HOST_SYTEM_NAME STREQUAL "Windows" )
      # set(VCPKG_TARGET_TRIPLET "x64-windows" CACHE STRING "VCPKG target triplet" FORCE)
      execute_process ( COMMAND ${VCPKG_ROOT}/bootstrap-vcpkg.bat )
    else ()
      # set(VCPKG_TARGET_TRIPLET "x64-linux" CACHE STRING "VCPKG target triplet" FORCE)
      execute_process ( COMMAND ${VCPKG_ROOT}/bootstrap-vcpkg.sh )
    endif ()

  endif () # VCPKG_ROOT
endfunction ( vcpkg_setup )