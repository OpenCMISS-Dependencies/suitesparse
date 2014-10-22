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
TARGET_INCLUDE_DIRECTORIES(cholmod PRIVATE 
    ../SuiteSparse_config
    ../AMD/Include ../COLAMD/Include ../CAMD/Include ../CCOLAMD/Include
    $<TARGET_PROPERTY:metis,INTERFACE_INCLUDE_DIRECTORIES>
)
TARGET_INCLUDE_DIRECTORIES(cholmod PUBLIC
    Include
)
target_link_libraries(cholmod 
    PUBLIC amdi amdl camd colamd ccolamd 
    PRIVATE blas lapack metis
)
export(TARGETS cholmod amdl amdi camd colamd ccolamd FILE ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/cholmod-${CHOLMOD_VERSION}/cholmod-config.cmake)
WRITE_BASIC_PACKAGE_VERSION_FILE(${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/cholmod-${CHOLMOD_VERSION}/cholmod-config-version.cmake
    VERSION ${CHOLMOD_VERSION} COMPATIBILITY AnyNewerVersion)
