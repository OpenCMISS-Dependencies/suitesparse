file(GLOB src Source/*.c)
ADD_LIBRARY(ccolamdi OBJECT ${src})
target_compile_definitions(ccolamdi PRIVATE DINT)
TARGET_INCLUDE_DIRECTORIES(ccolamdi PRIVATE Include ../SuiteSparse_config)
ADD_LIBRARY(ccolamdl OBJECT ${src})
target_compile_definitions(ccolamdl PRIVATE DLONG)
TARGET_INCLUDE_DIRECTORIES(ccolamdl PRIVATE Include ../SuiteSparse_config)

add_library(ccolamd $<TARGET_OBJECTS:ccolamdl> $<TARGET_OBJECTS:ccolamdi>)
target_link_libraries(ccolamd suitesparseconfig)
TARGET_INCLUDE_DIRECTORIES(ccolamd
    PRIVATE ../SuiteSparse_config
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)
install(TARGETS ccolamd EXPORT suitesparse-config
    DESTINATION lib INCLUDES DESTINATION include)
install(FILES Include/ccolamd.h DESTINATION include)

if (BUILD_TESTS)
    add_subdirectory(Demo)
endif()