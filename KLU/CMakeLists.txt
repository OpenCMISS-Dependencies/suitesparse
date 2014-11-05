SET(src 
    Source/klu_diagnostics.c
    Source/klu_dump.c
    Source/klu_extract.c
    Source/klu_factor.c
    Source/klu_free_numeric.c
    Source/klu_kernel.c
    Source/klu_refactor.c
    Source/klu_scale.c
    Source/klu_solve.c
    Source/klu_sort.c
    Source/klu_tsolve.c
    Source/klu.c
)
SET(src_allprec
    Source/klu_analyze.c
    Source/klu_analyze_given.c
    Source/klu_defaults.c
    Source/klu_free_symbolic.c
    Source/klu_memory.c
)

SET(OBJS )
SET(zFLAG COMPLEX)
SET(dFLAG )
foreach(inttype DLONG DINT)
    foreach(prec d z)
        # Build complex by default as the test uses both :-(
        #if (BUILD_PRECISION MATCHES [${prec}])
            SET(name ${prec}${inttype}klu)
            ADD_LIBRARY(${name} OBJECT ${src})
            target_compile_definitions(${name} PRIVATE ${inttype} ${${prec}FLAG})
            TARGET_INCLUDE_DIRECTORIES(${name} 
                PRIVATE ../SuiteSparse_config
                ../AMD/Include ../COLAMD/Include ../BTF/Include
                PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)
            LIST(APPEND OBJS "$<TARGET_OBJECTS:${name}>")        
        #endif()
    endforeach()
    SET(name ${inttype}klu_common)
    ADD_LIBRARY(${name} OBJECT ${src_allprec})
    target_compile_definitions(${name} PRIVATE ${inttype})
    TARGET_INCLUDE_DIRECTORIES(${name} 
        PRIVATE ../SuiteSparse_config
        ../AMD/Include ../COLAMD/Include ../BTF/Include
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Include>)
    LIST(APPEND OBJS "$<TARGET_OBJECTS:${name}>")
endforeach()

add_library(klu ${OBJS})
target_link_libraries(klu PUBLIC btf amd colamd)
install(TARGETS klu EXPORT suitesparse-config
    DESTINATION lib INCLUDES DESTINATION include)
install(FILES Include/klu.h DESTINATION include)

#if(BUILD_TESTING)
  add_subdirectory(Demo)
#endif()