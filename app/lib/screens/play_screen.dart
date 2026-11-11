import 'dart:async';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart' hide Card;

import '../game/game_controller.dart';
import '../game/hand_order.dart';
import '../game/meld_selection.dart';
import '../labels.dart';
import '../theme/chibre_theme.dart';
import '../theme/flow_color.dart';
import '../theme/screen_theme.dart';
import '../widgets/announcement_summary.dart';
import '../widgets/game_actions_bar.dart';
import '../widgets/hand_columns.dart';
import '../widgets/hand_layout.dart';
import '../widgets/hand_view.dart';
import '../widgets/meld_controls.dart';
import '../widgets/meld_offer.dart';
import '../widgets/pause_overlay.dart';
import '../widgets/playing_card.dart';
import '../widgets/round_summary.dart';
import '../widgets/score_board.dart';
import '../widgets/seat_badge.dart';
import '../widgets/trick_view.dart';
import '../widgets/trump_choice_panel.dart';
import 'end_screen.dart';
import 'played_cards_screen.dart';

/// The table: the player's hand at the bottom, partner on top, computer
/// players on the sides. Shows the end screen once the game is over.
/// The height taken by the names at the top and bottom of the table.
const _nameRowHeight = 48.0;

/// Around the hand and the Stöck button lined up with its cards.
const _handPadding = EdgeInsets.fromLTRB(8, 0, 8, 4);

const _actionAreaPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
const _trumpChoicePadding = EdgeInsets.symmetric(horizontal: 24, vertical: 4);

/// How the space below the score bar is shared: 60% for the table, 40%
/// for the player's area.
const _tableFlex = 3, _playerFlex = 2;

/// The height of the game actions bar, as a share of the player's area.
const _actionsBarShare = 0.15;

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

  /// The computer player is choosing a move for this player.
  var _thinking = false;

  /// The move it suggested, until the table changes.
  GameAction? _suggestion;

  /// The suggestion for the current move, computed as soon as it is the
  /// player's turn so that "Jouer pour moi" answers without waiting.
  Future<GameAction>? _upcomingSuggestion;

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
    _skipMeldsIfNone();
    _prepareSuggestion();
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
      if (!_sameMove(previous, table)) {
        _suggestion = null;
        _upcomingSuggestion = null;
      }
      if (!(table.player?.mayAnnounceMelds ?? false)) _resetMelds();
    });
    _skipMeldsIfNone();
    _prepareSuggestion();
    if (table.leftBy != null && previous?.leftBy == null) {
      _showLeft(table.leftBy!);
    }
  }

  /// From the trump choice until the player decides on the melds.
  bool get _decidingMelds {
    final player = _table?.player;
    return player != null &&
        player.mayAnnounceMelds &&
        player.hand.length == handSize &&
        !_meldsDecided;
  }

  /// Card taps select the cards of the meld, until the player validates it
  /// or chooses to play without one.
  bool get _choosingMelds => _decidingMelds && !_table!.autoAnnounce;

  /// With automatic announcements, the melds the player is asked to
  /// announce or keep secret.
  List<Meld> get _offeredMelds => _decidingMelds && _table!.autoAnnounce
      ? findBestMelds(_table!.player!.hand)
      : const [];

  /// With automatic announcements, a player without melds has nothing to
  /// decide.
  void _skipMeldsIfNone() {
    final table = _table;
    if (table == null || !table.autoAnnounce || !_decidingMelds) return;
    if (_offeredMelds.isEmpty) _skipMelds();
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
    if (_offeredMelds.isNotEmpty) return;
    if (_choosingMelds) {
      setState(
        () => _selection = _selection.contains(card)
            ? _selection.remove(card)
            : _selection.add(card),
      );
      return;
    }
    if (!table.isMyTurn || !player.legalCards.contains(card)) return;
    final suggestion = _suggestion;
    _play(
      card,
      stoeck: table.autoAnnounce
          ? player.stoeckSeat == null &&
                completesStoeck(
                  card,
                  player.playedBy(player.seat),
                  player.mode!,
                )
          : suggestion is PlayCard &&
                suggestion.card == card &&
                suggestion.stoeck,
    );
  }

  void _play(Card card, {bool stoeck = false}) {
    final player = _table!.player!;
    _controller.act(PlayCard(player.seat, card, melds: _melds, stoeck: stoeck));
    setState(() {
      _resetMelds();
      _suggestion = null;
      _upcomingSuggestion = null;
    });
  }

  /// Asks the expert computer player for a move and highlights it: the card
  /// to play, or the trump to choose. The player still taps it to play it.
  Future<void> _suggest() async {
    _prepareSuggestion();
    final upcoming = _upcomingSuggestion!;
    setState(() => _thinking = true);
    try {
      final action = await upcoming;
      if (mounted && identical(upcoming, _upcomingSuggestion)) {
        setState(() => _suggestion = action);
      }
    } finally {
      if (mounted) setState(() => _thinking = false);
    }
  }

  /// Starts computing the suggestion once "Jouer pour moi" may be pressed.
  void _prepareSuggestion() {
    final table = _table;
    if (table == null ||
        !table.assistance ||
        !table.isMyTurn ||
        _decidingMelds ||
        _upcomingSuggestion != null) {
      return;
    }
    // Errors reach "Jouer pour moi" if pressed, and are dropped otherwise.
    _upcomingSuggestion = _controller.suggestAction()..ignore();
  }

  /// Whether [table] still asks this player for the same move as [before],
  /// so that a suggestion stays valid.
  bool _sameMove(TableView? before, TableView table) =>
      table.isMyTurn &&
      before != null &&
      before.phase == table.phase &&
      before.player?.hand == table.player?.hand;

  CardSet get _suggestedCards => switch (_suggestion) {
    PlayCard(:final card) => CardSet.of([card]),
    _ => CardSet.empty,
  };

  void _openPlayedCards() => Navigator.of(context).push(
    flowRoute<void>(context, (_) => PlayedCardsScreen(controller: _controller)),
  );

  void _skipMelds() {
    setState(() => _meldsDecided = true);
    _controller.meldsChosen();
    _prepareSuggestion();
  }

  void _announceOffered() {
    final melds = _offeredMelds;
    setState(() {
      _melds = melds;
      _meldsDecided = true;
    });
    _controller.meldsChosen();
    _prepareSuggestion();
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
    _prepareSuggestion();
  }

  /// The card that completes Stöck if the player can play it now: tapping
  /// the Stöck button above it plays it and announces Stöck.
  Card? _stoeckCard(TableView table) {
    final player = table.player!;
    if (table.autoAnnounce ||
        !table.isMyTurn ||
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
      return ScreenTheme(
        color: ScreenColors.play,
        child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    if (table.phase == TablePhase.gameOver) {
      return EndScreen(controller: _controller, table: table, onHome: _leave);
    }
    return ScreenTheme(
      color: ScreenColors.play,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _confirmLeave();
        },
        child: Scaffold(
          // Only colors the status bar like on the other screens.
          appBar: AppBar(toolbarHeight: 0, automaticallyImplyLeading: false),
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
                    Expanded(flex: _tableFlex, child: _tableArea(table)),
                    Expanded(flex: _playerFlex, child: _playerArea(table)),
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
        // The trick fits between the top and bottom names; the side names
        // sit above the side cards.
        final cardWidth = TrickView.cardWidthIn(
          Size(box.maxWidth - 16, box.maxHeight - 2 * _nameRowHeight),
        );
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
                  cardWidth: cardWidth,
                  hold: table.trickHold,
                  winner: shownTrick.isComplete
                      ? shownTrick.winner(player.mode!)
                      : null,
                ),
              ),
            if (_offeredMelds case final melds when melds.isNotEmpty)
              Center(
                child: MeldOffer(
                  melds: melds,
                  onAnnounce: _announceOffered,
                  onKeepSecret: _skipMelds,
                ),
              ),
            if (table.showsRecap)
              Center(
                child: AnnouncementSummary(
                  player: player,
                  nicknames: table.nicknames,
                  multiplier: table.options.multiplierFor(player.mode!),
                  onDismiss: _controller.dismissRecap,
                ),
              ),
            if (table.showsRoundSummary)
              Center(
                child: RoundSummary(
                  roundPoints: table.roundPoints,
                  team: teamOf(table.seat),
                  onDismiss: _controller.dismissRoundSummary,
                ),
              ),
          ],
        );
      },
    );
  }

  /// The action area, the Stöck button when it applies, the player's hand
  /// and the game actions bar.
  Widget _playerArea(TableView table) {
    final hand = sortHand(
      table.player!.hand,
      table.player!.mode,
      byTrump: table.sortByTrump,
    );
    final stoeckCard = _stoeckCard(table);
    return LayoutBuilder(
      builder: (context, box) {
        final handLayout = HandLayout(
          box.maxWidth - _handPadding.horizontal,
          hand.length,
        );
        // No card rises while choosing trump, so the choice may use the
        // room above the cards.
        final actionAreaBottom =
            _handPadding.vertical +
            handLayout.height -
            (_choosingTrump(table) ? handLayout.riseRoom : 0);
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: _handPadding,
                      // A raised card goes over the Stöck button.
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (stoeckCard != null)
                            HandColumns(
                              cards: hand,
                              card: stoeckCard,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: ActionChip(
                                  label: const Text('Stöck'),
                                  onPressed: () =>
                                      _play(stoeckCard, stoeck: true),
                                ),
                              ),
                            ),
                          HandView(
                            cards: hand,
                            enabled: _enabledCards(table),
                            selected: _choosingMelds
                                ? _selection
                                : _suggestedCards,
                            onTap: _onCardTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: actionAreaBottom,
                    child: _actionArea(table),
                  ),
                ],
              ),
            ),
            if (table.assistance)
              SizedBox(
                height: box.maxHeight * _actionsBarShare,
                child: GameActionsBar(
                  onPlayForMe: table.isMyTurn && !_decidingMelds
                      ? _suggest
                      : null,
                  thinking: _thinking,
                  onPlayedCards: _openPlayedCards,
                ),
              ),
          ],
        );
      },
    );
  }

  /// It is this player's turn to choose trump.
  bool _choosingTrump(TableView table) =>
      table.isMyTurn && table.phase == TablePhase.choosingTrump;

  Widget _actionArea(TableView table) {
    final player = table.player!;
    final text = Theme.of(context).textTheme;
    if (_choosingTrump(table)) {
      // The buttons share the height left under the title, so that the
      // choice always spans the whole width.
      return Padding(
        padding: _trumpChoicePadding,
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                player.chibred
                    ? 'Votre partenaire a chibré : choisissez l\'atout'
                    : 'Choisissez l\'atout',
                style: text.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TrumpChoicePanel(
                modes: table.options.allowedModes,
                canChibrer: !player.chibred,
                onChoose: (mode) =>
                    _controller.act(ChooseTrump(table.seat, mode)),
                onChibrer: () => _controller.act(Chibrer(table.seat)),
                suggested: _suggestion,
              ),
            ),
          ],
        ),
      );
    }
    final Widget content;
    if (table.phase == TablePhase.playing) {
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
    } else if (table.seatToAct != null || table.roundSummaryFor.isNotEmpty) {
      content = _statusText(table);
    } else {
      content = const SizedBox.shrink();
    }
    // Content that would not fit is scaled down.
    return Container(
      padding: _actionAreaPadding,
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
    if (_decidingMelds) return Text('Choisissez votre annonce', style: style);
    if (table.isMyTurn) return Text('À vous de jouer', style: style);
    final waiting = _waitingFor(table);
    if (waiting == null) return const SizedBox.shrink();
    return Text(waiting, style: style?.copyWith(color: UiColors.textMuted));
  }

  /// What the game waits for when it is not this player's turn.
  String? _waitingFor(TableView table) {
    String name(int seat) => table.nicknames[seat];
    final reading = table.recapFor.where((seat) => seat != table.seat);
    if (reading.isNotEmpty) return '${name(reading.first)} lit les annonces…';
    final summary = table.roundSummaryFor.where((seat) => seat != table.seat);
    if (summary.isNotEmpty) {
      return '${name(summary.first)} lit le résumé de la manche…';
    }
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
