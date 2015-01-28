file(GLOB src Source/*.c)
ADD_LIBRARY(colamdi OBJECT ${src})
target_compile_definitions(colamdi PRIVATE DINT)
TARGET_INCLUDE_DIRECTORIES(colamdi PRIVATE Include ../SuiteSparse_config)
ADD_LIBRARY(colamdl OBJECT ${src})
target_compile_definitions(colamdl PRIVATE DLONG)
TARGET_INCLUDE_DIRECTORIES(colamdl PRIVATE Include ../SuiteSparse_config)

add_library(colamd $<TARGET_OBJECTS:colamdi> $<TARGET_OBJECTS:colamdl>)
target_link_libraries(colamd suitesparseconfig)
TARGET_INCLUDE_DIRECTORIES(colamd
    PRIVATE ../SuiteSparse_config
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)
install(TARGETS colamd EXPORT suitesparse-config
    DESTINATION lib INCLUDES DESTINATION include)
install(FILES Include/colamd.h DESTINATION include)

if (BUILD_TESTS)
    add_subdirectory(Demo)
endif()