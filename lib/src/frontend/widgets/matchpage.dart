import 'package:fluent/src/backend/services/base/services.dart';
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
          return MatchingPage(snapshot.data[0].uid, snapshot.data[0].name, snapshot.data[0].language, snapshot.data[0].fluency);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  String potentialUID;
  String potentialName;
  String potentialLanguage;
  int potentialFluency;

  MatchingPage(this.potentialUID, this.potentialName, this.potentialLanguage, this.potentialFluency);

  @override
  _MatchingPage createState() => _MatchingPage(potentialUID, potentialName, potentialLanguage, potentialFluency);
}

class _MatchingPage extends State<MatchingPage>{
  String potentialUID;
  String potentialName;
  String potentialLanguage;
  int potentialFluency;
  var user;
  String search;

  _MatchingPage(this.potentialUID, this.potentialName, this.potentialLanguage, this.potentialFluency);

  Widget build(BuildContext context) {
    final matching = ServicesProvider.of(context).services.matching;
    //while (user == null) {
      //return Center(child: CircularProgressIndicator());
    //}
    return Scaffold(
        body: Column(
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
                      potentialFluency = user[0].fluency;
                      potentialLanguage = user[0].language;
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
                      "$potentialUID $potentialName $potentialLanguage $potentialFluency",
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
                    user = await matching.chooseUser(FirebaseAuth.instance.currentUser.uid, potentialUID);
                    setState(() {
                      potentialUID = user[0].uid;
                      potentialName = user[0].name;
                      potentialFluency = user[0].fluency;
                      potentialLanguage = user[0].language;
                    });
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
                    potentialName = user[0].name;
                    potentialFluency = user[0].fluency;
                    potentialLanguage = user[0].language;
                  });
                  //await matching.getMatches(FirebaseAuth.instance.currentUser.uid);
                },
              ),
            ]
        )
    );
  }
}
