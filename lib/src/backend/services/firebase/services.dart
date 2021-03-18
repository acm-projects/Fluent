import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent/src/backend/services/firebase/auth.dart';
import 'package:fluent/src/backend/services/firebase/storage.dart';

class FirebaseServices {
  final FirebaseApp app;

  final FirebaseAuthService auth;
  final FirebaseStorageService storage;
  final FirebaseFirestore database;

  FirebaseServices._(this.app, this.auth, this.storage, this.database);

  static Future<FirebaseServices> initialize() async {
    final app = await Firebase.initializeApp();

    final auth = FirebaseAuthService.initialize(app);
    final storage = FirebaseStorageService.initialize(app);
    final database = FirebaseFirestore.instanceFor(app: app);

    return FirebaseServices._(app, auth, storage, database);
  }
}
