import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/fluency.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/storage.dart';
import 'package:meta/meta.dart';

class ProfilesService {
  final FirebaseFirestore _database;
  final StorageService _storage;

  ProfilesService._(this._database, this._storage);

  factory ProfilesService.initialize(
    FirebaseFirestore database,
    StorageService storage,
  ) {
    return ProfilesService._(database, storage);
  }

  /// Creates a profile with the given information in the database.
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
    var ref = _database.collection('profiles').doc(uid);

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
    var snap = await _database.collection('profiles').doc(uid).get();

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

  /// Fetches the given user's profile picture's URL.
  Future<String> fetchPictureUrl(User user) => _storage.fetchImageUrl(user.uid);
}
