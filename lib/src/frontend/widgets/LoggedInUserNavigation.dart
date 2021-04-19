import 'package:fluent/src/backend/models/match.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  // final MatchProfile currentUser;
  //   //
  //   // // constructor for ChatScreen to initialize the User
  //   // BottomNavBar({this.currentUser});

  MatchProfile currentUser;
  //final String pfp;
  BottomNavBar({Key key, @required this.currentUser}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int set = 0;

  _onTabTapped(int index) {
    setState(() {
      set = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    print(widget.currentUser.uid);

    final List<WidgetBuilder> _navBarPages = [
      (context) => MatchingPage.create(context),
      (context) => MatchRequestPage(currentUser: widget.currentUser),
      (context) => InboxScreen(currentUser: widget.currentUser),
    ];

    return Scaffold(
      body: _navBarPages[set](context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: set,
        items:[
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Match')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism),
              title: Text('Match Requests')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text('Inbox')
          ),
        ],
        onTap: _onTabTapped,
      ),
    );
  }
}