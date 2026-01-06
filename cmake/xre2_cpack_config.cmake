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

set(KMCMAKE_PACKAGING_INSTALL_PREFIX "/opt/EA/inf")
set(KMCMAKE_PACKAGE_VENDOR "${PROJECT_NAME}")
set(KMCMAKE_PACKAGE_NAME "${PROJECT_NAME}")

set(KMCMAKE_PACKAGE_VERSION "${PROJECT_VERSION}")
set(KMCMAKE_PACKAGE_DESCRIPTION
        "kmcmake is the cpp cmake build system projects."
)
configure_file(${PROJECT_SOURCE_DIR}/cmake/deb/postinst.in ${PROJECT_SOURCE_DIR}/cmake/deb/postinst @ONLY)
configure_file(${PROJECT_SOURCE_DIR}/cmake/rpm/postinst.in ${PROJECT_SOURCE_DIR}/cmake/rpm/postinst @ONLY)

set(KMCMAKE_PACKAGE_MAINTAINER "Jeff.li")
set(KMCMAKE_PACKAGE_CONTACT "lijippy@163.com")
set(KMCMAKE_PACKAGE_HOMEPAGE_URL "https://github.com/kumose/kmcmake")
set(KMCMAKE_PACKAGE_SYSTEM_NAME "unknown")

if(${LC_KMCMAKE_PRETTY_NAME} MATCHES "ubuntu")
    set(KMCMAKE_PACKAGE_SYSTEM_NAME "ubuntu-${KMCMAKE_DISTRO_VERSION_ID}")
    set(CPACK_GENERATOR "STGZ;DEB")
elseif(${LC_KMCMAKE_PRETTY_NAME} MATCHES "centos")
    set(KMCMAKE_PACKAGE_SYSTEM_NAME "centos-${KMCMAKE_DISTRO_VERSION_ID}")
    set(CPACK_GENERATOR "STGZ;RPM")
elseif(${LC_KMCMAKE_PRETTY_NAME} MATCHES "darwin")
    set(KMCMAKE_PACKAGE_SYSTEM_NAME "darwin-${KMCMAKE_DISTRO_VERSION_ID}")
endif()
if (${KMCMAKE_PACKAGE_SYSTEM_NAME} MATCHES "unknown")
    set(KMCMAKE_PACKAGE_SYSTEM_NAME "linux") # default to linux  if not set
endif ()

if (${KMCMAKE_PACKAGE_SYSTEM_NAME} MATCHES "unknown")
    set(KMCMAKE_PACKAGE_SYSTEM_NAME "linux") # default to linux  if not set
endif ()
set (TAR_FILE_NAME "${KMCMAKE_PACKAGE_NAME}-${KMCMAKE_PACKAGE_VERSION}-${KMCMAKE_PACKAGE_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}")


if (DEFINED CUDA_VERSION)
    set (TAR_FILE_NAME "${TAR_FILE_NAME}-cu${CUDA_VERSION}")
elseif (DEFINED CUDAToolkit_VERSION)
    set (TAR_FILE_NAME "${TAR_FILE_NAME}-cu${CUDAToolkit_VERSION}")
endif ()
set(KMCMAKE_PACKAGE_FILE_NAME "${TAR_FILE_NAME}")
set(KMCMAKE_PACKAGE_DIRECTORY package)

kmcmake_print("on platform: ${LC_KMCMAKE_PRETTY_NAME}")
kmcmake_print("package format: ${CPACK_GENERATOR}")
kmcmake_print("package file name: ${KMCMAKE_PACKAGE_FILE_NAME}")
#################################################################################
# system configuration
#################################################################################
set(CPACK_PACKAGING_INSTALL_PREFIX ${KMCMAKE_PACKAGING_INSTALL_PREFIX})
set(CPACK_PACKAGE_VENDOR "${KMCMAKE_PACKAGE_VENDOR}")
set(CPACK_PACKAGE_NAME "${KMCMAKE_PACKAGE_NAME}")
set(CPACK_PACKAGE_VERSION "${KMCMAKE_PACKAGE_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION
        "${KMCMAKE_PACKAGE_DESCRIPTION}"
)
set(CPACK_PACKAGE_MAINTAINER "${KMCMAKE_PACKAGE_MAINTAINER}")
set(CPACK_PACKAGE_CONTACT "${KMCMAKE_PACKAGE_CONTACT}")
set(CPACK_PACKAGE_HOMEPAGE_URL "${KMCMAKE_PACKAGE_HOMEPAGE_URL}")
set(CPACK_PACKAGE_FILE_NAME "${KMCMAKE_PACKAGE_FILE_NAME}")
set(CPACK_PACKAGE_DIRECTORY ${KMCMAKE_PACKAGE_DIRECTORY})

if (${LC_KMCMAKE_PRETTY_NAME} MATCHES "ubuntu")
    set (CPACK_DEBIAN_PACKAGE_SHLIBDEPS_PRIVATE_DIRS
            "/usr/local/cuda-${CPACK_CUDA_VERSION_MAJOR}.${CPACK_CUDA_VERSION_MINOR}/${CMAKE_INSTALL_LIBDIR}/stubs")
    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
            "${CMAKE_CURRENT_SOURCE_DIR}/cmake/deb/preinst;${CMAKE_CURRENT_SOURCE_DIR}/cmake/deb/prerm;${CMAKE_CURRENT_SOURCE_DIR}/cmake/deb/postrm;${CMAKE_CURRENT_SOURCE_DIR}/cmake/deb/postinst")
elseif (${LC_KMCMAKE_PRETTY_NAME} MATCHES "darwin")
    MESSAGE(STATUS "Apple dist: macos build dmg package")
elseif (${LC_KMCMAKE_PRETTY_NAME} MATCHES "centos")
    set(CPACK_RPM_PACKAGE_DEBUG 1)
    set(CPACK_RPM_RUNTIME_DEBUGINFO_PACKAGE ON)
    set(CPACK_RPM_PACKAGE_RELOCATABLE ON)
    SET(CPACK_RPM_PRE_INSTALL_SCRIPT_FILE "${PROJECT_SOURCE_DIR}/cmake/rpm/preinst")
    SET(CPACK_RPM_POST_INSTALL_SCRIPT_FILE "${PROJECT_SOURCE_DIR}/cmake/rpm/postinst")
    SET(CPACK_RPM_PRE_UNINSTALL_SCRIPT_FILE "${PROJECT_SOURCE_DIR}/cmake/rpm/prerm")
    SET(CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE "${PROJECT_SOURCE_DIR}/cmake/rpm/postrm")
endif ()
include(CPack)