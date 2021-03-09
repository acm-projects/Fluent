import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/chat.dart';
import 'package:fluent/src/backend/models/fluency.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/chat.dart';
import 'package:fluent/src/backend/services/firebase.dart' as Firebase;
import 'package:fluent/src/backend/services/users.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/theme/style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AppInit());
}

class InitData {}

class AppInit extends StatelessWidget {
  Future<InitData> init() async {
    await Firebase.init(useEmulators: true);

    Future<void> registerOrSignIn({
      @required String email,
      @required String password,
    }) async {
      try {
        await register(email: email, password: password);
      } catch (e) {
        await signIn(email: email, password: password);
      }
    }

    await registerOrSignIn(
        email: 'test1@example.com', password: 'test1@example.com');
    var test1 = CurrentUser.instance.ref;
    var test1profile = await Profile.create(
      uid: test1.uid,
      username: 'testuser1',
      name: 'Test User1',
      birthDate: Timestamp.fromDate(DateTime.parse('1990-01-01')),
      gender: '',
      bio: 'I am a very cool test user!',
      language: 'es',
      fluency: Fluency.Advanced,
    );

    await registerOrSignIn(
        email: 'test2@example.com', password: 'test2@example.com');
    var test2 = CurrentUser.instance.ref;
    var test2profile = await Profile.create(
      uid: test2.uid,
      username: 'testuser2',
      name: 'Test User2',
      birthDate: Timestamp.fromDate(DateTime.parse('1992-02-26')),
      gender: '',
      bio: 'I am also a very cool test user!',
      language: 'es',
      fluency: Fluency.Intermediate,
    );

    await registerOrSignIn(
        email: 'test3@example.com', password: 'test3@example.com');
    var test3 = CurrentUser.instance.ref;
    var test3profile = await Profile.create(
      uid: test3.uid,
      username: 'testuser3',
      name: 'Test User3',
      birthDate: Timestamp.fromDate(DateTime.parse('1989-07-13')),
      gender: '',
      bio: 'I am the third very cool test user!',
      language: 'es',
      fluency: Fluency.Advanced,
    );

    var chat = await createChatWith([test1]);

    await chat.sendMessage('hello world!');

    await registerOrSignIn(
        email: 'test1@example.com', password: 'test1@example.com');

    await Future.delayed(
        Duration(seconds: 2), () => chat.sendMessage('world hello!'));

    var messages = await chat.fetchMessages(2);
    for (var message in messages) {
      print(message.content);
    }

    await registerOrSignIn(
        email: 'test2@example.com', password: 'test2@example.com');

    try {
      var chat2 = ChatRef(chat.uid);
      var messages2 = await chat2.fetchMessages(2);
      for (var message in messages2) {
        print('snooping found ${message.content}');
      }
    } catch (e) {
      print('caught $e :(');
    }

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
              home: home,
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
