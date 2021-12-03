import json
import pyjq

from . import Handler


class JQHandler(Handler):
    def annotate(self, input):
        annotations = []
        input = self._decode(input)
        json_dict = json.loads(input)
        for severity in self._severities:
            matches = pyjq.all(severity["match"], json_dict)
            match_attrs = severity.get("match-attrs", self._match_attrs)
            for match in matches:
                annotation = {}
                # TODO: Catch errors
                file = match_attrs["file"]
                line = match_attrs["line"]
                end_line = match_attrs.get("line", line)
                title = match_attrs["title"]
                message = match_attrs["message"]
                # TODO: Catch errors
                annotation["severity_name"] = severity["severity_name"]
                annotation["file"] = pyjq.all(file, match)[0]
                annotation["line"] = pyjq.all(line, match)[0]
                annotation["end-line"] = pyjq.all(end_line, match)[0]
                annotation["title"] = pyjq.all(title, match)[0]
                annotation["message"] = pyjq.all(message, match)[0]
                annotations.append(annotation)
        return annotations
