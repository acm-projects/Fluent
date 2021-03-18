import 'package:fluent/src/backend/services/base/services.dart';
import 'package:fluent/src/backend/services/firebase/services.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/theme/style.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Fluent',
    theme: theme,
    home: FutureBuilder<FirebaseServices>(
      future: FirebaseServices.initialize(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Material(child: Center(child: Text('An error occurred.')));
        }

        if (snapshot.hasData) {
          return ServicesProvider(
            services: Services(
              storage: snapshot.data.storage,
              auth: snapshot.data.auth,
              database: snapshot.data.database,
            ),
            child: AppInit(),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    ),
  ));
}

class AppInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
