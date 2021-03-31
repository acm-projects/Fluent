import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class FileRef {
  Future<void> putFile(File file);
}

abstract class StorageService {
  StorageService._();

  /// Fetches the URL for the image with the given [fileName].
  Future<String> fetchImageUrl(String fileName);

  Reference ref(String path);
}
