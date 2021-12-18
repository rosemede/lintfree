# Changelog

This project uses [semantic versioning][semver].

**Table of contents:**

- [0.x](#0x)
  - [0.0.0-a1](#000-a1)
  - [0.0.0-a0](#000-a0)

[semver]: https://semver.org/

<!--

## Unreleased

- Add reference implementations for the following tools:

  - [cSpell][cspell]
  - [Lintspaces][lintspaces]
  - [MarkdownLint][markdownlint]
  - [shfmt][shfmt]
  - [Whitespace Total Fixer][wtf]

  Each reference implementation includes a parser configuration, a lint script, and integration into the build system.

-->

## 0.x

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

### 0.0.0-a0

_Released on 2021-12-15_

- Added the first working version of the program, which can parse `checkstyle`, `gcc`, and `json` output from lint files and generate the corresponding annotation for GitHub Actions.

  This release includes a reference implementation for [ShellCheck][shellcheck].

[cspell]: https://cspell.org/
[editorconfig]: https://editorconfig.org/
[flake8]: https://flake8.pycqa.org/en/latest/
[jq]: https://stedolan.github.io/jq/manual/
[lintspaces]: https://github.com/evanshortiss/lintspaces-cli
[markdownlint]: https://github.com/igorshubovych/markdownlint-cli
[prettier]: https://prettier.io/
[prospector]: http://prospector.landscape.io/en/master/
[shellcheck]: https://www.shellcheck.net/
[shfmt]: https://github.com/patrickvane/shfmt
[wtf]: https://github.com/dlenski/wtf
[xpath]: https://lxml.de/xpathxslt.html
