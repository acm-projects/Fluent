import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/services_provider.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/theme/style.dart';
import 'package:fluent/src/frontend/widgets/InboxScreen.dart';
import 'package:fluent/src/frontend/widgets/LoggedInUserNavigation.dart';
import 'package:fluent/src/frontend/widgets/MatchRequestCard.dart';
import 'package:fluent/src/frontend/widgets/createProfile.dart';
import 'package:fluent/src/frontend/widgets/ChatScreen.dart';
import 'package:fluent/src/frontend/widgets/editProfile.dart';
import 'package:fluent/src/frontend/widgets/matchpage.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Fluent',
    theme: theme,
    home: AppInit(),
  ));
}

class AppInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return createServicesProvider((context) {

      return Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          page(child) => MaterialPageRoute(builder: (context) => child);

          switch (settings.name) {
            case '/':
              return page(LoginPage());
            case '/signUp':
              return page(SignUpPage());
            case '/editProfile':
              return page(EditProfilePage());
            case '/createProfile':
              return page(CreateProfilePage());
            case '/inbox':
              return page(InboxScreen());
            case '/chat':
              return page(ChatScreen(chatUser: settings.arguments as User));
            case '/match':
              //return page(MatchingPage());
              return page(MatchingPage.create(context));
            case '/navigation':
              return page(BottomNavBar());


            default:
              throw 'Undefined route ${settings.name}';
          }
        },
      );
    });
  }
}
