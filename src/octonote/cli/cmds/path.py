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

import os

import click

from octonote import cli


@click.command(cls=cli.StylizedCommand)
@click.help_option("-h", "--help", help=cli.HELP_STR)
@click.option(
    "-a",
    "--absolute",
    is_flag=True,
    help="Print absolute directory names",
)
@click.pass_obj
def path(app, absolute):
    """Print the parser configuration search path and exit

    You can set the configuration search path with the `OCTONOTE_PATH`
    environment variable. Alternatively, you can invoke `octonote` with the
    `-p` or `--path` options (see `octonote --help` for more information).

    If you do not set a search path, the program will generate a default path
    that:

    - Searches the program's built-in stock configuration directory

    \b
    - Searches for `.octonote` directories in every parent of the current
      working directory (within the bounds of the current Git repository, if
      detected)

    If ANSI color output is supported, existant directories will be highlighted
    blue whereas non-existant directories will be dimmed.
    """
    paths = app.get_config_search_paths()
    for path in paths:
        dirname = path
        if not absolute:
            dirname = os.path.relpath(dirname)
        dirname = click.format_filename(dirname)
        if path.is_dir():
            dirname = click.style(f"{dirname}", fg="blue")
        else:
            dirname = click.style(f"{dirname}", dim=True)
        click.echo(f"{dirname}")
