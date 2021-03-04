import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show UserCredential;
import 'package:fluent/src/backend/models/core.dart';
import 'package:fluent/src/backend/models/language.dart';
import 'package:fluent/src/backend/services/users.dart' as Users;

/// Represents a user. Can be used to access profile information.
abstract class UserData extends HasUid {
  /// Fetches this user's profile data.
  Future<Profile> fetchProfile();

  /// This user's unique ID.
  @override
  String get uid;
}

/// Represents a user's public-facing profile.
class Profile extends UserData {
  String uid;

  /// This user's username.
  String username;

  /// This user's real name.
  String name;

  /// The hash of this user's profile picture.
  String pfpHash;

  /// This user's birth date.
  Timestamp birthDate;

  /// This user's gender.
  String gender;

  /// This user's bio.
  String bio;

  /// The language this user wants to practice.
  Language language;

  /// This user's fluency in their chosen language.
  Fluency fluency;

  Profile(
      {this.uid,
      this.username,
      this.name,
      this.pfpHash,
      this.birthDate,
      this.gender,
      this.bio,
      this.language,
      this.fluency});

  /// This user's age
  int get age {
    var now = DateTime.now();
    var birthDate = this.birthDate.toDate();

    var years = now.year - birthDate.year;
    var months = now.month - birthDate.month;
    var days = now.day - birthDate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      return years - 1;
    } else {
      return years;
    }
  }

  /// Returns this profile.
  @override
  Future<Profile> fetchProfile() async => this;

  Future<String> fetchPfpUrl() async => Users.fetchPfpUrl(this.pfpHash);
}

/// Represents the currently logged in user.
class CurrentUser extends UserData {
  String uid;

  /// This user's Firebase authentication credential.
  UserCredential auth;

  CurrentUser(this.auth) : uid = auth.user.uid;

  @override
  Future<Profile> fetchProfile() => Users.fetchProfile(this.uid);
}
