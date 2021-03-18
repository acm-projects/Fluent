import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:meta/meta.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;

  final Stream<CurrentUser> currentUser;

  FirebaseAuthService._(this._auth)
      : currentUser = _auth.userChanges().map((user) => user == null ? null : CurrentUser(user));

  factory FirebaseAuthService.initialize(FirebaseApp app) {
    return FirebaseAuthService._(FirebaseAuth.instanceFor(app: app));
  }

  @override
  Future<void> register({@required String email, @required String password}) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signIn({@required String email, @required String password}) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signOut() => _auth.signOut();
}
