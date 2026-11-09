import 'package:chibre_core/chibre_core.dart';
import 'package:flutter/material.dart';

import 'suit_icon.dart';

/// A filled button with a pip of [suit] at each end and its label centered.
class PipButton extends StatelessWidget {
  const PipButton({
    super.key,
    required this.suit,
    required this.onPressed,
    required this.child,
  });

  final Suit suit;
  final VoidCallback? onPressed;
  final Widget child;

  static const _pipSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final pip = Opacity(
      opacity: onPressed == null ? 0.3 : 1,
      child: SuitIcon(suit, size: _pipSize),
    );
    return FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          pip,
          const SizedBox(width: 12),
          Expanded(
            child: DefaultTextStyle.merge(
              textAlign: TextAlign.center,
              child: child,
            ),
          ),
          const SizedBox(width: 12),
          pip,
        ],
      ),
    );
  }
}
