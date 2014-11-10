PROJECT(CHOLMOD VERSION 3.0.1 LANGUAGES C)

file(GLOB check Check/*.c)
file(GLOB chol Cholesky/cholmod*.c)
file(GLOB core Core/cholmod*.c)
file(GLOB gpu GPU/cholmod*.c GPU/*.cu)
file(GLOB matops MatrixOps/cholmod*.c)
file(GLOB mod Modify/cholmod*.c)
file(GLOB part Partition/*.c)
file(GLOB snod Supernodal/cholmod*.c)

foreach(INT_TYPE_FLAG INT LONG)
    ADD_LIBRARY(cholmod_${INT_TYPE_FLAG} OBJECT ${check} ${chol} ${core} ${matops} ${mod} ${part} ${snod})
    target_compile_definitions(cholmod_${INT_TYPE_FLAG} PRIVATE D${INT_TYPE_FLAG} NPARTITION)
    TARGET_INCLUDE_DIRECTORIES(cholmod_${INT_TYPE_FLAG} PRIVATE 
        ../SuiteSparse_config
        ../AMD/Include ../COLAMD/Include ../CAMD/Include ../CCOLAMD/Include
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>
    )
endforeach()
add_library(cholmod $<TARGET_OBJECTS:cholmod_INT> $<TARGET_OBJECTS:cholmod_LONG>)
target_link_libraries(cholmod
    PUBLIC suitesparseconfig amd camd colamd ccolamd
    PRIVATE blas lapack metis)
set_target_properties(cholmod PROPERTIES OUTPUT_NAME cholmod-${CHOLMOD_VERSION})
TARGET_INCLUDE_DIRECTORIES(cholmod PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>
)

install(TARGETS cholmod EXPORT suitesparse-config
    DESTINATION lib INCLUDES DESTINATION include)
install(DIRECTORY Include/ DESTINATION include
    FILES_MATCHING PATTERN "*.h")
    
if (BUILD_TESTS)
    add_subdirectory(Demo)
endif()    
