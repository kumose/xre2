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
# kmcmake_cc_proto_target:
#   A helper function to generate C++ source and header files from Protocol Buffers (.proto) files.
#
# Parameters:
#   OPTIONS:
#     PUBLIC       - Marks the target as public (optional)
#     EXCLUDE_SYSTEM - Exclude system includes (optional)
#
#   ARGS:
#     NAME         - The name of the proto target (required)
#     OUTDIR       - Output directory for generated .pb.cc and .pb.h files (required)
#
#   LIST_ARGS:
#     PROTOS       - List of .proto files to compile (required)
#     DEPS         - Additional dependencies for the generated sources (optional)
#     INCLUDES     - Extra include directories for protoc (optional)
# OutputVariable:
#     ${NAME}_SRCS  - list of *pb.cc
#     ${NAME}_HRDS  - list of *pb.h
#
# Behavior:
#   1. Parses the arguments and list arguments.
#   2. Finds the Protobuf package (must be installed).
#   3. Prepares protoc include flags from PROJECT_SOURCE_DIR and user-specified INCLUDES.
#   4. Iterates over each .proto file:
#       - Computes absolute path, directory, and base filename.
#       - Determines output .pb.cc and .pb.h filenames.
#       - Adds a custom command to generate C++ files using protoc.
#   5. Collects all generated .pb.cc and .pb.h files into HDRS and SRCS lists.
#   6. Sets <NAME>_HDRS and <NAME>_SRCS variables in the parent scope for use by other targets.
#
# Example usage:
#   kmcmake_cc_proto_target(
#       NAME proto_obj
#       PROTOS ${PROTO_FILES}
#       OUTDIR ${PROJECT_SOURCE_DIR}
#   )
# Using the generated files
# add_library(
#        myproto
#        ${proto_obj_SRCS}
# )
############################################################################################################

function(kmcmake_cc_proto)
    set(options
            PUBLIC
            EXCLUDE_SYSTEM
    )
    set(args
            NAME
            OUTDIR
    )

    set(list_args
            PROTOS
            DEPS
            INCLUDES
    )

    cmake_parse_arguments(
            PARSE_ARGV 0
            KMCMAKE_CC_PROTO
            "${options}"
            "${args}"
            "${list_args}"
    )

    find_package(Protobuf REQUIRED)
    set(PROTOC_FLAGS "-I${PROTOBUF_INCLUDE_DIRS}")
    set(INCLUDE_FLAGS "-I${PROJECT_SOURCE_DIR}")
    foreach (INC ${KMCMAKE_CC_PROTO_INCLUDES})
        if(NOT "${INC}" STREQUAL "")
            set(INCLUDE_FLAGS "${INCLUDE_FLAGS} -I${INC}")
        endif()
    endforeach ()
    message(STATUS ${INCLUDE_FLAGS})
    foreach (P ${KMCMAKE_CC_PROTO_PROTOS})
        get_filename_component(PROTO_ABS ${P} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
        get_filename_component(PROTO_DIR ${PROTO_ABS} DIRECTORY)
        get_filename_component(PROTO_NAME_WE ${P} NAME_WE)

        set(HDR ${PROTO_DIR}/${PROTO_NAME_WE}.pb.h)
        set(SRC ${PROTO_DIR}/${PROTO_NAME_WE}.pb.cc)
        list(APPEND HDRS ${HDR})
        list(APPEND SRCS ${SRC})
        message(STATUS "${PROTOBUF_PROTOC_EXECUTABLE} ${PROTOC_FLAGS} ${INCLUDE_FLAGS} --cpp_out=${KMCMAKE_CC_PROTO_OUTDIR} ${PROTO_ABS}")
        add_custom_command(
                OUTPUT ${HDR} ${SRC}
                COMMAND ${PROTOBUF_PROTOC_EXECUTABLE} ${PROTOC_FLAGS} ${INCLUDE_FLAGS} --cpp_out=${KMCMAKE_CC_PROTO_OUTDIR} ${PROTO_ABS}
                DEPENDS ${PROTO_ABS} ${KMCMAKE_CC_PROTO_DEPS}
        )
    endforeach ()
    set(${KMCMAKE_CC_PROTO_NAME}_HDRS ${HDRS} PARENT_SCOPE)
    set(${KMCMAKE_CC_PROTO_NAME}_SRCS ${SRCS} PARENT_SCOPE)
endfunction()
