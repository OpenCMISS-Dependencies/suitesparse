project(METIS C)
CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

# Overwrite the opencmiss-
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

# Find sources.
file(GLOB metis_sources Lib/*.c)

# Build libmetis.
add_library(metis STATIC ${metis_sources})
target_include_directories(metis PUBLIC Lib)

if(UNIX)
  target_link_libraries(metis m)
endif()
#export(TARGETS metis FILE ${CMAKE_CURRENT_BINARY_DIR}/metis-config.cmake)

#add_executable(graphchk Programs/graphchk.c Programs/io.c)
#add_executable(graphchk Programs/kmetis.c Programs/io.c)
#add_executable(graphchk Programs/graphchk.c Programs/io.c)
#add_executable(graphchk Programs/graphchk.c Programs/io.c)
#add_executable(graphchk Programs/graphchk.c Programs/io.c)
#add_executable(graphchk Programs/graphchk.c Programs/io.c)