import 'dart:async';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart' hide Card;

import '../game/game_controller.dart';
import '../game/hand_order.dart';
import '../game/meld_selection.dart';
import '../labels.dart';
import '../theme/chibre_theme.dart';
import '../widgets/hand_view.dart';
import '../widgets/meld_controls.dart';
import '../widgets/meld_summary.dart';
import '../widgets/pause_overlay.dart';
import '../widgets/playing_card.dart';
import '../widgets/round_summary.dart';
import '../widgets/score_board.dart';
import '../widgets/seat_badge.dart';
import '../widgets/trick_view.dart';
import '../widgets/trump_choice_panel.dart';
import 'end_screen.dart';

/// The table: the player's hand at the bottom, partner on top, computer
/// players on the sides. Shows the end screen once the game is over.
class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key, required this.controller});

  final GameController controller;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late final StreamSubscription<TableView> _subscription;
  late final AppLifecycleListener _lifecycle;
  TableView? _table;

  // Melds chosen at the start of the round, sent with the first card.
  var _meldsDecided = false;
  var _selection = CardSet.empty;
  var _melds = <Meld>[];

  /// Fits the trump choice: a title and two rows of buttons.
  static const _actionAreaHeight = 136.0;

  GameController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _table = _controller.table;
    _subscription = _controller.tables.listen(_onTable);
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        if (state == AppLifecycleState.resumed) _controller.setAway(false);
        if (state == AppLifecycleState.paused ||
            state == AppLifecycleState.hidden) {
          _controller.setAway(true);
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  void _onTable(TableView table) {
    if (!mounted) return;
    final previous = _table;
    setState(() {
      _table = table;
      if (!(table.player?.mayAnnounceMelds ?? false)) _resetMelds();
    });
    if (table.leftBy != null && previous?.leftBy == null) {
      _showLeft(table.leftBy!);
    }
  }

  /// From the trump choice until the player validates a meld or chooses to
  /// play without one: card taps select the cards of the meld.
  bool get _choosingMelds {
    final player = _table?.player;
    return player != null &&
        player.mayAnnounceMelds &&
        player.hand.length == handSize &&
        !_meldsDecided;
  }

  void _resetMelds() {
    _meldsDecided = false;
    _selection = CardSet.empty;
    _melds = [];
  }

  Future<void> _showLeft(String nickname) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Partie terminée'),
        content: Text('$nickname a quitté la partie.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _leave() async {
    await _controller.leave();
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter la partie ?'),
        content: const Text('La partie sera terminée pour les deux joueurs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    if (leave == true) await _leave();
  }

  // ------------------------------------------------------------- Actions

  void _onCardTap(Card card) {
    final table = _table!;
    final player = table.player!;
    if (_choosingMelds) {
      setState(
        () => _selection = _selection.contains(card)
            ? _selection.remove(card)
            : _selection.add(card),
      );
      return;
    }
    if (!table.isMyTurn || !player.legalCards.contains(card)) return;
    _play(card);
  }

  void _play(Card card, {bool stoeck = false}) {
    final player = _table!.player!;
    _controller.act(PlayCard(player.seat, card, melds: _melds, stoeck: stoeck));
    setState(_resetMelds);
  }

  void _skipMelds() {
    _controller.meldsChosen();
    setState(() => _meldsDecided = true);
  }

  /// Announces the selected cards; there is no going back once valid.
  void _validateMelds() {
    final melds = meldsFromSelection(_selection);
    if (melds == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Ces cartes ne forment pas une annonce.'),
          ),
        );
      return;
    }
    _controller.meldsChosen();
    setState(() {
      _melds = melds;
      _meldsDecided = true;
      _selection = CardSet.empty;
    });
  }

  /// The card that completes Stöck if the player can play it now: tapping
  /// the Stöck button above it plays it and announces Stöck.
  Card? _stoeckCard(TableView table) {
    final player = table.player!;
    if (!table.isMyTurn ||
        table.phase != TablePhase.playing ||
        _choosingMelds ||
        player.stoeckSeat != null) {
      return null;
    }
    final played = player.playedBy(player.seat);
    for (final card in player.legalCards.cards) {
      if (completesStoeck(card, played, player.mode!)) return card;
    }
    return null;
  }

  // ------------------------------------------------------------- Layout

  @override
  Widget build(BuildContext context) {
    final table = _table;
    if (table == null || table.player == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (table.phase == TablePhase.gameOver) {
      return EndScreen(controller: _controller, table: table, onHome: _leave);
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  ScoreBoard(
                    scores: table.scores,
                    team: teamOf(table.seat),
                    target: table.options.targetScore,
                    mode: table.player!.mode,
                    multiplier: table.player!.mode == null
                        ? 1
                        : table.options.multiplierFor(table.player!.mode!),
                  ),
                  Expanded(child: _tableArea(table)),
                  _actionArea(table),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: HandView(
                      cards: sortHand(table.player!.hand, table.player!.mode),
                      style: table.cardStyle,
                      enabled: _enabledCards(table),
                      selected: _selection,
                      onTap: _onCardTap,
                      badge: switch (_stoeckCard(table)) {
                        final card? => (
                          card: card,
                          child: ActionChip(
                            label: const Text('Stöck'),
                            onPressed: () => _play(card, stoeck: true),
                          ),
                        ),
                        null => null,
                      },
                    ),
                  ),
                ],
              ),
              if (table.isPaused)
                Positioned.fill(
                  child: PauseOverlay(
                    nickname: table.pausedFor!,
                    onAbandon: _leave,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  CardSet _enabledCards(TableView table) {
    final player = table.player!;
    if (_choosingMelds) return player.hand;
    if (table.isMyTurn && table.phase == TablePhase.playing) {
      return player.legalCards;
    }
    // Not the player's turn: show the hand undimmed but ignore taps.
    return table.isMyTurn ? CardSet.empty : player.hand;
  }

  Widget _tableArea(TableView table) {
    final player = table.player!;
    Widget seat(int seat) => SeatBadge(
      nickname: table.nicknames[seat],
      isTurn: table.seatToAct == seat,
      isTrumpChooser: player.trumpChooser == seat && player.mode != null,
      announcement: _announcement(player, seat),
    );

    final shownTrick = switch (player.currentTrick) {
      final trick? when trick.cards.isNotEmpty => trick,
      _ => player.completedTricks.isEmpty ? null : player.completedTricks.last,
    };
    final right = (table.seat + 1) % seatCount;
    final top = (table.seat + 2) % seatCount;
    final left = (table.seat + 3) % seatCount;
    return LayoutBuilder(
      builder: (context, box) {
        final cardWidth = (box.maxHeight / 5.2).clamp(36.0, 72.0);
        final sideNamesBottom =
            box.maxHeight / 2 + cardWidth * cardAspectRatio / 2 + 16;
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: seat(top),
              ),
            ),
            // Above the trick's side cards, to leave the row to the cards.
            Positioned(left: 8, bottom: sideNamesBottom, child: seat(left)),
            Positioned(right: 8, bottom: sideNamesBottom, child: seat(right)),
            Align(alignment: Alignment.bottomCenter, child: seat(table.seat)),
            if (shownTrick != null)
              Center(
                child: TrickView(
                  trick: shownTrick,
                  viewer: table.seat,
                  style: table.cardStyle,
                  cardWidth: cardWidth,
                  hold: table.trickHold,
                  winner: shownTrick.isComplete
                      ? shownTrick.winner(player.mode!)
                      : null,
                ),
              ),
            if (table.showsMeldRecap)
              Center(
                child: MeldSummary(
                  player: player,
                  nicknames: table.nicknames,
                  multiplier: table.options.multiplierFor(player.mode!),
                  onDismiss: _controller.dismissMelds,
                ),
              ),
            if (table.phase == TablePhase.roundOver)
              Center(
                child: RoundSummary(
                  roundPoints: table.roundPoints,
                  team: teamOf(table.seat),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Melds are not recalled under the names: players must remember them,
  /// as at a real table.
  String? _announcement(PlayerView player, int seat) =>
      player.stoeckSeat == seat ? 'Stöck' : null;

  Widget _actionArea(TableView table) {
    final player = table.player!;
    final text = Theme.of(context).textTheme;
    final Widget content;
    if (table.isMyTurn && table.phase == TablePhase.choosingTrump) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player.chibred
                ? 'Votre partenaire a chibré : choisissez l\'atout'
                : 'Choisissez l\'atout',
            style: text.titleMedium,
          ),
          const SizedBox(height: 8),
          TrumpChoicePanel(
            modes: table.options.allowedModes,
            canChibrer: !player.chibred,
            onChoose: (mode) => _controller.act(ChooseTrump(table.seat, mode)),
            onChibrer: () => _controller.act(Chibrer(table.seat)),
          ),
        ],
      );
    } else if (table.phase == TablePhase.playing) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _statusText(table),
          // Melds are chosen as soon as the trump is known, even before
          // the player's turn; they are sent with the player's first card.
          if (_choosingMelds) ...[
            const SizedBox(height: 8),
            MeldControls(
              hasSelection: _selection.isNotEmpty,
              onSkip: _skipMelds,
              onValidate: _validateMelds,
            ),
          ] else if (_melds.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final meld in _melds) Chip(label: Text(meldName(meld))),
              ],
            ),
          ],
        ],
      );
    } else if (table.seatToAct != null) {
      content = _statusText(table);
    } else {
      content = const SizedBox.shrink();
    }
    // A fixed height keeps the table, and the names on it, from moving when
    // the content changes; content that would not fit is scaled down.
    return Container(
      height: _actionAreaHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, box) => FittedBox(
          fit: BoxFit.scaleDown,
          // Full width, so that rows of buttons wrap rather than shrink.
          child: SizedBox(width: box.maxWidth, child: content),
        ),
      ),
    );
  }

  Widget _statusText(TableView table) {
    final style = Theme.of(context).textTheme.titleMedium;
    if (_choosingMelds) return Text('Choisissez votre annonce', style: style);
    if (table.isMyTurn) return Text('À vous de jouer', style: style);
    final waiting = _waitingFor(table);
    if (waiting == null) return const SizedBox.shrink();
    return Text(
      waiting,
      style: style?.copyWith(color: ChibreColors.ivory.withValues(alpha: 0.7)),
    );
  }

  /// What the game waits for when it is not this player's turn.
  String? _waitingFor(TableView table) {
    String name(int seat) => table.nicknames[seat];
    final reading = table.meldRecapFor.where((seat) => seat != table.seat);
    if (reading.isNotEmpty) return '${name(reading.first)} lit les annonces…';
    final choosing = table.meldChoiceFor.where((seat) => seat != table.seat);
    if (choosing.isNotEmpty) {
      return '${name(choosing.first)} choisit son annonce…';
    }
    final seat = table.seatToAct;
    if (seat == null) return null;
    return table.phase == TablePhase.choosingTrump
        ? '${name(seat)} choisit l\'atout…'
        : '${name(seat)} joue…';
  }
}
