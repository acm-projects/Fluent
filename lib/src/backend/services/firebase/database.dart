/*import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(int age, String bio, String name, String username) async{
    return await userCollection.doc(uid).set({
      'age': age,
      'bio': bio,
      'name': name,
      'username': username
    });
  }

  void _onPressed() {
    userCollection.doc("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
  }
}

 */