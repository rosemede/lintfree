# Copyright 2021, Naomi Rose and contributors
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

import pathlib

from importlib.metadata import distribution

dist = distribution("octonote")
version = dist.version

root_dir_path = pathlib.Path(__file__).parent
data_dir_path = root_dir_path.joinpath("data")
schemas_dir_path = data_dir_path.joinpath("schemas")
configs_dir_path = data_dir_path.joinpath("configs")
