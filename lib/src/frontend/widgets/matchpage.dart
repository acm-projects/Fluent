import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchingPage extends StatefulWidget {
  static Widget create(BuildContext context) {
    final matching = ServicesProvider.of(context).services.matching;
    return FutureBuilder(
      future: matching.getUsers(
          FirebaseAuth.instance.currentUser.uid), //filled in actural UID instead of future function
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return MatchingPage(
                snapshot.data[0].pfp,
                snapshot.data[0].uid,
                snapshot.data[0].name,
                snapshot.data[0].bio,
                snapshot.data[0].gender);
          } else {
            return Center(child: Text("No users found."));
          }
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
    print(potentialBio);
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
          child: Align(
            alignment: Alignment.centerLeft,
          child: TextFormField(
            onChanged: (val) {
              setState(() => search = val);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(90.0)),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              //filled: true,
            ),
          ),),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage('$potentialPFP'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Flexible(
                                  flex:10,
                                  child: Text(
                                    ' $potentialName, $potentialGender',
                                    style: TextStyle(
                                        fontFamily: 'AirbnbCerealBold',
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    //TextStyle(height: 2, fontSize: 20),

                                    // textScaleFactor: 1.8, style:
                                    // TextStyle(color: Colors.blue)),
                                  ),
                                ),
                                Flexible(
                                    flex: 2,
                                    child: Center(
                                        child: Container(
                                            // adding margin
                                            margin: const EdgeInsets.only(left:5.0, right: 5.0),
                                            // adding padding
                                            padding: const EdgeInsets.all(3.0),
                                            child: Expanded(
                                              child: SingleChildScrollView(
                                                  child:
                                                      Column(children: <Widget>[

                                                  Text(
                                                    '$potentialBio',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'AirbnbCereal',
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white),
                                                    //TextStyle(height: 2, fontSize: 20),
                                                    // textScaleFactor: 1.8, style:
                                                    // TextStyle(color: Colors.blue)),
                                                  ),
                                              ])),
                                            )))),
                                SizedBox(height: 10),
                              ])),
                    ]),
                    elevation: 10)),
            Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Row contents horizontally,
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
                          FirebaseAuth.instance.currentUser.uid, potentialUID);

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
