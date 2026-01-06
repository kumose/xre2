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
# kmcmake_cc_simd
# Detect x86 SIMD features (SSE, SSE2, SSE3, SSSE3, SSE4.1, SSE4.2, AVX, AVX2, AVX512)
################################################################################################

# Predefine variables
set(KMCMAKE_X86_SSE1 FALSE)
set(KMCMAKE_X86_SSE2 FALSE)
set(KMCMAKE_X86_SSE3 FALSE)
set(KMCMAKE_X86_SSSE3 FALSE)
set(KMCMAKE_X86_SSE4_1 FALSE)
set(KMCMAKE_X86_SSE4_2 FALSE)
set(KMCMAKE_X86_AVX FALSE)
set(KMCMAKE_X86_AVX2 FALSE)
set(KMCMAKE_X86_AVX512F FALSE)
set(KMCMAKE_X86_SUPPORT_FLAGS "")

set(KMCMAKE_X86_BMI1 FALSE)
set(KMCMAKE_X86_BMI2 FALSE)
set(KMCMAKE_X86_POPCNT FALSE)
set(KMCMAKE_X86_FAST_MATH FALSE)
set(KMCMAKE_X86_FMA FALSE)
set(KMCMAKE_X86_F16C FALSE)
set(KMCMAKE_X86_LZCNT FALSE)
set(KMCMAKE_X86_MOVBE FALSE)

include(CheckCXXSourceRuns)




function(kmcmake_detect_simd code flags OUT_VAR)
    # Return false immediately if flags is empty
    if(NOT flags OR flags STREQUAL "")
        set(${OUT_VAR} FALSE PARENT_SCOPE)
        kmcmake_print("simd check: flags is empty → false")
        return()
    endif()

    if(NOT code OR code STREQUAL "")
        set(${OUT_VAR} FALSE PARENT_SCOPE)
        kmcmake_print("simd check: code is empty → false")
        return()
    endif()

    foreach(_FLAG ${flags})
        # Save original required flags to avoid side effects
        set(_OLD_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS})
        set(CMAKE_REQUIRED_FLAGS ${_FLAG})
        
        # Check if code compiles and runs with current flag
        check_cxx_source_runs("${code}" _TEST_FLAG)
        
        # Restore original required flags
        set(CMAKE_REQUIRED_FLAGS ${_OLD_REQUIRED_FLAGS})

        # Return false if any flag is unsupported
        if(NOT _TEST_FLAG)
            set(${OUT_VAR} FALSE PARENT_SCOPE)
            kmcmake_print("simd check: flag '${_FLAG}' not supported → false")
            return()
        endif()
    endforeach()

    # All flags are supported
    set(${OUT_VAR} TRUE PARENT_SCOPE)
    kmcmake_print("simd check: all flags '${flags}' supported → true")
endfunction()

#----------------------------------------
# SSE Checks
#----------------------------------------
if(WIN32)
    set(SSE1_FLAG "/arch:SSE")
    set(SSE2_FLAG "/arch:SSE2")
    set(SSE3_FLAG "/arch:SSE3")
    set(SSSE3_FLAG "/arch:SSSE3")
    set(SSE4_1_FLAG "/arch:SSE4")
    set(SSE4_2_FLAG "/arch:SSE4")
    set(AVX_FLAG "/arch:AVX")
    set(AVX2_FLAG "/arch:AVX2")
    set(FAST_MATH_FLAG "/fp:fast")

    set(BMI1_FLAG "/arch:SSE2")
    set(BMI2_FLAG "/arch:AVX2")
    set(POPCNT_FLAG "/arch:SSE2")
    set(FMA_FLAG "/arch:AVX2")
    set(LZCNT_FLAG "/arch:SSE2")
    set(F16C_FLAG "/arch:AVX")
    set(MOVBE_FLAG "/arch:SSE2")

    set(AVX512_FLAG "/arch:AVX512")
else()
    set(SSE1_FLAG "-msse")
    set(SSE2_FLAG "-msse2")
    set(SSE3_FLAG "-msse3")
    set(SSSE3_FLAG "-mssse3")
    set(SSE4_1_FLAG "-msse4.1;-msse4;")
    set(SSE4_2_FLAG "-msse4.2;-msse4")
    set(AVX_FLAG "-mavx")
    set(AVX2_FLAG "-mavx2")

    set(FAST_MATH_FLAG "-ffast-math")
    set(BMI1_FLAG "-mbmi")
    set(BMI2_FLAG "-mbmi2")
    set(POPCNT_FLAG "-mpopcnt")
    set(FMA_FLAG "-mfma")
    set(F16C_FLAG "-mf16c")
    set(LZCNT_FLAG "-mlzcnt")
    set(MOVBE_FLAG "-mmovbe")

    set(AVX512F_FLAG "-mavx512f")
    set(AVX512VL_FLAG "-mavx512vl")
    set(AVX512BW_FLAG "-mavx512bw")
    
endif()



SET(SSE1_DEFAULT_CODE "
  #include <xmmintrin.h>

  int main()
  {
    __m128 a;
    float vals[4] = {0,0,0,0};
    a = _mm_loadu_ps(vals);  // SSE1
    return 0;
  }")

SET(SSE2_DEFAULT_CODE "
  #include <emmintrin.h>

  int main()
  {
    __m128d a;
    double vals[2] = {0,0};
    a = _mm_loadu_pd(vals);  // SSE2
    return 0;
  }")


SET(SSE3_DEFAULT_CODE "
#include <pmmintrin.h>
int main() {
    __m128 u, v;
    u = _mm_set1_ps(0.0f);
    v = _mm_moveldup_ps(u); // SSE3
    return 0;
}")

SET(SSSE3_DEFAULT_CODE "
  #include <tmmintrin.h>
  const double v = 0;
  int main() {
    __m128i a = _mm_setzero_si128();
    __m128i b = _mm_abs_epi32(a); // SSSE3
    return 0;
  }")

SET(SSE4_1_DEFAULT_CODE "
  #include <smmintrin.h>

  int main ()
  {
     __m128i a = _mm_setzero_si128();
     __m128i b = _mm_setzero_si128();
    __m128i res = _mm_max_epi8(a, b); // SSE4_1

    return 0;
  }
")

SET(SSE4_2_DEFAULT_CODE "
  #include <nmmintrin.h>

  int main()
  {
      __m128i a = _mm_setzero_si128();
      __m128i b = _mm_setzero_si128();
      __m128i c = _mm_cmpgt_epi64(a, b);
    return 0;
  }
")


SET(AVX_DEFAULT_CODE "
#if !defined __AVX__ // MSVC supports this flag since MSVS 2013
#error \"__AVX__ define is missing\"
#endif
#include <immintrin.h>
void test()
{
    __m256 a = _mm256_set1_ps(0.0f);
}
int main() { return 0; }")

SET(AVX2_DEFAULT_CODE "
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

SET(AVX512_DEFAULT_CODE "
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

SET(POPCNT_DEFAULT_CODE "
#include <immintrin.h>
int main() {
    unsigned int x = 0x12345678;
    #if defined(_MSC_VER)
    unsigned int cnt = __popcnt(x);  // MSVC POPCNT intrinsic
    #else
    unsigned int cnt = _mm_popcnt_u32(x);  // GCC/Clang POPCNT intrinsic
    #endif
    (void)cnt;
    return 0;
}")

SET(BMI1_DEFAULT_CODE "
#if defined(_MSC_VER) && !defined(_M_BMI)
#error \"BMI1 not supported by MSVC\"
#elif defined(__GNUC__) && !defined(__BMI__)
#error \"BMI1 not supported by GCC/Clang\"
#endif
#include <immintrin.h>
int main() {
    unsigned int a = 0xFFFF0000;
    unsigned int b = 0x0000FFFF;
    #if defined(_MSC_VER)
    unsigned int res = _andn_u32(a, b);  // MSVC BMI1 intrinsic
    #else
    unsigned int res = __builtin_ia32_andn_u32(a, b);  // GCC/Clang BMI1 intrinsic
    #endif
    (void)res;
    return 0;
}")

SET(BMI2_DEFAULT_CODE "
#if defined(_MSC_VER) && !defined(_M_BMI2)
#error \"BMI2 not supported by MSVC\"
#elif defined(__GNUC__) && !defined(__BMI2__)
#error \"BMI2 not supported by GCC/Clang\"
#endif
#include <immintrin.h>
int main() {
    unsigned int x = 0x12345678;
    #if defined(_MSC_VER)
    unsigned int res = _bzhi_u32(x, 16);  // MSVC BMI2 intrinsic（位截断）
    #else
    unsigned int res = __builtin_ia32_bzhi_u32(x, 16);  // GCC/Clang BMI2 intrinsic
    #endif
    (void)res;
    return 0;
}")

SET(FAST_MATH_DEFAULT_CODE "
#include <cmath>
#include <cstdio>

// Verify core fast math optimizations: floating-point reordering, precision tradeoffs
int main() {
    // 1. Verify floating-point operation optimization (fast math may reorder operations)
    float a = 1.234f, b = 5.678f, c = 9.012f;
    float res1 = (a + b) * c;
    float res2 = a * c + b * c;
    
    // 2. Verify trigonometric function optimization (fast math may use approximations)
    float sin_val = sinf(a);
    float cos_val = cosf(b);
    float tan_val = tanf(c);
    
    // 3. Verify reciprocal/square root optimization (fast math may use _mm_rcp_ps-like instructions)
    float rcp_val = 1.0f / a;
    float sqrt_val = sqrtf(b);
    
    // Force usage of computed results (prevent compiler from optimizing out unused code)
    printf(\"%f %f %f %f %f %f %f\", res1, res2, sin_val, cos_val, tan_val, rcp_val, sqrt_val);
    return 0;
}")

# Add FMA test code (add to SIMD Test Code Definitions section)
SET(FMA_DEFAULT_CODE "
#if defined(_MSC_VER) && !defined(__AVX2__)
#error \"FMA requires AVX2 support in MSVC\"
#elif defined(__GNUC__) && !defined(__FMA__)
#error \"FMA not supported by GCC/Clang\"
#endif
#include <immintrin.h>
int main() {
    __m256 a = _mm256_set1_ps(1.5f);
    __m256 b = _mm256_set1_ps(2.5f);
    __m256 c = _mm256_set1_ps(3.5f);
    
    // FMA instruction: a = a*b + c (fused multiply-add)
    __m256 res = _mm256_fmadd_ps(a, b, c);
    
    // Verify result (basic sanity check to prevent optimization)
    float out[8];
    _mm256_storeu_ps(out, res);
    return (out[0] > 0.0f) ? 0 : 1;
}")

SET(F16C_DEFAULT_CODE "
#if defined(_MSC_VER) && !defined(__AVX__)
#error \"F16C requires AVX support in MSVC\"
#elif defined(__GNUC__) && !defined(__F16C__)
#error \"F16C not supported by GCC/Clang\"
#endif
#include <immintrin.h>
int main() {
    __m128i fp16_data = _mm_set_epi16(0x3C00, 0x4000, 0x4200, 0x4400, 
                                      0x4600, 0x4800, 0x4A00, 0x4C00); // FP16: 1.0, 2.0, 4.0, ..., 128.0
    __m256 fp32_data = _mm256_cvtph_ps(fp16_data);
    
    __m128i fp16_result = _mm256_cvtps_ph(fp32_data, _MM_FROUND_TO_NEAREST_INT);
    
    return _mm_extract_epi16(fp16_result, 0) == 0x3C00 ? 0 : 1;
}")

SET(LZCNT_DEFAULT_CODE "
#if defined(_MSC_VER) && !defined(_M_AMD64) && !defined(_M_IX86)
#error \"LZCNT requires x86/x86_64 architecture in MSVC\"
#elif defined(__GNUC__) && !defined(__LZCNT__)
#error \"LZCNT not supported by GCC/Clang\"
#endif
#include <immintrin.h>
int main() {
    unsigned int x = 0x80000000;
    unsigned int y = 0x00000001;
    
#if defined(_MSC_VER)
    unsigned int cnt_x = _lzcnt_u32(x);  // MSVC  intrinsic
    unsigned int cnt_y = _lzcnt_u32(y);
#else
    unsigned int cnt_x = __builtin_clz(x); // GCC/Clang intrinsic (等价于 LZCNT)
    unsigned int cnt_y = __builtin_clz(y);
#endif
    
    return (cnt_x == 0 && cnt_y == 31) ? 0 : 1;
}")

SET(MOVBE_DEFAULT_CODE "
#if defined(_MSC_VER) && !defined(__SSE2__)
#error \"MOVBE requires SSE2 support in MSVC\"
#elif defined(__GNUC__) && !defined(__MOVBE__)
#error \"MOVBE not supported by GCC/Clang\"
#endif
#include <immintrin.h>
int main() {
    unsigned int le_data = 0x12345678;
    unsigned int be_data = _mm_movemask_epi8(_mm_loadu_si128((__m128i*)&le_data));
    unsigned int converted = _mm_extract_epi32(_mm_movbe_epi32(_mm_set_epi32(0, 0, 0, le_data)), 0);
    
    return converted == 0x78563412 ? 0 : 1;
}")

#----------------------------------------
# Run all x86 checks
#----------------------------------------
macro(check_x86_simd_flags)
    # sse1
    kmcmake_detect_simd("${SSE1_DEFAULT_CODE}"  "${SSE1_FLAG}" KMCMAKE_X86_SSE1)
    if (KMCMAKE_X86_SSE1)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${SSE1_FLAG}")
    endif()
    # sse2
    kmcmake_detect_simd("${SSE2_DEFAULT_CODE}"  "${SSE2_FLAG}" KMCMAKE_X86_SSE2)
    if (KMCMAKE_X86_SSE2)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${SSE2_FLAG}")
    endif()
    # sse3
    kmcmake_detect_simd("${SSE3_DEFAULT_CODE}"  "${SSE3_FLAG}" KMCMAKE_X86_SSE3)
    if (KMCMAKE_X86_SSE3)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${SSE3_FLAG}")
    endif()
    # ssse3
    kmcmake_detect_simd("${SSSE3_DEFAULT_CODE}"  "${SSSE3_FLAG}" KMCMAKE_X86_SSSE3)
    if (KMCMAKE_X86_SSSE3)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${SSSE3_FLAG}")
    endif()
    # sse4_1
    kmcmake_detect_simd("${SSE4_1_DEFAULT_CODE}"  "${SSE4_1_FLAG}" KMCMAKE_X86_SSE4_1)
    if (KMCMAKE_X86_SSE4_1)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${SSE4_1_FLAG}")
    endif()
    # sse4_2
    kmcmake_detect_simd("${SSE4_2_DEFAULT_CODE}"  "${SSE4_2_FLAG}" KMCMAKE_X86_SSE4_2)
    if (KMCMAKE_X86_SSE4_2)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${SSE4_2_FLAG}")
    endif()
    # avx
    kmcmake_detect_simd("${AVX_DEFAULT_CODE}"  "${AVX_FLAG}" KMCMAKE_X86_AVX)
    if (KMCMAKE_X86_AVX)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${AVX_FLAG}")
    endif()
    # avx2
    kmcmake_detect_simd("${AVX2_DEFAULT_CODE}"  "${AVX2_FLAG}" KMCMAKE_X86_AVX2)
    if (KMCMAKE_X86_AVX2)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${AVX2_FLAG}")
    endif()

      # POPCNT
    kmcmake_detect_simd("${POPCNT_DEFAULT_CODE}" "${POPCNT_FLAG}" KMCMAKE_X86_POPCNT)
    if(KMCMAKE_X86_POPCNT)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${POPCNT_FLAG}")
    endif()

    # BMI1
    kmcmake_detect_simd("${BMI1_DEFAULT_CODE}" "${BMI1_FLAG}" KMCMAKE_X86_BMI1)
    if(KMCMAKE_X86_BMI1)  
            list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${BMI1_FLAG}")
    endif()

    # BMI2
    kmcmake_detect_simd("${BMI2_DEFAULT_CODE}" "${BMI2_FLAG}" KMCMAKE_X86_BMI2)
    if(KMCMAKE_X86_BMI2)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${BMI2_FLAG}")
    endif()

     # FAST_MATH check (placed last to not interfere with core SIMD detection)
    kmcmake_detect_simd("${FAST_MATH_DEFAULT_CODE}" "${FAST_MATH_FLAG}" KMCMAKE_X86_FAST_MATH)
    if(KMCMAKE_X86_FAST_MATH)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${FAST_MATH_FLAG}")
    endif()

    # FMA check (FMA is often paired with AVX2, placed after AVX2 check)
    kmcmake_detect_simd("${FMA_DEFAULT_CODE}" "${FMA_FLAG}" KMCMAKE_X86_FMA)
    if(KMCMAKE_X86_FMA)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${FMA_FLAG}")
    endif()

     # F16C check (F16C is an AVX-era extension, placed after AVX check)
     kmcmake_detect_simd("${F16C_DEFAULT_CODE}" "${F16C_FLAG}" KMCMAKE_X86_F16C)
    if(KMCMAKE_X86_F16C)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${F16C_FLAG}")
    endif()

    # LZCNT check (LZCNT is a BMI1-compatible extension, placed after BMI1 check)
    kmcmake_detect_simd("${LZCNT_DEFAULT_CODE}" "${LZCNT_FLAG}" KMCMAKE_X86_LZCNT)
    if(KMCMAKE_X86_LZCNT)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${LZCNT_FLAG}")
    endif()
    # MOVBE check (MOVBE is an SSE2-era extension, placed after SSE2 check)
    kmcmake_detect_simd("${MOVBE_DEFAULT_CODE}" "${MOVBE_FLAG}" KMCMAKE_X86_MOVBE)
    if(KMCMAKE_X86_MOVBE)
        list(APPEND KMCMAKE_X86_SUPPORT_FLAGS "${MOVBE_FLAG}")
    endif()
    # avx512
    #kmcmake_detect_simd("${AVX512_DEFAULT_CODE}"  "${AVX512_FLAG}" KMCMAKE_X86_AVX512)
endmacro()

if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
    check_x86_simd_flags()
    list(REMOVE_DUPLICATES KMCMAKE_X86_SUPPORT_FLAGS)
endif()


################################################################################################
# kmcmake_arm_simd
# Detect ARM SIMD features (NEON, VFPv4, etc)
################################################################################################
# Predefine variables
set(KMCMAKE_ARM_NEON FALSE)
set(KMCMAKE_ARM_VFPv4 FALSE)
set(KMCMAKE_ARM_FMA FALSE)

#----------------------------------------
# NEON Check
#----------------------------------------
macro(check_arm_neon)
    set(CODE "
    #include <arm_neon.h>
    int main() { float32x4_t a = vdupq_n_f32(0.0f); return 0; }")
    check_cxx_source_runs("${CODE}" KMCMAKE_ARM_NEON_OK COMPILE_FLAGS "-mfpu=neon")
    if(KMCMAKE_ARM_NEON_OK)
        set(KMCMAKE_ARM_NEON TRUE)
    endif()
endmacro()

#----------------------------------------
# VFPv4 Check
#----------------------------------------
macro(check_arm_vfpv4)
    set(CODE "
    #if defined(__ARM_FP) && (__ARM_FP & 0x8)
    #include <arm_math.h>
    #endif
    int main() { float a = 0.0f; return 0; }")
    check_cxx_source_runs("${CODE}" KMCMAKE_ARM_VFPv4_OK COMPILE_FLAGS "-mfpu=vfpv4")
    if(KMCMAKE_ARM_VFPv4_OK)
        set(KMCMAKE_ARM_VFPv4 TRUE)
    endif()
endmacro()

#----------------------------------------
# FMA Check (optional, if compiler supports)
#----------------------------------------
macro(check_arm_fma)
    set(CODE "
    #if defined(__ARM_FEATURE_FMA)
    #include <arm_neon.h>
    #endif
    int main() { float32x4_t a = vdupq_n_f32(1.0f); float32x4_t b = vdupq_n_f32(2.0f); float32x4_t c = vfmaq_f32(a, b, a); return 0; }")
    check_cxx_source_runs("${CODE}" KMCMAKE_ARM_FMA_OK COMPILE_FLAGS "-mfpu=neon -mfma")
    if(KMCMAKE_ARM_FMA_OK)
        set(KMCMAKE_ARM_FMA TRUE)
    endif()
endmacro()

#----------------------------------------
# Run all ARM SIMD checks
#----------------------------------------
macro(check_arm_simd_flags)
  #  check_arm_neon()
  #  check_arm_vfpv4()
  #  check_arm_fma()
endmacro()

if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm.*|aarch64")
    check_arm_simd_flags()
endif()
