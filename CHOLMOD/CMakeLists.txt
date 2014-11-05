PROJECT(CHOLMOD VERSION 3.0.1 LANGUAGES C)

file(GLOB check Check/*.c)
file(GLOB chol Cholesky/cholmod*.c)
file(GLOB core Core/cholmod*.c)
file(GLOB gpu GPU/cholmod*.c GPU/*.cu)
file(GLOB matops MatrixOps/cholmod*.c)
file(GLOB mod Modify/cholmod*.c)
file(GLOB part Partition/*.c)
file(GLOB snod Supernodal/cholmod*.c)

ADD_LIBRARY(cholmod STATIC ${check} ${chol} ${core} ${matops} ${mod} ${part} ${snod})
set_target_properties(cholmod PROPERTIES OUTPUT_NAME cholmod-${CHOLMOD_VERSION})
target_compile_definitions(cholmod PRIVATE D${INT_TYPE_FLAG})
TARGET_INCLUDE_DIRECTORIES(cholmod PRIVATE 
    ../SuiteSparse_config
    ../AMD/Include ../COLAMD/Include ../CAMD/Include ../CCOLAMD/Include
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>
)
target_link_libraries(cholmod
    PUBLIC suitesparseconfig amd camd colamd ccolamd
    PRIVATE blas lapack metis)

install(TARGETS cholmod EXPORT cholmod-config
    DESTINATION lib INCLUDES DESTINATION include)
install(EXPORT cholmod-config DESTINATION lib/cmake)
WRITE_BASIC_PACKAGE_VERSION_FILE(${CMAKE_CURRENT_BINARY_DIR}/cholmod-config-version.cmake COMPATIBILITY AnyNewerVersion)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/cholmod-config-version.cmake DESTINATION lib/cmake)
    
if (BUILD_TESTS)
    add_subdirectory(Demo)
endif()    
