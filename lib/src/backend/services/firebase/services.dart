import 'package:firebase_core/firebase_core.dart';
import 'package:fluent/src/backend/services/firebase/auth.dart';
import 'package:fluent/src/backend/services/firebase/database.dart';
import 'package:fluent/src/backend/services/firebase/storage.dart';

class FirebaseServices {
  final FirebaseApp app;

  final FirebaseAuthService auth;
  final FirebaseStorageService storage;
  final FirestoreDatabaseService database;

  FirebaseServices._(this.app, this.auth, this.storage, this.database);

  static Future<FirebaseServices> initialize() async {
    final app = await Firebase.initializeApp();

    final auth = FirebaseAuthService.initialize(app);
    final storage = FirebaseStorageService.initialize(app);
    final database = FirestoreDatabaseService.initialize(app);

    return FirebaseServices._(app, auth, storage, database);
  }
}
