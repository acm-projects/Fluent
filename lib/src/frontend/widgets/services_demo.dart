import 'dart:async';
import 'dart:math';

import 'package:fluent/src/backend/models/fluency.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServicesDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final services = ServicesProvider.of(context).services;
    final auth = services.auth;
    final profiles = services.profiles;

    final random = Random();

    Future<void> register(String user) async {
      final email = 'test_$user@example.com';
      try {
        var uid = await auth.register(email: email, password: email);

        var now = DateTime.now();

        await profiles.createProfile(
          uid: uid,
          username: 'user$user',
          name: 'User $user',
          birthDate: DateTime(now.year - random.nextInt(25) - 25, now.month, now.day),
          gender: '',
          bio: 'I am test user $user.\n\nThis is my multi-line bio!',
          language: 'es',
          fluency: Fluency.Intermediate,
        );
      } catch (e) {
        // already exists is fine
      }
    }

    return FutureBuilder<void>(
      future: Future.wait([register('A'), register('B')]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Material(
            child: Center(
              child: Column(children: [
                Text('An error occurred.'),
                Text(snapshot.error.toString()),
              ]),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return _ServicesDemoPages();
        }

        return Material(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class _ServicesDemoPages extends StatefulWidget {
  @override
  State createState() => _ServicesDemoPagesState();
}

class NavPage {
  WidgetBuilder builder;
  BottomNavigationBarItem navItem;

  NavPage({@required this.builder, @required this.navItem});
}

class _ServicesDemoPagesState extends State<_ServicesDemoPages> {
  int _selectedPage = 0;

  List<NavPage> _pages = [
    NavPage(
      builder: (context) => _DemoAuthPage(),
      navItem: BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Auth'),
    ),
    NavPage(
      builder: (context) => _DemoProfilePage(),
      navItem: BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Services Demo')),
      body: _pages[_selectedPage].builder(context),
      bottomNavigationBar: BottomNavigationBar(
        items: _pages.map((page) => page.navItem).toList(),
        currentIndex: _selectedPage,
        onTap: (index) => setState(() => _selectedPage = index),
      ),
    );
  }
}

class _DemoAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [_CurrentUserDisplay(), _SwitchUserButtons()],
    );
  }
}

class _CurrentUserDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthState.of(context).currentUser;
    if (currentUser == null) {
      return Text('Logged out.');
    } else {
      return Text('Logged in as ${currentUser.user.email}.');
    }
  }
}

class _SwitchUserButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = ServicesProvider.of(context).services.auth;

    Future<void> signIn(String account) => auth.signIn(email: account, password: account);
    Future<void> signOut() => auth.signOut();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(child: Text('User A'), onPressed: () => signIn('test_A@example.com')),
        ElevatedButton(child: Text('User B'), onPressed: () => signIn('test_B@example.com')),
        ElevatedButton(child: Text('Sign Out'), onPressed: () => signOut()),
      ],
    );
  }
}

class _DemoProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthState.of(context).currentUser;
    if (currentUser == null) {
      return Center(child: Text('Not logged in.'));
    }

    final profiles = ServicesProvider.of(context).services.profiles;

    return FutureBuilder<Profile>(
        future: profiles.fetchProfile(currentUser.user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            return _DemoProfile(snapshot.data);
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}

class _DemoProfile extends StatelessWidget {
  final Profile _profile;

  _DemoProfile(this._profile);

  @override
  Widget build(BuildContext context) {
    final profiles = ServicesProvider.of(context).services.profiles;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('${_profile.name} (${_profile.username})'),
          Text(_profile.bio),
          FutureBuilder<String>(
            future: profiles.fetchPictureUrl(_profile),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Icon(Icons.error);
              }

              if (snapshot.hasData) {
                return Image.network(snapshot.data);
              }

              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
