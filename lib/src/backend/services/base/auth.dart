import 'package:fluent/src/backend/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

abstract class AuthService {
  AuthService._();

  Stream<CurrentUser> get currentUser;

  /// Registers a user using [email] and [password].
  Future<void> register({@required String email, @required String password});

  /// Signs in the user using [email] and [password].
  Future<void> signIn({@required String email, @required String password});

  /// Signs out the current user.
  Future<void> signOut();
}

class AuthState extends InheritedWidget {
  final CurrentUser currentUser;

  const AuthState({
    Key key,
    @required this.currentUser,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(AuthState old) => currentUser != old.currentUser;

  static AuthState of(BuildContext context) {
    final AuthState result = context.dependOnInheritedWidgetOfExactType<AuthState>();
    assert(result != null, 'No AuthState found in context');
    return result;
  }
}
