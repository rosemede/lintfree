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
    "-c",
    "--console",
    is_flag=True,
    envvar="PRINT_CONSOLE",
    help="""Print visible annotations to the console (can also be set with the `PRINT_CONSOLE` environment variable value)""",
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
def parse(app, input, quiet, console, parser_id, error_on, format, sort_by):
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
    # TODO: IF console is false and this is not being run in a GitHub Actions
    # workflow, exit immediately
    app.configure_output(quiet=quiet, console=console)
    app.load_configs()
    app.parse(parser_id, input, format)
    status_code = app.print(sort_by, error_on)
    sys.exit(status_code)
