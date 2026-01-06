# Copyright (C) Kumo inc. and its affiliates.
# Author: Jeff.li lijippy@163.com
# All rights reserved.
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
###################################################################################################

################################################################################################
# kmcmake_cc_test
################################################################################################

function(kmcmake_cc_test)
    set(options
            DISABLED
            EXT
            EXCLUDE_SYSTEM
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
            KMCMAKE_CC_TEST
            "${options}"
            "${args}"
            "${list_args}"
            ${ARGN}
    )
    if (NOT KMCMAKE_CC_TEST_MODULE)
        kmcmake_error("no module name")
    endif ()
    kmcmake_raw("-----------------------------------")
    kmcmake_print_label("Building Test" "${KMCMAKE_CC_TEST_NAME}")
    kmcmake_raw("-----------------------------------")

    set(${KMCMAKE_CC_TEST_NAME}_INCLUDE_SYSTEM SYSTEM)
    if (KMCMAKE_CC_LIB_EXCLUDE_SYSTEM)
        set(${KMCMAKE_CC_TEST_NAME}_INCLUDE_SYSTEM "")
    endif ()

    if (VERBOSE_KMCMAKE_BUILD)
        kmcmake_print_list_label("Sources" KMCMAKE_CC_TEST_SOURCES)
        kmcmake_print_list_label("Deps" KMCMAKE_CC_TEST_DEPS)
        kmcmake_print_list_label("COPTS" KMCMAKE_CC_TEST_COPTS)
        kmcmake_print_list_label("Defines" KMCMAKE_CC_TEST_DEFINES)
        kmcmake_print_list_label("Links" KMCMAKE_CC_TEST_LINKS)
        message("-----------------------------------")
    endif ()
    set(KMCMAKE_RUN_THIS_TEST ON)
    if (KMCMAKE_CC_TEST_SKIP)
        set(KMCMAKE_RUN_THIS_TEST OFF)
    endif ()
    if (KMCMAKE_CC_TEST_EXT)
        set(KMCMAKE_RUN_THIS_TEST OFF)
    endif ()

    set(testcase ${KMCMAKE_CC_TEST_MODULE}_${KMCMAKE_CC_TEST_NAME})
    if (${KMCMAKE_CC_TEST_MODULE} IN_LIST ${PROJECT_NAME}_SKIP_TEST)
        set(KMCMAKE_RUN_THIS_TEST OFF)
    endif ()

    add_executable(${testcase} ${KMCMAKE_CC_TEST_SOURCES})

    target_compile_options(${testcase} PRIVATE $<$<COMPILE_LANGUAGE:C>:${KMCMAKE_CC_TEST_COPTS}>)
    target_compile_options(${testcase} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${KMCMAKE_CC_TEST_CXXOPTS}>)
    target_compile_options(${testcase} PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:${KMCMAKE_CC_TEST_CUOPTS}>)
    if (KMCMAKE_CC_TEST_DEPS)
        add_dependencies(${testcase} ${KMCMAKE_CC_TEST_DEPS})
    endif ()
    target_link_libraries(${testcase} PRIVATE ${KMCMAKE_CC_TEST_LINKS})

    target_compile_definitions(${testcase}
            PUBLIC
            ${KMCMAKE_CC_TEST_DEFINES}
    )

    target_include_directories(${testcase} ${${KMCMAKE_CC_TEST_NAME}_INCLUDE_SYSTEM}
            PUBLIC
            ${KMCMAKE_CC_TEST_INCLUDES}
            "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>"
            "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )
    if (NOT KMCMAKE_CC_TEST_COMMAND)
        set(KMCMAKE_CC_TEST_COMMAND ${testcase})
    endif ()

    if (KMCMAKE_RUN_THIS_TEST)
        add_test(NAME ${testcase}
                COMMAND ${KMCMAKE_CC_TEST_COMMAND})
    endif ()

endfunction()

function(kmcmake_cc_test_ext)
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
            KMCMAKE_CC_TEST_EXT
            "${options}"
            "${args}"
            "${list_args}"
            ${ARGN}
    )

    set(KMCMAKE_RUN_THIS_TEST ON)
    if (KMCMAKE_CC_TEST_EXT_DISABLE)
        set(KMCMAKE_RUN_THIS_TEST OFF)
    endif ()

    if (KMCMAKE_CC_TEST_EXT_MODULE)
        set(basecmd ${KMCMAKE_CC_TEST_EXT_MODULE}_${KMCMAKE_CC_TEST_EXT_NAME})
        if (${KMCMAKE_CC_TEST_EXT_MODULE} IN_LIST ${PROJECT_NAME}_SKIP_TEST)
            set(KMCMAKE_RUN_THIS_TEST OFF)
        endif ()
    else ()
        set(basecmd ${KMCMAKE_CC_TEST_EXT_NAME})
    endif ()

    if (KMCMAKE_CC_TEST_EXT_ALIAS)
        set(test_name ${KMCMAKE_CC_TEST_EXT_MODULE}_${KMCMAKE_CC_TEST_EXT_NAME}_${KMCMAKE_CC_TEST_EXT_ALIAS})
    else ()
        set(test_name ${KMCMAKE_CC_TEST_EXT_MODULE}_${KMCMAKE_CC_TEST_EXT_NAME})
    endif ()

    if (KMCMAKE_RUN_THIS_TEST)
        add_test(NAME ${test_name} COMMAND ${basecmd} ${KMCMAKE_CC_TEST_EXT_ARGS})
        if (KMCMAKE_CC_TEST_EXT_FAIL_EXP)
            set_property(TEST ${test_name} PROPERTY FAIL_REGULAR_EXPRESSION ${KMCMAKE_CC_TEST_EXT_FAIL_EXP})
        endif ()
        if (KMCMAKE_CC_TEST_EXT_PASS_EXP)
            set_property(TEST ${test_name} PROPERTY PASS_REGULAR_EXPRESSION ${KMCMAKE_CC_TEST_EXT_PASS_EXP})
        endif ()
        if (KMCMAKE_CC_TEST_EXT_SKIP_EXP)
            set_property(TEST ${test_name} PROPERTY SKIP_REGULAR_EXPRESSION ${KMCMAKE_CC_TEST_EXT_SKIP_EXP})
        endif ()
    endif ()

endfunction()


function(kmcmake_cc_test_library)
    set(options
            SHARED
            EXCLUDE_SYSTEM
    )
    set(args NAME
            NAMESPACE
    )

    set(list_args
            DEPS
            SOURCES
            OBJECTS
            HEADERS
            INCLUDES
            PINCLUDES
            DEFINES
            COPTS
            CXXOPTS
            CUOPTS
            LINKS
            PLINKS
            WLINKS
    )

    cmake_parse_arguments(
            PARSE_ARGV 0
            KMCMAKE_CC_LIB
            "${options}"
            "${args}"
            "${list_args}"
    )

    if ("${KMCMAKE_CC_LIB_NAME}" STREQUAL "")
        get_filename_component(KMCMAKE_CC_LIB_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
        string(REPLACE " " "_" KMCMAKE_CC_LIB_NAME ${KMCMAKE_CC_LIB_NAME})
        kmcmake_print(" Library, NAME argument not provided. Using folder name:  ${KMCMAKE_CC_LIB_NAME}")
    endif ()

    if ("${KMCMAKE_CC_LIB_NAMESPACE}" STREQUAL "")
        set(KMCMAKE_CC_LIB_NAMESPACE ${PROJECT_NAME})
        kmcmake_print(" Library, NAMESPACE argument not provided. Using target alias:  ${KMCMAKE_CC_LIB_NAME}::${KMCMAKE_CC_LIB_NAME}")
    endif ()

    kmcmake_raw("-----------------------------------")
    if (KMCMAKE_CC_LIB_SHARED)
        set(KMCMAKE_LIB_INFO "${KMCMAKE_CC_LIB_NAMESPACE}::${KMCMAKE_CC_LIB_NAME}  SHARED&STATIC INTERNAL")
    else ()
        set(KMCMAKE_LIB_INFO "${KMCMAKE_CC_LIB_NAMESPACE}::${KMCMAKE_CC_LIB_NAME}  STATIC INTERNAL")
    endif ()

    set(${KMCMAKE_CC_LIB_NAME}_INCLUDE_SYSTEM SYSTEM)
    if (KMCMAKE_CC_LIB_EXCLUDE_SYSTEM)
        set(${KMCMAKE_CC_LIB_NAME}_INCLUDE_SYSTEM "")
    endif ()

    kmcmake_print_label("Create Library" "${KMCMAKE_LIB_INFO}")
    kmcmake_raw("-----------------------------------")
    if (VERBOSE_KMCMAKE_BUILD)
        kmcmake_print_list_label("Sources" KMCMAKE_CC_LIB_SOURCES)
        kmcmake_print_list_label("Objects" KMCMAKE_CC_LIB_OBJECTS)
        kmcmake_print_list_label("Deps" KMCMAKE_CC_LIB_DEPS)
        kmcmake_print_list_label("COPTS" KMCMAKE_CC_LIB_COPTS)
        kmcmake_print_list_label("CXXOPTS" KMCMAKE_CC_LIB_CXXOPTS)
        kmcmake_print_list_label("CUOPTS" KMCMAKE_CC_LIB_CUOPTS)
        kmcmake_print_list_label("Defines" KMCMAKE_CC_LIB_DEFINES)
        kmcmake_print_list_label("Includes" KMCMAKE_CC_LIB_INCLUDES)
        kmcmake_print_list_label("Private Includes" KMCMAKE_CC_LIB_PINCLUDES)
        kmcmake_print_list_label("Links" KMCMAKE_CC_LIB_LINKS)
        kmcmake_print_list_label("Private Links" KMCMAKE_CC_LIB_PLINKS)
        kmcmake_raw("-----------------------------------")
    endif ()
    set(KMCMAKE_CC_LIB_OBJECTS_FLATTEN)
    if (KMCMAKE_CC_LIB_OBJECTS)
        foreach (obj IN LISTS KMCMAKE_CC_LIB_OBJECTS)
            list(APPEND KMCMAKE_CC_LIB_OBJECTS_FLATTEN $<TARGET_OBJECTS:${obj}>)
        endforeach ()
    endif ()
    if (KMCMAKE_CC_LIB_SOURCES)
        add_library(${KMCMAKE_CC_LIB_NAME}_OBJECT OBJECT ${KMCMAKE_CC_LIB_SOURCES} ${KMCMAKE_CC_LIB_HEADERS})
        list(APPEND KMCMAKE_CC_LIB_OBJECTS_FLATTEN $<TARGET_OBJECTS:${KMCMAKE_CC_LIB_NAME}_OBJECT>)
        if (KMCMAKE_CC_LIB_DEPS)
            add_dependencies(${KMCMAKE_CC_LIB_NAME}_OBJECT ${KMCMAKE_CC_LIB_DEPS})
        endif ()
        set_property(TARGET ${KMCMAKE_CC_LIB_NAME}_OBJECT PROPERTY POSITION_INDEPENDENT_CODE 1)
        target_compile_options(${KMCMAKE_CC_LIB_NAME}_OBJECT PRIVATE $<$<COMPILE_LANGUAGE:C>:${KMCMAKE_CC_LIB_COPTS}>)
        target_compile_options(${KMCMAKE_CC_LIB_NAME}_OBJECT PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${KMCMAKE_CC_LIB_CXXOPTS}>)
        target_compile_options(${KMCMAKE_CC_LIB_NAME}_OBJECT PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:${KMCMAKE_CC_LIB_CUOPTS}>)
        target_include_directories(${KMCMAKE_CC_LIB_NAME}_OBJECT ${${KMCMAKE_CC_LIB_NAME}_INCLUDE_SYSTEM}
                PUBLIC
                ${KMCMAKE_CC_LIB_INCLUDES}
                "$<BUILD_INTERFACE:${${PROJECT_NAME}_SOURCE_DIR}>"
                "$<BUILD_INTERFACE:${${PROJECT_NAME}_BINARY_DIR}>"
                "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
        )
        target_include_directories(${KMCMAKE_CC_LIB_NAME}_OBJECT ${${KMCMAKE_CC_LIB_NAME}_INCLUDE_SYSTEM}
                PRIVATE
                ${KMCMAKE_CC_LIB_PINCLUDES}
        )

        target_compile_definitions(${KMCMAKE_CC_LIB_NAME}_OBJECT
                PUBLIC
                ${KMCMAKE_CC_LIB_DEFINES}
        )
    endif ()

    list(LENGTH KMCMAKE_CC_LIB_OBJECTS_FLATTEN obj_len)
    if (obj_len EQUAL -1)
        kmcmake_error("no source or object give to the library ${KMCMAKE_CC_LIB_NAME}")
    endif ()
    add_library(${KMCMAKE_CC_LIB_NAME}_static STATIC ${KMCMAKE_CC_LIB_OBJECTS_FLATTEN})
    if (${KMCMAKE_CC_LIB_NAME}_OBJECT)
        add_dependencies(${KMCMAKE_CC_LIB_NAME}_static ${KMCMAKE_CC_LIB_NAME}_OBJECT)
    endif ()
    if (KMCMAKE_CC_LIB_DEPS)
        add_dependencies(${KMCMAKE_CC_LIB_NAME}_static ${KMCMAKE_CC_LIB_DEPS})
    endif ()
    target_link_libraries(${KMCMAKE_CC_LIB_NAME}_static PRIVATE ${KMCMAKE_CC_LIB_PLINKS})
    target_link_libraries(${KMCMAKE_CC_LIB_NAME}_static PUBLIC ${KMCMAKE_CC_LIB_LINKS})
    target_link_libraries(${KMCMAKE_CC_LIB_NAME}_static PRIVATE ${KMCMAKE_CC_LIB_WLINKS})
    set_target_properties(${KMCMAKE_CC_LIB_NAME}_static PROPERTIES
            OUTPUT_NAME ${KMCMAKE_CC_LIB_NAME})
    add_library(${KMCMAKE_CC_LIB_NAMESPACE}::${KMCMAKE_CC_LIB_NAME}_static ALIAS ${KMCMAKE_CC_LIB_NAME}_static)
    if (KMCMAKE_CC_LIB_SHARED)
        add_library(${KMCMAKE_CC_LIB_NAME}_shared SHARED ${KMCMAKE_CC_LIB_OBJECTS_FLATTEN})
        if (${KMCMAKE_CC_LIB_NAME}_OBJECT)
            add_dependencies(${KMCMAKE_CC_LIB_NAME}_shared ${KMCMAKE_CC_LIB_NAME}_OBJECT)
        endif ()
        if (KMCMAKE_CC_LIB_DEPS)
            add_dependencies(${KMCMAKE_CC_LIB_NAME}_shared ${KMCMAKE_CC_LIB_DEPS})
        endif ()
        target_link_libraries(${KMCMAKE_CC_LIB_NAME}_shared PRIVATE ${KMCMAKE_CC_LIB_PLINKS})
        target_link_libraries(${KMCMAKE_CC_LIB_NAME}_shared PUBLIC ${KMCMAKE_CC_LIB_LINKS})
        foreach (link ${KMCMAKE_CC_LIB_WLINKS})
            target_link_libraries(${KMCMAKE_CC_LIB_NAME}_shared PRIVATE $<LINK_LIBRARY:WHOLE_ARCHIVE,${link}>)
        endforeach ()
        set_target_properties(${KMCMAKE_CC_LIB_NAME}_shared PROPERTIES
                OUTPUT_NAME ${KMCMAKE_CC_LIB_NAME}
                VERSION ${${PROJECT_NAME}_VERSION}
                SOVERSION ${${PROJECT_NAME}_VERSION_MAJOR})
        add_library(${KMCMAKE_CC_LIB_NAMESPACE}::${KMCMAKE_CC_LIB_NAME} ALIAS ${KMCMAKE_CC_LIB_NAME}_shared)
    endif ()

    foreach (arg IN LISTS KMCMAKE_CC_LIB_UNPARSED_ARGUMENTS)
        message(WARNING "Unparsed argument: ${arg}")
    endforeach ()

endfunction()
