import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluent/src/backend/services/base/storage.dart';

class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService._(this._storage);

  factory FirebaseStorageService.initialize(FirebaseApp app) {
    return FirebaseStorageService._(FirebaseStorage.instanceFor(app: app));
  }

  @override
  Future<String> fetchImageUrl(String name) async {
    return _storage.ref('/images/$name.png').getDownloadURL();
  }

  @override
  Reference ref(String path) {
    return _storage.ref(path);
  }
}
