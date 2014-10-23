ADD_LIBRARY(suitesparseconfig STATIC SuiteSparse_config.c)
TARGET_INCLUDE_DIRECTORIES(suitesparseconfig PUBLIC .)
# Use timing plugin
if (UNIX)
    target_link_libraries(suitesparseconfig PUBLIC rt)
endif()