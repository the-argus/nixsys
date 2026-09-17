#!/usr/bin/env python3
"""
Convert an .itermcolors file into banner yaml
See: https://iterm2colorschemes.com/
And: https://www.ditig.com/256-colors-cheat-sheet
"""

import plistlib
import sys


def to_hex(comp):
    v = round(max(0.0, min(1.0, float(comp))) * 255)
    return f"{v:02x}"


def main():
    if len(sys.argv) != 2:
        sys.exit(f"usage: {sys.argv[0]} <file.itermcolors>")

    with open(sys.argv[1], "rb") as f:
        data = plistlib.load(f)

    for i in range(16):
        c = data.get(f"Ansi {i} Color")
        if c is None:
            continue
        hexcolor = "".join(
            to_hex(c[k]) for k in ("Red Component", "Green Component", "Blue Component")
        )
        print(f'ansi{i:02X}:\t\t"{hexcolor}"')


if __name__ == "__main__":
    main()
