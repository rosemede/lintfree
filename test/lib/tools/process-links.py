#!/usr/bin/env python3
import sys

import charset_normalizer
import urlextract


def get_contents(filename):
    with open(filename, "rb") as file:
        bytes = file.read()
        charset_data = charset_normalizer.from_bytes(bytes).best()
        return str(charset_data)

def handle_line(extractor, file, file_line, line_num, output_dict):
    urls = extractor.find_urls(file_line)
    for url, message in output_dict.items():
        if url in urls:
            sys.stderr.write(f"{file}:{line_num + 1}: {url} {message}\n")


def main(file, output):
    file_lines = get_contents(file).splitlines()
    output_lines = get_contents(output).splitlines()
    output_dict = {}
    for line in output_lines:
        url, message = line.split(" ", 1)
        output_dict[url] = message.strip()
    extractor = urlextract.URLExtract()
    for line_num, file_line in enumerate(file_lines):
        handle_line(extractor, file, file_line, line_num, output_dict)

    sys.stderr.flush()


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {__file__} FILE OUTPUT")
        sys.exit(1)
    file = sys.argv[1]
    output = sys.argv[2]
    main(file, output)
