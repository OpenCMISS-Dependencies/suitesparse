CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT (SuiteSparse VERSION 4.4.0 LANGUAGES C Fortran)

option(BUILD_TESTS "${PROJECT_NAME} - Build tests" ON)
set(BUILD_PRECISION dz CACHE STRING "${PROJECT_NAME} - Build precisions (dz)")
set(INT_TYPE long CACHE STRING "${PROJECT_NAME} - Integer version (int32, long)")
option(WITH_CHOLMOD "Build CHOLMOD component" ON)
option(WITH_UMFPACK "Build UMFPACK component" ON)

find_package(BLAS CONFIG REQUIRED)
find_package(LAPACK CONFIG REQUIRED)
find_package(METIS 4 CONFIG REQUIRED)
find_package(MPI REQUIRED)

if(INT_TYPE STREQUAL int32)
    message(STATUS "Building with int32 integers")
    SET(INT_TYPE_FLAG INT)
    SET(INT_TYPE_CHAR i)
else()
    message(STATUS "Building with long integers")
    SET(INT_TYPE_FLAG LONG)
    SET(INT_TYPE_CHAR l)
endif()

#SET(CMAKE_C_COMPILER ${MPI_C_COMPILER})
#SET(CMAKE_C_FLAGS "-O3")
#SET(CMAKE_Fortran_COMPILER ${MPI_Fortran_COMPILER})
#SET(CMAKE_Fortran_FLAGS "-O3 -Q")
include(CMakePackageConfigHelpers)

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
if (WITH_CHOLMOD OR WITH_UMFPACK)
    add_subdirectory(CHOLMOD)
endif()
if (WITH_UMFPACK)
    add_subdirectory(UMFPACK)
endif()

install(EXPORT suitesparse-config DESTINATION lib/cmake)