import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:fluent/src/backend/models/core.dart';
import 'package:fluent/src/backend/models/language.dart';
import 'package:fluent/src/backend/services/storage.dart';
import 'package:fluent/src/backend/services/users.dart' as Users;
import 'package:meta/meta.dart';

/// Represents a user. Can be used to access profile information.
class User extends HasUid {
  /// This user's unique ID.
  @override
  String uid;

  User(this.uid);

  /// Fetches this user's profile data.
  Future<Profile> fetchProfile() => Users.fetchProfile(this.uid);
}

/// Represents a user's public-facing profile.
class Profile extends User {
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

  Profile({
    @required String uid,
    @required this.username,
    @required this.name,
    @required this.pfpHash,
    @required this.birthDate,
    @required this.gender,
    @required this.bio,
    @required this.language,
    @required this.fluency,
  }) : super(uid);

  /// This user's age.
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

  /// Fetches this user's profile picture's URL.
  Future<String> fetchPfpUrl() async => fetchImageUrl(this.uid);
}

/// Represents the currently logged in user.
class CurrentUser extends User {
  static CurrentUser _instance = CurrentUser._(null);

  /// This user's Firebase authentication credential.
  Auth.User user;

  CurrentUser._(this.user) : super(user.uid);

  static void update(Auth.User user) {
    _instance.user = user;
  }

  static CurrentUser get instance => _instance;
}
