import 'package:chibre_core/chibre_core.dart';

/// Cards always dealt to the host, to test the screens without waiting for
/// the right hand: `--test-fix-deal=<name>` on the command line. Each hand
/// holds the seven of diamonds so the host chooses trump first.
enum TestDeal {
  /// A sequence of four hearts (50) to announce.
  sequence('sequence', 'D7 H7 H8 H9 H10'),

  /// King and queen of spades: Stöck when spades are trump.
  stoeck('stock', 'D7 SQ SK'),

  /// The best diamonds: seven, nine, jack and ace.
  goodHand('good-hand', 'D7 D9 DJ DA');

  const TestDeal(this.flagValue, this._cards);

  final String flagValue;
  final String _cards;

  CardSet get cards => CardSet.parse(_cards);

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
