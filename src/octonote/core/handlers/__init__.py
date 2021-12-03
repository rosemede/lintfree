import charset_normalizer

from ... import errors


class Handler:

    _format = {}

    _match_attrs = {}

    _severities = []

    def __init__(self, format):
        self._format = format
        severities = self._format["severities"]
        self._match_attrs = self._format["match-attrs"]
        for severity_name in severities:
            severity = severities.get(severity_name)
            self._severities.append(severity)

    def _decode(self, bytes):
        # TODO: Catch encoding errors
        charset_data = charset_normalizer.from_bytes(bytes).best()
        return str(charset_data)

    def annotate(self, input):
        raise errors.NotImplementedError


from .jq import JQHandler
from .regex import RegexHandler
from .xpath import XPathHandler
