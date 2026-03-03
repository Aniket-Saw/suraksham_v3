import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: SurakshamApp()));
}

class SurakshamApp extends ConsumerWidget {
  const SurakshamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Suraksham',
      themeMode: ThemeMode.dark, // Defaulting to dark mode for the premium feel
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
