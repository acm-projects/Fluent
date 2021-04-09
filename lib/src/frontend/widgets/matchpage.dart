import 'package:fluent/src/backend/services/base/services.dart';
import 'package:fluent/src/frontend/pages.dart';
import 'package:fluent/src/frontend/widgets/MatchRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MatchingPage extends StatefulWidget{
  static Widget create(BuildContext context) {
    final matching = ServicesProvider.of(context).services.matching;
    return FutureBuilder(
      future: matching.getUsers(FirebaseAuth.instance.currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          return MatchingPage(snapshot.data[0].pfp, snapshot.data[0].uid, snapshot.data[0].name, snapshot.data[0].bio, snapshot.data[0].gender);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  String potentialPFP;
  String potentialUID;
  String potentialName;
  String potentialBio;
  String potentialGender;

  MatchingPage(this.potentialPFP, this.potentialUID, this.potentialName, this.potentialBio, this.potentialGender);

  @override
  _MatchingPage createState() => _MatchingPage(potentialPFP, potentialUID, potentialName, potentialBio, potentialGender);
}

class _MatchingPage extends State<MatchingPage>{

  String potentialPFP;
  String potentialUID;
  String potentialName;
  String potentialBio;
  String potentialGender;
  var user;
  String search;

  _MatchingPage(this.potentialPFP, this.potentialUID, this.potentialName, this.potentialBio, this.potentialGender);

  /*int set = 0;
  final List<Widget> _navBarPages = [
    InboxScreen(),
    //MatchingPage(potentialPFP, potentialUID, potentialName, potentialBio, potentialGender),
    MatchRequestPage(),
    InboxScreen(),
  ];

  _onTabTapped(int index) {
    setState(() {
      set = index;
    });
  }*/

  Widget build(BuildContext context) {
    final matching = ServicesProvider.of(context).services.matching;
    //while (user == null) {
      //return Center(child: CircularProgressIndicator());
    //}

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child:
                  TextFormField(
                    onChanged: (val) {
                      setState(() => search = val);
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      user = await matching.searchUser(search);
                      setState(() {
                        potentialUID = user[0].uid;
                        potentialName = user[0].name;
                        potentialGender = user[0].gender;
                        potentialBio = user[0].bio;
                      });
                    },
                    child: Text("Search")
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                      child: Text("Potential Matches",
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.blue))
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Center(
                    child: Text(
                        "$potentialUID $potentialName $potentialBio $potentialGender $potentialPFP",
                        textScaleFactor: 1.8, style:
                    TextStyle(color: Colors.blue)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                    child: Text(
                      'Send Like',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      user = await matching.chooseUser(potentialUID);
                      setState(() {
                        potentialUID = user[0].uid;
                        potentialName = user[0].name;
                        potentialGender = user[0].gender;
                        potentialBio = user[0].bio;
                        potentialPFP = user[0].pfp;
                      });
                      await matching.getMatches(user[0]);
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text(
                    'Send dislike',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    user = await matching.skipUser(FirebaseAuth.instance.currentUser.uid, user[0].uid);
                    setState(() {
                      potentialUID = user[0].uid;
                      potentialName = user[0].name;
                      potentialGender = user[0].gender;
                      potentialBio = user[0].bio;
                    });
                  },
                ),
              ]
          ),
        ),

      /*bottomNavigationBar: BottomNavigationBar(
          //currentIndex: set,
          items:[
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                title: Text('Match'),

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
      ),*/
    );
  }
}
