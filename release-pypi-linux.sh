#!/bin/sh
set -e
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
# Different to release-pypi-win.cmd and release-pypi-osx.sh,
# this script has to be ran from a clean dockerfile

# Random note: The reason why this script is being ran from within a container
# is to ensure glibc compatibility. From what I've seen so far, it appears
# that having multiple glibc versions is a somewhat convoluted process
# and I don't trust myself to be able to manage them well.

# Download dependenciess
if [ "$1" != "testonly" ]; then
    # Upload to PyPI
    conda activate py3.8
    python3 -m pip install twine
    python3 -m twine upload dist/*
fi