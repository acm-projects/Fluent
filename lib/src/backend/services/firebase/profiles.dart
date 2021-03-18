import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent/src/backend/models/fluency.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/profiles.dart';
import 'package:fluent/src/backend/services/base/storage.dart';
import 'package:meta/meta.dart';

class FirestoreProfilesService implements ProfilesService {
  // TODO: extract into DatabaseService and FirestoreDatabaseService
  final FirebaseFirestore _firestore;
  final StorageService _storage;

  FirestoreProfilesService._(this._firestore, this._storage);

  factory FirestoreProfilesService.initialize(
    FirebaseApp app,
    StorageService storage,
  ) {
    return FirestoreProfilesService._(
        FirebaseFirestore.instanceFor(app: app), storage);
  }

  @override
  Future<Profile> createProfile({
    @required String uid,
    @required String username,
    @required String name,
    @required DateTime birthDate,
    @required String gender,
    @required String bio,
    @required String language,
    @required Fluency fluency,
  }) async {
    var ref = _firestore.collection('profiles').doc(uid);

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

  @override
  Future<Profile> fetchProfile(String uid) async {
    var snap = await _firestore.collection('profiles').doc(uid).get();

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

  @override
  Future<String> fetchPictureUrl(User user) => _storage.fetchImageUrl(user.uid);
}
