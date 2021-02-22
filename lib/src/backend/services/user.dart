import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> register(String email, String password) async {
  return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
}

Future<UserCredential> login(String email, String password) async {
  return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
}
