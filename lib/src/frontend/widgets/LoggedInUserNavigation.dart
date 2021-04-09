import 'package:flutter/material.dart';
import 'package:fluent/src/frontend/pages.dart';

class BottomNavBar extends StatefulWidget {
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
      MatchRequestPage(),
      InboxScreen(),
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
