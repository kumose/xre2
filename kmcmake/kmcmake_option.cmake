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

################################################################################################
# options
################################################################################################
option(BUILD_STATIC_LIBRARY "kmcmake set build static library or not" ON)

option(BUILD_SHARED_LIBRARY "kmcmake set build shared library or not" OFF)

option(VERBOSE_KMCMAKE_BUILD "print kmcmake detail information" OFF)

option(VERBOSE_CMAKE_BUILD "verbose cmake make debug" OFF)

option(CONDA_ENV_ENABLE "enable conda auto env" OFF)

option(KMCMAKE_USE_CXX11_ABI "use cxx11 abi or not" ON)

option(KMCMAKE_BUILD_TEST "enable project test or not" OFF)

option(KMCMAKE_BUILD_BENCHMARK "enable project benchmark or not" OFF)

option(KMCMAKE_BUILD_EXAMPLES "enable project examples or not" OFF)

option(KMCMAKE_ENABLE_CUDA "" OFF)

option(KMCMAKE_STATUS_PRINT "kmcmake print or not, default on" ON)

option(KMCMAKE_INSTALL_LIB "avoid centos install to lib64" OFF)

option(WITH_DEBUG_SYMBOLS "With debug symbols" ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)