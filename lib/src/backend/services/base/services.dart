import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:fluent/src/backend/services/base/profiles.dart';
import 'package:fluent/src/backend/services/base/storage.dart';
import 'package:flutter/widgets.dart';

class Services {
  StorageService storage;
  AuthService auth;
  FirebaseFirestore database;
  ProfilesService profiles;

  Services({
    @required this.storage,
    @required this.auth,
    @required this.database,
    ProfilesService profiles,
  }) : this.profiles = profiles ?? ProfilesService.initialize(database, storage);
}

class ServicesProvider extends InheritedWidget {
  final Services services;

  ServicesProvider({
    Key key,
    @required this.services,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ServicesProvider old) {
    return services != old.services;
  }

  static ServicesProvider of(BuildContext context) {
    final ServicesProvider result = context.dependOnInheritedWidgetOfExactType<ServicesProvider>();
    assert(result != null, 'No ServicesProvider found in context');
    return result;
  }
}
