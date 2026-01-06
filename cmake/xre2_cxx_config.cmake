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

list(APPEND KMCMAKE_CLANG_CL_FLAGS
        "/W3"
        "/DNOMINMAX"
        "/DWIN32_LEAN_AND_MEAN"
        "/D_CRT_SECURE_NO_WARNINGS"
        "/D_SCL_SECURE_NO_WARNINGS"
        "/D_ENABLE_EXTENDED_ALIGNED_STORAGE"
)

list(APPEND KMCMAKE_CLANG_CL_TEST_FLAGS
        "-Wno-c99-extensions"
        "-Wno-deprecated-declarations"
        "-Wno-missing-noreturn"
        "-Wno-missing-prototypes"
        "-Wno-missing-variable-declarations"
        "-Wno-null-conversion"
        "-Wno-shadow"
        "-Wno-shift-sign-overflow"
        "-Wno-sign-compare"
        "-Wno-unused-function"
        "-Wno-unused-member-function"
        "-Wno-unused-parameter"
        "-Wno-unused-private-field"
        "-Wno-unused-template"
        "-Wno-used-but-marked-unused"
        "-Wno-zero-as-null-pointer-constant"
        "-Wno-gnu-zero-variadic-macro-arguments"
)

list(APPEND KMCMAKE_GCC_FLAGS
        "-Wall"
        "-Wextra"
        "-Wno-cast-qual"
        "-Wconversion-null"
        "-Wformat-security"
        "-Woverlength-strings"
        "-Wpointer-arith"
        "-Wno-undef"
        "-Wunused-local-typedefs"
        "-Wunused-result"
        "-Wvarargs"
        "-Wno-attributes"
        "-Wno-implicit-fallthrough"
        "-Wno-unused-parameter"
        "-Wno-unused-function"
        "-Wwrite-strings"
        "-Wclass-memaccess"
        "-Wno-sign-compare"
        "-DNOMINMAX"
)

list(APPEND KMCMAKE_GCC_TEST_FLAGS
        "-Wno-conversion-null"
        "-Wno-deprecated-declarations"
        "-Wno-missing-declarations"
        "-Wno-sign-compare"
        "-Wno-undef"
        "-Wno-sign-compare"
        "-Wno-unused-function"
        "-Wno-unused-parameter"
        "-Wno-unused-private-field"
)

list(APPEND KMCMAKE_LLVM_FLAGS
        "-Wall"
        "-Wextra"
        "-Wno-cast-qual"
        "-Wno-conversion"
        "-Wno-sign-compare"
        "-Wfloat-overflow-conversion"
        "-Wfloat-zero-conversion"
        "-Wfor-loop-analysis"
        "-Wformat-security"
        "-Wgnu-redeclared-enum"
        "-Winfinite-recursion"
        "-Wliteral-conversion"
        "-Wmissing-declarations"
        "-Woverlength-strings"
        "-Wpointer-arith"
        "-Wself-assign"
        "-Wno-shadow"
        "-Wstring-conversion"
        "-Wtautological-overlap-compare"
        "-Wno-undef"
        "-Wuninitialized"
        "-Wunreachable-code"
        "-Wunused-comparison"
        "-Wunused-local-typedefs"
        "-Wunused-result"
        "-Wno-vla"
        "-Wwrite-strings"
        "-Wno-float-conversion"
        "-Wno-implicit-float-conversion"
        "-Wno-implicit-int-float-conversion"
        "-Wno-implicit-int-conversion"
        "-Wno-shorten-64-to-32"
        "-Wno-sign-conversion"
        "-Wno-unused-parameter"
        "-Wno-unused-function"
        "-DNOMINMAX"
)

list(APPEND KMCMAKE_LLVM_TEST_FLAGS
        "-Wno-c99-extensions"
        "-Wno-deprecated-declarations"
        "-Wno-missing-noreturn"
        "-Wno-missing-prototypes"
        "-Wno-missing-variable-declarations"
        "-Wno-null-conversion"
        "-Wno-shadow"
        "-Wno-undef"
        "-Wno-shift-sign-overflow"
        "-Wno-sign-compare"
        "-Wno-unused-function"
        "-Wno-unused-member-function"
        "-Wno-unused-parameter"
        "-Wno-unused-private-field"
        "-Wno-unused-template"
        "-Wno-sign-compare"
        "-Wno-unused-function"
        "-Wno-used-but-marked-unused"
        "-Wno-zero-as-null-pointer-constant"
        "-Wno-gnu-zero-variadic-macro-arguments"
)

list(APPEND KMCMAKE_MSVC_FLAGS
        "/W3"
        "/DNOMINMAX"
        "/DWIN32_LEAN_AND_MEAN"
        "/D_CRT_SECURE_NO_WARNINGS"
        "/D_SCL_SECURE_NO_WARNINGS"
        "/D_ENABLE_EXTENDED_ALIGNED_STORAGE"
        "/bigobj"
        "/wd4005"
        "/wd4068"
        "/wd4180"
        "/wd4244"
        "/wd4267"
        "/wd4503"
        "/wd4800"
)

list(APPEND KMCMAKE_MSVC_LINKOPTS
        "-ignore:4221"
)

list(APPEND KMCMAKE_MSVC_TEST_FLAGS
        "/wd4018"
        "/wd4101"
        "/wd4503"
        "/wd4996"
        "/DNOMINMAX"
)

list(APPEND KMCMAKE_RANDOM_HWAES_ARM32_FLAGS
        "-mfpu=neon"
)

list(APPEND KMCMAKE_RANDOM_HWAES_ARM64_FLAGS
        "-march=armv8-a+crypto"
)

list(APPEND KMCMAKE_RANDOM_HWAES_MSVC_X64_FLAGS
)

list(APPEND KMCMAKE_RANDOM_HWAES_X64_FLAGS
        "-maes"
        "-msse4.1"
)

################################################################################################
# cxx options
################################################################################################

set(KMCMAKE_LSAN_LINKOPTS "")
set(KMCMAKE_HAVE_LSAN OFF)
set(KMCMAKE_DEFAULT_LINKOPTS "")

if (BUILD_SHARED_LIBS AND MSVC)
    set(KMCMAKE_BUILD_DLL TRUE)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
else ()
    set(KMCMAKE_BUILD_DLL FALSE)
endif ()

if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64" OR "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "AMD64")
    if (MSVC)
        set(KMCMAKE_RANDOM_RANDEN_COPTS "${KMCMAKE_RANDOM_HWAES_MSVC_X64_FLAGS}")
    else ()
        set(KMCMAKE_RANDOM_RANDEN_COPTS "${KMCMAKE_RANDOM_HWAES_X64_FLAGS}")
    endif ()
elseif ("${CMAKE_SYSTEM_PROCESSOR}" MATCHES "arm.*|aarch64")
    if ("${CMAKE_SIZEOF_VOID_P}" STREQUAL "8")
        set(KMCMAKE_RANDOM_RANDEN_COPTS "${KMCMAKE_RANDOM_HWAES_ARM64_FLAGS}")
    elseif ("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
        set(KMCMAKE_RANDOM_RANDEN_COPTS "${KMCMAKE_RANDOM_HWAES_ARM32_FLAGS}")
    else ()
        message(WARNING "Value of CMAKE_SIZEOF_VOID_P (${CMAKE_SIZEOF_VOID_P}) is not supported.")
    endif ()
else ()
    message(WARNING "Value of CMAKE_SYSTEM_PROCESSOR (${CMAKE_SYSTEM_PROCESSOR}) is unknown and cannot be used to set KMCMAKE_RANDOM_RANDEN_COPTS")
    set(KMCMAKE_RANDOM_RANDEN_COPTS "")
endif ()


if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(KMCMAKE_DEFAULT_COPTS "${KMCMAKE_GCC_FLAGS}")
    set(KMCMAKE_TEST_COPTS "${KMCMAKE_GCC_FLAGS};${KMCMAKE_GCC_TEST_FLAGS}")
elseif ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
    # MATCHES so we get both Clang and AppleClang
    if (MSVC)
        # clang-cl is half MSVC, half LLVM
        set(KMCMAKE_DEFAULT_COPTS "${KMCMAKE_CLANG_CL_FLAGS}")
        set(KMCMAKE_TEST_COPTS "${KMCMAKE_CLANG_CL_FLAGS};${KMCMAKE_CLANG_CL_TEST_FLAGS}")
        set(KMCMAKE_DEFAULT_LINKOPTS "${KMCMAKE_MSVC_LINKOPTS}")
    else ()
        set(KMCMAKE_DEFAULT_COPTS "${KMCMAKE_LLVM_FLAGS}")
        set(KMCMAKE_TEST_COPTS "${KMCMAKE_LLVM_FLAGS};${KMCMAKE_LLVM_TEST_FLAGS}")
        if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
            # AppleClang doesn't have lsan
            # https://developer.apple.com/documentation/code_diagnostics
            if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 3.5)
                set(KMCMAKE_LSAN_LINKOPTS "-fsanitize=leak")
                set(KMCMAKE_HAVE_LSAN ON)
            endif ()
        endif ()
    endif ()
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    set(KMCMAKE_DEFAULT_COPTS "${KMCMAKE_MSVC_FLAGS}")
    set(KMCMAKE_TEST_COPTS "${KMCMAKE_MSVC_FLAGS};${KMCMAKE_MSVC_TEST_FLAGS}")
    set(KMCMAKE_DEFAULT_LINKOPTS "${KMCMAKE_MSVC_LINKOPTS}")
else ()
    message(WARNING "Unknown compiler: ${CMAKE_CXX_COMPILER}.  Building with no default flags")
    set(KMCMAKE_DEFAULT_COPTS "")
    set(KMCMAKE_TEST_COPTS "")
endif ()

##############################################################################
# default arch option
##############################################################################

option(KMCMAKE_SIMD_LEVEL_NONE "" OFF)
option(KMCMAKE_SIMD_LEVEL_SSE "" ON)
option(KMCMAKE_SIMD_LEVEL_AVX "" ON)
option(KMCMAKE_SIMD_LEVEL_AVX2 "" ON)
option(KMCMAKE_SIMD_LEVEL_BMI "" OFF)
option(KMCMAKE_SIMD_LEVEL_BMI2 "" OFF)
option(KMCMAKE_SIMD_LEVEL_FMA "" ON)
option(KMCMAKE_SIMD_LEVEL_MOVBE "" OFF)

set_property(CACHE KMCMAKE_SIMD_LEVEL_NONE PROPERTY ADVANCED TRUE)
set_property(CACHE KMCMAKE_SIMD_LEVEL_SSE PROPERTY ADVANCED TRUE)
set_property(CACHE KMCMAKE_SIMD_LEVEL_AVX PROPERTY ADVANCED TRUE)
set_property(CACHE KMCMAKE_SIMD_LEVEL_AVX2 PROPERTY ADVANCED TRUE)

define_property(
    GLOBAL PROPERTY KMCMAKE_SIMD_MUTEX_GROUP
    BRIEF_DOCS "Mutually exclusive SIMD level options"
    FULL_DOCS "Only one SIMD level can be enabled at a time"
)
set_property(GLOBAL PROPERTY KMCMAKE_SIMD_MUTEX_GROUP
    KMCMAKE_SIMD_LEVEL_NONE
    KMCMAKE_SIMD_LEVEL_SSE
    KMCMAKE_SIMD_LEVEL_AVX
    KMCMAKE_SIMD_LEVEL_AVX2
)

macro(varify_simd_level)
    if(KMCMAKE_SIMD_LEVEL_NONE)
        # 关闭所有 SIMD 选项（NONE 优先级最高）
        set(KMCMAKE_SIMD_LEVEL_SSE OFF)
        set(KMCMAKE_SIMD_LEVEL_AVX OFF)
        set(KMCMAKE_SIMD_LEVEL_AVX2 OFF)
        set(KMCMAKE_SIMD_LEVEL_BMI OFF)
        set(KMCMAKE_SIMD_LEVEL_BMI2 OFF)
        set(KMCMAKE_SIMD_LEVEL_FMA OFF)
        set(KMCMAKE_SIMD_LEVEL_MOVBE OFF)
    else()
        if(KMCMAKE_SIMD_LEVEL_AVX AND NOT KMCMAKE_SIMD_LEVEL_SSE)
            message(WARNING "AVX requires SSE enabled, automatically enabling SSE")
            set(KMCMAKE_SIMD_LEVEL_SSE ON CACHE BOOL "" FORCE)
        endif()
        if(KMCMAKE_SIMD_LEVEL_AVX2 AND NOT KMCMAKE_SIMD_LEVEL_AVX)
            message(WARNING "AVX2 requires AVX enabled, automatically enabling AVX")
            set(KMCMAKE_SIMD_LEVEL_AVX ON CACHE BOOL "" FORCE)
        endif()

        if(KMCMAKE_SIMD_LEVEL_SSE AND NOT KMCMAKE_X86_SSE4_2)
            kmcmake_error("Configure to build with SSE, but the CPU does not support SSE4.2")
        endif()
        if(KMCMAKE_SIMD_LEVEL_AVX AND NOT KMCMAKE_X86_AVX)
            kmcmake_error("Configure to build with AVX, but the CPU does not support AVX")
        endif()
        if(KMCMAKE_SIMD_LEVEL_AVX2 AND NOT KMCMAKE_X86_AVX2)
            kmcmake_error("Configure to build with AVX2, but the CPU does not support AVX2")
        endif()
        if(KMCMAKE_SIMD_LEVEL_FMA AND NOT KMCMAKE_X86_FMA)
            kmcmake_error("Configure to build with FMA, but the CPU does not support FMA")
        endif()
    endif()
endmacro(varify_simd_level)

set(KMCMAKE_ARCH_OPTION)

    
macro(makeup_simd_flags)
    if(KMCMAKE_SIMD_LEVEL_SSE)
        list(APPEND KMCMAKE_ARCH_OPTION 
        ${SSE1_FLAG} 
        ${SSE2_FLAG} 
        ${SSE3_FLAG} 
        ${SSSE3_FLAG} 
        ${SSE4_1_FLAG} 
        ${SSE4_2_FLAG}
        ${POPCNT_FLAG}
        ${LZCNT_FLAG}
        )
    endif()
    if(KMCMAKE_SIMD_LEVEL_AVX)
        list(APPEND KMCMAKE_ARCH_OPTION ${AVX_FLAG})
    endif()

    if(KMCMAKE_SIMD_LEVEL_AVX2)
        list(APPEND KMCMAKE_ARCH_OPTION ${AVX2_FLAG})
    endif()

    if(KMCMAKE_SIMD_LEVEL_BMI)
        list(APPEND KMCMAKE_ARCH_OPTION ${BMI1_FLAG})
    endif()

    if(KMCMAKE_SIMD_LEVEL_BMI2)
        list(APPEND KMCMAKE_ARCH_OPTION ${BMI2_FLAG})
    endif()

    if(KMCMAKE_SIMD_LEVEL_FMA)
        list(APPEND KMCMAKE_ARCH_OPTION ${FMA_FLAG})
    endif()

    if(KMCMAKE_SIMD_LEVEL_MOVBE)
        list(APPEND KMCMAKE_ARCH_OPTION ${MOVBE_FLAG})
    endif()
    list(REMOVE_DUPLICATES KMCMAKE_ARCH_OPTION)
endmacro(makeup_simd_flags)

macro(setting_for_gen_macros)
    if(KMCMAKE_SIMD_LEVEL_NONE)
        set(KMCMAKE_SIMD_LEVEL_NONE_VAL 1)
    else()
        set(KMCMAKE_SIMD_LEVEL_NONE_VAL 0)
    endif()
    if(KMCMAKE_SIMD_LEVEL_SSE)
        set(KMCMAKE_SIMD_LEVEL_SSE_VAL 1)
    else()
        set(KMCMAKE_SIMD_LEVEL_SSE_VAL 0)
    endif()
    if(KMCMAKE_SIMD_LEVEL_AVX)
        set(KMCMAKE_SIMD_LEVEL_AVX_VAL 1)
    else()
        set(KMCMAKE_SIMD_LEVEL_AVX_VAL 0)
    endif()
    if(KMCMAKE_SIMD_LEVEL_AVX2)
        set(KMCMAKE_SIMD_LEVEL_AVX2_VAL 1)
    else()
        set(KMCMAKE_SIMD_LEVEL_AVX2_VAL 0)
    endif()

    if(KMCMAKE_SIMD_LEVEL_BMI)
        set(KMCMAKE_SIMD_LEVEL_BMI_VAL 1)
    else()
        set(KMCMAKE_SIMD_LEVEL_BMI_VAL 0)
    endif()
    
    if(KMCMAKE_SIMD_LEVEL_BMI2)
        set(KMCMAKE_SIMD_LEVEL_BMI2_VAL 1)
    else()
        set(KMCMAKE_SIMD_LEVEL_BMI2_VAL 0)
    endif()
        if(KMCMAKE_SIMD_LEVEL_FMA)
        set(KMCMAKE_SIMD_LEVEL_FMA_VAL 1)
    else()
        set(KMCMAKE_SIMD_LEVEL_FMA_VAL 0)
    endif()

    if(KMCMAKE_SIMD_LEVEL_MOVBE)
        set(KMCMAKE_SIMD_LEVEL_MOVBE_VAL 1)
    else()
        set(KMCMAKE_SIMD_LEVEL_MOVBE_VAL 0)
    endif()
endmacro(setting_for_gen_macros)




#############################################################
if(MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG "/Zi /Od /DDEBUG" CACHE STRING "Debug mode flags for MSVC")
    set(CMAKE_CXX_FLAGS_RELEASE "/O2 /DNDEBUG" CACHE STRING "Release mode flags for MSVC")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "/Zi /O2 /DNDEBUG" CACHE STRING "RelWithDebInfo mode flags for MSVC")
else()
    set(CMAKE_CXX_FLAGS_DEBUG "-g3 -O0 -DDEBUG" CACHE STRING "Debug mode flags for GCC/Clang")
    set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG" CACHE STRING "Release mode flags for GCC/Clang")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-g -O2 -DNDEBUG" CACHE STRING "RelWithDebInfo mode flags for GCC/Clang")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif ()


varify_simd_level()
makeup_simd_flags()
setting_for_gen_macros()



if (DEFINED ENV{KMCMAKE_CXX_FLAGS})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} $ENV{KMCMAKE_CXX_FLAGS}")
endif ()

################################
# follow CC flag we provide
# ${KMCMAKE_DEFAULT_COPTS}
# ${KMCMAKE_TEST_COPTS}
# ${KMCMAKE_ARCH_OPTION} for arch option, by default, we set enable and
# ${KMCMAKE_RANDOM_RANDEN_COPTS}
# set it to haswell arch
##############################################################################
set(KMCMAKE_CXX_OPTIONS ${KMCMAKE_DEFAULT_COPTS} ${KMCMAKE_ARCH_OPTION} ${KMCMAKE_RANDOM_RANDEN_COPTS})
###############################
#
# define you options here
# eg.
# list(APPEND KMCMAKE_CXX_OPTIONS "-fopenmp")
list(REMOVE_DUPLICATES KMCMAKE_CXX_OPTIONS)
kmcmake_print_list_label("CXX_OPTIONS:" KMCMAKE_CXX_OPTIONS)