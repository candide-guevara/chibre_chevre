import 'package:flutter/widgets.dart';

/// Plays animations at their full length even when the phone has animations
/// turned off: they show who played which card and who won each trick.
/// Otherwise Flutter shortens them to 5% of their duration.
class AnimatedBinding extends WidgetsFlutterBinding {
  static void ensureInitialized() {
    AnimatedBinding();
  }

  @override
  bool get disableAnimations => false;
}
