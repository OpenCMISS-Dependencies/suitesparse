file(GLOB src Source/*.c)
ADD_LIBRARY(camdi OBJECT ${src})
target_compile_definitions(camdi PRIVATE DINT)
TARGET_INCLUDE_DIRECTORIES(camdi PRIVATE Include ../SuiteSparse_config)

ADD_LIBRARY(camdl OBJECT ${src})
target_compile_definitions(camdl PRIVATE DLONG)
TARGET_INCLUDE_DIRECTORIES(camdl PRIVATE Include ../SuiteSparse_config)

add_library(camd $<TARGET_OBJECTS:camdi> $<TARGET_OBJECTS:camdl>)
target_link_libraries(camd suitesparseconfig)
TARGET_INCLUDE_DIRECTORIES(camd PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include> 
    PRIVATE ../SuiteSparse_config)
install(TARGETS camd EXPORT suitesparse-config
    DESTINATION lib INCLUDES DESTINATION include)
install(FILES Include/camd.h DESTINATION include)

if (BUILD_TESTS)
    add_subdirectory(Demo)
endif()