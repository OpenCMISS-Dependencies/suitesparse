MACRO(CREATE_TEST NAME TYPE)
    add_executable(${NAME} ${NAME}.${TYPE} ${extra})
    target_include_directories(${NAME} PRIVATE 
        ../Include
    $<TARGET_PROPERTY:suitesparseconfig,INTERFACE_INCLUDE_DIRECTORIES>)
    target_link_libraries(${NAME} PRIVATE amdi amdl suitesparseconfig)
    if (UNIX)
        target_link_libraries(${NAME} PRIVATE rt)
    endif()
    
    set(TARGET ${CMAKE_CURRENT_SOURCE_DIR}/${NAME}.out)
    add_test(NAME ${NAME}
        COMMAND ${CMAKE_COMMAND}
            -DCMD=$<TARGET_FILE:${NAME}>
            -DTARGET=${TARGET}
            -P ${CMAKE_CURRENT_SOURCE_DIR}/testhelper.cmake)
ENDMACRO()

set(extra "")
CREATE_TEST(amd_demo c)
CREATE_TEST(amd_simple c)
CREATE_TEST(amd_demo2 c)
CREATE_TEST(amd_l_demo c)
CREATE_TEST(amd_f77demo f)
CREATE_TEST(amd_f77simple f)
set(extra amd_f77wrapper.c)
CREATE_TEST(amd_f77cross f)