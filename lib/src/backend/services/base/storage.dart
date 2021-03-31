abstract class StorageService {
  StorageService._();

  /// Fetches the URL for the image with the given [fileName].
  Future<String> fetchImageUrl(String fileName);
}
