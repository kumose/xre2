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