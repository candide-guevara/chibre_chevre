import 'dart:async';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart' hide Card;

import '../game/game_controller.dart';
import '../game/hand_order.dart';
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

  // Melds being prepared during the first trick.
  var _selectingMeld = false;
  var _selection = CardSet.empty;
  var _melds = <Meld>[];
  var _stoeck = false;

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

  void _resetMelds() {
    _selectingMeld = false;
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
    if (_selectingMeld) {
      setState(
        () => _selection = _selection.contains(card)
            ? _selection.remove(card)
            : _selection.add(card),
      );
      return;
    }
    if (!table.isMyTurn || !player.legalCards.contains(card)) return;
    final stoeck =
        _stoeck &&
        completesStoeck(card, player.playedBy(player.seat), player.mode!);
    _controller.act(PlayCard(player.seat, card, melds: _melds, stoeck: stoeck));
    setState(() {
      _resetMelds();
      if (stoeck) _stoeck = false;
    });
  }

  void _validateMeld() {
    final meld = Meld.fromCards(_selection);
    final String? error;
    if (meld == null) {
      error = 'Ces cartes ne forment pas une annonce.';
    } else if (validateMelds([..._melds, meld], _table!.player!.hand) != null) {
      error = 'Ces cartes sont déjà annoncées.';
    } else {
      error = null;
    }
    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() {
      _melds = [..._melds, meld!];
      _selectingMeld = false;
      _selection = CardSet.empty;
    });
  }

  bool _canAnnounceStoeck(PlayerView player) =>
      player.stoeckSeat == null &&
      player.legalCards.cards.any(
        (card) =>
            completesStoeck(card, player.playedBy(player.seat), player.mode!),
      );

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
    if (_selectingMeld) return player.hand;
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
          // Melds can be prepared before the player's turn; they are sent
          // with the player's first card.
          if (player.mayAnnounceMelds) ...[
            const SizedBox(height: 8),
            MeldControls(
              selecting: _selectingMeld,
              announced: _melds,
              onStart: () => setState(() => _selectingMeld = true),
              onValidate: _validateMeld,
              onCancel: () => setState(() {
                _selectingMeld = false;
                _selection = CardSet.empty;
              }),
            ),
          ],
          if (table.isMyTurn && _canAnnounceStoeck(player))
            FilterChip(
              label: const Text('Stöck'),
              selected: _stoeck,
              onSelected: (value) => setState(() => _stoeck = value),
            ),
        ],
      );
    } else if (table.seatToAct != null) {
      content = _statusText(table);
    } else {
      content = const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: content,
    );
  }

  Widget _statusText(TableView table) {
    final text = Theme.of(context).textTheme;
    if (_selectingMeld) {
      return Text(
        'Sélectionnez les cartes de l\'annonce',
        style: text.titleMedium,
      );
    }
    if (table.isMyTurn) return Text('À vous de jouer', style: text.titleMedium);
    final reading = table.meldRecapFor.where((seat) => seat != table.seat);
    if (reading.isNotEmpty) {
      return Text(
        '${table.nicknames[reading.first]} lit les annonces…',
        style: text.titleMedium?.copyWith(
          color: ChibreColors.ivory.withValues(alpha: 0.7),
        ),
      );
    }
    if (table.seatToAct == null) return const SizedBox.shrink();
    final name = table.nicknames[table.seatToAct!];
    return Text(
      table.phase == TablePhase.choosingTrump
          ? '$name choisit l\'atout…'
          : '$name joue…',
      style: text.titleMedium?.copyWith(
        color: ChibreColors.ivory.withValues(alpha: 0.7),
      ),
    );
  }
}
