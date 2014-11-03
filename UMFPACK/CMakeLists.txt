CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT(UMFPACK VERSION 5.7.0 LANGUAGES C)

file(GLOB src Source/*.c)
ADD_LIBRARY(umfpack STATIC ${src})
set_target_properties(umfpack PROPERTIES OUTPUT_NAME umfpack-${UMFPACK_VERSION})
target_link_libraries(umfpack PUBLIC cholmod)
TARGET_INCLUDE_DIRECTORIES(umfpack PRIVATE 
    Source ../SuiteSparse_config ../AMD/Include
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>
)

install(TARGETS umfpack EXPORT umfpack-config
    DESTINATION lib
    INCLUDES DESTINATION include)
install(EXPORT umfpack-config DESTINATION lib/cmake)
WRITE_BASIC_PACKAGE_VERSION_FILE(${CMAKE_CURRENT_BINARY_DIR}/umfpack-config-version.cmake
    COMPATIBILITY AnyNewerVersion)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/umfpack-config-version.cmake DESTINATION lib/cmake)    

if (BUILD_TESTS)
    add_subdirectory(Demo)
endif()