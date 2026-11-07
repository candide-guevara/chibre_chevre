import 'package:chibre_core/chibre_core.dart';

/// Cards always dealt in hosted games, to test the screens without waiting
/// for the right hand: `--test-fix-deal=<name>` on the command line. The
/// host (seat 0) always holds the seven of diamonds so it chooses trump
/// first; cards not listed are dealt at random.
enum TestDeal {
  /// The whole deal is fixed: every player has a sequence, the host's 50
  /// (four hearts) beats the others' 20, and no other meld is possible.
  sequence('sequence', [
    'D7 H7 H8 H9 H10 S6 SA CQ DK',
    'S7 S8 S9 C6 D9 DJ DQ HJ CK',
    'C7 C8 C9 H6 D10 SJ SK CA DA',
    'HQ HK HA D6 D8 S10 SQ C10 CJ',
  ]),

  /// King and queen of spades: Stöck when spades are trump.
  stoeck('stock', ['D7 SQ SK']),

  /// The best diamonds: seven, nine, jack and ace.
  goodHand('good-hand', ['D7 D9 DJ DA']);

  const TestDeal(this.flagValue, this._hands);

  final String flagValue;

  /// Preset cards by seat, starting with the host.
  final List<String> _hands;

  /// The preset cards by seat.
  Map<int, CardSet> get presets => {
    for (final (seat, cards) in _hands.indexed) seat: CardSet.parse(cards),
  };

  static const flag = '--test-fix-deal';

  /// The deal asked for in [args], null when the flag is absent.
  static TestDeal? fromArgs(List<String> args) {
    final index = args.indexWhere(
      (arg) => arg == flag || arg.startsWith('$flag='),
    );
    if (index < 0) return null;
    final arg = args[index];
    final value = arg.contains('=')
        ? arg.substring(arg.indexOf('=') + 1)
        : (index + 1 < args.length ? args[index + 1] : '');
    for (final deal in values) {
      if (deal.flagValue == value) return deal;
    }
    final known = values.map((deal) => deal.flagValue).join(', ');
    throw ArgumentError('$flag must be one of: $known (got "$value")');
  }
}
