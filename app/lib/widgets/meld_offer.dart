import 'package:chibre_core/chibre_core.dart' hide Card;
import 'package:flutter/material.dart';

import '../strings.dart';
import '../theme/chibre_theme.dart';
import '../theme/screen_theme.dart';

/// With automatic announcements, the melds the player holds at the start of
/// a round: announce them all, or keep them secret.
class MeldOffer extends StatelessWidget {
  const MeldOffer({
    super.key,
    required this.melds,
    required this.onAnnounce,
    required this.onKeepSecret,
  });

  final List<Meld> melds;
  final VoidCallback onAnnounce;
  final VoidCallback onKeepSecret;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    const size = Size(120, 44);
    return ScreenTheme(
      color: UiColors.popup,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: UiColors.popup,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Strings.yourMelds, style: text.titleLarge),
              const SizedBox(height: 12),
              for (final meld in melds)
                Text(Strings.meldName(meld), style: text.titleMedium),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: size),
                    onPressed: onKeepSecret,
                    child: const Text(Strings.keepSecret),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(minimumSize: size),
                    onPressed: onAnnounce,
                    child: const Text(Strings.announce),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
