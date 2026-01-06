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
