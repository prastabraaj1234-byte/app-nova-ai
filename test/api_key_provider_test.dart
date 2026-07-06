import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_ai/providers/api_key_provider.dart';

void main() {
  group('ApiKeyProvider Phase 0 Security Tests', () {
    test('default api key is safe simulated placeholder and NOT a real secret', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final key = container.read(apiKeyProvider);
      expect(key, 'PROTOTYPE_SIMULATED_MODE');
      expect(key!.contains('AIzaSy'), false);
      expect(key.contains('AQ.Ab8R'), false);
    });

    test('saveApiKey updates in-memory state without SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(apiKeyProvider.notifier).saveApiKey('test_key');
      expect(container.read(apiKeyProvider), 'test_key');

      await container.read(apiKeyProvider.notifier).clearApiKey();
      expect(container.read(apiKeyProvider), 'PROTOTYPE_SIMULATED_MODE');
    });
  });
}
