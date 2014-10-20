PROJECT(AMD C Fortran)
CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

file(GLOB src Source/*.c Source/*.f)
ADD_LIBRARY(amd STATIC ${src})
message(STATUS "ss inc dir: ${SS_CONFIG}")
TARGET_INCLUDE_DIRECTORIES(amd PRIVATE Include ../SuiteSparse_config)
#export(TARGETS amd FILE ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/amd-config.cmake)