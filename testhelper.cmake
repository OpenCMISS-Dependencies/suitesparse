execute_process(COMMAND ${CMD} 
    OUTPUT_VARIABLE CMD_RESULT 
    RESULT_VARIABLE CMD_RETCODE)
file(WRITE tmp "${CMD_RESULT}")
execute_process(COMMAND ${CMAKE_COMMAND} 
    -E compare_files tmp ${TARGET}
    RESULT_VARIABLE CMP_RETCODE)
if(CMD_RETCODE OR CMP_RETCODE)
    file(WRITE ${TARGET}.testout "${CMD_RESULT}")       
    message(FATAL_ERROR "Test binary ${CMD} failed: CMD_RETCODE=${CMD_RETCODE}, CMP_RETCODE=${CMP_RETCODE}")
endif()
file(REMOVE tmp)