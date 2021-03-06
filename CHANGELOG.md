# Changelog

This project uses [semantic versioning][semver].

**Table of contents:**

- [0.x](#0x)
  - [0.0.0-a2](#000-a2)
  - [0.0.0-a1](#000-a1)
  - [0.0.0-a0](#000-a0)

[semver]: https://semver.org/

<!--

## Unreleased

- Fixed bug with handling of internal severity levels causing any sort of
  annotation to raise a parse exception.

- Fixed issues with some Python development dependencies being listed as user
  dependencies.

-->

## 0.x

### 0.0.0-a2

_Released on 2021-12-20_

- Added the `OBELIST_NO_ERROR` environment variable.

  If you set this environment variable to `true`, the `obelist` command will ignore the `--error-on` option and never exit with an error.

- Added a colon (`:`) between the parser name and error code when printing annotations to the console.

- Added reference implementations for the following tools:

  - [Black][black]
  - [cSpell][cspell]
  - [Lintspaces][lintspaces]
  - [Lychee][lychee]
  - [markdown-link-check][mlc]
  - [MarkdownLint][markdownlint]
  - [Misspell][misspell]
  - [proselint][proselint]
  - [reorder-python-imports][py-imports]
  - [shfmt][shfmt]
  - [Whitespace Total Fixer][wtf]
  - [woke][woke]
  - [yamllint][yamllint]

  Each reference implementation includes a parser configuration, a lint script, and integration into the build system.

[black]: https://black.readthedocs.io/en/stable/index.html
[cspell]: https://cspell.org/
[lintspaces]: https://github.com/evanshortiss/lintspaces-cli
[lychee]: https://github.com/lycheeverse/lychee
[markdownlint]: https://github.com/igorshubovych/markdownlint-cli
[misspell]: https://github.com/client9/misspell
[mlc]: https://github.com/tcort/markdown-link-check
[proselint]: https://github.com/amperser/proselint
[py-imports]: https://github.com/asottile/reorder_python_imports
[shfmt]: https://github.com/patrickvane/shfmt
[woke]: https://github.com/get-woke/woke
[wtf]: https://github.com/dlenski/wtf
[yamllint]: https://yamllint.readthedocs.io/en/stable/index.html

### 0.0.0-a1

_Released on 2021-12-17_

- Improved the format and consistency of the parser configuration YAML files.

- Improved the way that line-by-line regex parsing is done.

  You can now construct annotations over multiple lines. This technique is useful when error messages are grouped by file (e.g., the filename is printed once, and every error message is printed on a separate line).

- Added the `format` command that allows you to cache annotations to a temporary file (without failing) and then reparse the cached annotations in aggregate, allowing you to error out with a complete set of annotations after all the lint checks have been run.

- Improved the output of annotations when printed to the console.

  Console annotations now include the following:

  - The filename and line numbers
  - A quotation block showing the code the annotation applies to with a configurable number of before and after context lines
  - The annotation title (which can include an error code)
  - The annotation message

  For example:

  ```text
  src/obelist/core/query.py:45
  >             severities["match_re"] = re.compile(match)
  >
  >     def annotate(self, input):
    Flake8 CCR001
      Cognitive complexity is too high (31 > 3)
  ```

- Add reference implementations for the following tools:

  - [EditorConfig][editorconfig]
  - [Flake8][flake8]
  - [Prettier][prettier]
  - [Prospector][prospector]

  Each reference implementation includes a parser configuration, a lint script, and integration into the build system.

[editorconfig]: https://editorconfig.org/
[flake8]: https://flake8.pycqa.org/en/latest/
[prettier]: https://prettier.io/
[prospector]: http://prospector.landscape.io/en/master/

### 0.0.0-a0

_Released on 2021-12-15_

- Added the first working version of the program, which can parse `checkstyle`, `gcc`, and `json` output from lint files and generate the corresponding annotation for GitHub Actions.

  This release includes a reference implementation for [ShellCheck][shellcheck].

[shellcheck]: https://www.shellcheck.net/
