import 'package:fluent/src/backend/models/fluency.dart';

class MatchProfile{
  String pfp;

  String uid;

  String bio;

  String username;

  String name;

  String gender;

  String language;

  int fluency;

  int age;

  int fluencyDifference;

  MatchProfile({
    this.pfp,
    this.uid,
    this.username,
    this.bio,
    this.gender,
    this.name,
    this.age,
    this.language,
    this.fluency,
    this.fluencyDifference
  });
}