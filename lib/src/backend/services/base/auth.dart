import 'package:fluent/src/backend/models/user.dart';
import 'package:meta/meta.dart';

enum AuthStatus {
  unknown,
  signedIn,
  signedOut,
}

class AuthState {
  final CurrentUser currentUser;
  final AuthStatus status;

  const AuthState._(this.status, this.currentUser);

  static const AuthState unknown = AuthState._(AuthStatus.unknown, null);
  static const AuthState signedOut = AuthState._(AuthStatus.signedOut, null);

  factory AuthState.signedIn(CurrentUser currentUser) =>
      AuthState._(AuthStatus.signedIn, currentUser);
}

abstract class AuthService {
  AuthService._();

  Stream<AuthState> get authState;

  /// Registers a user using [email] and [password].
  Future<void> register({@required String email, @required String password});

  /// Signs in the user using [email] and [password].
  Future<void> signIn({@required String email, @required String password});

  /// Signs out the current user.
  Future<void> signOut();
}
