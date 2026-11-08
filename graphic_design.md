# Graphic design

The look and feel of the app and of its cards. [SPECIFICATION.md](SPECIFICATION.md) describes what the screens do; this document describes how they look.

## Principles

* Overall sober, no tacky decorations on buttons.
* A dark, calm table so the cards are the only colourful thing on screen.
* Everything is drawn in code (Flutter `CustomPainter`), no external image or font assets. Even the back arrow and the card lettering are vector paths.
* Readable on small, ~5 year old phones: large touch targets, high contrast, short animations.

## App palette

Derived from billiard table green (`app/lib/theme/chibre_theme.dart`, `ChibreColors`):

| Name        | Colour    | Use                                                      |
|-------------|-----------|----------------------------------------------------------|
| `felt`      | `#0B6B3A` | screen background, the table                             |
| `feltDark`  | `#07482A` | app bar, panels, pop-ups, score board, text fields       |
| `feltLight` | `#17844C` | subtle highlights on the felt                            |
| `ivory`     | `#FFFBF0` | text, outlines, primary buttons, trump badge             |
| `brass`     | `#D9B95B` | accents: whose turn it is, selection, points gained, multiplier, "En pause" badge |
| `red`       | `#C0272D` | red suits outside the cards                              |
| `ink`       | `#1E2623` | black suits and text on ivory                            |

The Material theme is dark, seeded from `felt`, with ivory as primary and brass as secondary.

## Components

* **Buttons**: at least 240×52, corners rounded 8, text 18. The main action of a screen is a filled ivory button with felt text, brighter than the outlined ivory buttons next to it, so the eye goes to it first. Action bars sit at the bottom of the screen.
* **Panels and pop-ups** (score board, round summary, announcements, pause overlay): `feltDark` cards on the felt; the pause overlay is `feltDark` at 80 % opacity over the table. Secondary text is ivory at 70 %, points gained are brass.
* **Seat badges**: rounded 12, `feltDark` with ivory text; the player whose turn it is turns brass with felt text.
* **Trump indicator**: "Atout :" followed by the suit drawn large on an ivory disc (⬇ / ⬆ for Obenabe / Undenufe), then the multiplier in brass.
* **Cards in the hand**: unplayable cards are darkened (40 % black); selected or suggested cards are raised by 15 % of their height and outlined in brass.
* **Motion**: kept short and functional. Selection 120 ms, turn badge 200 ms, a played card slides to the trick in 300 ms; a complete trick waits for the host's pause, then slides to its winner and fades out.

## Cards

### Common to every design

* 36 Swiss-French cards: ♦ ♥ ♠ ♣, 6 to Ace.
* Our own original design, in the 1930s rubber hose cartoon style: animals instead of humans on the face cards, one per suit:
  * cows for hearts, dogs for spades, monkeys for diamonds, zebras for clubs.
* Slender figures (noodle limbs, pinched waists, big four-fingered gloves and shoes) rather than chubby mascots.
  * Heads are drawn in side view so the snout reads clearly.
  * Queens have a bust to tell them apart from kings and jacks.
  * Kings hold a scepter on the right of the card. Jacks hold a halberd on the left, all at the same length and angle, the pennant pointing outwards.
  * Each animal stands in its home landscape: Alps for the cows, an old town for the dogs, jungle for the monkeys, savanna for the zebras.
* Corner indices: the rank above the suit, in the top-left corner and again rotated 180° in the bottom-right. The face cards use the English letters K, Q and J, the ace A. The index must stay readable at the smallest card size.
* Number cards use the classic pip layouts inside a central block narrow enough to leave room for the indices, even on the 10. Aces have a single large emblem and no "AS" label.

### Card designs are pluggable

A design is a subclass of `CardDesign` (`app/lib/card_art/card_design.dart`) drawn in a 400×600 box. It fills in the ground, frame, index, pips, ace and face cards; the card layout (corner index, pip positions) is shared. Designs are registered in `cardDesigns` (`card_designs.dart`), the first one being the default, and chosen with `CardDesignScope`. Each card is drawn once into a cached picture and replayed at any size.

Reusable building blocks:

* `toolkit/`: geometry, inking (outline heavier on the shadow side, cel shadow crescent, highlight), suit shapes, glyph lettering.
* `toon/`: the rubber hose figures (heads, hands, shoes, costumes, poses per rank and suit) and the landscapes, coloured by each design.

### Dark Deco (default)

An art deco night:

* **Ground**: midnight blue (`#121624` to `#1D2238`).
* **Frame**: a double stepped gold art deco frame (`#D9B45A`, light gold `#F3DC93`) with small gold fans in the middle of the long sides.
* **Index**: the Limelight typeface, baked into the code as glyph outlines, in crimson (`#D42C45`) for the red suits and ivory (`#F2E8D0`) for the black ones.
* **Pips**: gold-rimmed suit shapes, crimson or ivory (`#F2E8D0`).
* **Aces**: a winged gold medallion holding the suit, centred on the card.
* **Face cards**: the figure stands in a stepped arch window under a moonlit violet sky, in its landscape drawn in muted indigo with gold details. A soft gold glow rims the figure, and a vignette darkens the window edges.
* **Costumes**: hearts crimson, diamonds burnt orange, spades navy, clubs teal, all with gold trim and ivory accents.
