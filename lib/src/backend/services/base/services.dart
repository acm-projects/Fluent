import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:fluent/src/backend/services/base/profiles.dart';
import 'package:fluent/src/backend/services/base/storage.dart';
import 'package:flutter/widgets.dart';

abstract class Services {
  StorageService get storage;
  AuthService get auth;
  ProfilesService get profiles;
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
    if (services != old.services) {
      throw Exception('Services must be constant!');
    }
    return false;
  }

  static ServicesProvider of(BuildContext context) {
    final ServicesProvider result =
        context.dependOnInheritedWidgetOfExactType<ServicesProvider>();
    assert(result != null, 'No ServicesProvider found in context');
    return result;
  }
}
