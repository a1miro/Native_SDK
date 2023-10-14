cmake_minimum_required(VERSION 3.18.0 FATAL_ERROR)
project(PowerVR_SDK)

# Ensure we are not building for apple targets
if(APPLE OR IOS)
#	message(FATAL_ERROR "Sorry, the PowerVR SDK is no longer supported on Apple devices")
endif()

# Avoids the SDK target being added multiple times
if(TARGET PowerVR_SDK)
	return()
endif()


# Provides install directory variables to GNU standards
include(GNUInstallDirs)

# Store the root directory of the SDK framework, so configurable files can be found
set(SDK_ROOT_INTERNAL_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "Path to the root of the SDK")

# Make a top-level project file to build everything
add_library(PowerVR_SDK INTERFACE)

# set default PVR_WINDOW_SYSTEM to X11 on Linux
if(UNIX AND NOT APPLE)
	set(PVR_WINDOW_SYSTEM "X11" CACHE STRING "Window system to use")
endif()

# Set dropdown options for PVR_WINDOW_SYSTEM
set_property(CACHE PVR_WINDOW_SYSTEM PROPERTY STRINGS "Screen" "X11" "XCB" "Wayland" "NullWS")


# Set default vakues for the options used by the SDK
# These options configure which parts of the framework are built
option(PVR_BUILD_FRAMEWORK_VULKAN "Build the Vulkan part of the framework" ON)
option(PVR_BUILD_FRAMEWORK_GLES "Build the GLES part of the framework" OFF)
option(PVR_BUILD_FRAMEWORK_OPENCL "Build the OpenCL part of the framework" OFF)
option(PVR_BUILD_VULKAN_EXAMPLES "Build the Vulkan examples" OFF)
option(PVR_BUILD_OPENGLES_EXAMPLES "Build the GLES examples" OFF)
option(PVR_BUILD_OPENCL_EXAMPLES "Build the OpenCL examples" OFF)


# Tell CMake where to find the SDK's cmake modules, ie when cmake calls find_package(*)
# cmake needs to know where the SDK's custom scripts for this process are located
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

# Now we need to add in the CMake utilities, they're cmake files that provide helper functions
include(cmake/utilities/assets.cmake)			# Provides add_assets_to_target
include(cmake/utilities/executable.cmake)		# Provides add_platform_specific_executable
include(cmake/utilities/spirv.cmake)			# Provides add_spirv_shaders_to_target

# Add the framework source tree
add_subdirectory(framework)

# If the user has the examples option, then also add the examples source tree
if(PVR_BUILD_VULKAN_EXAMPLES OR PVR_BUILD_OPENGLES_EXAMPLES OR PVR_BUILD_OPENCL_EXAMPLES)
	add_subdirectory(examples)
endif()

# Add in the PVR Scope Developer external target.
add_subdirectory(external/PVRScope)

# Set the C++ standard to C++20
set(CMAKE_CXX_STANDARD 20)
