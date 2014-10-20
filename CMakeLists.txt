CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT (SuiteSparse VERSION 4.4.0 LANGUAGES C Fortran)

SET(CMAKE_PREFIX_PATH ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR} ${CMAKE_PREFIX_PATH})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OPENCMISS_DEPENDENCIES_LIBRARIES})

message(STATUS "prefix path: ${CMAKE_PREFIX_PATH}")

find_package(MPI REQUIRED)

#SET(CMAKE_C_COMPILER ${MPI_C_COMPILER})
#SET(CMAKE_C_FLAGS "-O3")
#SET(CMAKE_Fortran_COMPILER ${MPI_Fortran_COMPILER})
#SET(CMAKE_Fortran_FLAGS "-O3 -Q")

add_subdirectory(SuiteSparse_config)
add_subdirectory(metis-4.0.3)
add_subdirectory(AMD)
add_subdirectory(CAMD)
add_subdirectory(COLAMD)
add_subdirectory(CCOLAMD)
add_subdirectory(CHOLMOD)
add_subdirectory(UMFPACK)