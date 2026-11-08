"""Renders the Art Deco decks from their SVG drawings.

Ivoire is the drawing as is. Minuit swaps the palette of everything but the
animals' portraits for one based on navy #0A377C: the black suits' ink and the
fans' outer arcs turn ivory, the frames navy. Each card is rendered at 300x450
with rsvg-convert and saved as lossless WebP; its transparent rounded corners
come from the drawing.

    python3 tool/render_svg_deck.py [assets/sources/art_deco_svg [assets/cards]]
"""
import io
import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

from PIL import Image

APP = Path(__file__).resolve().parent.parent
SIZE = (300, 450)
SVG = '{http://www.w3.org/2000/svg}'
FACE_GROUP = 'translate(0 12.5)'  # holds the arch and the portrait, or the pips
CORNER_GROUP = 'rotate(180 125 187.5)'  # the bottom-right copy of the corner

MIDNIGHT = {
    '#f3e8cf': '#0a377c',  # card
    '#ecdbab': '#2a64b0',  # arch
    '#fbf6ea': '#3a76c0',  # sunburst
    '#cbb88f': '#041634',  # outer edge
    '#8c1d23': '#e8574b',  # red suits
    '#d4b061': '#dbb968',  # gold
    '#a8813a': '#c9a253',  # dark gold
}
INK, NAVY, ARCH_GOLD = '#f4ead2', '#041634', '#dbb968'


def midnight(root, face_card):
    """Recolours [root] in place, leaving the portrait of a [face_card]."""

    def walk(el, in_face, in_group):
        if el.tag == SVG + 'g':
            transform = el.get('transform', '')
            if face_card and in_face:
                return  # the portrait
            in_face = in_face or transform == FACE_GROUP
            in_group = in_group or transform != CORNER_GROUP
        for attr in ('fill', 'stroke'):
            colour = (el.get(attr) or '').lower()
            if colour == '#1b1612':
                outline = attr == 'stroke' and el.get('fill') == 'none' and el.tag == SVG + 'path'
                ink = (attr == 'fill' and in_group) or outline
                el.set(attr, INK if ink else NAVY)
            elif colour == '#a8813a' and in_face:
                el.set(attr, ARCH_GOLD)
            elif colour in MIDNIGHT:
                el.set(attr, MIDNIGHT[colour])
        for child in el:
            walk(child, in_face, in_group)

    walk(root, False, False)


def render(svg_bytes, out):
    png = subprocess.run(
        ['rsvg-convert', '-w', str(SIZE[0]), '-h', str(SIZE[1])],
        input=svg_bytes, check=True, capture_output=True).stdout
    image = Image.open(io.BytesIO(png)).convert('RGBA')
    image.save(out, 'WEBP', lossless=True, quality=100, method=6, exact=True)


def main():
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else APP / 'assets/sources/art_deco_svg'
    dst = Path(sys.argv[2]) if len(sys.argv) > 2 else APP / 'assets/cards'
    ET.register_namespace('', SVG[1:-1])
    for deck in ('ivory', 'midnight'):
        (dst / deck).mkdir(parents=True, exist_ok=True)
    for path in sorted(src.glob('*.svg')):
        card = path.stem
        render(path.read_bytes(), dst / 'ivory' / f'{card}.webp')
        root = ET.parse(path).getroot()
        midnight(root, face_card=card[-1] in 'JQK')
        render(ET.tostring(root), dst / 'midnight' / f'{card}.webp')
        print(card, flush=True)


if __name__ == '__main__':
    main()
