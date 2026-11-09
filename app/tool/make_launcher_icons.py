"""Renders the Android launcher icons from the goat.

The adaptive icon's foreground is the badge of the start screen,
assets/icons/chevre_round.webp, shown whole on its own cream and already faded
at its border. The classic icon is cut out of the square
assets/icons/chevre_square.webp, as a rounded square that fades out to
transparent along its outline.

    python3 tool/make_launcher_icons.py
"""
from pathlib import Path

import numpy as np
from PIL import Image, ImageChops, ImageDraw

APP = Path(__file__).resolve().parent.parent
RES = APP / 'android/app/src/main/res'
ROUND = APP / 'assets/icons/chevre_round.webp'
SQUARE = APP / 'assets/icons/chevre_square.webp'
BACKGROUND = (238, 209, 175)  # the cream of the badge
ROUND_WINDOW = 880  # pixels of the badge across the 108dp adaptive foreground
FADE = 0.048  # width of the classic icon's fade, as a fraction of the icon
DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}


def classic(square, size):
    half, radius = size / 2, size * 0.2
    yy, xx = np.mgrid[:size, :size] + 0.5
    qx = np.abs(xx - half) - (half - radius)
    qy = np.abs(yy - half) - (half - radius)
    edge = np.hypot(np.maximum(qx, 0), np.maximum(qy, 0)) + np.minimum(np.maximum(qx, qy), 0) - radius
    icon = np.asarray(square.resize((size, size), Image.LANCZOS)).astype(float)
    icon[..., 3] *= np.clip(-edge / (FADE * size), 0, 1)
    icon = Image.fromarray(icon.round().astype(np.uint8), 'RGBA')

    big = size * 4
    mask = Image.new('L', (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, big - 1, big - 1), radius=big * 0.2, fill=255)
    icon.putalpha(ImageChops.multiply(icon.getchannel('A'), mask.resize((size, size), Image.LANCZOS)))
    return icon


def foreground(badge, size):
    k = size / ROUND_WINDOW
    scaled = badge.resize((round(badge.width * k), round(badge.height * k)), Image.LANCZOS)
    canvas = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    offset = round(size / 2 - badge.width / 2 * k)
    canvas.paste(scaled, (offset, offset), scaled)
    return canvas


def main():
    badge = Image.open(ROUND).convert('RGBA')
    square = Image.open(SQUARE).convert('RGBA')
    for density, k in DENSITIES.items():
        folder = RES / f'mipmap-{density}'
        classic(square, round(48 * k)).save(folder / 'ic_launcher.png', optimize=True)
        foreground(badge, round(108 * k)).save(folder / 'ic_launcher_foreground.png', optimize=True)
    (RES / 'values/ic_launcher_background.xml').write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
        '    <color name="ic_launcher_background">#%02X%02X%02X</color>\n'
        '</resources>\n' % BACKGROUND)


if __name__ == '__main__':
    main()
