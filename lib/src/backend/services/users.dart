import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluent/src/backend/models/language.dart';
import 'package:fluent/src/backend/models/data.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in with email and password
  Future signInUserWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //register with email and password
  Future registerUserWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign out
  Future signOutUser() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}

Future<Profile> fetchProfile(String uid) async {
  var snap = await FirebaseFirestore.instance.collection('profiles').doc(uid).get();

  return Profile(
    uid: uid,
    username: snap.get('username'),
    name: snap.get('name'),
    pfpHash: snap.get('pfpHash'),
    birthDate: snap.get('birthDate'),
    gender: snap.get('gender'),
    bio: snap.get('bio'),
    language: Language(snap.get('language')),
    fluency: parseFluency(snap.get('fluency')),
  );
}

Future<String> fetchPfpUrl(String hash) async {
  return FirebaseStorage.instance.ref('/images/$hash.png').getDownloadURL();
}
