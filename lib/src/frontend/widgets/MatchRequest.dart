import 'package:fluent/src/backend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluent/src/frontend/widgets/SearchAndUserIcon.dart';
// later the actual user model will be imported to get the actual user's data
import 'package:fluent/src/frontend/frontendmodels/UITestMessageModel.dart';
import 'package:fluent/src/frontend/widgets/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class MatchRequestPage extends StatefulWidget {
  @override
  _MatchRequestPageState createState() => _MatchRequestPageState();
}

class _MatchRequestPageState extends State<MatchRequestPage> {
  //int set = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('profiles')
                .doc(auth.FirebaseAuth.instance.currentUser.uid)
                .collection('selected')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                    child: Container(
                      // with constraints we are getting the height of the phone screen so that
                      // SingleChildScrollView won't try to go infinitely vertical
                        constraints: BoxConstraints(
                            maxHeight:
                            MediaQuery.of(context).size.height - 35),
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                        child: Column(
                          // the MainAxisSize.min will tell the Column to be as small as its children will allow
                          // This is the 1st step to prevent “RenderFlex children have non-zero flex but incoming height constraints are unbounded,”
                          // which means we are preventing the SearchAndUserIcon from expanding infinitely,
                          // we are trying to put restraints on it so that the child can't do that
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // 2nd step to prevent the error. Wrap the child in an Expanded so that it can't extend infinitely.
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 2,
                                child: SearchAndUserIcon(),
                              ),

                              // for the user's picture, name, text message display, timestamp, etc.
                              Flexible(
                                  fit: FlexFit.loose,
                                  flex: 12,
                                  child: ListView.separated(
                                      separatorBuilder: (context, builder) => Divider(
                                        color: Colors.black,
                                      ),
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        // change this object to backend stuff
                                        final Message messages =
                                        chats[index];
                                        return GestureDetector(
                                          onTap: () {
                                            // this will let you tap to the next page, this will be changed once
                                            // routes are implemented again
                                            Navigator.pushNamed(context, '/chat', arguments: User(snapshot.data.docs[index].id));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 0.0),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                  EdgeInsets.all(2.0),
                                                  // if the message is unread, show blue border
                                                  decoration: messages
                                                      .unread
                                                      ? BoxDecoration(
                                                    // Note that the border should only appear around the user whose messages
                                                    // you haven't read yet
                                                    borderRadius: BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        40)),
                                                    border:
                                                    Border.all(
                                                      width: 2,
                                                      color: Colors
                                                          .lightBlue[
                                                      400],
                                                    ),
                                                    // if you've read their messages, show the boxShape only with no border
                                                    //shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey
                                                            .withOpacity(
                                                            0.3),
                                                        spreadRadius:
                                                        2,
                                                        blurRadius: 5,
                                                      ),
                                                    ],
                                                    // otherwise, don't show the blue border
                                                  )
                                                      : BoxDecoration(
                                                    // if you've read their messages, show the boxShape only with no border
                                                    shape: BoxShape
                                                        .circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey
                                                            .withOpacity(
                                                            0.3),
                                                        spreadRadius:
                                                        1,
                                                        blurRadius: 3,
                                                      ),
                                                    ],
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage: NetworkImage(snapshot.data.docs[index]['pfp']),
                                                  ),
                                                ),

                                                // this next container is for the username
                                                Container(
                                                  width:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.65,
                                                  padding:
                                                  EdgeInsets.fromLTRB(
                                                      20.0, 0, 0, 0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Text(snapshot.data.docs[index]['name'],
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  16.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      // For formatting the latest text and time
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            // Text is wrapped in Flexible Widget so that it will follow the container's
                                                            // dimensions and not overflow to the right
                                                            Flexible(
                                                              child: Text(
                                                                " ", //messages.text,
                                                                // this is so that once it reaches 2 lines, it will put an ellipses after the text
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 2,
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                ),
                                                              ),
                                                            ),
                                                            // put an extra space in the front of the time text for formatting purposes
                                                            Text(
                                                                "messages.time",
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  11.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                                  color: Colors
                                                                      .grey[
                                                                  600],
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }))
                            ])));
              }
            }),

        /*bottomNavigationBar: BottomNavigationBar(
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
            onTap: (index) {
              setState(() {
                set = index;
              });
            }
        ),*/
      ),
    );

  }
}
