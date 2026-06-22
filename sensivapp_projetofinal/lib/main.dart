import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/app_routes.dart';
import 'providers/lembrete_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LembreteProvider(),
      child: const SensivApp(),
    ),
  );
}

class SensivApp extends StatefulWidget {
  const SensivApp({super.key});

  static _SensivAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_SensivAppState>();

  @override
  State<SensivApp> createState() => _SensivAppState();
}

class _SensivAppState extends State<SensivApp> {
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SensivApp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        return AnimatedTheme(
          data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          duration: const Duration(milliseconds: 600),
          child: child!,
        );
      },
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
