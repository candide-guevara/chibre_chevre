import 'package:chibre_core/chibre_core.dart';

/// The deal of every round of hosted games, to test the screens without
/// waiting for the right hand: `--test-fix-deal=<name>` on the command line.
/// Every player's cards are fixed. The host (seat 0) always holds the seven
/// of diamonds so it chooses trump first.
enum TestDeal {
  /// The whole deal is fixed: every player has a sequence, the host's 50
  /// (four hearts) beats the others' 20, and no other meld is possible.
  sequence('sequence', [
    'D7 H7 H8 H9 H10 S6 SA CQ DK',
    'S7 S8 S9 C6 D9 DJ DQ HJ CK',
    'C7 C8 C9 H6 D10 SJ SK CA DA',
    'HQ HK HA D6 D8 S10 SQ C10 CJ',
  ]),

  /// The host has the king and queen of spades: Stöck when spades are
  /// trump. Nobody has a meld, nor another Stöck.
  stoeck('stock', [
    'D7 SQ SK H6 H9 HJ C7 C10 CA',
    'H7 H10 HK S6 S8 S10 D6 D9 CK',
    'H8 HQ S7 S9 SJ D8 D10 DQ C6',
    'HA SA DJ DK DA C8 C9 CJ CQ',
  ]),

  /// The host has the best diamonds: seven, nine, jack and ace. Nobody has
  /// a meld, nor Stöck.
  goodHand('good-hand', [
    'D7 D9 DJ DA H6 H8 S7 SQ CK',
    'H7 H9 HJ HK S6 S8 S10 D6 C6',
    'H10 HQ S9 SJ D8 DK C7 C9 CJ',
    'HA SK SA D10 DQ C8 C10 CQ CA',
  ]);

  const TestDeal(this.flagValue, this._hands);

  final String flagValue;

  /// The hands by seat, starting with the host.
  final List<String> _hands;

  /// The hands by seat.
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
