import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:fluent/src/backend/models/core.dart';
import 'package:fluent/src/backend/models/fluency.dart';
import 'package:meta/meta.dart';

/// Represents a user. Can be used to access profile information.
class User extends HasUid {
  /// This user's unique ID.
  @override
  String uid;

  User(this.uid);
}

/// Represents a user's public-facing profile.
class Profile extends User {
  /// This user's username.
  String username;

  /// This user's real name.
  String name;

  /// This user's birth date.
  DateTime birthDate;

  /// This user's gender.
  String gender;

  /// This user's bio.
  String bio;

  /// The language this user wants to practice.
  String language;

  /// This user's fluency in their chosen language.
  Fluency fluency;

  Profile({
    @required String uid,
    @required this.username,
    @required this.name,
    @required this.birthDate,
    @required this.gender,
    @required this.bio,
    @required this.language,
    @required this.fluency,
  }) : super(uid);

  /// This user's age.
  int get age {
    var now = DateTime.now();

    var years = now.year - birthDate.year;
    var months = now.month - birthDate.month;
    var days = now.day - birthDate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      return years - 1;
    } else {
      return years;
    }
  }
}

/// Represents the currently logged in user.
class CurrentUser extends User {
  /// This user's Firebase authentication credential.
  Auth.User user;

  CurrentUser(this.user) : super(user?.uid);

  User get ref => User(this.uid);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CurrentUser && runtimeType == other.runtimeType && user == other.user;

  @override
  int get hashCode => user.hashCode;
}
