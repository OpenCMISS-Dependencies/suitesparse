CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT (SuiteSparse VERSION 4.4.0 LANGUAGES C Fortran)

if (OPENCMISS_DEPENDENCIES_LIBRARIES)
    SET(CMAKE_PREFIX_PATH ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR} ${CMAKE_PREFIX_PATH})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OPENCMISS_DEPENDENCIES_LIBRARIES})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OPENCMISS_DEPENDENCIES_LIBRARIES})
else()
    SET(CMAKE_PREFIX_PATH ../cmake ${CMAKE_PREFIX_PATH})
    SET(OPENCMISS_DEPENDENCIES_CONFIGS_DIR ${CMAKE_CURRENT_BINARY_DIR})
endif()

find_package(BLAS CONFIG REQUIRED)
find_package(LAPACK CONFIG REQUIRED)
find_package(METIS 4 CONFIG REQUIRED)
find_package(MPI REQUIRED)

#SET(CMAKE_C_COMPILER ${MPI_C_COMPILER})
#SET(CMAKE_C_FLAGS "-O3")
#SET(CMAKE_Fortran_COMPILER ${MPI_Fortran_COMPILER})
#SET(CMAKE_Fortran_FLAGS "-O3 -Q")

include(CMakePackageConfigHelpers)
enable_testing()
MACRO(CREATE_TEST NAME TYPE)
    add_executable(${NAME} ${NAME}.${TYPE} ${extra})
    target_include_directories(${NAME} PRIVATE 
        ../Include
    $<TARGET_PROPERTY:suitesparseconfig,INTERFACE_INCLUDE_DIRECTORIES>)
    target_link_libraries(${NAME} PRIVATE ${LIBS} suitesparseconfig)
    if (UNIX)
        target_link_libraries(${NAME} PRIVATE rt m)
    endif()
    
    set(TARGET ${CMAKE_CURRENT_SOURCE_DIR}/${NAME}.out)
    add_test(NAME ${NAME}
        COMMAND ${CMAKE_COMMAND}
            -DCMD=$<TARGET_FILE:${NAME}>
            -DTARGET=${TARGET}
            -P ${SuiteSparse_SOURCE_DIR}/testhelper.cmake)
ENDMACRO()

add_subdirectory(SuiteSparse_config)
add_subdirectory(AMD)
add_subdirectory(CAMD)
add_subdirectory(COLAMD)
add_subdirectory(CCOLAMD)
add_subdirectory(CHOLMOD)
add_subdirectory(UMFPACK)