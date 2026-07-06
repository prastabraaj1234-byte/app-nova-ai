import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_ai/screens/memory_vault_screen.dart';
import 'package:nova_ai/screens/premium_screen.dart';
import 'package:nova_ai/screens/privacy_policy_screen.dart';

void main() {
  group('Route & UI Smoke Tests (Asset-Safe Standalone Screens)', () {
    testWidgets('MemoryVaultScreen constructs and renders without crashes', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: MemoryVaultScreen())));
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('PremiumScreen constructs and renders without crashes', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: PremiumScreen())));
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('PrivacyPolicyScreen constructs and renders without crashes', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: PrivacyPolicyScreen())));
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
