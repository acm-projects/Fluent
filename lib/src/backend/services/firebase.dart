import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> init({bool useEmulators = false}) async {
  var core = await Firebase.initializeApp();

  var auth = FirebaseAuth.instance;
  var storage = FirebaseStorage.instance;
  var firestore = FirebaseFirestore.instance;
  var functions = FirebaseFunctions.instance;

  if (useEmulators) {
    auth.useEmulator('http://localhost:9099');
    firestore.settings = Settings(
      host: "http://localhost:8080",
      sslEnabled: false,
    );
    functions.useFunctionsEmulator(origin: 'http://localhost:5001');
  }
}
