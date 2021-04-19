import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/fluency.dart';

class MatchProfile{
  String pfp;

  String uid;

  String bio;

  String username;

  String name;

  String gender;

  String language;

  String Gender;

  int fluency;

  Timestamp age;

  int fluencyDifference;

  MatchProfile({
    this.pfp,
    this.uid,
    this.username,
    this.bio,
    this.gender,
    this.Gender,
    this.name,
    this.age,
    this.language,
    this.fluency,
    this.fluencyDifference
  });
}