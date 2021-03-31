import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:fluent/src/backend/services/base/chat.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:flutter/material.dart';

import 'firebase/services.dart';

class ServicesProviderInit {
  static Widget create(WidgetBuilder builder) {
    return FutureBuilder<FirebaseServices>(
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
              builder: (context, currentUserSnapshot) {
                return AuthState(
                  currentUser: currentUserSnapshot.data,
                  child: ChatServiceProvider(
                    chatService: ChatService(currentUserSnapshot.data, firestoreSnapshot.data.database),
                    child: builder(context),
                  ),
                );
              },
            ),
          );
        }

        return Material(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
