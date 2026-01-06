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

#[[kmcmake_cc_test(
        NAME custom_comparator_test
        SOURCES custom_comparator_test.cc
        DEPS turbo::turbo ${KMCMAKE_DEPS_LINK} ${GTEST_LIB} ${GTEST_MAIN_LIB}
        CXXOPTS ${KMCMAKE_CXX_OPTIONS}
)]]
#[[
kmcmake_cc_test(
        NAME foo_test
        SOURCES foo_test.cc
        DEPS ${PROJECT}::foo ${KMCMAKE_DEPS_LINK} gtest gtest_main
        COPTS ${KMCMAKE_CXX_OPTIONS}
)

kmcmake_cc_test(
        NAME foo_doctest
        SOURCES foo_doctest.cc
        DEPS ${PROJECT}::foo ${KMCMAKE_DEPS_LINK} doctest
        CXXOPTS ${KMCMAKE_CXX_OPTIONS}
)
]]





configure_file(${PROJECT_SOURCE_DIR}/tests/config.h.in ${PROJECT_SOURCE_DIR}/tests/config.h @ONLY)

find_package(GTest REQUIRED)

set(TEST_TARGETS
        charclass_test
        compile_test
        filtered_re2_test
        mimics_pcre_test
        parse_test
        possible_match_test
        re2_test
        re2_arg_test
        regexp_test
        required_prefix_test
        search_test
        set_test
        simplify_test
        string_generator_test

        dfa_test
        exhaustive1_test
        exhaustive2_test
        exhaustive3_test
        exhaustive_test
        random_test
)

foreach(target ${TEST_TARGETS})
    kmcmake_cc_test(
            NAME ${target}
            MODULE re2
            SOURCES ${target}.cc
            CXXOPTS ${KMCMAKE_CXX_OPTIONS}
            LINKS
            xre2::xre2_static
            xre2::testing_static
            GTest::gtest
            GTest::gtest_main
            ${KMCMAKE_DEPS_LINK}
    )
endforeach ()