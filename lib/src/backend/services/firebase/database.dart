import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('profiles');

  Future<void> postUserData(String name, DateTime age, String gender, String language, int fluency, String bio) async{
    return await userCollection.doc(uid).set({
      "UID": uid,
      'name': name,
      'age': age,
      'gender': gender,
      'language': language,
      'fluency': fluency,
      'bio': bio
    }).then((_){
      print("success!");
    });
  }
}
