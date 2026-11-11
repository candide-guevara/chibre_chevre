# Chibre Chèvre

A phone app to play [Chibre](https://www.swisslos.ch/fr/jass/informations/les-regles-du-jass/bases-du-jass.html)
with a friend against two expert computer players, over the local network, or alone
with a computer partner.
See [SPECIFICATION.md](SPECIFICATION.md).

| Directory | What |
|---|---|
| `packages/chibre_core` | Pure Dart: rules engine, computer players, insights, simulator |
| `packages/chibre_net` | Pure Dart: protobuf protocol, LAN transport, host/joiner sessions |
| `proto/` | The wire format (`chibre.proto`) |
| `app/` | The Flutter app (Android, plus Linux desktop for local demos) |

Commands below assume `flutter` and `dart` are on the `PATH`
(e.g. `export PATH="$HOME/develop/flutter/bin:$PATH"`).

## Tests

```bash
(cd packages/chibre_core && dart test)
(cd packages/chibre_net && dart test)
(cd app && flutter test)
```

## Local demo on one computer

Two instances of the Linux app act as two phones. `CHIBRE_PROFILE` keeps
their nicknames and saved games apart:

```bash
cd app
flutter run -d linux                                  # first player
flutter run -d linux --dart-define=CHIBRE_PROFILE=bea # second player
```

Set a nickname in "Profil" on both, "Créer une partie" on one and
"Rejoindre une partie" on the other.

To test the screens without waiting for the right cards, start the host with
`--test-fix-deal=<hand>`: every round gets the same deal, every player's cards
fixed, and the host holds 7♦ so it chooses trump first. The computer players
use a fixed seed, so they replay the same moves.

| `<hand>` | Host's cards |
|---|---|
| `sequence` | ♥ 7 8 9 10: a 50 sequence. Every other player has a 20 sequence, so the host's wins |
| `stock` | ♠ K Q: Stöck when ♠ is trump. Nobody has a meld or another Stöck |
| `good-hand` | ♦ 7 9 J A. Nobody has a meld or Stöck |

```bash
flutter run -d linux --dart-entrypoint-args=--test-fix-deal=stock
build/linux/x64/debug/bundle/chibre --test-fix-deal=stock  # already built
flutter run --dart-define=TEST_FIX_DEAL=stock              # on a phone
```

`flutter run` passes no command line arguments to Android apps, hence the
`--dart-define` there; it is read when building, so changing it needs a new
`flutter run`, not a hot restart.

## Android

```bash
cd app
flutter run                  # on a connected phone or emulator
flutter build apk --release  # build/app/outputs/flutter-apk/app-release.apk
```

Both phones must be on the same Wi-Fi. Emulators don't receive the other
instance's broadcasts: in debug builds, type the address shown on the host's
waiting screen into "Adresse (hôte:port)" on the join screen.

## Measuring frame times

```bash
cd app
tool/frame_bench.sh [device id] [rounds] [runs]   # e.g. tool/frame_bench.sh 1f42897a 2 3
```

Plays a single player game (`good-hand` deal, fixed bot seed) through the
play screen in profile mode, tapping like a player, and saves the build and
raster time of every frame to `build/frame_bench/<commit>-<date>-run<n>.json`,
then prints the median of each statistic over the runs (3 by default). It
uses its own profile and saved game (`CHIBRE_PROFILE=bench`), so the
phone's own game is untouched. Compare runs on the same device only.

## Comparing computer players

```bash
cd packages/chibre_core
dart run bin/simulate.dart --a expert --b heuristic --deals 40
```

## Measuring the AI's speed and strength

```bash
cd packages/chibre_core
# Times a fixed amount of AI work; the fingerprints must not change when
# a change is only meant to make the AI faster.
dart compile exe bin/speed_bench.dart -o /tmp/speed_bench && /tmp/speed_bench
# Expert teams with different thinking budgets (seconds on a phone) play
# whole games against each other.
dart compile exe bin/budget_match.dart -o /tmp/budget_match && /tmp/budget_match --pairs 50
# How well cheap predictors guess the expert's card: record games once,
# then evaluate predictors on them as often as needed.
dart compile exe bin/predict_bench.dart -o /tmp/predict_bench
/tmp/predict_bench record /tmp/games.txt --games 28
/tmp/predict_bench evaluate /tmp/games.txt

# How long the insights take per round and per game, a 0.1 s team
# against a 0.6 s one; also how much weaker the 0.1 s team is.
dart compile exe bin/insights_bench.dart -o /tmp/insights_bench
/tmp/insights_bench --pairs 12

# Two playing algorithms of bin/variants.dart on the same deals with the
# teams swapped: points per round and time per decision, or game win rate.
dart compile exe bin/algo_match.dart -o /tmp/algo_match
/tmp/algo_match expert8700v2 expert8700v1 --pairs 300
/tmp/algo_match expert8700v2 expert8700v1 --games 60
```

Compile them (phones run compiled code too): `dart run` is slower and
less representative.
