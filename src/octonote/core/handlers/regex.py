import re

from . import Handler

class RegexHandler(Handler):
    def __init__(self, format):
        super().__init__(format)
        # Compile regular expressions (and catch any errors)
        for severities in self._severities:
            # TODO: Catch errors
            match = severities["match"]
            severities["match_re"] = re.compile(match)

    def annotate(self, input):
        input = self._decode(input)

        matches = []

        input_lines = input.strip().splitlines()
        for line in input_lines:
            line = line.rstrip("\n")
            print(line)
            for severity in self._severities:
                match = severity["match_re"].search(line)
                if match:
                    matches.append((line, severity, match))
                    break

        annotations = []

        # TODO: Handle exceptions when a user tries to use positional and named
        # groups simultaneously
        for line, matcher, match in matches:
            annotation = {"severity_name": matcher["severity_name"]}

            match_attrs = matcher.get("match-attrs", self._match_attrs)

            # filename
            file = match_attrs["file"]
            match_groupdict = match.groupdict()
            if match_groupdict:
                file = file.format(**match_groupdict)
            match_groups = match.groups()
            if match_groups:
                file = file.format(*match_groups)
            annotation["file"] = file

            # line
            line = match_attrs["line"]
            match_groupdict = match.groupdict()
            if match_groupdict:
                line = line.format(**match_groupdict)
            match_groups = match.groups()
            if match_groups:
                line = line.format(*match_groups)
            annotation["line"] = line

            # end-line
            end_line = match_attrs.get("end-line", line)
            if end_line != line:
                match_groupdict = match.groupdict()
                if match_groupdict:
                    end_line = line.format(**match_groupdict)
                match_groups = match.groups()
                if match_groups:
                    end_line = line.format(*match_groups)
            annotation["end-line"] = end_line

            # title
            title = match_attrs["title"]
            match_groupdict = match.groupdict()
            if match_groupdict:
                title = title.format(**match_groupdict)
            match_groups = match.groups()
            if match_groups:
                title = title.format(*match_groups)
            annotation["title"] = title

            # message
            message = match_attrs["message"]
            match_groupdict = match.groupdict()
            if match_groupdict:
                message = message.format(**match_groupdict)
            match_groups = match.groups()
            if match_groups:
                message = message.format(*match_groups)
            annotation["message"] = message

            annotations.append(annotation)

        return annotations
