"""Renders the Android launcher icons from the goat or a queen's head.

The goat's round icon, assets/icons/chevre_round.webp, is the badge of the
start screen, shown whole on its own cream and already faded at its border;
its classic icon is cut out of the square assets/icons/chevre_square.webp.
The heads in assets/icons/<suit>Q.png are cut out of the Vintage queens, on a
transparent background, with the neck already faded out: the face is centred
in the icon and the feathers may be cropped. Unless already faded, the art fades out along
the icon's outline: a rounded square for the classic icon, the circle that
launchers show of the adaptive icon's foreground.

    python3 tool/make_launcher_icons.py [G|C|D|H|S]    # the goat by default
"""
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageChops, ImageDraw

APP = Path(__file__).resolve().parent.parent
RES = APP / 'android/app/src/main/res'
QUEEN = {'classic': 280, 'adaptive': 432, 'background': (249, 220, 170),
         'fade': {'classic', 'adaptive'}}
# Per icon set: its image, the centre of the face in pixels of that image, how
# many of these pixels span a classic icon and the 108dp adaptive foreground,
# the background color behind them, and the icons whose art fades out along
# their outline. A set may have another image for the classic icon, with its
# own centre, no background behind it, and its own width of the fade, as a
# fraction of the icon.
SETS = {
    'G': {'image': 'assets/icons/chevre_round.webp', 'centre': (305, 305),
          'classic_image': 'assets/icons/chevre_square.webp',
          'classic_centre': (313.5, 313.5), 'classic_background': None,
          'classic': 627, 'adaptive': 880, 'background': (238, 209, 175),
          'fade': {'classic'}, 'classic_fade': 0.048},
    'C': {'image': 'assets/icons/CQ.png', 'centre': (145, 182), **QUEEN},
    'D': {'image': 'assets/icons/DQ.png', 'centre': (134, 197), **QUEEN},
    'H': {'image': 'assets/icons/HQ.png', 'centre': (150, 208), **QUEEN},
    'S': {'image': 'assets/icons/SQ.png', 'centre': (157, 182), **QUEEN},
}
DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}


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


def classic(head, centre, size, window, background, faded, fade_width):
    half, radius = size / 2, size * 0.2
    yy, xx = grid(size)
    qx = np.abs(xx - half) - (half - radius)
    qy = np.abs(yy - half) - (half - radius)
    edge = np.hypot(np.maximum(qx, 0), np.maximum(qy, 0)) + np.minimum(np.maximum(qx, qy), 0) - radius
    art = place(head, centre, size, window)
    if faded:
        art = fade(art, -edge / (fade_width * size))

    big = size * 4
    mask = Image.new('L', (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, big - 1, big - 1), radius=big * 0.2, fill=255)
    icon = Image.new('RGBA', (size, size), background + (255,) if background else (0, 0, 0, 0))
    icon.alpha_composite(art)
    icon.putalpha(ImageChops.multiply(icon.getchannel('A'), mask.resize((size, size), Image.LANCZOS)))
    return icon


def foreground(head, centre, size, window, faded):
    yy, xx = grid(size)
    dp = np.hypot(xx - size / 2, yy - size / 2) * 108 / size
    art = place(head, centre, size, window)
    return fade(art, (36 - dp) / 6) if faded else art


def main():
    s = SETS[sys.argv[1] if len(sys.argv) > 1 else 'G']
    head = Image.open(APP / s['image']).convert('RGBA')
    centre, background = s['centre'], s['background']
    classic_head = Image.open(APP / s.get('classic_image', s['image'])).convert('RGBA')
    classic_centre = s.get('classic_centre', centre)
    for density, k in DENSITIES.items():
        folder = RES / f'mipmap-{density}'
        icon = classic(classic_head, classic_centre, round(48 * k), s['classic'],
                       s.get('classic_background', background), 'classic' in s['fade'],
                       s.get('classic_fade', 0.08))
        icon.save(folder / 'ic_launcher.png', optimize=True)
        art = foreground(head, centre, round(108 * k), s['adaptive'], 'adaptive' in s['fade'])
        art.save(folder / 'ic_launcher_foreground.png', optimize=True)
    (RES / 'values/ic_launcher_background.xml').write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
        '    <color name="ic_launcher_background">#%02X%02X%02X</color>\n'
        '</resources>\n' % background)


if __name__ == '__main__':
    main()
