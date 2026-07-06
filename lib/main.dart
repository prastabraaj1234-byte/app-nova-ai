import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_ai/core/router.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/providers/theme_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: NovaAIApp(),
    ),
  );
}

class NovaAIApp extends ConsumerWidget {
  const NovaAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = ref.watch(themeAccentProvider);
    
    return MaterialApp.router(
      title: 'Nova AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(accent),
      routerConfig: appRouter,
    );
  }
}
