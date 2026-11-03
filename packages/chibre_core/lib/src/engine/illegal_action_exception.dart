/// Thrown when a player attempts an action the rules don't allow.
class IllegalActionException implements Exception {
  const IllegalActionException(this.message);

  final String message;

  @override
  String toString() => 'IllegalActionException: $message';
}
