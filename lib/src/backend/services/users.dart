import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, Timestamp;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent/src/backend/models/fluency.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:meta/meta.dart';

/// Registers a user using [email] and [password].
Future<void> register({
  @required String email,
  @required String password,
}) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
}

/// Signs in the user using [email] and [password].
Future<void> signIn({
  @required String email,
  @required String password,
}) async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
}

/// Signs out the current user.
Future<void> signOut() {
  return FirebaseAuth.instance.signOut();
}

/// Creates a profile with the given information in the database.
Future<Profile> createProfile({
  @required String uid,
  @required String username,
  @required String name,
  @required Timestamp birthDate,
  @required String gender,
  @required String bio,
  @required String language,
  @required Fluency fluency,
}) async {
  var ref = FirebaseFirestore.instance.collection('profiles').doc(uid);

  await ref.set({
    'username': username,
    'name': name,
    'birthDate': birthDate,
    'gender': gender,
    'bio': bio,
    'language': language,
    'fluency': fluency.index,
  });

  return Profile(
    uid: uid,
    username: username,
    name: name,
    birthDate: birthDate,
    gender: gender,
    bio: bio,
    language: language,
    fluency: fluency,
  );
}

/// Fetches the profile for the user with uid [uid].
Future<Profile> fetchProfile(String uid) async {
  var snap =
      await FirebaseFirestore.instance.collection('profiles').doc(uid).get();

  return Profile(
    uid: uid,
    username: snap.get('username'),
    name: snap.get('name'),
    birthDate: snap.get('birthDate'),
    gender: snap.get('gender'),
    bio: snap.get('bio'),
    language: snap.get('language'),
    fluency: Fluency.values[snap.get('fluency')],
  );
}
