# Project specs

The goal of this project is to create a phone app to play the [chibre][0] card game.

## Requirements

* 2 human players, each with their own phone, play as partners against a team of 2 computer players.
  * Seating (counter-clockwise play order): Human A (host), Bot 1, Human B (joiner), Bot 2. Humans sit opposite each other.
* the app shall not collect any personal data, nor have any form of account.
  * A random installation id (generated locally, never tied to a person) may be used to recognise a reconnecting player.
* All computation happens on the phones. **There is no backend in the first version**: games are played over the local network (same Wi-Fi).
  * The networking code must be abstracted behind an interface (see [Architecture](#architecture)) so that an AWS-backed implementation can be added later without touching the game engine, the AI or the UI.
  * When the AWS backend is added, its design should minimize data transfer volume and QPS to minimize costs.
* the whole system must be runnable locally on my machine for demo purposes and quick feedback (see [Local development](#local-development)).
  * later on we will see how to create the needed google app dev (and aws) accounts.
* the computer players should be expert level to challenge the humans.
* Platform: **Android only**. The app must run smoothly on ~5 year old devices (minSdk 26 / Android 8, ~2 GB RAM, mid-range CPU).
* UI language: **French** only.

## Out of scope

* Only 2 human player mode is supported.
* iOS.
* Internet play (first version; LAN only).
* The app will never be monetized, this is just to have fun with my friends.
* Users of the app can be trusted not to cheat.

## Tech stack

* The application should use the flutter framework.
* Only use dependencies from trusted sources (ex dart.dev, flutter.dev, google publishers on pub.dev), prefer re-implementation to depending on a module from a random dude on the internet.
  * Expected dependencies: `protobuf` and `fixnum` (dart.dev), `shared_preferences` / `path_provider` (flutter.dev) for local storage, `flutter_svg` only if vector rendering via `CustomPainter` is impractical (it is published by flutter.dev).
* Client/client (and later client/backend) messages are protocol buffers encoded in binary.
  * LAN: length-prefixed protobuf frames over a TCP socket.
  * LAN discovery: the host broadcasts a `GameAdvert` protobuf as a UDP datagram every second (to `255.255.255.255` and to localhost, port 47820). This is re-implemented with `dart:io` instead of mDNS because the first-party `multicast_dns` package can only query, not advertise. On Android, the app may need a `WifiManager.MulticastLock` to receive broadcasts.
  * The `.proto` files live in a top-level `proto/` directory and are the single source of truth for the wire format.
* Future backend (not part of the first version): AWS lambda running golang code and dynamoDb for persistent state, protobuf binary over HTTP.
  * lambda must use few dependencies to optimize cold starts, bloated frameworks are forbidden.

## Architecture

Layers, from bottom to top. Lower layers must not depend on upper layers.

1. **Game engine** (pure Dart, no Flutter imports): cards, deck, dealing, trump modes, legal move computation, trick resolution, melds detection/validation/comparison, scoring, game state machine. Deterministic given a seed. Fully unit-tested.
2. **AI** (pure Dart): expert bot and blunder analysis (see [Computer players](#computer-players)). Depends only on the engine.
3. **Transport** (abstract interface `GameTransport` + discovery interface `GameDiscovery`):
   * Responsibilities: advertise a hosted game, list open/paused games, connect/reconnect, send/receive protobuf messages, report connection state changes.
   * First implementation: `LanTransport` (UDP broadcast discovery + TCP). An `InMemoryTransport` is used by the tests.
   * Later: `AwsTransport` / `AwsDiscovery`. No other code may know which implementation is in use (injected at startup).
4. **Session**: the host phone is authoritative. It runs the engine and both bots, validates every action from the joiner, and sends each player only the information they are allowed to see (own hand, played cards, announced melds, scores). The joiner is a thin client that renders state and sends actions.
5. **UI** (Flutter screens below).

Packages:

* `packages/chibre_core` (pure Dart): engine, AI, insights, bot-vs-bot simulator.
* `packages/chibre_net` (pure Dart): protobuf wire format, transports, host and client sessions.
* `app/` (Flutter): screens and widgets only.

### Code organisation

* Prefer small, clean abstractions so the code is human readable and easily modifiable in later iterations.
* Each abstraction lives in its own dedicated file, e.g. `blunder_calculator.dart`, `computer_player.dart`, `meld_validator.dart`, `lan_transport.dart`.
* Each reusable widget lives in its own dedicated file, e.g. `card_widget.dart`, `open_game_list.dart`, `score_board.dart`, `trump_choice_panel.dart`.
* Screens are composed from these widgets rather than being large monolithic build methods.

## Local development

* The app must also build and run as a **Linux desktop** app so two instances can be launched on the developer machine and play against each other over localhost. The desktop window opens with a phone form factor (412×906 logical pixels, like a OnePlus 13R).
* Two Android emulators on the same machine must also work. Because broadcasts don't cross the emulators' virtual networks, debug builds offer a manual "host:port" entry on the join screen.
* For testing the screens, the desktop app accepts `--test-fix-deal=<hand>` (`sequence`, `stock` or `good-hand`): in every round of a hosted game the host is dealt a preset set of cards (a four-card sequence, King + Queen of spades, or 7 9 J A of diamonds, each with 7♦ so the host chooses trump first), the rest of the deal being random. With `sequence` the whole deal is fixed instead: every player has a sequence and the host's is the highest, with no other meld possible.
* A command-line bot-vs-bot simulator (pure Dart, `dart run`) is provided to test the engine and measure AI strength.
* `README.md` documents how to run all of the above.

## Game rules

Follow the standard Chibre rules from [swisslos.ch][0], with these specifics:

* 36 Swiss-French cards (♦ ♥ ♠ ♣, 6 to Ace), 9 cards per player, play is counter-clockwise.
* **Trump modes**: chosen by the host (see [Host game screen](#host-game-screen)):
  * "4 couleurs" (default): only the four suits can be trump.
  * "4 couleurs + Obenabe + Undenufe".
* **Choosing trump**: in the first round, the holder of 7♦ chooses trump. In each subsequent round, the role moves to the next player counter-clockwise. The chooser may **chibrer**: pass the choice to their partner, who must then choose.
* **Card points**: standard (157 per round including 5 for the last trick; 257 for a match, i.e. one team takes all 9 tricks).
* **Multipliers**: host option, default off. When on: ♦ ♥ ×1, ♠ ♣ ×2, Obenabe / Undenufe ×3. Applied to trick points and melds.
* **Melds (annonces)**:
  * Sequences of the same suit: 3 cards 20, 4 cards 50, 5 cards 100, 6 cards 150, 7 cards 200, 8 cards 250, 9 cards 300.
  * Four of a kind: Jacks 200, Nines 150, Aces/Kings/Queens/Tens 100.
  * Melds are announced by each player during the first trick, before playing their first card. Only the team holding the single best meld scores melds (all of that team's melds count). Comparison follows the standard rules (higher value, then longer sequence, then higher card, then trump, then earlier announcer).
  * Stöck (King + Queen of trump, 20 points): always counted regardless of the meld comparison. The player announces it when playing the second of the two cards (an "Stöck" button appears at that moment).
  * Not announcing a meld or Stöck means it does not count (and is a potential blunder in the insights).
* **End of game**: the first team to reach the target score (default 1000) wins. Points are counted in the order Stöck, melds, tricks, so the game may end mid-round.

## Computer players

* Expert level. Suggested approach: determinized Monte-Carlo tree search (ISMCTS / perfect-information sampling) over the engine, plus heuristics for trump choice, chibrer and meld decisions. Bots must reason only from information their seat can see (no peeking at other hands).
* Bots run on the host phone, in a background isolate so the UI never freezes.
* **Adaptive compute budget**: on first launch (and when the app version changes) the app runs a short benchmark to measure the phone's simulation speed and stores the result locally. The search budget (number of iterations / time per decision) is derived from it to get the strongest play while keeping the game snappy: target ≤ ~1.5 s per bot decision, including a minimum delay of ~0.5 s so humans can follow what happened.
* Bots announce melds and Stöck correctly.

## Start screen

It consists of 3 buttons

* Rejoindre une partie (Join game)
* Créer une partie (Host game)
* Profil (Player details)

Until the player details are input, the join and host buttons must be greyed out.

## Player details screen

Just a text input field for their nickname.
The players details will be stored locally on the phone, never sent to any server.
It is however allowed to communicate those details to the other player when joining a game.

## Join game screen

Displays the list of games found on the local network, refreshed live.

* New games show the game name and the host nickname.
* Paused games (waiting for a player to reconnect) are visually distinct (e.g. a "En pause" badge and different style) and are only joinable by the player who left them (matched by installation id). They show the current score.
* Tapping on a game opens the play game screen.
* Debug builds only: manual "host:port" entry.

## Host game screen

Allows to configure different options:

* game name (prefilled with "<nickname>'s game", in French "Partie de <nickname>")
* number of points (default 1000)
* trump modes: "4 couleurs" (default) or "4 couleurs + Obenabe + Undenufe"
* multipliers: off (default) / on
* pause before collecting a trick: a slider from 0.5 s to 5 s (default 1.5 s, steps of 0.5 s). It sets how long a complete trick stays on the table before sliding to its winner, so beginners have time to memorize the cards played. The host shares it with the joiner so both phones animate in step, and keeps it when resuming a saved game.

A bar of three buttons at the bottom of the screen:

* "Par défaut" puts every option back to its default value.
* "Avancé" opens the advanced settings screen (empty for now; advanced options will go there).
* "Lancer la partie" (start game), a filled button brighter than the two others so the eye goes to it first, opens the waiting for player screen and starts advertising the game on the network.

## Waiting for player screen

Mentions that it is waiting for a player, has a cancel button to go back to start screen (and stop advertising).
As soon as a player joins, both phones open the play game screen. The host picks the animal card set at random and shares it with the joiner.

## Play game screen

* The player's cards are shown at the bottom, sorted by suit and rank (trump first once chosen).
* The partner is at the top, bots on the left and right, each with their nickname ("Ordi 1", "Ordi 2" for bots). The current trick is in the center.
* Always visible: both team scores ("Nous" and "Ordi", for the bots' team), target score, current trump mode, whose turn it is. The trump is shown prominently: an "Atout :" label followed by the suit drawn large on an ivory badge (⬇ / ⬆ for Obenabe / Undenufe), plus the multiplier when it applies. The same "Nous" / "Ordi" labels are used in the round summary and the end game screen.
* **Trump choice**: when it is the player's turn to choose, a panel shows the allowed trump modes plus "Chibrer" (if allowed).
* **Playing a card**: a single tap on a card plays it. Illegal cards are greyed out and cannot be tapped. Cards cannot be played when it's not the player's turn.
* **Melds**: once trump is chosen and until they play their first card, each player starts in meld selection, even when it is not their turn: both humans choose their melds at the same time. Taps select/deselect cards. A single button below reads "Ne pas annoncer, jouer" while no card is selected, and "Valider l'annonce" as soon as one is. Validating checks that the selected cards form one or more valid melds (e.g. a sequence and four of a kind selected together) and shows an error otherwise. Once the player validates a meld or chooses not to announce, there is no going back: card taps play cards again, and the validated melds stay visible as chips until they are sent, and shown to the others, with the player's first card, as the rules require.
* The computer players do not play a card until both humans have validated their melds or chosen not to announce (or played their first card): each choice is sent to the host right away. Meanwhile, a human who is done sees "<nickname> choisit son annonce…".
* **Playing a card**, by anyone: the card slides from the player's side of the table to its place in the trick.
* **Collecting a trick**: once a trick is complete it stays on the table for the host's chosen pause, then its cards slide towards the seat of the player who won it and fade out. The host waits for the pause and the slide before a bot leads the next trick.
* **Stöck**: when the player can play the second card of King+Queen of trump, a "Stöck" button appears right above that card in the hand. Tapping it plays the card and announces Stöck; tapping the card itself plays it without announcing. The hand always keeps room for the button so nothing moves when it appears.
* Once the first trick has been collected, a pop-up in the style of the round summary shows every player's meld calls with their cards, and the points the winning team scores. Each human closes it with a tap ("Touchez pour continuer"); it closes by itself after 10 s. Nobody plays from the end of the first trick until both humans have closed it or it timed out; meanwhile a player who closed it sees "<nickname> lit les annonces…". The host drives it (it tells each phone who still has it open; closing it sends a message to the host). Melds and Stöck are not recalled elsewhere on the table: as in real games, players must memorize them.
* Likewise, once the trick in which a player announced Stöck has been collected, the same pop-up says who announced it and the points it brings, with the same 10 s timeout and tap to close, and the game waits for it the same way. Stöck announced during the first trick is shown in the same pop-up as the melds. Stöck announced in the last trick of a round is not recapped: the round summary follows.
* **Button bar** at the bottom of the screen (fixed height, always present):
  * "Jouer pour moi": plays the move the expert computer player would make in the player's place (trump choice, or card with melds and Stöck), computed from the player's own view only, with the same budget as the bots; on the joiner's phone it runs locally in a background isolate. Melds the player already validated, or chose not to announce, are kept. Enabled only on the player's turn; shows a spinner while computing.
  * "Cartes jouées": opens a screen, updated live, listing the melds and Stöck announced this round (meld cards once shown, only values before) and every trick of the round in play order with who played each card, the winner's card highlighted.
* At the end of each round, a short summary (points per team for the round) is shown before the next deal.
* **Disconnection**: if a player loses the connection or backgrounds the app, the game pauses for everyone with a "En attente de <nickname>…" overlay. The host keeps the game advertised as paused; the player can rejoin from the join screen and the game resumes where it stopped. The host can abandon the paused game at any time (back to start screen). The host persists the game state locally so a crash/restart of the host app can also resume.

## End game screen

* Shows both teams scores and the winner.
* A button to go to the insights screen
* A button to rematch
* A button to go to the start screen

Rematch keeps the same seats and options; the joiner must accept.

## Insights screen

During the course of the game all the moves, trump choices, melds and starting hands are recorded.
After the game, the expert AI analyses each human decision (trump choice / chibrer, melds and Stöck announced or missed, card plays) by comparing the expected points of the chosen action against the best alternative, given the information available to that player at the time.
It surfaces the 3 biggest blunders (largest expected point loss) for each human player, showing the situation (hand, trick, trump), what was played, what was better and the estimated cost in points.
For example failing to call a meld.

The analysis runs on the host in a background isolate (a progress indicator is shown) and the result is sent to the joiner.

At the end of the screen:

* A button to rematch
* A button to rematch with the exact same card distributions as before (same deals in the same order, same first trump chooser)
* A button to go to the start screen

## Graphic design

* Overall sober, no tacky decorations on buttons.
* Use a color palette derived from billiard green.
* Use Swiss-French cards (diamonds, hearts, spades, clubs)
* For the cards design we will be original and design our own:
  * Use rubber hose cartoon style
  * Instead of humans use monkeys, cows and zebras for face cards (do not mix them but generate different card sets per animal and select one set at random at the start of each game).
  * The art is drawn by the implementing agents as vector graphics in code (SVG or Flutter `CustomPainter`), no external image assets. Share as much as possible between sets (card frame, suit symbols, pip layouts); only the face cards (Jack, Queen, King, and optionally Ace) differ per animal.
  * Cards must remain readable on small screens (rank and suit index in the corners).

## Testing

* Engine: unit tests for legal moves, trick winner, every meld type and comparison rule, scoring, multipliers, match bonus, end-of-game mid-round.
* AI: bot-vs-bot simulations; the expert bot must beat a random-legal-move bot and a simple heuristic bot by a wide margin over many games.
* Transport: tests with an in-memory `GameTransport` implementation, including disconnect/reconnect.

[0]: https://www.swisslos.ch/fr/jass/informations/les-regles-du-jass/bases-du-jass.html
