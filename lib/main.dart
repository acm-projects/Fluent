import 'package:fluent/src/backend/services/services_provider.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/theme/style.dart';
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
    return ServicesProviderInit.create((context) {
      return Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          page(child) => MaterialPageRoute(builder: (context) => child);

          switch (settings.name) {
            case '/':
              return page(LoginPage());
            case '/signUp':
              return page(SignUpPage());
            default:
              throw 'Undefined route ${settings.name}';
          }
        },
      );
    });
  }
}
