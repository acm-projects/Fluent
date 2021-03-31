import 'package:fluent/src/backend/services/matching.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MatchingPage extends StatefulWidget{
  @override
  _MatchingPage createState() => _MatchingPage();
}

class _MatchingPage extends State<MatchingPage>{
  String potentialName = " ";
  String potentialLanguage = " ";
  int potentialFluency;
  var user;
  String search;
  String testUser = "test1";

  @override
  void initState(){
    super.initState();
    asyncMethod();
  }
  void asyncMethod() async{
    user = await GetMatches().getUsers(testUser);
    setState(() {
      potentialName = user[0].name;
      potentialFluency = user[0].fluency;
      potentialLanguage = user[0].language;
    });
  }
  Widget build(BuildContext context) {
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
                    user = await GetMatches().searchUser(search);
                    //print(user[0].name);
                    setState(() {
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
                      "$potentialName $potentialLanguage $potentialFluency",
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
                    user =
                    await GetMatches().chooseUser(testUser, user[0].name);
                    setState(() {
                      potentialName = user[0].name;
                      potentialFluency = user[0].fluency;
                      potentialLanguage = user[0].language;
                    });
                    await GetMatches().getMatches(testUser);
                  },
                ),
              ),
              ElevatedButton(
                child: Text(
                  'Send dislike',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  user = await GetMatches().skipUser(testUser, user[0].name);
                  setState(() {
                    potentialName = user[0].name;
                    potentialFluency = user[0].fluency;
                    potentialLanguage = user[0].language;
                  });
                },
              ),
            ]
        )
    );
  }
}