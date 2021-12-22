import json

import jq

from . import Handler


class JQHandler(Handler):
    def _set_value(self, match, set_dict, key):
        query = set_dict.get(key)
        if query is None:
            return None
        value = jq.compile(query).input(match).first()
        if self._debug:
            print(value)
        return value

    def _annotate(self, input):
        # TODO: Catch errors
        input = self._decode(input)
        json_dict = json.loads(input)

        def matches_fn(query):
            return jq.compile(query).input(json_dict).all()

        self._generate_matches(matches_fn)
        return self._annotations
