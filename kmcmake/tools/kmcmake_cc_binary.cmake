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
# kmcmake_cc_binary
################################################################################################
function(kmcmake_cc_binary)
    set(options
            PUBLIC
            EXCLUDE_SYSTEM
    )
    set(list_args
            DEPS
            SOURCES
            DEFINES
            COPTS
            CXXOPTS
            CUOPTS
            LINKS
            INCLUDES
    )

    cmake_parse_arguments(
            KMCMAKE_CC_BINARY
            "${options}"
            "NAME"
            "${list_args}"
            ${ARGN}
    )

    set(${KMCMAKE_CC_BINARY_NAME}_INCLUDE_SYSTEM SYSTEM)
    if (KMCMAKE_CC_LIB_EXCLUDE_SYSTEM)
        set(${KMCMAKE_CC_BINARY_NAME}_INCLUDE_SYSTEM "")
    endif ()

    kmcmake_raw("-----------------------------------")
    kmcmake_print_label("Building Binary" "${KMCMAKE_CC_BINARY_NAME}")
    kmcmake_raw("-----------------------------------")
    if (VERBOSE_KMCMAKE_BUILD)
        kmcmake_print_list_label("Sources" KMCMAKE_CC_BINARY_SOURCES)
        kmcmake_print_list_label("Deps" KMCMAKE_CC_BINARY_DEPS)
        kmcmake_print_list_label("COPTS" KMCMAKE_CC_BINARY_COPTS)
        kmcmake_print_list_label("CXXOPTS" KMCMAKE_CC_BINARY_CXXOPTS)
        kmcmake_print_list_label("CUOPTS" KMCMAKE_CC_BINARY_CUOPTS)
        kmcmake_print_list_label("Defines" KMCMAKE_CC_BINARY_DEFINES)
        kmcmake_print_list_label("Includes" KMCMAKE_CC_BINARY_INCLUDES)
        kmcmake_print_list_label("Links" KMCMAKE_CC_BINARY_LINKS)
        message("-----------------------------------")
    endif ()

    set(exec_case ${KMCMAKE_CC_BINARY_NAME})

    add_executable(${exec_case} ${KMCMAKE_CC_BINARY_SOURCES})

    target_compile_options(${exec_case} PRIVATE $<$<COMPILE_LANGUAGE:C>:${KMCMAKE_CC_BINARY_COPTS}>)
    target_compile_options(${exec_case} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${KMCMAKE_CC_BINARY_CXXOPTS}>)
    target_compile_options(${exec_case} PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:${KMCMAKE_CC_BINARY_CUOPTS}>)
    if (KMCMAKE_CC_BINARY_DEPS)
        add_dependencies(${exec_case} ${KMCMAKE_CC_BINARY_DEPS})
    endif ()
    target_link_libraries(${exec_case} PRIVATE ${KMCMAKE_CC_BINARY_LINKS})

    target_compile_definitions(${exec_case}
            PUBLIC
            ${KMCMAKE_CC_BINARY_DEFINES}
    )

    target_include_directories(${exec_case} ${${KMCMAKE_CC_LIB_NAME}_INCLUDE_SYSTEM}
            PRIVATE
            ${KMCMAKE_CC_BINARY_INCLUDES}
            "$<BUILD_INTERFACE:${${PROJECT_NAME}_SOURCE_DIR}>"
            "$<BUILD_INTERFACE:${${PROJECT_NAME}_BINARY_DIR}>"
            "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
    )
    if (KMCMAKE_CC_BINARY_PUBLIC)
        install(TARGETS ${exec_case}
                EXPORT ${PROJECT_NAME}Targets
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        )
    endif (KMCMAKE_CC_BINARY_PUBLIC)

endfunction()
