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
# kmcmake_cc_interface
################################################################################################
################################################################################
# Create a Library.
#
# Example usage:
#
# kmcmake_cc_library(  NAME myLibrary
#                  NAMESPACE myNamespace
#                  SOURCES
#                       myLib.cpp
#                       myLib_functions.cpp
#                  DEFINES
#                     USE_DOUBLE_PRECISION=1
#                  PUBLIC_INCLUDE_PATHS
#                     ${CMAKE_SOURCE_DIR}/mylib/include
#                  PRIVATE_INCLUDE_PATHS
#                     ${CMAKE_SOURCE_DIR}/include
#                  PRIVATE_LINKED_TARGETS
#                     Threads::Threads
#                  PUBLIC_LINKED_TARGETS
#                     Threads::Threads
#                  LINKED_TARGETS
#                     Threads::Threads
# )
#
# The above example creates an alias target, myNamespace::myLibrary which can be
# linked to by other tar gets.
# PUBLIC_DEFINES -  preprocessor defines which are inherated by targets which
#                       link to this library
#
#
# PUBLIC_INCLUDE_PATHS - include paths which are public, therefore inherted by
#                        targest which link to this library.
#
# PRIVATE_INCLUDE_PATHS - private include paths which are only visible by MyLibrary
#
# LINKED_TARGETS        - targets to link to.
################################################################################
function(kmcmake_cc_interface)
    set(options
            PUBLIC
            EXCLUDE_SYSTEM
    )
    set(args NAME
            NAMESPACE
    )

    set(list_args
            HEADERS
            COPTS
            CXXOPTS
            CUOPTS
            DEFINES
    )

    cmake_parse_arguments(
            PARSE_ARGV 0
            KMCMAKE_CC_INTERFACE
            "${options}"
            "${args}"
            "${list_args}"
    )

    if ("${KMCMAKE_CC_INTERFACE_NAME}" STREQUAL "")
        get_filename_component(KMCMAKE_CC_INTERFACE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
        string(REPLACE " " "_" KMCMAKE_CC_INTERFACE_NAME ${KMCMAKE_CC_INTERFACE_NAME})
        kmcmake_print(" Library, NAME argument not provided. Using folder name:  ${KMCMAKE_CC_INTERFACE_NAME}")
    endif ()

    if ("${KMCMAKE_CC_INTERFACE_NAMESPACE}" STREQUAL "")
        set(KMCMAKE_CC_INTERFACE_NAMESPACE ${PROJECT_NAME})
        message(" Library, NAMESPACE argument not provided. Using target alias:  ${KMCMAKE_CC_INTERFACE_NAME}::${KMCMAKE_CC_INTERFACE_NAME}")
    endif ()

    if ("${KMCMAKE_CC_INTERFACE_HEADERS}" STREQUAL "")
        kmcmake_error("no source give to the interface ${KMCMAKE_CC_INTERFACE_NAME}")
    endif ()

    set(${KMCMAKE_CC_INTERFACE_NAME}_INCLUDE_SYSTEM SYSTEM)
    if (KMCMAKE_CC_INTERFACE_EXCLUDE_SYSTEM)
        set(${KMCMAKE_CC_INTERFACE_NAME}_INCLUDE_SYSTEM "")
    endif ()

    kmcmake_raw("-----------------------------------")
    if (KMCMAKE_CC_INTERFACE_PUBLIC)
        set(KMCMAKE_CC_INTERFACE_INFO "${KMCMAKE_CC_INTERFACE_NAMESPACE}::${KMCMAKE_CC_INTERFACE_NAME}  INTERFACE PUBLIC")
    else ()
        set(KMCMAKE_CC_INTERFACE_INFO "${KMCMAKE_CC_INTERFACE_NAMESPACE}::${KMCMAKE_CC_INTERFACE_NAME}  INTERFACE INTERNAL")
    endif ()
    kmcmake_print_label("Create Library" "${KMCMAKE_CC_INTERFACE_INFO}")
    kmcmake_raw("-----------------------------------")
    if (VERBOSE_KMCMAKE_BUILD)
        kmcmake_print_list_label("Headers" KMCMAKE_CC_INTERFACE_HEADERS)
        kmcmake_raw("-----------------------------------")
    endif ()

    add_library(${KMCMAKE_CC_INTERFACE_NAME} INTERFACE)
    add_library(${KMCMAKE_CC_INTERFACE_NAMESPACE}::${KMCMAKE_CC_INTERFACE_NAME} ALIAS ${KMCMAKE_CC_INTERFACE_NAME})

    target_compile_options(${KMCMAKE_CC_INTERFACE_NAME} INTERFACE $<$<COMPILE_LANGUAGE:C>:${KMCMAKE_CC_INTERFACE_COPTS}>)
    target_compile_options(${KMCMAKE_CC_INTERFACE_NAME} INTERFACE $<$<COMPILE_LANGUAGE:CXX>:${KMCMAKE_CC_INTERFACE_CXXOPTS}>)
    target_compile_options(${KMCMAKE_CC_INTERFACE_NAME} INTERFACE $<$<COMPILE_LANGUAGE:CUDA>:${KMCMAKE_CC_INTERFACE_CUOPTS}>)

    target_include_directories(${KMCMAKE_CC_INTERFACE_NAME} ${${KMCMAKE_CC_INTERFACE_NAME}_INCLUDE_SYSTEM}
            INTERFACE
            "$<BUILD_INTERFACE:${${PROJECT_NAME}_SOURCE_DIR}>"
            "$<BUILD_INTERFACE:${${PROJECT_NAME}_BINARY_DIR}>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )

    target_compile_definitions(${KMCMAKE_CC_INTERFACE_NAME} INTERFACE ${KMCMAKE_CC_INTERFACE_DEFINES})


    if (KMCMAKE_CC_INTERFACE_PUBLIC)
        install(TARGETS ${KMCMAKE_CC_INTERFACE_NAME}
                EXPORT ${PROJECT_NAME}Targets
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        )
    endif ()

    foreach (arg IN LISTS KMCMAKE_CC_INTERFACE_UNPARSED_ARGUMENTS)
        message(WARNING "Unparsed argument: ${arg}")
    endforeach ()

endfunction()
