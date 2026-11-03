# chibre_core

Pure Dart (no Flutter) game engine, computer players and game analysis for
the Chibre app. See `SPECIFICATION.md` at the repository root.

- `lib/src/engine/`: cards, rules, melds, rounds and games.
- `lib/src/ai/`: random, heuristic and expert computer players.
- `lib/src/insights/`: finds the biggest blunders of a finished game.
- `lib/src/simulation/`: plays games between computer players.

## Commands

```bash
dart pub get
dart test
dart analyze

# Compare two computer players on the same deals (duplicate format)
dart run bin/simulate.dart --a expert --b heuristic --deals 40
dart run bin/simulate.dart --help
```
