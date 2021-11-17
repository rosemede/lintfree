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

import click

from octonote import cli


@click.command(cls=cli.StylizedCommand)
@click.argument("config_id")
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.pass_obj
def debug(app, config_id):
    """Debug issues with a parser configuration"""
    app.debug(config_id)
