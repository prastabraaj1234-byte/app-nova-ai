import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

/// Singleton provider for the active AuthService implementation.
final authServiceProvider = Provider<AuthService>((ref) {
  return LocalAuthService();
});

/// Stream provider listening to real-time authentication state changes.
final authStateProvider = StreamProvider<AuthUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Provider returning the current synchronous AuthUser or null.
final currentUserProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value;
});
