file(GLOB src Source/*.c)
ADD_LIBRARY(camdi STATIC ${src})
target_compile_definitions(camdi PRIVATE DINT)
TARGET_INCLUDE_DIRECTORIES(camdi PRIVATE Include ../SuiteSparse_config)
ADD_LIBRARY(camdl STATIC ${src})
target_compile_definitions(camdl PRIVATE DLONG)
TARGET_INCLUDE_DIRECTORIES(camdl PRIVATE Include ../SuiteSparse_config)

add_subdirectory(Demo)