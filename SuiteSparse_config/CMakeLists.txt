ADD_LIBRARY(suitesparseconfig SuiteSparse_config.c)
TARGET_INCLUDE_DIRECTORIES(suitesparseconfig
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)

install(TARGETS suitesparseconfig EXPORT suitesparse-config
    DESTINATION lib INCLUDES DESTINATION include)
install(FILES SuiteSparse_config.h DESTINATION include)

if (UNIX)
    target_link_libraries(suitesparseconfig PUBLIC m)
    if (NOT APPLE)
        target_link_libraries(suitesparseconfig PUBLIC rt)
    endif()
endif()