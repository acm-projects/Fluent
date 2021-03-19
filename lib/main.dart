import 'package:fluent/src/backend/services/firebase.dart' as Firebase;
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/theme/style.dart';
import 'package:fluent/src/frontend/widgets/matchpage.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.init();
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
              title: 'Flutter Demo',
              theme: theme,
              home: MatchingPage(),
            );
          }

          if (snapshot.hasError) {
            return app(ErrorPage(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return app(MyHomePage(title: 'Flutter Demo Home Page'));
          }

          return app(LoadingPage()); // todo: Implement loading screen
        });
  }
}
