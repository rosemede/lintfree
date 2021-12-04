import textwrap

import pastel


printer = pastel.Pastel(True)
printer.add_style("header", options=["bold"])
printer.add_style("location", "light_blue")
# printer.add_style("code", "white")
printer.add_style("notice", options=["bold"])
printer.add_style("warning", "yellow", options=["bold"])
printer.add_style("error", "red", options=["bold"])

# For debug output
printer.add_style("set", "yellow")
printer.add_style("add", "green")

from icecream import ic


class BaseFormater:

    _github = False

    _title = None
    _annotations = []

    def __init__(self, title, annotations):
        self._printer = printer
        self._title = title
        self._annotations = annotations

    def _print(self, str):
        print(printer.colorize(str))

    def _print_prologue(self, group_name=None):
        pass

    def _print_annotation(self, annotation):
        pass

    def _print_annotations(self):
        for annotation in self._annotations:
            self._print_annotation(annotation)

    def _print_epilogue(self, group_name=None):
        pass

    def print_report(self, group_name=None):
        self._print_prologue(group_name)
        self._print_annotations()
        self._print_epilogue(group_name)


class CommandFormater(BaseFormater):
    def _print_prologue(self, group_name=None):
        if group_name:
            group = f"::group::{group_name}"
            print(group)

    def _print_annotation(self, annotation):
        severity = annotation["severity"]
        file = f"file={annotation['file']}"
        line = f"line={int(annotation['line'])}"
        end_line = f"endLine={int(annotation['end_line'])}"
        title = f"title={annotation['title']}"
        message = annotation["message"]
        print(f"::{severity} {file},{line},{end_line},{title}::{message}")

    def _print_epilogue(self, group_name=None):
        if group_name:
            print("::endgroup::")


class ConsoleFormater(BaseFormater):
    def _print_prologue(self, group_name=None):
        self._print(f"<header>{self._title}</header>")

    def _print_annotation(self, annotation):
        print("")
        file = annotation["file"]
        line = int(annotation["line"])
        end_line = int(annotation["end_line"])
        end_line = "" if end_line == line else f":{end_line}"
        location = f"  <location>{file}:{line}{end_line}</location>"
        self._print(location)
        # with open(filename, "r") as file:
        #     lines = file.readlines()
        #     line = lines[line_num - 1].rstrip("\n")
        #     line = style.print(f"<code>{line}</code>")
        #     print(line)
        severity = annotation["severity"]
        severity_len = " " * len(severity)
        severity_str = f"<{severity}>{severity.capitalize()}:</{severity}>"
        initial_indent = "      " + severity_len
        msg = annotation["message"]
        msg = textwrap.fill(
            msg, 79, initial_indent=initial_indent, subsequent_indent="    "
        )
        msg = msg.lstrip()
        self._print(f"    {severity_str} {msg}")
