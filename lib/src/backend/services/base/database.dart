abstract class DocSnap {
  dynamic get(String field);
}

abstract class DocRef {
  Future<DocSnap> get();
  Future<void> set(Map<String, dynamic> fields);
}

abstract class CollectionRef {
  DocRef doc(String path);
}

abstract class DatabaseService {
  CollectionRef collection(String path);
}
