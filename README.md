# Chibre

A phone app to play [Chibre](https://www.swisslos.ch/fr/jass/informations/les-regles-du-jass/bases-du-jass.html)
with a friend against two expert computer players, over the local network.
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
`--test-fix-deal=<hand>`: in every round the host gets these cards (the rest
of the deal is random), including 7♦ so it chooses trump first.

| `<hand>` | Host's cards |
|---|---|
| `sequence` | ♥ 7 8 9 10: a 50 sequence. The whole deal is fixed: every other player has a 20 sequence, so the host's wins |
| `stock` | ♠ K Q: Stöck when ♠ is trump |
| `good-hand` | ♦ 7 9 J A |

```bash
flutter run -d linux --dart-entrypoint-args=--test-fix-deal=stock
build/linux/x64/debug/bundle/chibre --test-fix-deal=stock  # already built
```

## Android

```bash
cd app
flutter run                  # on a connected phone or emulator
flutter build apk --release  # build/app/outputs/flutter-apk/app-release.apk
```

Both phones must be on the same Wi-Fi. Emulators don't receive the other
instance's broadcasts: in debug builds, type the address shown on the host's
waiting screen into "Adresse (hôte:port)" on the join screen.

## Comparing computer players

```bash
cd packages/chibre_core
dart run bin/simulate.dart --a expert --b heuristic --deals 40
```
