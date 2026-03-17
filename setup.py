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
from skbuild import setup
import os

from wheel.cli import pack_f

cmake_args_list = []
km_root = os.getenv('KMPKG_CMAKE', 'no')
km_tool=''
if km_root != 'no':
    km_tool = '-DCMAKE_TOOLCHAIN_FILE=' + km_root

if km_tool != '':
    cmake_args_list.append(km_tool)

setup(
    name="xre2",
    version="1.1.5",
    description="xre2 python binding",
    author="Kumo Ins",
    license="A-GPL",
    packages=["xre2"],
    package_dir={"": "python"},
    cmake_install_dir="python/xre2",
    python_requires=">=3.8",
    cmake_args=cmake_args_list,
    cmake_executable='cmake',
    language="c++",
    include_package_data=True,
    package_data={"xre2": ["*.pxd"]},
    classifiers=[
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Programming Language :: Python :: 3.12',
        'Programming Language :: Python :: 3.13',
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Libraries :: Python Modules',
        'License :: OSI Approved :: Apache Software License',
        'Operating System :: OS Independent',
    ],
    compiler_directives={'language_level': "3"}
)
