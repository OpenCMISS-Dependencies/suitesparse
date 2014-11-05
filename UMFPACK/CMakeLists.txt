CMAKE_MINIMUM_REQUIRED(VERSION 3.0)
PROJECT(UMFPACK VERSION 5.7.0 LANGUAGES C)

SET(COMMON_SRC 
Source/umf_ltsolve.c
Source/umf_utsolve.c
Source/umf_triplet.c
Source/umf_assemble.c
Source/umf_store_lu.c
Source/umf_assemble.c
Source/umf_blas3_update.c
Source/umf_build_tuples.c
Source/umf_create_element.c
Source/umf_dump.c
Source/umf_extend_front.c
Source/umf_garbage_collection.c
Source/umf_get_memory.c
Source/umf_init_front.c
Source/umf_kernel.c
Source/umf_kernel_init.c
Source/umf_kernel_wrapup.c
Source/umf_local_search.c
Source/umf_lsolve.c
Source/umf_ltsolve.c
Source/umf_mem_alloc_element.c
Source/umf_mem_alloc_head_block.c
Source/umf_mem_alloc_tail_block.c
Source/umf_mem_free_tail_block.c
Source/umf_mem_init_memoryspace.c
Source/umf_report_vector.c
Source/umf_row_search.c
Source/umf_scale_column.c
Source/umf_set_stats.c
Source/umf_solve.c
Source/umf_symbolic_usage.c
Source/umf_transpose.c
Source/umf_tuple_lengths.c
Source/umf_usolve.c
Source/umf_utsolve.c
Source/umf_valid_numeric.c
Source/umf_valid_symbolic.c
Source/umf_grow_front.c
Source/umf_start_front.c
Source/umf_store_lu.c
Source/umf_scale.c
Source/umfpack_solve.c
Source/umfpack_col_to_triplet.c
Source/umfpack_defaults.c
Source/umfpack_free_numeric.c
Source/umfpack_free_symbolic.c
Source/umfpack_get_numeric.c
Source/umfpack_get_lunz.c
Source/umfpack_get_symbolic.c
Source/umfpack_get_determinant.c
Source/umfpack_numeric.c
Source/umfpack_qsymbolic.c
Source/umfpack_report_control.c
Source/umfpack_report_info.c
Source/umfpack_report_matrix.c
Source/umfpack_report_numeric.c
Source/umfpack_report_perm.c
Source/umfpack_report_status.c
Source/umfpack_report_symbolic.c
Source/umfpack_report_triplet.c
Source/umfpack_report_vector.c
Source/umfpack_solve.c
Source/umfpack_symbolic.c
Source/umfpack_transpose.c
Source/umfpack_triplet_to_col.c
Source/umfpack_scale.c
Source/umfpack_load_numeric.c
Source/umfpack_save_numeric.c
Source/umfpack_load_symbolic.c
Source/umfpack_save_symbolic.c
)
SET(DOUBLE_PREC_EXTRA_SRC
Source/umf_analyze.c
Source/umf_apply_order.c
Source/umf_colamd.c
Source/umf_cholmod.c
Source/umf_free.c
Source/umf_fsize.c
Source/umf_is_permutation.c
Source/umf_malloc.c
Source/umf_realloc.c
Source/umf_report_perm.c
Source/umf_singletons.c
)

macro(ADDSTUFF name)
    TARGET_INCLUDE_DIRECTORIES(${name} PRIVATE 
        Source ../SuiteSparse_config ../AMD/Include
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>
        $<BUILD_INTERFACE:$<TARGET_PROPERTY:cholmod,INTERFACE_INCLUDE_DIRECTORIES>>
    )    
endmacro()

SET(OBJS )
foreach(prec d z)
    if(BUILD_PRECISION MATCHES [${prec}])
        message(STATUS "Building UMFPACK precision '${prec}'")
        STRING(TOUPPER ${prec} PREC)
        SET(CDEFS ${PREC}${INT_TYPE_FLAG})
        add_library(${prec}map_nox OBJECT Source/umf_triplet.c)
        ADDSTUFF(${prec}map_nox)
        target_compile_definitions(${prec}map_nox PRIVATE DO_MAP ${CDEFS})
        
        add_library(${prec}nomap_x OBJECT Source/umf_triplet.c)
        target_compile_definitions(${prec}nomap_x PRIVATE DO_VALUES ${CDEFS})
        ADDSTUFF(${prec}nomap_x)
        
        add_library(${prec}map_x OBJECT Source/umf_triplet.c)
        target_compile_definitions(${prec}map_x PRIVATE DO_MAP DO_VALUES ${CDEFS})
        ADDSTUFF(${prec}map_x)
        
        add_library(${prec}wsolve OBJECT Source/umfpack_solve.c)
        target_compile_definitions(${prec}wsolve PRIVATE WSOLVE ${CDEFS})
        ADDSTUFF(${prec}wsolve)
        
        add_library(${prec}cgsolve OBJECT Source/umf_ltsolve.c Source/umf_utsolve.c)
        target_compile_definitions(${prec}cgsolve PRIVATE CONJUGATE_SOLVE ${CDEFS})
        ADDSTUFF(${prec}cgsolve)
        
        add_library(${prec}fixq OBJECT Source/umf_assemble.c)
        target_compile_definitions(${prec}fixq PRIVATE FIXQ ${CDEFS})
        ADDSTUFF(${prec}fixq)
        
        add_library(${prec}drop OBJECT Source/umf_store_lu.c)
        target_compile_definitions(${prec}drop PRIVATE DROP ${CDEFS})
        ADDSTUFF(${prec}drop)
        
        SET(EXTRA_SRC )
        if(${prec} STREQUAL d)
            SET(EXTRA_SRC ${DOUBLE_PREC_EXTRA_SRC})
        endif()
        add_library(${prec}umfpack OBJECT ${COMMON_SRC} ${EXTRA_SRC})
        target_compile_definitions(${prec}umfpack PRIVATE ${CDEFS})
        ADDSTUFF(${prec}umfpack)
        
        LIST(APPEND OBJS "$<TARGET_OBJECTS:${prec}umfpack>"
            "$<TARGET_OBJECTS:${prec}map_nox>"
            "$<TARGET_OBJECTS:${prec}nomap_x>"
            "$<TARGET_OBJECTS:${prec}map_x>"
            "$<TARGET_OBJECTS:${prec}wsolve>"
            "$<TARGET_OBJECTS:${prec}cgsolve>"
            "$<TARGET_OBJECTS:${prec}fixq>"
            "$<TARGET_OBJECTS:${prec}drop>"
        )        
    endif()
endforeach()
	
ADD_LIBRARY(umfpack STATIC ${OBJS} Source/umfpack_timer.c Source/umfpack_tictoc.c)
target_link_libraries(umfpack PUBLIC cholmod)
ADDSTUFF(umfpack)
set_target_properties(umfpack PROPERTIES OUTPUT_NAME umfpack-${UMFPACK_VERSION})

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