import 'package:fluent/src/backend/services/base/services.dart';
import 'package:fluent/src/backend/services/firebase/services.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/theme/style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FutureBuilder<FirebaseServices>(
    future: FirebaseServices.initialize(),
    builder: (_, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('An error occurred.'));
      }

      if (snapshot.hasData) {
        return ServicesProvider(
          services: snapshot.data,
          child: AppInit(),
        );
      }

      return Center(child: Text('Loading'));
    },
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
