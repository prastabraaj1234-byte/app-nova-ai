import 'dart:async';

/// Represents an authenticated user session in the application.
class AuthUser {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isAnonymous;
  final String status; // ACTIVE, DELETING, SUSPENDED, DELETED

  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.isAnonymous = false,
    this.status = 'ACTIVE',
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'isAnonymous': isAnonymous,
        'status': status,
      };
}

/// Abstract Authentication Service contract for MVP and production.
abstract class AuthService {
  Stream<AuthUser?> get authStateChanges;
  AuthUser? get currentUser;
  Future<AuthUser> signInAnonymously();
  Future<AuthUser> signInWithGoogle();
  Future<AuthUser> signInWithApple();
  Future<String?> getIdToken({bool forceRefresh = false});
  Future<void> signOut();
  Future<void> requestAccountDeletion();
}

/// Local/dev authentication implementation.
/// Provides offline developer tokens ('dev-token:uid:email') compatible with
/// backend verification until Firebase project config is bound.
class LocalAuthService implements AuthService {
  final _authStateController = StreamController<AuthUser?>.broadcast();
  AuthUser? _currentUser;

  LocalAuthService() {
    // Default mock session for offline MVP development
    _currentUser = const AuthUser(
      uid: 'local_dev_user',
      email: 'dev@nova.local',
      displayName: 'Nova Developer',
      isAnonymous: false,
      status: 'ACTIVE',
    );
    Future.microtask(() => _authStateController.add(_currentUser));
  }

  @override
  Stream<AuthUser?> get authStateChanges => _authStateController.stream;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<AuthUser> signInAnonymously() async {
    _currentUser = AuthUser(
      uid: 'anon_${DateTime.now().millisecondsSinceEpoch}',
      isAnonymous: true,
      status: 'ACTIVE',
    );
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    _currentUser = const AuthUser(
      uid: 'google_user_demo',
      email: 'user@gmail.com',
      displayName: 'Google Demo User',
      isAnonymous: false,
      status: 'ACTIVE',
    );
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<AuthUser> signInWithApple() async {
    _currentUser = const AuthUser(
      uid: 'apple_user_demo',
      email: 'user@privaterelay.appleid.com',
      displayName: 'Apple Demo User',
      isAnonymous: false,
      status: 'ACTIVE',
    );
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    if (_currentUser == null) return null;
    return 'dev-token:${_currentUser!.uid}:${_currentUser!.email ?? ""}';
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<void> requestAccountDeletion() async {
    if (_currentUser != null) {
      _currentUser = AuthUser(
        uid: _currentUser!.uid,
        email: _currentUser!.email,
        displayName: _currentUser!.displayName,
        status: 'DELETING',
      );
      _authStateController.add(_currentUser);
    }
  }
}
