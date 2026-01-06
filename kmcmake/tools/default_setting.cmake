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
# color
################################################################################################
if (NOT WIN32)
    string(ASCII 27 Esc)
    set(kmcmake_colour_reset "${Esc}[m")
    set(kmcmake_colour_bold "${Esc}[1m")
    set(kmcmake_red "${Esc}[31m")
    set(kmcmake_green "${Esc}[32m")
    set(kmcmake_yellow "${Esc}[33m")
    set(kmcmake_blue "${Esc}[34m")
    set(kmcmake_agenta "${Esc}[35m")
    set(kmcmake_cyan "${Esc}[36m")
    set(kmcmake_white "${Esc}[37m")
    set(kmcmake_bold_red "${Esc}[1;31m")
    set(kmcmake_bold_green "${Esc}[1;32m")
    set(kmcmake_bold_yellow "${Esc}[1;33m")
    set(kmcmake_bold_blue "${Esc}[1;34m")
    set(kmcmake_bold_magenta "${Esc}[1;35m")
    set(kmcmake_bold_cyan "${Esc}[1;36m")
    set(kmcmake_bold_white "${Esc}[1;37m")
endif ()


################################################################################################
# print
################################################################################################
function(kmcmake_debug)
    if (KMCMAKE_STATUS_DEBUG)
        string(TIMESTAMP timestamp)
        if (KMCMAKE_CACHE_RUN)
            set(type "DEBUG (CACHE RUN)")
        else ()
            set(type "DEBUG")
        endif ()
        message(STATUS "${kmcmake_blue}[kmcmake *** ${type} *** ${timestamp}] ${ARGV}${kmcmake_colour_reset}")
    endif ()
endfunction(kmcmake_debug)


function(kmcmake_print)
    if (KMCMAKE_STATUS_PRINT OR KMCMAKE_STATUS_DEBUG)
        if (KMCMAKE_CACHE_RUN)
            kmcmake_debug("${ARGV}")
        else ()
            message(STATUS "${kmcmake_green}[kmcmake] ${ARGV}${kmcmake_colour_reset}")
        endif ()
    endif ()
endfunction(kmcmake_print)

function(kmcmake_error)
    message("")
    foreach (print_message ${ARGV})
        message(SEND_ERROR "${kmcmake_bold_red}[kmcmake ** INTERNAL **] ${print_message}${kmcmake_colour_reset}")
    endforeach ()
    message(FATAL_ERROR "${kmcmake_bold_red}[kmcmake ** INTERNAL **] [Directory:${CMAKE_CURRENT_LIST_DIR}]${kmcmake_colour_reset}")
    message("")
endfunction(kmcmake_error)

function(kmcmake_warn)
    message("")
    foreach (print_message ${ARGV})
        message(WARNING "${kmcmake_red}[kmcmake WARNING] ${print_message}${kmcmake_colour_reset}")
    endforeach ()
    message(WARNING "${kmcmake_red}[kmcmake WARNING] [Directory:${CMAKE_CURRENT_LIST_DIR}]${kmcmake_colour_reset}")
    message("")
endfunction(kmcmake_warn)


set(KMCMAKE_ALIGN_LENGTH 30)
MACRO(kmcmake_print_label Label Value)
    string(LENGTH ${Label} lLength)
    math(EXPR paddingLeng ${KMCMAKE_ALIGN_LENGTH}-${lLength})
    string(REPEAT " " ${paddingLeng} PADDING)
    message("${kmcmake_yellow}${Label}${kmcmake_colour_reset}:${PADDING}${kmcmake_cyan}${Value}${kmcmake_colour_reset}")
ENDMACRO()

MACRO(kmcmake_raw Value)
    message("${Value}")
ENDMACRO()

MACRO(kmcmake_directory_list result curdir)
    FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
    SET(dirlist "")
    FOREACH (child ${children})
        IF (IS_DIRECTORY ${curdir}/${child})
            LIST(APPEND dirlist ${child})
        ENDIF ()
    ENDFOREACH ()
    SET(${result} ${dirlist})
ENDMACRO()

MACRO(kmcmake_print_list result)
    foreach (arg IN LISTS ${result})
        message(" - ${kmcmake_cyan}${arg}${kmcmake_colour_reset}")
    endforeach ()
ENDMACRO()


MACRO(kmcmake_print_list_label Label ListVar)
    message("${kmcmake_yellow}${Label}${kmcmake_colour_reset}:")
    kmcmake_print_list(${ListVar})
ENDMACRO()



################################################################################################
# install dir
################################################################################################
include(GNUInstallDirs)

if (${PROJECT_NAME}_VERSION)
    set(KMCMAKE_SUBDIR "${PROJECT_NAME}_${PROJECT_VERSION}")
    set(KMCMAKE_INSTALL_BINDIR "${CMAKE_INSTALL_BINDIR}/${KMCMAKE_SUBDIR}")
    set(KMCMAKE_INSTALL_CONFIGDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${KMCMAKE_SUBDIR}")
    set(KMCMAKE_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}/{KMCMAKE_SUBDIR}")
    set(KMCMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_LIBDIR}/${KMCMAKE_SUBDIR}")
else ()
    set(KMCMAKE_INSTALL_BINDIR "${CMAKE_INSTALL_BINDIR}")
    set(KMCMAKE_INSTALL_CONFIGDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
    set(KMCMAKE_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}")
    set(KMCMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_LIBDIR}")
endif ()


################################################################################################
# kmcmake_target_check
################################################################################################
function(kmcmake_target_check my_target)
    if (NOT TARGET ${my_target})
        message(FATAL_ERROR " KMCMAKE: compiling ${PROJECT_NAME} requires a ${my_target} CMake target in your project,
                   see CMake/README.md for more details")
    endif (NOT TARGET ${my_target})
endfunction()

