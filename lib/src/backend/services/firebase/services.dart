import 'package:firebase_core/firebase_core.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:fluent/src/backend/services/firebase/auth.dart';
import 'package:fluent/src/backend/services/firebase/profiles.dart';
import 'package:fluent/src/backend/services/firebase/storage.dart';

class FirebaseServices implements Services {
  final FirebaseApp app;

  final FirebaseAuthService auth;
  final FirebaseStorageService storage;
  final FirestoreProfilesService profiles;

  FirebaseServices._(this.app, this.auth, this.storage, this.profiles);

  static Future<FirebaseServices> initialize() async {
    final app = await Firebase.initializeApp();

    final auth = FirebaseAuthService.initialize(app);
    final storage = FirebaseStorageService.initialize(app);
    final profiles = FirestoreProfilesService.initialize(app, storage);

    return FirebaseServices._(app, auth, storage, profiles);
  }
}
