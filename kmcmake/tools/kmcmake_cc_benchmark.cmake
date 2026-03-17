# Copyright (C) Kumo inc. and its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
###################################################################################################


################################################################################################
# kmcmake_cc_benchmark
################################################################################################

function(kmcmake_cc_bm)
    set(options
            DISABLED
            EXT
    )
    set(args NAME
            MODULE
    )
    set(list_args
            DEPS
            SOURCES
            DEFINES
            COPTS
            CXXOPTS
            CUOPTS
            INCLUDES
            COMMAND
            LINKS
    )

    cmake_parse_arguments(
            KMCMAKE_CC_BM
            "${options}"
            "${args}"
            "${list_args}"
            ${ARGN}
    )

    if (NOT KMCMAKE_CC_BM_MODULE)
        kmcmake_error("no module name to the bm")
    endif ()

    kmcmake_raw("-----------------------------------")
    kmcmake_print_label("Building Benchmark" "${KMCMAKE_CC_BM_NAME}")
    kmcmake_raw("-----------------------------------")
    if (VERBOSE_KMCMAKE_BUILD)
        kmcmake_print_list_label("Sources" KMCMAKE_CC_BM_SOURCES)
        kmcmake_print_list_label("Deps" KMCMAKE_CC_BM_DEPS)
        kmcmake_print_list_label("COPTS" KMCMAKE_CC_BM_COPTS)
        kmcmake_print_list_label("Defines" KMCMAKE_CC_BM_DEFINES)
        kmcmake_print_list_label("Liniks" KMCMAKE_CC_BM_LINKS)
        message("-----------------------------------")
    endif ()
    set(${KMCMAKE_CC_BM_NAME}_INCLUDE_SYSTEM SYSTEM)
    if (KMCMAKE_CC_LIB_EXCLUDE_SYSTEM)
        set(${KMCMAKE_CC_BM_NAME}_INCLUDE_SYSTEM "")
    endif ()

    set(KMCMAKE_RUN_THIS_TEST ON)
    if (KMCMAKE_CC_BM_SKIP)
        set(KMCMAKE_RUN_THIS_TEST OFF)
    endif ()
    if (KMCMAKE_CC_BM_EXT)
        set(KMCMAKE_RUN_THIS_TEST OFF)
    endif ()
    set(testcase ${KMCMAKE_CC_BM_MODULE}_${KMCMAKE_CC_BM_NAME})
    if (${KMCMAKE_CC_BM_MODULE} IN_LIST ${PROJECT_NAME}_SKIP_BENCHMARK)
        set(KMCMAKE_RUN_THIS_TEST OFF)
    endif ()

    add_executable(${testcase} ${KMCMAKE_CC_BM_SOURCES})

    target_compile_options(${testcase} PRIVATE $<$<COMPILE_LANGUAGE:C>:${KMCMAKE_CC_BM_COPTS}>)
    target_compile_options(${testcase} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${KMCMAKE_CC_BM_CXXOPTS}>)
    target_compile_options(${testcase} PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:${KMCMAKE_CC_BM_CUOPTS}>)
    if (KMCMAKE_CC_BM_DEPS)
        add_dependencies(${testcase} ${KMCMAKE_CC_BM_DEPS})
    endif ()
    target_link_libraries(${testcase} PRIVATE ${KMCMAKE_CC_BM_LINKS})
    target_compile_definitions(${testcase}
            PUBLIC
            ${KMCMAKE_CC_BM_DEFINES}
    )

    target_include_directories(${testcase} ${${KMCMAKE_CC_BM_NAME}_INCLUDE_SYSTEM}
            PUBLIC
            ${KMCMAKE_CC_BM_INCLUDES}
            "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
            "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )
    if (NOT KMCMAKE_CC_BM_COMMAND)
        set(KMCMAKE_CC_BM_COMMAND ${testcase})
    endif ()

    if (KMCMAKE_RUN_THIS_TEST)
        add_test(NAME ${testcase}
                COMMAND ${KMCMAKE_CC_BM_COMMAND})
    endif ()

endfunction()

function(kmcmake_cc_bm_ext)
    set(options
            DISABLE
    )
    set(args NAME
            MODULE
            ALIAS
    )
    set(list_args
            ARGS
            FAIL_EXP
            SKIP_EXP
            PASS_EXP
    )

    cmake_parse_arguments(
            KMCMAKE_CC_BM_EXT
            "${options}"
            "${args}"
            "${list_args}"
            ${ARGN}
    )

    set(KMCMAKE_RUN_THIS_TEST ON)
    if (KMCMAKE_CC_BM_EXT_DISABLE)
        set(KMCMAKE_RUN_THIS_TEST OFF)
    endif ()

    if (KMCMAKE_CC_BM_EXT_MODULE)
        set(basecmd ${KMCMAKE_CC_BM_EXT_MODULE}_${KMCMAKE_CC_BM_EXT_NAME})
        if (${KMCMAKE_CC_BM_EXT_MODULE} IN_LIST ${PROJECT_NAME}_SKIP_BENCHMARK)
            set(KMCMAKE_RUN_THIS_TEST OFF)
        endif ()
    else ()
        set(basecmd ${KMCMAKE_CC_BM_EXT_NAME})
    endif ()

    if (KMCMAKE_CC_BM_EXT_ALIAS)
        set(test_name ${KMCMAKE_CC_BM_EXT_MODULE}_${KMCMAKE_CC_BM_EXT_NAME}_${KMCMAKE_CC_BM_EXT_ALIAS})
    else ()
        set(test_name ${KMCMAKE_CC_BM_EXT_MODULE}_${KMCMAKE_CC_BM_EXT_NAME})
    endif ()

    if (KMCMAKE_RUN_THIS_TEST)
        add_test(NAME ${test_name} COMMAND ${basecmd} ${KMCMAKE_CC_BM_EXT_ARGS})
        if (KMCMAKE_CC_BM_EXT_FAIL_EXP)
            set_property(TEST ${test_name} PROPERTY FAIL_REGULAR_EXPRESSION ${KMCMAKE_CC_BM_EXT_FAIL_EXP})
        endif ()
        if (KMCMAKE_CC_BM_EXT_PASS_EXP)
            set_property(TEST ${test_name} PROPERTY PASS_REGULAR_EXPRESSION ${KMCMAKE_CC_BM_EXT_PASS_EXP})
        endif ()
        if (KMCMAKE_CC_BM_EXT_SKIP_EXP)
            set_property(TEST ${test_name} PROPERTY SKIP_REGULAR_EXPRESSION ${KMCMAKE_CC_BM_EXT_SKIP_EXP})
        endif ()
    endif ()

endfunction()
