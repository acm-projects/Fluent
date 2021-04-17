import 'package:fluent/src/backend/models/match.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MatchingPage extends StatefulWidget {
  static Widget create(BuildContext context) {
    final matching = ServicesProvider.of(context).services.matching;
    return FutureBuilder(
      future: matching.getUsers(
          "NAOk72rUNdeRKOmCps4wTY6sbhe2"), //filled in actural UID instead of future function
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          return MatchingPage(
              snapshot.data[0].pfp,
              snapshot.data[0].uid,
              snapshot.data[0].name,
              snapshot.data[0].bio,
              snapshot.data[0].gender);
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

  MatchingPage(this.potentialPFP, this.potentialUID, this.potentialName,
      this.potentialBio, this.potentialGender);

  @override
  _MatchingPage createState() => _MatchingPage(
      potentialPFP, potentialUID, potentialName, potentialBio, potentialGender);
}

class _MatchingPage extends State<MatchingPage> {
  String potentialPFP;
  String potentialUID;
  String potentialName;
  String potentialBio;
  String potentialGender;
  var user;
  String search;

  _MatchingPage(this.potentialPFP, this.potentialUID, this.potentialName,
      this.potentialBio, this.potentialGender);

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final matching = ServicesProvider.of(context).services.matching;
    //while (user == null) {
    //return Center(child: CircularProgressIndicator());
    //}
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.black, size: 30),
              onPressed: () async {
                user = await matching.searchUser(search);
                setState(() {
                  potentialUID = user[0].uid;
                  potentialName = user[0].name;
                  potentialGender = user[0].gender;
                  potentialBio = user[0].bio;
                  potentialPFP = user[0].pfp;
                });
              },
            ),
          ],
          title: Container(
            height: 40,
            width: 280,
            alignment: Alignment.topRight,
            color: Colors.transparent,
            child: TextFormField(
              onChanged: (val) {
                setState(() => search = val);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(const Radius.circular(90.0)),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                //filled: true,
              ),
            ),
          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Container(
                height: size.height * .6,
                width: size.width * .95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFBFBFC),
                ),
                child: Card(
                    child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(40),
                        width: 800,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage('$potentialPFP'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(children: <Widget>[
                            Text(
                              '$potentialName',
                              style: TextStyle(height: 2, fontSize: 20),

                              // textScaleFactor: 1.8, style:
                              // TextStyle(color: Colors.blue)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 100.0),
                              child: Container(
                                height: 1.0,
                                width: 10000000,
                                color: Colors.black12,
                              ),
                            ),
                            Text(
                              " $potentialGender",
                              style: TextStyle(height: 2, fontSize: 20),

                              // textScaleFactor: 1.8, style:
                              // TextStyle(color: Colors.blue)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 100.0),
                              child: Container(
                                height: 1.0,
                                width: 10000000,
                                color: Colors.black12,
                              ),
                            ),
                            Text(
                              '$potentialBio',
                              style: TextStyle(height: 2, fontSize: 20),

                              // textScaleFactor: 1.8, style:
                              // TextStyle(color: Colors.blue)),
                            ),
                          ])),
                    ]),
                    elevation: 10)),
            Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, //Center Row contents horizontally,
                children: <Widget>[
                  IconButton(
                    icon: new Icon(
                      Icons.thumb_up,
                      size: 40.0,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      user = await matching.chooseUser(
                          potentialUID, potentialName, potentialPFP);

                      setState(() {
                        potentialUID = user[0].uid;
                        potentialName = user[0].name;
                        potentialGender = user[0].gender;
                        potentialBio = user[0].bio;
                        potentialPFP = user[0].pfp;
                      });
                    },
                  ),
                  SizedBox(width: 50, height: 100),
                  IconButton(
                    icon: new Icon(
                      Icons.thumb_down,
                      size: 40.0,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      user = await matching.skipUser(
                          FirebaseAuth.instance.currentUser.uid, user[0].uid);

                      setState(() {
                        potentialUID = user[0].uid;
                        potentialName = user[0].name;
                        potentialGender = user[0].gender;
                        potentialBio = user[0].bio;
                        potentialPFP = user[0].pfp;
                      });
                    },
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
