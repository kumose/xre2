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
if (POLICY CMP0042)
    cmake_policy(SET CMP0042 NEW)
endif ()
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/kmcmake/package)

include(kmcmake_option)
include(default_setting)


################################################################################################
# platform info
################################################################################################

set(KMCMAKE_PRETTY_NAME)

if (CMAKE_SYSTEM_NAME MATCHES "Linux")
    cmake_host_system_information(RESULT KMCMAKE_PRETTY_NAME QUERY DISTRIB_PRETTY_NAME)
    kmcmake_print("${KMCMAKE_PRETTY_NAME}")

    cmake_host_system_information(RESULT KMCMAKE_DISTRO QUERY DISTRIB_INFO)
    kmcmake_print_list_label("KMCMAKE_DISTRO:" KMCMAKE_DISTRO)
    foreach (dis IN LISTS KMCMAKE_DISTRO)
        kmcmake_print("${dis} = `${${dis}}`")
    endforeach ()
elseif (CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(KMCMAKE_PRETTY_NAME "darwin")
elseif (CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(KMCMAKE_PRETTY_NAME "windows")
else ()
    message(FATAL_ERROR "unknown system")
endif ()

string(TOLOWER ${KMCMAKE_PRETTY_NAME} LC_KMCMAKE_PRETTY_NAME)
string(TOUPPER ${KMCMAKE_PRETTY_NAME} UP_KMCMAKE_PRETTY_NAME)

include(kmcmake_cc_library)
include(kmcmake_cc_interface)
include(kmcmake_cc_object)
include(kmcmake_cc_test)
include(kmcmake_cc_binary)
include(kmcmake_cc_benchmark)
include(simd_detect)



################################################################################################
# kmcmake_simd
################################################################################################
INCLUDE(CheckCXXSourceRuns)

SET(SSE1_CODE "
  #include <xmmintrin.h>

  int main()
  {
    __m128 a;
    float vals[4] = {0,0,0,0};
    a = _mm_loadu_ps(vals);  // SSE1
    return 0;
  }")

SET(SSE2_CODE "
  #include <emmintrin.h>

  int main()
  {
    __m128d a;
    double vals[2] = {0,0};
    a = _mm_loadu_pd(vals);  // SSE2
    return 0;
  }")

SET(SSE3_CODE "
#include <pmmintrin.h>
int main() {
    __m128 u, v;
    u = _mm_set1_ps(0.0f);
    v = _mm_moveldup_ps(u); // SSE3
    return 0;
}")

SET(SSSE3_CODE "
  #include <tmmintrin.h>
  const double v = 0;
  int main() {
    __m128i a = _mm_setzero_si128();
    __m128i b = _mm_abs_epi32(a); // SSSE3
    return 0;
  }")

SET(SSE4_1_CODE "
  #include <smmintrin.h>

  int main ()
  {
     __m128i a = _mm_setzero_si128();
     __m128i b = _mm_setzero_si128();
    __m128i res = _mm_max_epi8(a, b); // SSE4_1

    return 0;
  }
")

SET(SSE4_2_CODE "
  #include <nmmintrin.h>

  int main()
  {
      __m128i a = _mm_setzero_si128();
      __m128i b = _mm_setzero_si128();
      __m128i c = _mm_cmpgt_epi64(a, b);
    return 0;
  }
")


MACRO(CHECK_SSE lang type flags)
    SET(__FLAG_I 1)
    SET(CMAKE_REQUIRED_FLAGS_SAVE ${CMAKE_REQUIRED_FLAGS})
    FOREACH (__FLAG ${flags})
        IF (NOT ${lang}_${type}_FOUND)
            SET(CMAKE_REQUIRED_FLAGS ${__FLAG})
            CHECK_CXX_SOURCE_RUNS("${${type}_CODE}" ${lang}_HAS_${type}_${__FLAG_I})
            IF (${lang}_HAS_${type}_${__FLAG_I})
                SET(${lang}_${type}_FOUND TRUE)
            ENDIF ()
            MATH(EXPR __FLAG_I "${__FLAG_I}+1")
        ENDIF ()
    ENDFOREACH ()
    SET(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS_SAVE})

    IF (NOT ${lang}_${type}_FOUND)
        SET(${lang}_${type}_FOUND FALSE)
    ENDIF ()
    MARK_AS_ADVANCED(${lang}_${type}_FOUND ${lang}_${type}_FLAGS)

ENDMACRO()

MACRO(CHECK_SSE4 lang type flags)
    SET(__FLAG_I 1)
    SET(CMAKE_REQUIRED_FLAGS_SAVE ${CMAKE_REQUIRED_FLAGS})
    FOREACH (__FLAG ${flags})
        IF (NOT ${lang}_${type}_FOUND)
            SET(CMAKE_REQUIRED_FLAGS ${__FLAG})
            CHECK_CXX_SOURCE_RUNS("${${type}_CODE}" ${lang}_HAS_${type}_${__FLAG_I})
            IF (${lang}_HAS_${type}_${__FLAG_I})
                SET(${lang}_${type}_FOUND TRUE)
            ENDIF ()
            MATH(EXPR __FLAG_I "${__FLAG_I}")
        ENDIF ()
    ENDFOREACH ()
    SET(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS_SAVE})

    IF (NOT ${lang}_${type}_FOUND)
        SET(${lang}_${type}_FOUND FALSE)
    ENDIF ()
    MARK_AS_ADVANCED(${lang}_${type}_FOUND ${lang}_${type}_FLAGS)

ENDMACRO()

SET(AVX_CODE "
#if !defined __AVX__ // MSVC supports this flag since MSVS 2013
#error \"__AVX__ define is missing\"
#endif
#include <immintrin.h>
void test()
{
    __m256 a = _mm256_set1_ps(0.0f);
}
int main() { return 0; }")

SET(AVX2_CODE "
#if !defined __AVX2__ // MSVC supports this flag since MSVS 2013
#error \"__AVX2__ define is missing\"
#endif
#include <immintrin.h>
void test()
{
    int data[8] = {0,0,0,0, 0,0,0,0};
    __m256i a = _mm256_loadu_si256((const __m256i *)data);
    __m256i b = _mm256_bslli_epi128(a, 1);  // available in GCC 4.9.3+
}
int main() { return 0; }")

SET(AVX512_CODE "
#if defined __AVX512__ || defined __AVX512F__
#include <immintrin.h>
void test()
{
    __m512i zmm = _mm512_setzero_si512();
#if defined __GNUC__ && defined __x86_64__
    asm volatile (\"\" : : : \"zmm16\", \"zmm17\", \"zmm18\", \"zmm19\");
#endif
}
#else
#error \"AVX512 is not supported\"
#endif
int main() { return 0; }")


MACRO(CHECK_AVX type flags)
    SET(__FLAG_I 1)
    SET(CMAKE_REQUIRED_FLAGS_SAVE ${CMAKE_REQUIRED_FLAGS})
    FOREACH (__FLAG ${flags})
        IF (NOT CXX_${type}_FOUND)
            SET(CMAKE_REQUIRED_FLAGS ${__FLAG})
            CHECK_CXX_SOURCE_RUNS("${${type}_CODE}" CXX_HAS_${type}_${__FLAG_I})
            IF (CXX_HAS_${type}_${__FLAG_I})
                SET(CXX_${type}_FOUND TRUE)
            ENDIF ()
            MATH(EXPR __FLAG_I "${__FLAG_I}+1")
        ENDIF ()
    ENDFOREACH ()
    SET(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS_SAVE})

    IF (NOT CXX_${type}_FOUND)
        SET(CXX_${type}_FOUND FALSE)
    ENDIF ()

    MARK_AS_ADVANCED(CXX_${type}_FOUND CXX_${type}_FLAGS)

ENDMACRO()
if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64" OR "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "AMD64")
    CHECK_AVX("AVX" ";-mavx;/arch:AVX")
    CHECK_AVX("AVX2" ";-mavx2;/arch:AVX2")
    CHECK_AVX("AVX512" ";-mavx512;/arch:AVX512")
    CHECK_SSE(CXX "SSE1" ";-msse;/arch:SSE")
    CHECK_SSE(CXX "SSE2" ";-msse2;/arch:SSE2")
    CHECK_SSE(CXX "SSE3" ";-msse3;/arch:SSE3")
    CHECK_SSE(CXX "SSSE3" ";-mssse3;/arch:SSSE3")
    CHECK_SSE(CXX "SSE4_1" ";-msse4.1;-msse4;/arch:SSE4")
    CHECK_SSE(CXX "SSE4_2" ";-msse4.2;-msse4;/arch:SSE4")
elseif ("${CMAKE_SYSTEM_PROCESSOR}" MATCHES "arm.*|aarch64")
    IF (CMAKE_SYSTEM_NAME MATCHES "Linux")
        execute_process(COMMAND cat /proc/cpuinfo OUTPUT_VARIABLE CPUINFO)

        #neon instruction can be found on the majority part of modern ARM processor
        STRING(REGEX REPLACE "^.*(neon).*$" "\\1" NEON_THERE ${CPUINFO})
        STRING(COMPARE EQUAL "neon" "${NEON_THERE}" NEON_TRUE)
        IF (NEON_TRUE)
            set(NEON_FOUND true BOOL "NEON available on host")
        ELSE ()
            set(NEON_FOUND false BOOL "NEON available on host")
        ENDIF ()

        #Find the processor type (for now OMAP3 or OMAP4)
        STRING(REGEX REPLACE "^.*(OMAP3).*$" "\\1" OMAP3_THERE ${CPUINFO})
        STRING(COMPARE EQUAL "OMAP3" "${OMAP3_THERE}" OMAP3_TRUE)
        IF (OMAP3_TRUE)
            set(CORTEXA8_FOUND true BOOL "OMAP3 available on host")
        ELSE ()
            set(CORTEXA8_FOUND false BOOL "OMAP3 available on host")
        ENDIF ()

        #Find the processor type (for now OMAP3 or OMAP4)
        STRING(REGEX REPLACE "^.*(OMAP4).*$" "\\1" OMAP4_THERE ${CPUINFO})
        STRING(COMPARE EQUAL "OMAP4" "${OMAP4_THERE}" OMAP4_TRUE)
        IF (OMAP4_TRUE)
            set(CORTEXA9_FOUND true BOOL "OMAP4 available on host")
        ELSE ()
            set(CORTEXA9_FOUND false BOOL "OMAP4 available on host")
        ENDIF ()

    ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Darwin")
        execute_process(COMMAND  sysctl -a OUTPUT_VARIABLE CPUINFO)

        #neon instruction can be found on the majority part of modern ARM processor
        STRING(REGEX REPLACE "^.*(neon).*$" "\\1" NEON_THERE ${CPUINFO})
        STRING(COMPARE EQUAL "neon" "${NEON_THERE}" NEON_TRUE)
        IF (NEON_TRUE)
            set(NEON_FOUND true BOOL "NEON available on host")
        ELSE ()
            set(NEON_FOUND false BOOL "NEON available on host")
        ENDIF ()

    ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Windows")
        # TODO
        set(CORTEXA8_FOUND false BOOL "OMAP3 not available on host")
        set(CORTEXA9_FOUND false BOOL "OMAP4 not available on host")
        set(NEON_FOUND false BOOL "NEON not available on host")
    ELSE (CMAKE_SYSTEM_NAME MATCHES "Linux")
        set(CORTEXA8_FOUND false BOOL "OMAP3 not available on host")
        set(CORTEXA9_FOUND false BOOL "OMAP4 not available on host")
        set(NEON_FOUND false BOOL "NEON not available on host")
    ENDIF ()

    if (NOT NEON_FOUND)
        MESSAGE(STATUS "Could not find hardware support for NEON on this machine.")
    endif ()
    if (NOT CORTEXA8_FOUND)
        MESSAGE(STATUS "No OMAP3 processor on this on this machine.")
    endif ()
    if (NOT CORTEXA9_FOUND)
        MESSAGE(STATUS "No OMAP4 processor on this on this machine.")
    endif ()
    mark_as_advanced(NEON_FOUND)
endif ()
################################################################################################
# out of source build
################################################################################################
macro(KMCMAKE_ENSURE_OUT_OF_SOURCE_BUILD errorMessage)

    string(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_BINARY_DIR}" is_insource)
    if (is_insource)
        kmcmake_error(${errorMessage} "In-source builds are not allowed.
    CMake would overwrite the makefiles distributed with Compiler-RT.
    Please create a directory and run cmake from there, passing the path
    to this source directory as the last argument.
    This process created the file `CMakeCache.txt' and the directory `CMakeFiles'.
    Please delete them.")

    endif (is_insource)

endmacro(KMCMAKE_ENSURE_OUT_OF_SOURCE_BUILD)

option(KMCMAKE_USE_SYSTEM_INCLUDES "" OFF)
if (VERBOSE_CMAKE_BUILD)
    set(CMAKE_VERBOSE_MAKEFILE ON)
endif ()

if (KMCMAKE_USE_CXX11_ABI)
    add_definitions(-D_GLIBCXX_USE_CXX11_ABI=1)
elseif ()
    add_definitions(-D_GLIBCXX_USE_CXX11_ABI=0)
endif ()

if (CONDA_ENV_ENABLE)
    list(APPEND CMAKE_PREFIX_PATH $ENV{CONDA_PREFIX})
    include_directories($ENV{CONDA_PREFIX}/include)
    link_directories($ENV{CONDA_PREFIX}/${CMAKE_INSTALL_LIBDIR})
endif ()

if (KMCMAKE_INSTALL_LIB)
    set(CMAKE_INSTALL_LIBDIR lib)
endif ()

if (KMCMAKE_USE_SYSTEM_INCLUDES)
    set(KMCMAKE_INTERNAL_INCLUDE_WARNING_GUARD SYSTEM)
else ()
    set(KMCMAKE_INTERNAL_INCLUDE_WARNING_GUARD "")
endif ()

KMCMAKE_ENSURE_OUT_OF_SOURCE_BUILD("must out of source dir")

include(kmcmake_cc_proto)
include(git_commit)