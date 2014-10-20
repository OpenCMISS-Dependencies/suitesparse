CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT(CHOLMOD VERSION 3.5.0 LANGUAGES C)

find_package(BLAS CONFIG REQUIRED)
find_package(LAPACK CONFIG REQUIRED)
#find_package(METIS CONFIG REQUIRED)

file(GLOB check Check/*.c)
file(GLOB chol Cholesky/cholmod*.c)
file(GLOB core Core/cholmod*.c)
file(GLOB gpu GPU/cholmod*.c GPU/*.cu)
file(GLOB matops MatrixOps/cholmod*.c)
file(GLOB mod Modify/cholmod*.c)
file(GLOB part Partition/*.c)
file(GLOB snod Supernodal/cholmod*.c)
ADD_LIBRARY(cholmod STATIC ${check} ${chol} ${core} ${matops} ${mod} ${part} ${snod})
TARGET_INCLUDE_DIRECTORIES(cholmod PRIVATE 
    ../SuiteSparse_config
    ../AMD/Include ../COLAMD/Include ../CAMD/Include ../CCOLAMD/Include
    $<TARGET_PROPERTY:metis,INTERFACE_INCLUDE_DIRECTORIES>
)
TARGET_INCLUDE_DIRECTORIES(cholmod PUBLIC
    Include
)
target_link_libraries(cholmod blas lapack metis amd camd colamd ccolamd)
export(TARGETS cholmod metis amd camd colamd ccolamd FILE ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/cholmod-config.cmake)