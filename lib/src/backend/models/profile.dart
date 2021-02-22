import 'package:fluent/src/backend/models/language.dart';
import 'package:fluent/src/backend/models/profile_language.dart';

/// Represents a user's public-facing profile.
class Profile {
  /// This user's unique ID.
  String uid;

  /// This user's username.
  String username;

  /// This user's real name.
  String name;

  /// URL for this user's profile picture.
  String pfpUrl;

  /// This user's age.
  int age;

  /// This user's gender.
  String gender;

  /// This user's bio.
  String bio;

  /// This user's languages.
  Map<Language, LanguageInfo> languages;

  Profile._(this.uid, this.username, this.name, this.pfpUrl, this.age, this.gender, this.bio, this.languages);
}
