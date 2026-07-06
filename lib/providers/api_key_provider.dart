import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _defaultApiKey = 'PROTOTYPE_SIMULATED_MODE';

class ApiKeyNotifier extends Notifier<String?> {
  @override
  String? build() {
    return _defaultApiKey;
  }

  Future<void> saveApiKey(String key) async {
    state = key.trim().isEmpty ? _defaultApiKey : key.trim();
  }
  
  Future<void> clearApiKey() async {
    state = _defaultApiKey;
  }
}

final apiKeyProvider = NotifierProvider<ApiKeyNotifier, String?>(() {
  return ApiKeyNotifier();
});
