file(GLOB src Source/*.c)

# Version with -DINT
ADD_LIBRARY(amdi OBJECT ${src})
target_compile_definitions(amdi PRIVATE DINT)
TARGET_INCLUDE_DIRECTORIES(amdi 
    PRIVATE ../SuiteSparse_config
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)

# Version with -DLONG
ADD_LIBRARY(amdl OBJECT ${src})
target_compile_definitions(amdl PRIVATE DLONG)
TARGET_INCLUDE_DIRECTORIES(amdl 
    PRIVATE ../SuiteSparse_config
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)

file(GLOB srcF Source/*.f)
add_library(amd ${srcF} $<TARGET_OBJECTS:amdi> $<TARGET_OBJECTS:amdl>)
target_link_libraries(amd suitesparseconfig)
TARGET_INCLUDE_DIRECTORIES(amd
    PRIVATE ../SuiteSparse_config
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)
install(TARGETS amd EXPORT suitesparse-config
    DESTINATION lib INCLUDES DESTINATION include)
install(FILES Include/amd.h DESTINATION include)

# add tests/demos
if (BUILD_TESTS)
    add_subdirectory(Demo)
endif()