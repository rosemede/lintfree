import re

from .. import format

from . import Handler

from icecream import ic


class RegexHandler(Handler):

    _line_rules = []
    _rewrite_keys = []

    def __init__(self, format):
        super().__init__(format)
        # TODO: Catch errors
        self._line_rules = self._format["lines"]
        # Compile regular expressions (and catch any errors)
        for rule in self._line_rules:
            # TODO: Catch errors
            match = rule["match"]
            rule["match_re"] = re.compile(match)
        self._rewrite_keys = self._format["rewrite"]
        for rules in self._rewrite_keys.values():
            # Compile regular expressions (and catch any errors)
            for rule in rules:
                # TODO: Catch errors
                match = rule["match"]
                rule["match_re"] = re.compile(match)

    def _debug(self, str):
        print(format.printer.colorize(f"{str}"))

    def annotate(self, severities, input):
        input = self._decode(input)

        annotations = []

        current_annotation = {
            "file": None,
            "line": None,
            "end_line": None,
            "code": None,
            "severity": None,
            "message": None,
        }

        def is_complete(annotation):
            if not annotation.get("file"):
                return False
            if not annotation.get("line"):
                return False
            if not annotation.get("severity"):
                return False
            if not annotation.get("message"):
                return False
            return True

        input_lines = input.strip().splitlines()
        for line in input_lines:
            line = line.rstrip("\n")
            for rule in self._line_rules:
                match = rule["match_re"].search(line)
                if match:
                    if rule.get("reset"):
                        current_annotation = dict.fromkeys(current_annotation, None)
                    severity = rule.get("severity")
                    if severity is not None:
                        current_annotation["severity"] = severity
                    set_dict = rule.get("set", {})
                    for key, group in set_dict.items():
                        value = match.groups()[group]
                        current_annotation[key] = value.format(*match.groups())
                    if is_complete(current_annotation):
                        annotation = current_annotation.copy()
                        if annotation not in annotations:
                            annotations.append(annotation)
                        # current_annotation = dict.fromkeys(current_annotation, None)

        rewrite_dict = self._format.get("rewrite", {})
        for annotation in annotations:
            for key, rules in rewrite_dict.items():
                for rule in rules:
                    value = annotation[key]
                    new_value = rule["match_re"].sub(rule["replace"], value)
                    annotation[key] = new_value

        # We do this validation last because the user can modify the severity
        # at any stage before now
        for annotation in annotations:
            severity = annotation["severity"]
            if severity not in severities:
                raise ValueError(f"Unknown severity: {value}")

        return annotations
