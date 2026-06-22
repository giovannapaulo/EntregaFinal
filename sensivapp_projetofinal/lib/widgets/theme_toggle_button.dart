import 'package:flutter/material.dart';
import '../main.dart';
import '../core/app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = SensivApp.of(context);
    final isDark = appState?.isDarkMode ?? true;

    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.pastelPink.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          color: AppTheme.pastelPink,
          size: 20,
        ),
      ),
      onPressed: () => appState?.toggleTheme(),
    );
  }
}
