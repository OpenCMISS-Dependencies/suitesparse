#PROJECT(AMD C Fortran)
#CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

file(GLOB src Source/*.c Source/*.f)
#file(GLOB srcl Source/*.c Source/*.f)
#set_source_files_properties(${srcl} PROPERTIES COMPILE_DEFINITIONS DLONG)
#set_source_files_properties(${src} PROPERTIES COMPILE_DEFINITIONS DINT)

# Version with -DINT
ADD_LIBRARY(amdi STATIC ${src})
target_compile_definitions(amdi PRIVATE DINT)
TARGET_INCLUDE_DIRECTORIES(amdi 
    PRIVATE ../SuiteSparse_config
    PUBLIC Include)
# Version with -DLONG
ADD_LIBRARY(amdl STATIC ${src})
target_compile_definitions(amdl PRIVATE DLONG)
TARGET_INCLUDE_DIRECTORIES(amdl 
    PRIVATE ../SuiteSparse_config
    PUBLIC Include)
#file(WRITE dummy.c "")
#ADD_LIBRARY(amd STATIC dummy.c)
#target_link_libraries(amd PUBLIC amdi amdl)
#TARGET_INCLUDE_DIRECTORIES(amd 
#    PRIVATE ../SuiteSparse_config
#    PUBLIC Include)

#export(TARGETS amd FILE ${OPENCMISS_DEPENDENCIES_CONFIGS_DIR}/amd-config.cmake)

# add tests/demos
if (BUILD_TESTING)
    add_subdirectory(Demo)
endif()