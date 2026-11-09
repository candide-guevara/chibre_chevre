import 'dart:io';
import 'dart:isolate';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../card_art/card_image_loader.dart';
import '../widgets/playing_card.dart';
import 'card_decks.dart';
import 'network_lock.dart';
import 'profile_store.dart';
import 'test_deal.dart';

/// Lets two instances on one computer act as two phones in the local demo:
/// `flutter run -d linux --dart-define=CHIBRE_PROFILE=bea`.
const _profileName = String.fromEnvironment('CHIBRE_PROFILE');

/// Long-lived objects shared by the screens.
class AppServices {
  AppServices._({
    required this.profile,
    required this.cardDecks,
    required this.transport,
    required this.savedGames,
    this.testDeal,
  }) : _measure = _measureInBackground;

  /// Services without network or files, for widget tests.
  @visibleForTesting
  AppServices.forTesting({required this.profile, required this.savedGames})
    : cardDecks = CardDecks(profile),
      transport = InMemoryTransport(InMemoryNetwork()),
      testDeal = null,
      _measure = (() async => 1000);

  static Future<AppServices> start({TestDeal? testDeal}) async {
    final profile = await ProfileStore.open(profile: _profileName);
    final directory = await getApplicationSupportDirectory();
    final suffix = _profileName.isEmpty ? '' : '-$_profileName';
    await acquireMulticastLock();
    final pixelRatio =
        WidgetsBinding
            .instance
            .platformDispatcher
            .implicitView
            ?.devicePixelRatio ??
        3;
    return AppServices._(
      profile: profile,
      cardDecks: CardDecks(
        profile,
        loader: CardImageLoader(rootBundle),
        pixelWidth: (maxCardWidth * pixelRatio).ceil(),
      ),
      transport: LanTransport(),
      savedGames: FileSavedGameStore(
        File('${directory.path}/saved-game$suffix.bin'),
      ),
      testDeal: testDeal,
    );
  }

  final ProfileStore profile;

  /// The card design chosen on this phone; card images load in the
  /// background.
  final CardDecks cardDecks;
  final Transport transport;
  final SavedGameStore savedGames;

  /// Measures this phone's search iterations per second.
  final Future<double> Function() _measure;

  /// The measure started by [measureSpeed], for the next game.
  Future<double>? _speed;

  static Future<double> _measureInBackground() =>
      Isolate.run(() => measurePlayoutsPerSecond());

  /// Measures the phone's speed for the next game, in the background. The
  /// host and join screens call it as they open, so that the result is
  /// ready when the game starts and reflects how fast the phone is at that
  /// moment (once the app has started, in battery saver mode...).
  void measureSpeed() => _speed = _measure();

  /// Cards dealt to the host in every round, for testing.
  final TestDeal? testDeal;

  Future<HostSession> newHostSession() async => HostSession(
    transport: transport,
    newBots: await _newBots(),
    store: savedGames,
    newDeals: testDeal == null
        ? null
        : (random) => PresetHandDealSource(testDeal!.presets, random),
  );

  /// Runs the expert computer player for this phone's suggestions, with
  /// the game's thinking time.
  Future<BotRunner Function(Duration thinkingTime)> newAdvisor() => _newBots();

  /// Computer players thinking for a given time on this phone.
  Future<BotRunner Function(Duration thinkingTime)> _newBots() async {
    final measuring = _speed ?? _measure();
    _speed = null; // The next game measures again.
    final speed = await measuring;
    return (thinkingTime) => IsolateBotRunner(
      budget: ComputeBudget.forSpeed(speed, target: thinkingTime),
      seed: _seed,
    );
  }

  /// With a test deal, the computer players replay the same game.
  int? get _seed => testDeal == null ? null : 0;

  ClientSession newClientSession() => ClientSession(
    transport: transport,
    installationId: profile.installationId,
    nickname: profile.nickname!,
  );
}

/// Makes the [AppServices] available to all widgets below.
class Services extends InheritedWidget {
  const Services({super.key, required this.services, required super.child});

  final AppServices services;

  static AppServices of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Services>()!.services;

  @override
  bool updateShouldNotify(Services oldWidget) => services != oldWidget.services;
}
