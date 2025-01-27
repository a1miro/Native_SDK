cmake_minimum_required(VERSION 3.18)
project(VulkanExamples)

set(VULKAN_EXAMPLES 
	01_HelloAPI
	02_IntroducingPVRShell
	03_IntroducingPVRVk
	04_IntroducingPVRUtils
	05_IntroducingUIRenderer
	AmbientOcclusion
	Bumpmap
	DeferredShading
	DeferredShadingPFX
	ExampleUI
	GameOfLife
	GaussianBlur
	Glass
	GnomeHorde
	HelloRayTracing
	HybridHardShadows
	HybridReflections
	HybridRefractions
	HybridSoftShadows
	HybridTransparency
	ImageBasedLighting
	ImageBasedLightingMapGenerator
	IMGTextureFilterCubic
	MatrixMultiplication
	MultiSampling
	Multithreading
	ParticleSystem
	PipelineCache
	PostProcessing
	PVRScopeExample
	PVRScopeRemote
	RayTracedHardShadows
	Skinning
	RayTracingDenoising
	Shadows
	Subgroups
)

foreach(EXAMPLE ${VULKAN_EXAMPLES})
	message ("==>CMake generation for Vulkan/${EXAMPLE}...")
	add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/${EXAMPLE}")
endforeach()