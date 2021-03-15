import 'package:fluent/src/backend/services/firebase.dart' as Firebase;
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/theme/style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AppInit());
}

class InitData {}

class AppInit extends StatelessWidget {
  Future<InitData> init() async {
    await Future.wait(<Future>[
      Firebase.init(),
    ]);

    return InitData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InitData>(
        future: init(),
        builder: (context, snapshot) {
          app(Widget home) {
            return MaterialApp(
              title: 'Fluent Application',
              theme: theme,
              //home: home,
              // '/' is the name of the route to the home page
                initialRoute: '/',
                routes: {
                  // when navigating to the '/' route, build the AppInit() widget
                  '/': (context) {
                    return LoginPage();
                  },
                  // when navigating to the '/signUp' route, build the SignUpPage() widget
                  '/signUp': (context) => SignUpPage(),
                }
            );
          }

          if (snapshot.hasError) {
            return app(ErrorPage(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return app(LoginPage());
            //return app(MyHomePage(title: 'Flutter Demo Home Page'));
          }

          return app(LoadingPage()); // todo: Implement loading screen
        });
  }
}
