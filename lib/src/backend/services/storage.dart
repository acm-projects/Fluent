import 'package:firebase_storage/firebase_storage.dart';

/// Fetches the URL for the image with the given [name].
Future<String> fetchImageUrl(String name) async {
  return FirebaseStorage.instance.ref('/images/$name.png').getDownloadURL();
}
