#
# Copyright 2023 The titan-search Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#[[

kmcmake_cc_benchmark(
        NAME tedis_bench
        SOURCES tedis_bench.cc
        DEPS tedis::tedis ${KMCMAKE_DEPS_LINK} ${BENCHMARK_LIB} ${BENCHMARK_MAIN_LIB}
        COPTS ${USER_CXX_FLAGS}
)
]]

configure_file(${PROJECT_SOURCE_DIR}/benchmark/config.h.in ${PROJECT_SOURCE_DIR}/benchmark/config.h @ONLY)
find_package(benchmark REQUIRED)
kmcmake_cc_test(
        NAME regexp_benchmark
        MODULE re2
        SOURCES regexp_benchmark.cc
        CXXOPTS
        ${KMCMAKE_CXX_OPTIONS}
        LINKS
        xre2::xre2_static
        xre2::testing_static
        benchmark::benchmark
        benchmark::benchmark_main
        ${KMCMAKE_DEPS_LINK}
)