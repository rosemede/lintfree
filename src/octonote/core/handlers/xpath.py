from lxml import etree

from . import Handler

class XPathHandler(Handler):
    def annotate(self, input):
        annotations = []
        root = etree.fromstring(input)
        for severity in self._severities:
            matches = root.xpath(severity["match"])
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
                annotation["file"] = match.xpath(file)[0]
                annotation["line"] = match.xpath(line)[0]
                annotation["end-line"] = match.xpath(end_line)[0]
                annotation["title"] = match.xpath(title)[0]
                annotation["message"] = match.xpath(message)[0]
                annotations.append(annotation)
        return annotations
