#!/bin/sh
set -e
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