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
# ##############################################################################
# Get Git information: Tag + Commit Hash + Dirty Flag
# ##############################################################################
find_package(Git QUIET)

# Default values (non-Git environment)
set(GIT_TAG "unknown")
set(GIT_COMMIT_SHORT_HASH "unknown")
set(GIT_IS_DIRTY 0)
set(GIT_VERSION_STRING "unknown-unknown")
set(GIT_COMMIT_HASH "unknown")


if(GIT_FOUND)
    if (NOT GIT_ROOT_DIR)
        set(GIT_ROOT_DIR ${PROJECT_SOURCE_DIR})
    endif()
    # Only proceed if Git root is found (i.e., is a Git repo)
    if(GIT_ROOT_DIR AND EXISTS "${GIT_ROOT_DIR}/.git")
        # Step 2: Get FULL commit hash (fix empty issue!)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
            WORKING_DIRECTORY ${GIT_ROOT_DIR}
            OUTPUT_VARIABLE GIT_COMMIT_HASH
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )

        # Step 3: Get SHORT commit hash
        execute_process(
            COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
            WORKING_DIRECTORY ${GIT_ROOT_DIR}
            OUTPUT_VARIABLE GIT_COMMIT_SHORT_HASH
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )

        # Step 4: Get latest Git Tag
        execute_process(
            COMMAND ${GIT_EXECUTABLE} describe --tags --abbrev=0
            WORKING_DIRECTORY ${GIT_ROOT_DIR}
            OUTPUT_VARIABLE GIT_TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET
        )

        # Step 5: Check if working tree is DIRTY
        execute_process(
            COMMAND ${GIT_EXECUTABLE} diff --quiet --exit-code
            WORKING_DIRECTORY ${GIT_ROOT_DIR}
            RESULT_VARIABLE GIT_DIFF_RESULT
            ERROR_QUIET
        )
        if(GIT_DIFF_RESULT EQUAL 0)
            set(GIT_IS_DIRTY 0)
        else()
            set(GIT_IS_DIRTY 1)
        endif()

        # Step 6: Build combined version string
        set(GIT_VERSION_STRING "${GIT_TAG}-${GIT_COMMIT_SHORT_HASH}")
        if(GIT_IS_DIRTY)
            set(GIT_VERSION_STRING "${GIT_VERSION_STRING}-dirty")
        endif()

        # Fallback for no Tag
        if(GIT_TAG STREQUAL "unknown")
            set(GIT_VERSION_STRING "no-tag-${GIT_COMMIT_SHORT_HASH}")
            if(GIT_IS_DIRTY)
                set(GIT_VERSION_STRING "${GIT_VERSION_STRING}-dirty")
            endif()
        endif()

        # Final fallback for empty hash (should never happen now)
        if(GIT_COMMIT_HASH STREQUAL "")
            set(GIT_COMMIT_HASH "unknown")
        endif()
    endif()
endif()

message(STATUS "Git Version: ${GIT_VERSION_STRING}")
message(STATUS "Git Tag: ${GIT_TAG}, Hash: ${GIT_COMMIT_SHORT_HASH}, Dirty: ${GIT_IS_DIRTY}")