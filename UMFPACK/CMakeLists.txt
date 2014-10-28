CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT(UMFPACK VERSION 5.7.0 LANGUAGES C)

file(GLOB src Source/*.c)
ADD_LIBRARY(umfpack STATIC ${src})
set_target_properties(umfpack PROPERTIES OUTPUT_NAME umfpack-${UMFPACK_VERSION})
target_link_libraries(umfpack PUBLIC cholmod)
TARGET_INCLUDE_DIRECTORIES(umfpack PRIVATE 
    Source ../SuiteSparse_config
    ../AMD/Include
    $<TARGET_PROPERTY:cholmod,INTERFACE_INCLUDE_DIRECTORIES>
)
TARGET_INCLUDE_DIRECTORIES(umfpack PUBLIC
    Include
)
#target_link_libraries(umfpack blas lapack metis)
export(TARGETS umfpack FILE ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/umfpack-${UMFPACK_VERSION}/umfpack-config.cmake)
WRITE_BASIC_PACKAGE_VERSION_FILE(${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/umfpack-${UMFPACK_VERSION}/umfpack-config-version.cmake
    VERSION ${UMFPACK_VERSION} COMPATIBILITY AnyNewerVersion)

if (BUILD_TESTING)
    add_subdirectory(Demo)
endif()