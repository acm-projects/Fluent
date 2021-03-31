import 'package:fluent/src/backend/models/fluency.dart';

class MatchProfile{
  String bio;

  String username;

  String name;

  String language;

  int fluency;

  int age;

  int fluencyDifference;

  MatchProfile({
    this.username,
    this.bio,
    this.name,
    this.age,
    this.language,
    this.fluency,
    this.fluencyDifference
  });
}