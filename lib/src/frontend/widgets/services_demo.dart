import 'dart:async';
import 'dart:math';

import 'package:fluent/src/backend/models/chat.dart';
import 'package:fluent/src/backend/models/fluency.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:fluent/src/backend/services/base/chat.dart';
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

    Future<String> register(String user) async {
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

        return uid;
      } catch (e) {
        return auth.signIn(email: email, password: email);
      }
    }

    final chatService = ChatServiceProvider.of(context).chatService;

    return FutureBuilder<String>(
      future: (() async {
        var userA = await register('A');
        var userB = await register('B');

        var chat = await chatService.createChatWith(User(userA));
        return chat.uid;
      })(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Material(
            child: Center(
              child: Column(children: [
                Text('Error in ServicesDemo'),
                Text(snapshot.error.toString()),
              ]),
            ),
          );
        }

        if (snapshot.hasData) {
          return FutureBuilder<ChatSnap>(
            future: chatService.fetchChat(snapshot.data),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error in ServicesDemo.'));
              }

              if (snapshot.hasData) {
                return _CurrentChatProvider(
                  currentChat: snapshot.data,
                  child: _ServicesDemoPages(),
                );
              }

              return Material(child: Center(child: CircularProgressIndicator()));
            },
          );
        }

        return Material(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class _CurrentChatProvider extends InheritedWidget {
  final ChatSnap currentChat;

  _CurrentChatProvider({
    Key key,
    @required this.currentChat,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CurrentChatProvider old) => currentChat != old.currentChat;

  static _CurrentChatProvider of(BuildContext context) {
    final _CurrentChatProvider result = context.dependOnInheritedWidgetOfExactType<_CurrentChatProvider>();
    assert(result != null, 'No _CurrentChatProvider found in context');
    return result;
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
    NavPage(
      builder: (context) => _DemoChatPage(),
      navItem: BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
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

class _DemoChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [_MessageList(), _SendMessageButtons()]);
  }
}

class _MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatService = ChatServiceProvider.of(context).chatService;
    final currentChat = _CurrentChatProvider.of(context).currentChat;

    Future<Map<String, Profile>> fetchMemberProfiles() {
      final profiles = ServicesProvider.of(context).services.profiles;

      return Future.wait(currentChat.members.map((member) => profiles.fetchProfile(member.uid)))
          .then((profiles) => Map.fromIterables(currentChat.members.map((member) => member.uid), profiles));
    }

    return FutureBuilder<Map<String, Profile>>(
      future: fetchMemberProfiles(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error in _MessageList>FutureBuilder'));
        }

        if (snapshot.hasData) {
          final profileCache = snapshot.data;

          return StreamBuilder<Iterable<Message>>(
            stream: chatService.messages(currentChat.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error in _MessageList>FutureBuilder>StreamBuilder.'));
              }

              if (snapshot.hasData) {
                Widget formatMessage(Message message) {
                  final authorProfile = profileCache[message.author.uid];

                  return Text('${authorProfile.name}: ${message.content}');
                }

                return Column(
                    children: snapshot.data.map(formatMessage).toList(growable: false),
                    verticalDirection: VerticalDirection.up);
              }

              return Center(child: CircularProgressIndicator());
            },
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _SendMessageButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> send(String content) {
      final chatService = ChatServiceProvider.of(context).chatService;
      final currentChat = _CurrentChatProvider.of(context).currentChat;

      return chatService.sendMessage(currentChat.uid, content);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(child: Text('Send X'), onPressed: () => send('X')),
        ElevatedButton(child: Text('Send Y'), onPressed: () => send('Y')),
      ],
    );
  }
}
