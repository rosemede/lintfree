import click
from softener import cli


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
    # editorconfig-checker-disable
    # noqa: D213
    r"""Print the parser configuration search path and exit

    You can set the configuration search path with the `SOFTENER_PATH`
    environment variable. Alternatively, you can invoke `softener` with the
    `-p` or `--path` options (see `softener --help` for more information).

    If you do not set a search path, the program will generate a default path
    that:

    - Searches the program's built-in stock configuration directory

    \b
    - Searches for `.softener` directories in every parent of the current
      working directory (within the bounds of the current Git repository, if
      detected)

    If ANSI color output is supported, existant directories will be highlighted
    blue whereas non-existant directories will be dimmed.
    """
    # editorconfig-checker-enable
    paths = app.get_config_search_paths(absolute)
    for path in paths:
        path = click.format_filename(path)
        kwargs = {"fg": "blue"} if path.is_dir() else {"dim": True}
        path = click.style(f"{path}", **kwargs)
        click.echo(f"{path}")
