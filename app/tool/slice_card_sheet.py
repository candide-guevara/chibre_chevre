"""Cuts a generated sheet of cards into the images of a bundled card design.

The sheet has one row per suit (hearts, spades, diamonds, clubs) and the
columns A 10 K Q J 9 8 7 6, optionally followed by extra columns (e.g. a 5)
that are ignored, on a dark background. Each card is stretched to 2:3, given
transparent rounded corners and saved as lossless WebP, which is about a
third smaller than PNG and decodes a little faster.

    python3 tool/slice_card_sheet.py sheet.png assets/cards/vintage
"""
import sys

import numpy as np
from PIL import Image, ImageDraw

SIZE = (300, 450)
RADIUS = 0.07  # of the width, as the design's cornerRadius
SUITS = ['H', 'S', 'D', 'C']
RANKS = ['A', '10', 'K', 'Q', 'J', '9', '8', '7', '6']


def runs(flags):
    found, start = [], None
    for i, flag in enumerate(list(flags) + [False]):
        if flag and start is None:
            start = i
        if not flag and start is not None:
            found.append((start, i - 1))
            start = None
    return found


def between(gaps):
    """The spans between gaps at least 3 pixels wide."""
    gaps = [g for g in gaps if g[1] - g[0] >= 3]
    return [(a[1] + 1, b[0]) for a, b in zip(gaps, gaps[1:])]


def corner_mask():
    big = Image.new('L', (SIZE[0] * 4, SIZE[1] * 4), 0)
    ImageDraw.Draw(big).rounded_rectangle(
        (0, 0, big.width - 1, big.height - 1), RADIUS * big.width, fill=255)
    return big.resize(SIZE, Image.LANCZOS)


def main(sheet_path, out):
    sheet = Image.open(sheet_path).convert('RGB')
    dark = np.asarray(sheet.convert('L')) < 90
    rows = between(runs(dark.mean(axis=1) > 0.7))
    assert len(rows) == len(SUITS), rows
    mask = corner_mask()
    for (y0, y1), suit in zip(rows, SUITS):
        columns = between(runs(dark[y0 + 40:y1 - 40].mean(axis=0) > 0.85))
        assert len(columns) >= len(RANKS), columns
        for (x0, x1), rank in zip(columns, RANKS):
            card = sheet.crop((x0 + 1, y0 + 1, x1 - 1, y1 - 1))
            card = card.resize(SIZE, Image.LANCZOS).convert('RGBA')
            card.putalpha(mask)
            card.save(f'{out}/{suit}{rank}.webp', lossless=True, quality=100,
                      method=6, exact=True)


if __name__ == '__main__':
    main(*sys.argv[1:])
