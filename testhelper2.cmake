execute_process(COMMAND ${CMD}
    INPUT_FILE ${INFILE} 
    OUTPUT_VARIABLE CMD_RESULT 
    RESULT_VARIABLE CMD_RETCODE
    ERROR_VARIABLE CMD_ERR)
if(CMD_RETCODE)   
    message(FATAL_ERROR "Test binary ${CMD} failed: CMD_RETCODE=${CMD_RETCODE}, CMD_ERR=${CMD_ERR}")
endif()
message(STATUS "Result of test ${CMD}:\n${CMD_RESULT}")