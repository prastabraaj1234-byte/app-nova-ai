import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppAccent {
  purple(Color(0xFF6D5EF9), 'Neon Purple'),
  blue(Color(0xFF00D1FF), 'Cyber Blue'),
  green(Color(0xFF22C55E), 'Emerald Green'),
  red(Color(0xFFFF4444), 'Crimson Red'),
  orange(Color(0xFFFF9800), 'Amber Glow');

  final Color color;
  final String label;

  const AppAccent(this.color, this.label);
}

class ThemeAccentNotifier extends Notifier<AppAccent> {
  @override
  AppAccent build() => AppAccent.purple;

  void updateTheme(AppAccent accent) {
    state = accent;
  }
}

final themeAccentProvider = NotifierProvider<ThemeAccentNotifier, AppAccent>(() {
  return ThemeAccentNotifier();
});
