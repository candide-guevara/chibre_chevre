"""Renders the Android launcher icons from a queen's head.

The heads in assets/icons/<suit>Q.png are cut out of the Vintage queens, on a
transparent background, with the neck already faded out. The face is centred
in the icon, the feathers may be cropped, and the art fades out along the
icon's outline: a rounded square for the classic icon, the circle that
launchers show of the adaptive icon's foreground.

    python3 tool/make_launcher_icons.py [C|D|H|S]    # clubs by default
"""
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

APP = Path(__file__).resolve().parent.parent
RES = APP / 'android/app/src/main/res'
# The centre of each face, in pixels of its head image.
CENTRES = {'C': (145, 182), 'D': (134, 197), 'H': (150, 208), 'S': (157, 182)}
BACKGROUND = (249, 220, 170)  # as ic_launcher_background.xml
DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
CLASSIC_WINDOW = 280  # head pixels across a classic icon
ADAPTIVE_WINDOW = 432  # head pixels across the 108dp adaptive foreground


def place(head, centre, size, window):
    k = size / window
    scaled = head.resize((round(head.width * k), round(head.height * k)), Image.LANCZOS)
    canvas = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    canvas.paste(scaled, (round(size / 2 - centre[0] * k), round(size / 2 - centre[1] * k)), scaled)
    return canvas


def fade(image, inside):
    """Multiplies the alpha of [image] by [inside], from 0 to 1 per pixel."""
    a = np.asarray(image).astype(float)
    a[..., 3] *= np.clip(inside, 0, 1)
    return Image.fromarray(a.round().astype(np.uint8), 'RGBA')


def grid(size):
    return np.mgrid[:size, :size] + 0.5


def classic(head, centre, size):
    half, radius = size / 2, size * 0.2
    yy, xx = grid(size)
    qx = np.abs(xx - half) - (half - radius)
    qy = np.abs(yy - half) - (half - radius)
    edge = np.hypot(np.maximum(qx, 0), np.maximum(qy, 0)) + np.minimum(np.maximum(qx, qy), 0) - radius
    art = fade(place(head, centre, size, CLASSIC_WINDOW), -edge / (0.08 * size))

    big = size * 4
    mask = Image.new('L', (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, big - 1, big - 1), radius=big * 0.2, fill=255)
    icon = Image.new('RGBA', (size, size), BACKGROUND + (255,))
    icon.alpha_composite(art)
    icon.putalpha(mask.resize((size, size), Image.LANCZOS))
    return icon


def foreground(head, centre, size):
    yy, xx = grid(size)
    dp = np.hypot(xx - size / 2, yy - size / 2) * 108 / size
    return fade(place(head, centre, size, ADAPTIVE_WINDOW), (36 - dp) / 6)


def main():
    suit = sys.argv[1] if len(sys.argv) > 1 else 'C'
    head = Image.open(APP / f'assets/icons/{suit}Q.png').convert('RGBA')
    centre = CENTRES[suit]
    for density, k in DENSITIES.items():
        folder = RES / f'mipmap-{density}'
        classic(head, centre, round(48 * k)).save(folder / 'ic_launcher.png', optimize=True)
        foreground(head, centre, round(108 * k)).save(folder / 'ic_launcher_foreground.png', optimize=True)


if __name__ == '__main__':
    main()
