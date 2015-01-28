file(GLOB src Source/*.c)

# Version with -DINT
ADD_LIBRARY(btfi OBJECT ${src})
target_compile_definitions(btfi PRIVATE DINT)
TARGET_INCLUDE_DIRECTORIES(btfi 
    PRIVATE ../SuiteSparse_config
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)

# Version with -DLONG
ADD_LIBRARY(btfl OBJECT ${src})
target_compile_definitions(btfl PRIVATE DLONG)
TARGET_INCLUDE_DIRECTORIES(btfl 
    PRIVATE ../SuiteSparse_config
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)

add_library(btf $<TARGET_OBJECTS:btfi> $<TARGET_OBJECTS:btfl>)
install(TARGETS btf EXPORT suitesparse-config
    DESTINATION lib INCLUDES DESTINATION include)
install(FILES Include/btf.h DESTINATION include)