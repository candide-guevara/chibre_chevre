import 'dart:io';

import 'package:chibre_core/chibre_core.dart';
import 'package:chibre_net/chibre_net.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'compute_budget_loader.dart';
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
    required this.transport,
    required this.savedGames,
    required this.budget,
    this.testDeal,
  });

  static Future<AppServices> start({TestDeal? testDeal}) async {
    final profile = await ProfileStore.open(profile: _profileName);
    final directory = await getApplicationSupportDirectory();
    final suffix = _profileName.isEmpty ? '' : '-$_profileName';
    await acquireMulticastLock();
    return AppServices._(
      profile: profile,
      transport: LanTransport(),
      savedGames: FileSavedGameStore(
        File('${directory.path}/saved-game$suffix.bin'),
      ),
      budget: loadComputeBudget(profile),
      testDeal: testDeal,
    );
  }

  final ProfileStore profile;
  final Transport transport;
  final SavedGameStore savedGames;

  /// Measured in the background at startup.
  final Future<ComputeBudget> budget;

  /// Cards dealt to the host in every round, for testing.
  final TestDeal? testDeal;

  Future<HostSession> newHostSession() async => HostSession(
    transport: transport,
    bots: IsolateBotRunner(budget: await budget),
    store: savedGames,
    newDeals: testDeal == null
        ? null
        : (random) => PresetHandDealSource(
            HostSession.hostSeat,
            testDeal!.cards,
            random,
          ),
  );

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
