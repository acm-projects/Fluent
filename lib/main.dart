import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:fluent/src/backend/services/firebase/services.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/theme/style.dart';
import 'package:fluent/src/frontend/widgets/editProfile.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Fluent',
    theme: theme,
    home: FutureBuilder<FirebaseServices>(
      future: FirebaseServices.initialize(),
      builder: (_, firestoreSnapshot) {
        if (firestoreSnapshot.hasError) {
          return Material(child: Center(child: Text('An error occurred.')));
        }

        if (firestoreSnapshot.hasData) {
          return ServicesProvider(
            services: Services(
              storage: firestoreSnapshot.data.storage,
              auth: firestoreSnapshot.data.auth,
              database: firestoreSnapshot.data.database,
            ),
            child: StreamBuilder<CurrentUser>(
              stream: firestoreSnapshot.data.auth.currentUser,
              builder: (_, currentUserSnapshot) {
                return AuthState(
                  currentUser: currentUserSnapshot.data,
                  child: EditProfilePage(),
                );
              },
            ),
          );
        }

        return Material(child: Center(child: CircularProgressIndicator()));
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
