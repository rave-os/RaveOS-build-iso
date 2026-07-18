#!/usr/bin/env python3
"""Wordmark + tagline + status PNG-k generalasa a Plymouth temahoz.
Placeholder fontokkal (nincs Bebas Neue a rendszeren): Noto Sans Condensed
ExtraBold a wordmarkhoz, Ubuntu Mono a tagline/status szoveghez.
"""
from PIL import Image, ImageDraw, ImageFont

SCALE = 3  # 3x render, majd a Plymouth script kicsinyiti - crisp marad

WORDMARK_FONT = "/usr/share/fonts/noto/NotoSans-CondensedExtraBold.ttf"
MONO_FONT = "/usr/share/fonts/ubuntu/Ubuntu-B.ttf"
MONO_FONT_REGULAR = "/usr/share/fonts/ubuntu/Ubuntu-R.ttf"

RAVE_COLOR = (232, 232, 230, 255)   # #e8e8e6
OS_COLOR = (98, 160, 82, 255)       # #62a052
MUTED_COLOR = (122, 125, 130, 255)  # #7a7d82


def draw_tracked_text(draw, xy, text, font, fill, tracking):
    """Szoveg rajzolasa kezi betukoz-nyujtassal (PIL-nek nincs natix tracking)."""
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=font, fill=fill)
        w = draw.textlength(ch, font=font)
        x += w + tracking


def measure_tracked(draw, text, font, tracking):
    total = 0
    for ch in text:
        total += draw.textlength(ch, font=font) + tracking
    return total - tracking if text else 0


def make_wordmark():
    font_size = 46 * SCALE
    tracking = 4 * SCALE
    font = ImageFont.truetype(WORDMARK_FONT, font_size)

    tmp = Image.new("RGBA", (10, 10))
    d = ImageDraw.Draw(tmp)
    w_rave = measure_tracked(d, "RAVE", font, tracking)
    w_os = measure_tracked(d, "OS", font, tracking)
    gap = tracking  # a ket szo kozott is annyi hely mint a betukoz
    total_w = int(w_rave + gap + w_os) + 20
    ascent, descent = font.getmetrics()
    total_h = ascent + descent + 10

    img = Image.new("RGBA", (total_w, total_h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    draw_tracked_text(d, (10, 5), "RAVE", font, RAVE_COLOR, tracking)
    draw_tracked_text(d, (10 + w_rave + gap, 5), "OS", font, OS_COLOR, tracking)

    bbox = img.getbbox()
    img = img.crop(bbox)
    img.save("wordmark.png")
    print("wordmark.png", img.size)


def make_tagline():
    font_size = 13 * SCALE
    tracking = 1 * SCALE
    font = ImageFont.truetype(MONO_FONT_REGULAR, font_size)
    text = "RAVEOS FINOMHANGOLÁS, KULCSRA KÉSZ ÁLLAPOT!"

    tmp = Image.new("RGBA", (10, 10))
    d = ImageDraw.Draw(tmp)
    w = measure_tracked(d, text, font, tracking)
    ascent, descent = font.getmetrics()
    h = ascent + descent + 6

    img = Image.new("RGBA", (int(w) + 10, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    draw_tracked_text(d, (5, 3), text, font, MUTED_COLOR, tracking)
    bbox = img.getbbox()
    img = img.crop(bbox) if bbox else img
    img.save("tagline.png")
    print("tagline.png", img.size)


def make_status_stage(name, text):
    font_size = 11 * SCALE
    tracking = 1 * SCALE
    font = ImageFont.truetype(MONO_FONT_REGULAR, font_size)

    tmp = Image.new("RGBA", (10, 10))
    d = ImageDraw.Draw(tmp)
    w = measure_tracked(d, text, font, tracking)
    ascent, descent = font.getmetrics()
    h = ascent + descent + 6

    img = Image.new("RGBA", (int(w) + 10, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    draw_tracked_text(d, (5, 3), text, font, MUTED_COLOR, tracking)
    bbox = img.getbbox()
    img = img.crop(bbox) if bbox else img
    img.save(f"status-{name}.png")
    print(f"status-{name}.png", img.size)


STAGES = [
    ("01", "starting..."),
    ("02", "loading kernel modules..."),
    ("03", "mounting filesystems..."),
    ("04", "starting network..."),
    ("05", "preparing live environment..."),
    ("06", "almost there..."),
]

if __name__ == "__main__":
    make_wordmark()
    make_tagline()
    for name, text in STAGES:
        make_status_stage(name, text)
