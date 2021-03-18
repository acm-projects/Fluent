import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent/src/backend/services/base/database.dart';

class FirestoreDocSnap implements DocSnap {
  final DocumentSnapshot _snap;

  FirestoreDocSnap._(this._snap);

  @override
  dynamic get(String field) => _snap.get(field);
}

class FirestoreDocRef implements DocRef {
  final DocumentReference _ref;

  FirestoreDocRef._(this._ref);

  @override
  Future<DocSnap> get() => _ref.get().then((snap) => FirestoreDocSnap._(snap));

  @override
  Future<void> set(Map<String, dynamic> fields) => _ref.set(fields);
}

class FirestoreCollectionRef implements CollectionRef {
  final CollectionReference _ref;

  FirestoreCollectionRef._(this._ref);

  @override
  DocRef doc(String path) => FirestoreDocRef._(_ref.doc(path));
}

class FirestoreDatabaseService implements DatabaseService {
  final FirebaseFirestore _firestore;

  FirestoreDatabaseService._(this._firestore);

  factory FirestoreDatabaseService.initialize(FirebaseApp app) {
    return FirestoreDatabaseService._(FirebaseFirestore.instanceFor(app: app));
  }

  @override
  CollectionRef collection(String path) =>
      FirestoreCollectionRef._(_firestore.collection(path));
}
