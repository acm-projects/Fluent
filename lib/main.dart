import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/services_provider.dart';
import 'package:fluent/src/frontend/routes.dart';
import 'package:fluent/src/frontend/theme/style.dart';
import 'package:fluent/src/frontend/widgets/ChatScreen.dart';
import 'package:fluent/src/frontend/widgets/LoggedInUserNavigation.dart';
import 'package:fluent/src/frontend/widgets/createProfile.dart';
import 'package:fluent/src/frontend/widgets/editProfile.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Fluent',
    theme: theme,
    home: AppInit(),
    debugShowCheckedModeBanner: false,
  ));
}

class AppInit extends StatelessWidget {
  static RouteFactory _page(Widget Function(RouteSettings) builder) =>
      (RouteSettings settings) => MaterialPageRoute(
          settings: settings, builder: (context) => builder(settings));

  static final _routes = <String, RouteFactory>{
    Routes.login: _page((_) => LoginPage()),
    Routes.signUp: _page((_) => SignUpPage()),
    Routes.editProfile:
        _page((settings) => EditProfilePage(pfp: settings.arguments as String)),
    Routes.createProfile: _page((_) => CreateProfilePage()),
    Routes.chat:
        _page((settings) => ChatScreen(chatUser: settings.arguments as User)),
    Routes.home:
        _page((settings) => BottomNavBar(pfp: settings.arguments as String)),
  };

  @override
  Widget build(BuildContext context) {
    return createServicesProvider((context) {
      return Navigator(
        initialRoute: Routes.login,
        onGenerateRoute: (settings) {
          if (_routes.containsKey(settings.name)) {
            return _routes[settings.name](settings);
          } else {
            throw 'Undefined route: ${settings.name}';
          }
        },
      );
    });
  }
}
