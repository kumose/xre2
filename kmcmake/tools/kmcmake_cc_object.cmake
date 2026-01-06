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
# kmcmake_cc_object
################################################################################################
################################################################################
# Create a Library.
#
# Example usage:
#
# kmcmake_cc_object(  NAME myLibrary
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
function(kmcmake_cc_object)
    set(options
            EXCLUDE_SYSTEM
    )
    set(args NAME
            NAMESPACE
    )

    set(list_args
            DEPS
            SOURCES
            HEADERS
            INCLUDES
            PINCLUDES
            DEFINES
            COPTS
            CXXOPTS
            CUOPTS
    )

    cmake_parse_arguments(
            PARSE_ARGV 0
            KMCMAKE_CC_OBJECT
            "${options}"
            "${args}"
            "${list_args}"
    )

    if ("${KMCMAKE_CC_OBJECT_NAME}" STREQUAL "")
        get_filename_component(KMCMAKE_CC_OBJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
        string(REPLACE " " "_" KMCMAKE_CC_OBJECT_NAME ${KMCMAKE_CC_OBJECT_NAME})
        kmcmake_print(" Library, NAME argument not provided. Using folder name:  ${KMCMAKE_CC_OBJECT_NAME}")
    endif ()

    if (NOT KMCMAKE_CC_OBJECT_NAMESPACE OR "${KMCMAKE_CC_OBJECT_NAMESPACE}" STREQUAL "")
        set(KMCMAKE_CC_OBJECT_NAMESPACE ${PROJECT_NAME})
        kmcmake_print(" Library, NAMESPACE argument not provided. Using target alias:  ${KMCMAKE_CC_OBJECT_NAME}::${KMCMAKE_CC_OBJECT_NAME}")
    endif ()

    if ("${KMCMAKE_CC_OBJECT_SOURCES}" STREQUAL "")
        kmcmake_error("no source give to the library ${KMCMAKE_CC_OBJECT_NAME}, using kmcmake_cc_object instead")
    endif ()

    kmcmake_raw("-----------------------------------")
    set(KMCMAKE_LIB_INFO "${KMCMAKE_CC_OBJECT_NAMESPACE}::${KMCMAKE_CC_OBJECT_NAME}  OBJECT ")

    set(${KMCMAKE_CC_OBJECT_NAME}_INCLUDE_SYSTEM SYSTEM)
    if (KMCMAKE_CC_OBJECT_EXCLUDE_SYSTEM)
        set(${KMCMAKE_CC_OBJECT_NAME}_INCLUDE_SYSTEM "")
    endif ()

    kmcmake_print_label("Create Library" "${KMCMAKE_LIB_INFO}")
    kmcmake_raw("-----------------------------------")
    if (VERBOSE_KMCMAKE_BUILD)
        kmcmake_print_list_label("Sources" KMCMAKE_CC_OBJECT_SOURCES)
        kmcmake_print_list_label("Deps" KMCMAKE_CC_OBJECT_DEPS)
        kmcmake_print_list_label("COPTS" KMCMAKE_CC_OBJECT_COPTS)
        kmcmake_print_list_label("CXXOPTS" KMCMAKE_CC_OBJECT_CXXOPTS)
        kmcmake_print_list_label("CUOPTS" KMCMAKE_CC_OBJECT_CUOPTS)
        kmcmake_print_list_label("Defines" KMCMAKE_CC_OBJECT_DEFINES)
        kmcmake_print_list_label("Includes" KMCMAKE_CC_OBJECT_INCLUDES)
        kmcmake_print_list_label("Private Includes" KMCMAKE_CC_OBJECT_PINCLUDES)
        kmcmake_raw("-----------------------------------")
    endif ()
    add_library(${KMCMAKE_CC_OBJECT_NAME} OBJECT ${KMCMAKE_CC_OBJECT_SOURCES} ${KMCMAKE_CC_OBJECT_HEADERS})
    if (KMCMAKE_CC_OBJECT_DEPS)
        add_dependencies(${KMCMAKE_CC_OBJECT_NAME} ${KMCMAKE_CC_OBJECT_DEPS})
    endif ()
    set_property(TARGET ${KMCMAKE_CC_OBJECT_NAME} PROPERTY POSITION_INDEPENDENT_CODE 1)
    target_compile_options(${KMCMAKE_CC_OBJECT_NAME} PRIVATE $<$<COMPILE_LANGUAGE:C>:${KMCMAKE_CC_OBJECT_COPTS}>)
    target_compile_options(${KMCMAKE_CC_OBJECT_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${KMCMAKE_CC_OBJECT_CXXOPTS}>)
    target_compile_options(${KMCMAKE_CC_OBJECT_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:${KMCMAKE_CC_OBJECT_CUOPTS}>)
    target_include_directories(${KMCMAKE_CC_OBJECT_NAME} ${${KMCMAKE_CC_OBJECT_NAME}_INCLUDE_SYSTEM}
            PUBLIC
            ${KMCMAKE_CC_OBJECT_INCLUDES}
            "$<BUILD_INTERFACE:${${PROJECT_NAME}_SOURCE_DIR}>"
            "$<BUILD_INTERFACE:${${PROJECT_NAME}_BINARY_DIR}>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )
    target_include_directories(${KMCMAKE_CC_OBJECT_NAME} ${${KMCMAKE_CC_OBJECT_NAME}_INCLUDE_SYSTEM}
            PRIVATE
            ${KMCMAKE_CC_OBJECT_PINCLUDES}
    )

    target_compile_definitions(${KMCMAKE_CC_OBJECT_NAME}
            PUBLIC
            ${KMCMAKE_CC_OBJECT_DEFINES}
    )

    foreach (arg IN LISTS KMCMAKE_CC_OBJECT_UNPARSED_ARGUMENTS)
        message(WARNING "Unparsed argument: ${arg}")
    endforeach ()

endfunction()
