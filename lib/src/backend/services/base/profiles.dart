import 'package:fluent/src/backend/models/fluency.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:meta/meta.dart';

abstract class ProfilesService {
  ProfilesService._();

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
  });

  /// Fetches the profile for the user with uid [uid].
  Future<Profile> fetchProfile(String uid);

  /// Fetches the given user's profile picture's URL.
  Future<String> fetchPictureUrl(User user);
}
