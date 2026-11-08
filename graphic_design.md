# Graphic design

The look and feel of the app and of its cards. [SPECIFICATION.md](SPECIFICATION.md) describes what the screens do; this document describes how they look.

## Principles

* Overall sober, no tacky decorations on buttons.
* A dark, calm table so the cards are the only colourful thing on screen.
* The app's own visuals are drawn in code (Flutter `CustomPainter`), with no image or font assets: even the back arrow and the suit symbols are vector paths. Only the cards are images.
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

### Common to every deck

* 36 Swiss-French cards: ♦ ♥ ♠ ♣, 6 to Ace.
* Our own original design, in the 1930s rubber hose cartoon style: animals instead of humans on the face cards, one per suit:
  * cows for hearts, dogs for spades, monkeys for diamonds, zebras for clubs.
* Corner indices: the rank above the suit, in the top-left corner and again rotated 180° in the bottom-right. The face cards use the English letters K, Q and J, the ace A. The index must stay readable at the smallest card size.

### Decks

A deck is a `CardDesign` (`app/lib/card_art/card_design.dart`): images shipped in the app, listed in `cardDesigns` (`card_designs.dart`), the first one being the default. Each player picks theirs on the player details screen; it is a preference of the phone, not of the game, so partners can play with different decks.

To add a deck:

* One image per card in `app/assets/cards/<design id>/`, named `<suit><rank>.webp`: suit `H`, `S`, `D` or `C`, rank `6` to `10`, `J`, `Q`, `K` or `A` (e.g. `S10.webp`, `DQ.webp`). All 36 cards, no back.
* Portrait **2:3**, ideally 300×450, lossless WebP, with transparent rounded corners matching the design's `cornerRadius`.
* Declare the folder in `app/pubspec.yaml` and add a `CardDesign` to `cardDesigns`.

`app/tool/slice_card_sheet.py` cuts a generated sheet of cards (one row per suit, A to 6) into such files.

At startup, in the background, `CardImageLoader` decodes each card of the chosen deck at the size of the largest card on this screen (hand cards × pixel ratio), so that animations stay smooth on older phones. Other decks are loaded when the player details screen shows them. Until a card's image is ready, it is drawn as a blank card.

### Vintage

Generated from the prompt below, then retouched by hand: warm ivory cards with thin gold borders and corner flourishes, large central numerals on the number cards, and head-and-shoulders portraits of the animals on the face cards (crowned kings in ermine, queens in feathered hats, jacks in hats and bow ties).

#### Prompt for image generator

Create a 36-card Swiss Jass deck in a vintage Art Deco style, with a consistent visual identity across all four suits. The cards should have warm ivory backgrounds, elegant gold-and-black geometric borders, decorative Art Deco corner details, and a restrained palette of deep red, black, cream and gold. Each card should have clearly readable rank and suit markings in its upper-left and lower-right corners.

Each suit has its own animal: hearts are cows, spades are dogs, diamonds are monkeys, and clubs are zebras. The deck contains A, 10, K, Q, J, 9, 8, 7 and 6 in each suit. Draw 4 rows of 9 cards each, 1 row for each suit.

Numbered cards (10–6) should use a large central numeral instead of multiple suit symbols. The suit symbol should remain visible in the corners.

The King, Queen and Jack cards should feature individual animal portraits in a playful 1930s rubber-hose cartoon style, with expressive faces, exaggerated features and elegant costumes. The artistic direction should combine the charm of classic Disney rubber-hose characters, such as Clarabelle Cow, with the theatrical personality and stylization of Peacock from Skullgirls. Each portrait must be upright and feature only one character, never a mirrored or upside-down second portrait.

Portrait composition is particularly important: show only the animal's head and neck, cropping cleanly at the lower neck. Do not include half-body or bust-length illustrations, and do not let shoulders or torsos occupy the card. Accessories must nevertheless remain visible, including bow ties, necklaces, earrings and collars. Kings should wear crowns, Jacks should have distinctive hats, and every Queen must wear a hat decorated with feathers, maintaining consistency across all four suits.

Finally, all 36 cards should share consistent proportions, typography, border thickness, illustration scale and spacing. The result should look like a coherent, professionally designed vintage playing-card deck rather than a collection of unrelated illustrations.

