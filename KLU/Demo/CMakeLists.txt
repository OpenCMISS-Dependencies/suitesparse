MACRO(CREATE_EXEC_KLU NAME)
    add_executable(${NAME} ${NAME}.c)
    target_include_directories(${NAME} PRIVATE 
        ../Include
        ${SuiteSparse_SOURCE_DIR}/SuiteSparse_config)
    target_link_libraries(${NAME} PRIVATE cholmod klu btf suitesparseconfig)
    if (UNIX)
        target_link_libraries(${NAME} PRIVATE m)
    endif()
ENDMACRO()

macro(ADDTEST name exec matfile)
    add_test(NAME ${name}
        COMMAND ${CMAKE_COMMAND}
            -DCMD=$<TARGET_FILE:${exec}>
            -DINFILE=${CMAKE_CURRENT_SOURCE_DIR}/../Matrix/${matfile}
            -P ${SuiteSparse_SOURCE_DIR}/testhelper2.cmake)
endmacro()

IF(INT_TYPE_CHAR STREQUAL i)
    CREATE_EXEC_KLU(klu_simple)
    add_test(klu_simple klu_simple)
    
    CREATE_EXEC_KLU(kludemo)
    
    ADDTEST(kludemo1 kludemo 1c.mtx)
    ADDTEST(kludemo2 kludemo arrowc.mtx)
    ADDTEST(kludemo3 kludemo arrow.mtx)
    ADDTEST(kludemo4 kludemo impcol_a.mtx)
    ADDTEST(kludemo5 kludemo w156.mtx)
    ADDTEST(kludemo6 kludemo ctina.mtx)
endif()

IF(INT_TYPE_CHAR STREQUAL l)
    CREATE_EXEC_KLU(kluldemo)
    ADDTEST(kluldemo1 kluldemo 1c.mtx)
    ADDTEST(kluldemo2 kluldemo arrowc.mtx)
    ADDTEST(kluldemo3 kluldemo arrow.mtx)
    ADDTEST(kluldemo4 kluldemo impcol_a.mtx)
    ADDTEST(kluldemo5 kluldemo w156.mtx)
    ADDTEST(kluldemo6 kluldemo ctina.mtx)
endif()