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
export DEBIAN_FRONTEND=noninteractive
eval "$(conda shell.bash hook)"

rm -r dist

for VERSION in 3.8 3.9 3.10 3.11 3.12; do
    # Create and activate environment
    conda config --add channels conda-forge
    conda config --set channel_priority strict
    conda create -y -n py$VERSION python=$VERSION
    conda activate py$VERSION

    pip install -r requirements.txt
    # Build and package
    python3 setup.py bdist_wheel --python-tag py3 --plat-name manylinux1_x86_64
    # Cleanup
    rm -r kumo_turbo.egg-info
    conda deactivate
done
