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
# kmcmake_cc_library
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
function(kmcmake_cc_library)
    set(options
            PUBLIC
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
    if (KMCMAKE_CC_LIB_PUBLIC)
        set(KMCMAKE_LIB_INFO "${KMCMAKE_CC_LIB_NAMESPACE}::${KMCMAKE_CC_LIB_NAME}  SHARED&STATIC PUBLIC")
    else ()
        set(KMCMAKE_LIB_INFO "${KMCMAKE_CC_LIB_NAMESPACE}::${KMCMAKE_CC_LIB_NAME}  SHARED&STATIC INTERNAL")
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
    target_include_directories(${KMCMAKE_CC_LIB_NAME}_static INTERFACE
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
)

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
    target_include_directories(${KMCMAKE_CC_LIB_NAME}_shared INTERFACE
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
)

    if (KMCMAKE_CC_LIB_PUBLIC)
        install(TARGETS ${KMCMAKE_CC_LIB_NAME}_shared ${KMCMAKE_CC_LIB_NAME}_static
                EXPORT ${PROJECT_NAME}Targets
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        )
    endif ()

    foreach (arg IN LISTS KMCMAKE_CC_LIB_UNPARSED_ARGUMENTS)
        message(WARNING "Unparsed argument: ${arg}")
    endforeach ()

endfunction()