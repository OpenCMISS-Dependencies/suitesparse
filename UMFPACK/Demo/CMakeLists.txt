MACRO(ADDTEST NAME BINARY INFILE)
    add_test(${NAME} ${CMAKE_COMMAND}
            #-DCMD=$<TARGET_FILE:${BINARY}>
            -DCMD=${CMAKE_CURRENT_BINARY_DIR}/${BINARY}
            -DINFILE=${CMAKE_CURRENT_SOURCE_DIR}/Matrix/${INFILE}
            -P ${CMAKE_CURRENT_SOURCE_DIR}/testhelper.cmake)
ENDMACRO()

foreach(prec d z)
    if(BUILD_PRECISION MATCHES [${prec}])
        set(name umfpack_${prec}${INT_TYPE_CHAR}_demo)
        add_executable(${name} ${name}.c)
        target_link_libraries(${name} umfpack)
        set(TARGET ${CMAKE_CURRENT_SOURCE_DIR}/${name}.out)
        add_test(${name} ${CMAKE_COMMAND}
                -DCMD=${CMAKE_CURRENT_BINARY_DIR}/${name}
                -DTARGET=${TARGET}
                -P ${SuiteSparse_SOURCE_DIR}/testhelper.cmake)        
    endif()
endforeach()

if(INT_TYPE_CHAR MATCHES [i])
    add_executable(umfpack_simple umfpack_simple.c)
    target_link_libraries(umfpack_simple umfpack)
    add_test(umfpack_simple umfpack_simple)
endif()