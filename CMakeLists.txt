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
#
####################################################################################
# generate by kumo cmake building system kmkdo tools kmdo
# https://github.com/kumose/kmcmake
####################################################################################

cmake_minimum_required(VERSION 3.24)

project(xre2 CXX)

option(${PROJECT_NAME}_IS_TOP_PROJECT "xre2 project is the top level project or not" ON)

get_property(not_top DIRECTORY PROPERTY PARENT_DIRECTORY)
if (not_top)
    set(${PROJECT_NAME}_IS_TOP_PROJECT OFF)
endif ()

set(PROJECT_DESCRIPTION "Hercules is an ahead of time compiler for a subset of the Python language framework.")
set(PROJECT_VERSION_MAJOR 1)
set(PROJECT_VERSION_MINOR 11)
set(PROJECT_VERSION_PATCH 5)
set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

set(${PROJECT_NAME}_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(${PROJECT_NAME}_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(${PROJECT_NAME}_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(${PROJECT_NAME}_VERSION ${PROJECT_VERSION})

string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UP)

option(PYTHON_EXTENSION "kmcmake set build shared library or not" OFF)
set(KMCMAKE_VERSION 0.6.0)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/kmcmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/kmcmake/tools)
##################################################################
# add this for ${PROJECT_NAME} 's cmake include
##################################################################
list(APPEND CMAKE_MODULE_PATH ${${PROJECT_NAME}_SOURCE_DIR}/cmake)
#######################################################################
# warning
# in kmcmake directory, caution to modify files in that dir
######################################################################
include(kmcmake_module)

##################################################################
#
# your cmake directory ${PROJECT_SOURCE_DIR}/cmake, do things here
#################################################################


include(xre2_deps)
include(xre2_cxx_config)
include(xre2_test)

string(TOUPPER ${CMAKE_BUILD_TYPE} UPPERCASE_BUILD_TYPE)
configure_file(${PROJECT_SOURCE_DIR}/xre2/version.h.in ${PROJECT_SOURCE_DIR}/xre2/version.h @ONLY)

add_subdirectory(xre2)
####################################################################
# belows are auto, edit it be cation
####################################################################
if (KMCMAKE_BUILD_TEST)
    add_subdirectory(tests)
endif ()

if (KMCMAKE_BUILD_BENCHMARK)
    add_subdirectory(benchmark)
endif ()

if (KMCMAKE_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif ()
if(NOT PYTHON_EXTENSION)
    ##############################################
    # header installing
    #############################################
    install(DIRECTORY ${PROJECT_NAME}
            DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
            FILES_MATCHING
            PATTERN "*.inc"
            PATTERN "*.h"
            PATTERN "*.hpp"
            PATTERN "xre2/testing/*" EXCLUDE
            PATTERN "xre2/testing" EXCLUDE
            )

    # Layout. This works for all platforms:
    #   * <prefix>//cmake/<PROJECT-NAME>
    #   * <prefix>/*/
    #   * <prefix>/include/
    set(config_install_dir "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

    set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

    # Configuration
    set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
    set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
    set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
    set(namespace "${PROJECT_NAME}::")

    # Include module with fuction 'write_basic_package_version_file'
    include(CMakePackageConfigHelpers)

    # Configure '<PROJECT-NAME>ConfigVersion.cmake'
    # Use:
    #   * PROJECT_VERSION
    write_basic_package_version_file(
            "${version_config}" COMPATIBILITY SameMajorVersion
    )

    # Configure '<PROJECT-NAME>Config.cmake'
    # Use variables:
    #   * TARGETS_EXPORT_NAME
    #   * PROJECT_NAME
    configure_package_config_file(
            "cmake/xre2_config.cmake.in"
            "${project_config}"
            INSTALL_DESTINATION "${config_install_dir}"
    )

    #Targets:
    #  * <prefix>/${CMAKE_INSTALL_LIBDIR}/libbar.a
    #  * <prefix>/${CMAKE_INSTALL_LIBDIR}/libbaz.a
    #  * header location after install: <prefix>/include/foo/Bar.hpp
    #  * headers can be included by C++ code `#include <foo/Bar.hpp>`


    # Config
    #   * <prefix>/${CMAKE_INSTALL_LIBDIR}/cmake/Foo/FooConfig.cmake
    #   * <prefix>/${CMAKE_INSTALL_LIBDIR}/cmake/Foo/FooConfigVersion.cmake
    install(
            FILES
            "${project_config}" "${version_config}"
            DESTINATION
            "${config_install_dir}"
    )

    # Config
    #   * <prefix>/${CMAKE_INSTALL_LIBDIR}/cmake/Foo/FooTargets.cmake

    install(
            EXPORT
            "${TARGETS_EXPORT_NAME}"
            NAMESPACE
            "${namespace}"
            DESTINATION
            "${config_install_dir}"
    )
    configure_file(${PROJECT_SOURCE_DIR}/kmcmake/package/pkg_dump_template.pc.in
            ${PROJECT_BINARY_DIR}/package/${PROJECT_NAME}.pc)

    install(FILES ${PROJECT_BINARY_DIR}/package/${PROJECT_NAME}.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
    #include(xre2_cpack_config)
endif()
kmcmake_print("xre2 cmake build system is created by kmcmake package manager tools")
kmcmake_print("kmcmake: https://github.com/kumose/kmcmake")
kmcmake_print("tools: https://github.com/kumose/kmdo")
kmcmake_print("docs: https://pub.kumose.cc/kmdo")
