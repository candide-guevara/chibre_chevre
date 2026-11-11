import 'dart:ui';

import 'package:chibre/card_art/card_designs.dart';
import 'package:chibre/game/host_game_controller.dart';
import 'package:chibre/screens/play_screen.dart';
import 'package:chibre/services/app_services.dart';
import 'package:chibre/services/test_deal.dart';
import 'package:chibre/theme/chibre_theme.dart';
import 'package:chibre/theme/flow_color.dart';
import 'package:chibre/theme/screen_theme.dart';
import 'package:chibre/widgets/announcement_summary.dart';
import 'package:chibre/widgets/hand_view.dart';
import 'package:chibre/widgets/meld_offer.dart';
import 'package:chibre/widgets/playing_card.dart';
import 'package:chibre/widgets/round_summary.dart';
import 'package:chibre/widgets/trump_choice_panel.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Plays a single player game through the play screen, tapping like a
/// player would, and records the timing of every frame: see
/// `tool/frame_bench.sh`.

/// Keeps the saved game and the profile of the phone's player untouched:
/// closing the game deletes its saved game.
const _profile = String.fromEnvironment('CHIBRE_PROFILE');
const _benchProfile = 'bench';

const _rounds = int.fromEnvironment('FRAME_BENCH_ROUNDS', defaultValue: 2);

/// How often the player looks at the table, like a quick human.
const _lookInterval = Duration(milliseconds: 100);

/// Lets the table react to a tap before looking again.
const _afterTap = Duration(milliseconds: 300);

const _timeout = Duration(minutes: 15);

/// Where a card of the hand is tapped, as a share of its width from its
/// left edge: always in the part that the next card does not cover.
const _visibleCardShare = 0.15;

/// Plays animations at their full length, like `AnimatedBinding` does in
/// the app, even when the phone has animations turned off.
class _BenchBinding extends IntegrationTestWidgetsFlutterBinding {
  @override
  bool get disableAnimations => false;
}

void main() {
  final binding = _BenchBinding()
    ..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('play screen frame timings', timeout: const Timeout(_timeout), (
    tester,
  ) async {
    expect(
      _profile,
      _benchProfile,
      reason: 'run with --dart-define=CHIBRE_PROFILE=$_benchProfile',
    );
    final services = await AppServices.start(testDeal: TestDeal.goodHand);
    final profile = services.profile;
    if (profile.nickname == null) await profile.setNickname('Banc');
    final design = cardDesignById(profile.cardDesign);
    await services.cardDecks.load(design);

    final session = await services.newHostSession();
    await session.create(
      HostConfig(
        gameName: 'Banc d\'essai',
        nickname: profile.nickname!,
        autoAnnounce: true,
        solo: true,
      ),
    );
    await tester.pumpWidget(
      Services(
        services: services,
        child: CardDesignScope(
          design: design,
          child: MaterialApp(
            theme: chibreTheme(),
            home: FlowColor(
              color: ScreenColors.solo,
              child: ScreenTheme(
                color: ScreenColors.solo,
                child: PlayScreen(controller: HostGameController(session)),
              ),
            ),
          ),
        ),
      ),
    );

    bool done() {
      final table = session.table;
      return table == null ||
          table.phase == TablePhase.gameOver ||
          table.roundIndex >= _rounds;
    }

    await binding.watchPerformance(() async {
      while (!done()) {
        await tester.pump(_lookInterval);
        if (await _act(tester)) await tester.pump(_afterTap);
      }
    }, reportKey: 'play_frames');

    final view = PlatformDispatcher.instance.implicitView!;
    binding.reportData!['device'] = {
      'devicePixelRatio': view.devicePixelRatio,
      'physicalSize': '${view.physicalSize.width}x${view.physicalSize.height}',
      'refreshRate': view.display.refreshRate,
      'rounds': _rounds,
      'cardDesign': design.id,
    };
    await session.close();
  });
}

/// Does what the table asks of the player, if anything: true when it
/// tapped.
Future<bool> _act(WidgetTester tester) async {
  for (final popup in [RoundSummary, AnnouncementSummary]) {
    final finder = find.byType(popup);
    if (finder.evaluate().isNotEmpty) {
      await tester.tap(finder.first);
      return true;
    }
  }
  final offer = find.descendant(
    of: find.byType(MeldOffer),
    matching: find.text('Annoncer'),
  );
  if (offer.evaluate().isNotEmpty) {
    await tester.tap(offer);
    return true;
  }
  final trump = find.descendant(
    of: find.byType(TrumpChoicePanel),
    matching: find.byType(FilledButton),
  );
  if (trump.evaluate().isNotEmpty) {
    await tester.tap(trump.first);
    return true;
  }
  if (find.text('À vous de jouer').evaluate().isEmpty) return false;
  final playable = find
      .descendant(of: find.byType(HandView), matching: find.byType(PlayingCard))
      .evaluate()
      .where((element) => (element.widget as PlayingCard).enabled);
  if (playable.isEmpty) return false;
  final card = tester.getRect(find.byWidget(playable.first.widget));
  await tester.tapAt(
    card.centerLeft + Offset(card.width * _visibleCardShare, 0),
  );
  return true;
}
