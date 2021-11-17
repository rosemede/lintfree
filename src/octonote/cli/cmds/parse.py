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

import sys

import click

from octonote import cli


@click.command(cls=cli.StylizedCommand)
# TODO: allow multiple inputs to be specified
@click.argument("input", required=False, default="-", type=click.File("rb"))
@click.help_option("-h", "--help", help=cli.HELP_STR)
# TODO: Implement some sort of config guesssing
@click.option(
    "-q",
    "--quiet",
    is_flag=True,
    help="Suppress all non-essential output",
)
@click.option(
    "-v",
    "--verbose",
    is_flag=True,
    help="""Print human-readable annotations to the console""",
)
# TODO: https://click.palletsprojects.com/en/8.0.x/options/#choice-options
# TODO: https://click.palletsprojects.com/en/8.0.x/options/#dynamic-defaults-for-prompts
@click.option(
    "-p",
    "--parser",
    "parser_id",
    metavar="ID",
    required=True,
    help="Specify the parser to use",
)
# TODO: https://click.palletsprojects.com/en/8.0.x/options/#choice-options
@click.option(
    "-e",
    "--error-on",
    metavar="LEVEL",
    default="notice",
    show_default=True,
    help="Exit on the specified severity level (notice, warning, error)",
)
# TODO: https://click.palletsprojects.com/en/8.0.x/options/#choice-options
# TODO: https://click.palletsprojects.com/en/8.0.x/options/#dynamic-defaults-for-prompts
@click.option(
    "-f",
    "--format",
    "format",
    metavar="FORMAT",
    required=True,
    help="Specify the input format",
)
# TODO: https://click.palletsprojects.com/en/8.0.x/options/#choice-options
@click.option(
    "-s",
    "--sort-by",
    metavar="ATTR",
    default="file",
    show_default=True,
    help="Sort annotations by the specified attribute (file, severity)",
)
@click.pass_obj
def parse(app, input, quiet, verbose, parser_id, error_on, format, sort_by):
    """Generate annotations from input data using a parser configuration

    The `INPUT` argument, if specified, must reference any type of readable
    file. You can specify `-` to read from standard input (STDIN). However,
    when no `INPUT` value is provided, the program will attempt to read from
    STDIN by default.

    When the program exits because of a parsed error message, the returned error
    code corresponds to the highest error message encountered:

    - 100: notice
    - 101: warning
    - 102: error

    If the `GITHUB_ACTIONS` environment variable is set to `true`, this program
    will print GitHub workflow commands to send parser output to the GitHub
    Actions runner. GitHub Actions automatically sets this environment variable
    to `true` when running any workflow.

    The GitHub Actions runner does not print GitHub workflow commands to the
    output log. If you want preview the GitHub workflow commands, you can set
    the `GITHUB_ACTIONS` environment variable to `true` when running this
    program locally.
    """
    app.configure_output(quiet=quiet, verbose=verbose)
    app.load_configs()
    app.parse(parser_id, input, format)
    status_code = app.print(sort_by, error_on)
    sys.exit(status_code)
