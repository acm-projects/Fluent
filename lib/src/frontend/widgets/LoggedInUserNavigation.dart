import 'package:fluent/src/backend/models/match.dart';
import 'package:flutter/material.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:fluent/src/backend/models/match.dart';

class BottomNavBar extends StatefulWidget {
  // This wil  // final MatchProfile currentUser;
  //   //
  //   // // constructor for ChatScreen to initialize the User
  //   // BottomNavBar({this.currentUser});l be replaced with user for backend in order to fetch the proper picture and info for a chat screen

  final String pfp;
  BottomNavBar({Key key, @required this.pfp}) : super(key: key);

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

    final List<Widget> _navBarPages = [
      MatchingPage.create(context),
      MatchRequestPage(pfp: widget.pfp),
      InboxScreen(pfp: widget.pfp),
    ];


    return Scaffold(
      body: _navBarPages[set],
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
