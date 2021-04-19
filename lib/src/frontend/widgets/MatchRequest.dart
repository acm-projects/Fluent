import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:fluent/src/backend/models/match.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:fluent/src/frontend/routes.dart';
import 'package:flutter/material.dart';

class MatchRequestPage extends StatefulWidget {
  //final String pfp;
  MatchProfile currentUser;
  MatchRequestPage({Key key, @required this.currentUser}) : super(key: key);
  @override
  _MatchRequestPage createState() => _MatchRequestPage();
}

class Post {
  final String name;
  Post(this.name);
}

class _MatchRequestPage extends State<MatchRequestPage> {
  // int set = 0;
  List<Post> MatchNames = [];

  final SearchBarController<Post> _searchBarController = SearchBarController();

  Future<List<Post>> _getALlPosts(String text) async {
    List<Post> posts = MatchNames
        .where((element) =>
        element.name.contains(text))
        .toList();
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthState.of(context).currentUser;
    if (currentUser == null) {
      return Container(width: 0, height: 0);; // should only happen when logging out
    }

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
                .doc(currentUser.uid)
                .collection('selected')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              final matching = ServicesProvider.of(context).services.matching;

              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                    child: Container(
                      // with constraints we are getting the height of the phone screen so that
                      // SingleChildScrollView won't try to go infinitely vertical
                        constraints: BoxConstraints(
                            maxHeight:
                            MediaQuery
                                .of(context)
                                .size
                                .height - 35),
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
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 2,
                                        //child: Icon(
                                        //Icons.search,
                                        child: SearchBar<Post>(
                                          onSearch: _getALlPosts,
                                          searchBarController: _searchBarController,
                                          hintText: "Search user",
                                          onItemFound: (Post post, int index) {
                                            return Container(
                                              color: Colors.lightBlue,
                                              child: ListTile(
                                                title: Text(post.name),
                                                isThreeLine: true,
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          Detail()));
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      //),
                                      Flexible(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              // Navigator should go here. It should navigate to the EditProfile page
                                              Navigator.pushNamed(
                                                context,
                                                Routes.editProfile,
                                                arguments: widget.currentUser,
                                              );
                                            },
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                      ),
                                                    ],
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          widget.currentUser.pfp),
                                                    ))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),

                              // for the user's picture, name, text message display, timestamp, etc.
                              Flexible(
                                  fit: FlexFit.loose,
                                  flex: 12,
                                  child: ListView.separated(
                                      separatorBuilder: (context, builder) =>
                                          Divider(
                                            color: Colors.black,
                                          ),
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        MatchNames.add(Post(snapshot.data.docs[index]['name']));
                                        // change this object to backend stuff
                                        //final Message messages =
                                        //chats[index];
                                        return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 0.0),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                  EdgeInsets.all(2.0),
                                                  // if the message is unread, show blue border
                                                  decoration: BoxDecoration(
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
                                                    backgroundImage: NetworkImage(
                                                        snapshot.data
                                                            .docs[index]['pfp']),
                                                  ),
                                                ),

                                                // this next container is for the username
                                                Container(
                                                  width:
                                                  MediaQuery
                                                      .of(context)
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
                                                            child: Text(
                                                                snapshot.data
                                                                    .docs[index]['name'],
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
                                                      // Next row which contains all the buttons
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: IconButton(
                                                                  icon: new Icon(
                                                                    Icons.thumb_up,
                                                                    size: 30.0,
                                                                    color: Colors.green,
                                                                  ),

                                                                  // creates chat with user and takes them to the chat page
                                                                  onPressed: () async {
                                                                    await matching.chooseUser(
                                                                        snapshot.data.docs[index]['uid'], snapshot.data.docs[index]['name'], snapshot.data.docs[index]['pfp']);
                                                                    // This takes them to the chat page for the user
                                                                    Navigator.pushNamed(context, Routes.chat,
                                                                        arguments: User(snapshot
                                                                            .data.docs[index].id));
                                                                  }
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: IconButton(
                                                                  icon: new Icon(
                                                                    Icons.thumb_down,
                                                                    size: 30.0,
                                                                    color: Colors.red,
                                                                  ),

                                                                  // removes them from the list
                                                                  onPressed: () async {
                                                                    await matching.skipUser(
                                                                        snapshot.data.docs[index]['pfp'], snapshot.data.docs[index]['name']);
                                                                    //MatchNames.remove(Post(snapshot.data.docs[index]));
                                                                  }
                                                              ),
                                                            ),
                                                            SizedBox(width: 10.0),
                                                            ElevatedButton(
                                                              onPressed: () {},
                                                              child: Text('Profile',
                                                                style: TextStyle(
                                                                  fontSize: 14.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                primary: Colors.lightBlue[400],
                                                                minimumSize: Size(50,20),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                      }))
                            ])));
              }
            }),
      ),
    );
  }
}
class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}

