import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent/src/backend/models/language.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:meta/meta.dart';

/// Registers a user using [email] and [password].
Future<CurrentUser> register({@required String email, @required String password}) async {
  var auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  return CurrentUser(auth);
}

/// Signs in the user using [email] and [password].
Future<CurrentUser> signIn({@required String email, @required String password}) async {
  var auth = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  return CurrentUser(auth);
}

/// Signs out the current user.
Future<void> signOut() {
  return FirebaseAuth.instance.signOut();
}

/// Fetches the profile for the user with uid [uid].
Future<Profile> fetchProfile(String uid) async {
  var snap = await FirebaseFirestore.instance.collection('profiles').doc(uid).get();

  return Profile(
    uid: uid,
    username: snap.get('username'),
    name: snap.get('name'),
    pfpHash: snap.get('pfpHash'),
    birthDate: snap.get('birthDate'),
    gender: snap.get('gender'),
    bio: snap.get('bio'),
    language: Language(snap.get('language')),
    fluency: parseFluency(snap.get('fluency')),
  );
}
