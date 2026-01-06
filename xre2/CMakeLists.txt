#
# Copyright 2024 Kumo.
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
###########################################################################
# below are examples, after initialization, modify it to your own.
###########################################################################
###kmcmake_example


set(RE2_SOURCES
        bitmap256.cc
        bitstate.cc
        compile.cc
        dfa.cc
        filtered_re2.cc
        mimics_pcre.cc
        nfa.cc
        onepass.cc
        parse.cc
        perl_groups.cc
        prefilter.cc
        prefilter_tree.cc
        prog.cc
        re2.cc
        regexp.cc
        set.cc
        simplify.cc
        tostring.cc
        unicode_casefold.cc
        unicode_groups.cc
        util/rune.cc
        util/strutil.cc
)


kmcmake_cc_library(
        NAMESPACE ${PROJECT_NAME}
        NAME xre2
        SOURCES
        ${RE2_SOURCES}
        CXXOPTS
        ${KMCMAKE_CXX_OPTIONS}
        PLINKS
        ${KMCMAKE_DEPS_LINK}
        PUBLIC
)

if (KMCMAKE_BUILD_TEST OR KMCMAKE_BUILD_BENCHMARK)
    find_package(GTest REQUIRED)
    set(TESTING_SOURCES
            testing/backtrack.cc
            testing/dump.cc
            testing/exhaustive_tester.cc
            testing/null_walker.cc
            testing/regexp_generator.cc
            testing/string_generator.cc
            testing/tester.cc
            testing/pcre.cc
    )

    kmcmake_cc_library(
            NAMESPACE ${PROJECT_NAME}
            NAME testing
            SOURCES
            ${TESTING_SOURCES}
            CXXOPTS
            ${KMCMAKE_CXX_OPTIONS}
            PLINKS
            xre2::xre2_static
            ${KMCMAKE_DEPS_LINK}
    )
endif ()

###kmcmake_example