CMAKE_MINIMUM_REQUIRED(VERSION 3.3)
PROJECT (SuiteSparse VERSION 4.4.0 LANGUAGES C Fortran)

# Compilation hints:
# The SUITESPARSE timer function is disabled on __MINGW32__ platforms; see SuiteSparse_config.h:158

option(BUILD_TESTS "${PROJECT_NAME} - Build tests" ON)
option(PACKAGE_CONFIG_DIR "Directory for package config files (relative to CMAKE_INSTALL_PREFIX)" "lib/cmake")
set(BUILD_PRECISION dz CACHE STRING "${PROJECT_NAME} - Build precisions (dz)")
option(WITH_OPENMP "${PROJECT_NAME} - Use OpenMP" ON)
if (BUILD_SHARED_LIBS)
    # This will cause all the OBJECT targets to have -fPIC as well.
    SET(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()

find_package(MPI REQUIRED)
find_package(BLAS ${BLAS_VERSION} REQUIRED)
find_package(LAPACK ${LAPACK_VERSION} REQUIRED)
find_package(METIS ${METIS_VERSION} REQUIRED)

if (WITH_OPENMP)
  find_package(OpenMP)
  if (OPENMP_FOUND)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_Fortran_FLAGS}")
    # As recommended in the makefiles, CHOLMOD_OMP_NUM_THREADS should be matched to the local nodes number of cores.
    include(ProcessorCount)
    ProcessorCount(NUM_PROCESSORS)
    add_definitions(-DCHOLMOD_OMP_NUM_THREADS=${NUM_PROCESSORS})
  else()
    message(WARNING "OpenMP requested but not found. Skipping.")
  endif()
endif()

if (BUILD_TESTS)    
    enable_testing()
    MACRO(CREATE_TEST NAME TYPE)
        add_executable(${NAME} ${NAME}.${TYPE} ${extra})
        target_include_directories(${NAME} PRIVATE 
            ../Include
            ${SuiteSparse_SOURCE_DIR}/SuiteSparse_config)
        target_link_libraries(${NAME} PRIVATE ${LIBS} suitesparseconfig)
        if (UNIX)
            target_link_libraries(${NAME} PRIVATE m)
        endif()
        set(TARGET ${CMAKE_CURRENT_SOURCE_DIR}/${NAME}.out)
        add_test(NAME ${NAME}
            COMMAND ${CMAKE_COMMAND}
                -DCMD=$<TARGET_FILE:${NAME}>
                -DTARGET=${TARGET}
                -P ${SuiteSparse_SOURCE_DIR}/testhelper.cmake)
    ENDMACRO()
endif()

add_subdirectory(SuiteSparse_config)
add_subdirectory(AMD)
add_subdirectory(CAMD)
add_subdirectory(COLAMD)
add_subdirectory(CCOLAMD)
add_subdirectory(BTF)
add_subdirectory(KLU)
add_subdirectory(CHOLMOD)
add_subdirectory(UMFPACK)

# Create interface target for easy linking against suitesparse
add_library(suitesparse INTERFACE)
target_link_libraries(suitesparse INTERFACE
    suitesparseconfig amd btf camd cholmod colamd ccolamd klu umfpack
)
install(TARGETS suitesparse EXPORT suitesparse-config) 
install(EXPORT suitesparse-config DESTINATION ${PACKAGE_CONFIG_DIR})
include(CMakePackageConfigHelpers)
WRITE_BASIC_PACKAGE_VERSION_FILE(${CMAKE_CURRENT_BINARY_DIR}/suitesparse-config-version.cmake COMPATIBILITY SameMajorVersion)
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/suitesparse-config-dependencies.cmake 
    "include(CMakeFindDependencyMacro)\r\n"
    	"set(${PROJECT_NAME}_IMPORT_PREFIX \${_IMPORT_PREFIX})\r\n"
    "find_dependency(BLAS ${BLAS_VERSION})\r\n"
    "find_dependency(LAPACK ${LAPACK_VERSION})\r\n"
    "find_dependency(METIS ${METIS_VERSION})\r\n"
)
if (WITH_OPENMP)
    file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/suitesparse-config-dependencies.cmake "find_dependency(OpenMP)\r\n")
endif()
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/suitesparse-config-dependencies.cmake "set(_IMPORT_PREFIX \${${PROJECT_NAME}_IMPORT_PREFIX})")
install(FILES 
    ${CMAKE_CURRENT_BINARY_DIR}/suitesparse-config-version.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/suitesparse-config-dependencies.cmake
    DESTINATION ${PACKAGE_CONFIG_DIR})