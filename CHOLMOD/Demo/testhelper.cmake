message(STATUS "Command: ${CMD}, Infile: ${INFILE}")
execute_process(COMMAND ${CMD} 
    INPUT_FILE ${INFILE}
    RESULT_VARIABLE RETCODE
    OUTPUT_VARIABLE OUT)
if (RETCODE)
    message(STATUS "Code: ${RETCODE}, Output: ${OUT}")
    message(FATAL_ERROR "Test failed")
endif()
