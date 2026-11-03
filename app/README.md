# chibre (app)

The Flutter app: screens, widgets and card art only; the game logic lives in
`../packages`. See the repository README for how to run it.

- `lib/screens/`: one file per screen of the specification.
- `lib/widgets/`: reusable widgets (card, hand, trick, open game list...).
- `lib/card_art/`: the cards, drawn in code (rubber hose monkeys, cows, zebras).
- `lib/game/`: `GameController`, the screens' view of a hosted or joined game.
- `lib/services/`: profile storage, AI speed benchmark, network setup.
