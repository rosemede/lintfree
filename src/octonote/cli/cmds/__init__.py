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
from octonote.core.app import Application

from . import debug
from . import list
from . import parse
from . import path


@click.group(cls=cli.StylizedGroup)
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.version_option("--version", help=cli.VERSION_STR, message="%(version)s")
@click.option("-p", "--path", metavar="<PATH>", envvar="OCTONOTE_PATH", multiple=True, type=click.Path(), help='Set a configuration search path (overriding the `OCTONOTE_PATH`\x1f    environment variable and the default search path)')
@click.pass_context
def main(ctx, path):
    """Generate GitHub annotations from arbitrary input data"""
    app = Application()
    app.set_config_search_paths(path)
    ctx.obj = app


main.add_command(debug.debug)
main.add_command(list.list)
main.add_command(parse.parse)
main.add_command(path.path)


if __name__ == "__main__":
    main()
