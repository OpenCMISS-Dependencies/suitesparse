MACRO(ADDTEST NAME BINARY INFILE)
    add_test(${NAME} ${CMAKE_COMMAND}
            #-DCMD=$<TARGET_FILE:${BINARY}>
            -DCMD=${CMAKE_CURRENT_BINARY_DIR}/${BINARY}
            -DINFILE=${CMAKE_CURRENT_SOURCE_DIR}/Matrix/${INFILE}
            -P ${CMAKE_CURRENT_SOURCE_DIR}/testhelper.cmake)
ENDMACRO()

add_executable(umfpack_di_demo umfpack_di_demo.c)
target_link_libraries(umfpack_di_demo umfpack)
set(TARGET ${CMAKE_CURRENT_SOURCE_DIR}/umfpack_di_demo.out)
add_test(umfpack_di_demo ${CMAKE_COMMAND}
        -DCMD=${CMAKE_CURRENT_BINARY_DIR}/umfpack_di_demo
        -DTARGET=${TARGET}
        -P ${SuiteSparse_SOURCE_DIR}/testhelper.cmake)
        
#add_executable(umfpack_dl_demo umfpack_dl_demo.c)
#target_link_libraries(umfpack_dl_demo
#   # cholmod
#    umfpack
#   # amdi
#   # colamdi
#   # ccolamdi
#    suitesparseconfig
#)
#set(TARGET ${CMAKE_CURRENT_SOURCE_DIR}/umfpack_dl_demo.out)
#add_test(umfpack_dl_demo ${CMAKE_COMMAND}
#        -DCMD=${CMAKE_CURRENT_BINARY_DIR}/umfpack_dl_demo
#        -DTARGET=${TARGET}
#        -P ${SuiteSparse_SOURCE_DIR}/testhelper.cmake)

add_executable(umfpack_simple umfpack_simple.c)
target_link_libraries(umfpack_simple umfpack)
add_test(umfpack_simple umfpack_simple)