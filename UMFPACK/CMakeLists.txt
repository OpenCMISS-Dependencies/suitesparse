PROJECT(UMFPACK C)
CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

file(GLOB src Source/*.c)
ADD_LIBRARY(umfpack STATIC ${src})
TARGET_INCLUDE_DIRECTORIES(umfpack PRIVATE 
    Source ../SuiteSparse_config
    ../AMD/Include
    $<TARGET_PROPERTY:cholmod,INTERFACE_INCLUDE_DIRECTORIES>
)
TARGET_INCLUDE_DIRECTORIES(umfpack PUBLIC
    Include
)
#target_link_libraries(umfpack blas lapack metis)
export(TARGETS umfpack FILE ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/umfpack-config.cmake)