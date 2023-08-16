cmake_minimum_required(VERSION 3.18)
project(VulkanIntroducingPVRShell)
if(IOS)
	message ("Skipping VulkanIntroducingPVRShell : Vulkan is not supported on iOS.")
	return()
endif()

add_subdirectory(../../.. ${CMAKE_CURRENT_BINARY_DIR}/sdk)

if(PVR_PREBUILT_DEPENDENCIES)
	find_package(PVRShell REQUIRED MODULE)
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT BilrepFlip)


set(SRC_FILES BilrepFlip.cpp)

set(ASSET_FOLDER ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Assets_BilrepFlip)

# Adds an executable (or ndk library for Android) and necessary files like plists for Mac/iOS etc.
add_platform_specific_executable(BilrepFlip ${SRC_FILES})

# set the target property c++ standard
# AM: Unfortunatly, the target CXX_STANDARD property is set in cmake/Utitilies/compile.options.cmake,
# so ther is no possibility to set it here.
# set_property(TARGET BilrepFlip PROPERTY CXX_STANDARD 20)

#################################### ASSET FILES ##########################################
# For platforms supporting it, will be packaged with the executable for runtime use.
# Will be accessible from the app with their "relative path". One call per base path

### Shaders that need to be compiled to SpirV (Vulkan) ###
# During build time, glslangvalidator will be called to create a "<shadername.extension>.spv" file
add_spirv_shaders_to_target( BilrepFlip
	SOURCE_GROUP "shaders_source" 
	SPIRV_SOURCE_GROUP "shaders_generated"
	ASSET_FOLDER ${ASSET_FOLDER} 
	BASE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/
	FILE_LIST
		FragShader.fsh
		VertShader.vsh)

# Create and adds a Windows resource file (Resources.rc) with all the assets that have been added to the target with the previous functions
add_assets_resource_file(BilrepFlip)
add_platform_specific_executable(bilrep_data bilrep_data.cpp bilrep_data.h)
###########################################################################################

# Apply SDK example specific compile and linker options
apply_example_compile_options_to_target(BilrepFlip)

if(APPLE AND NOT IOS)
	find_package(MoltenVK REQUIRED)		
endif()

# platform and window system specific definitions to use for conditionally building the example. The VK_USE_PLATFORM_* defines are used by the Vulkan headers for
# enabling/disabling platform specific functionality. This example will primarily be using these defines for platform specific surface creation and making available
# the relevant functions required for this.

set(USE_PLATFORM "" CACHE INTERNAL "")
if (WIN32)
	list(APPEND USE_PLATFORM "VK_USE_PLATFORM_WIN32_KHR")
elseif(ANDROID)
	list(APPEND USE_PLATFORM "VK_USE_PLATFORM_ANDROID_KHR")
elseif(APPLE)
	if (${MOLTENVK_FOUND})
		list(APPEND USE_PLATFORM "VK_USE_PLATFORM_MACOS_MVK")
	endif()	
elseif(UNIX)
	if(PVR_WINDOW_SYSTEM)
		if (${PVR_WINDOW_SYSTEM} STREQUAL X11)
			list(APPEND USE_PLATFORM "VK_USE_PLATFORM_XLIB_KHR")
		elseif (${PVR_WINDOW_SYSTEM} STREQUAL XCB)
			list(APPEND USE_PLATFORM "VK_USE_PLATFORM_XCB_KHR")
		elseif (${PVR_WINDOW_SYSTEM} STREQUAL Wayland)
			list(APPEND USE_PLATFORM "VK_USE_PLATFORM_WAYLAND_KHR")
		endif()
	endif()
endif()

# Determine which platform VulkanIntroducingPVRShell should be built to support
if(USE_PLATFORM)	
	# Setup compile definitions
	target_compile_definitions(BilrepFlip 
		PUBLIC 
			"${USE_PLATFORM}")
endif()

target_include_directories(BilrepFlip PUBLIC ${MVK_INCLUDE_DIR})

target_link_libraries(BilrepFlip
	PVRShell
	${MVK_LIBRARIES}
)

target_link_libraries(bilrep_data PVRAssets PVRCore)
