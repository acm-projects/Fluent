import 'dart:async';

import 'package:fluent/src/backend/services/base/auth.dart';
import 'package:fluent/src/backend/services/base/chat.dart';
import 'package:fluent/src/backend/services/base/services.dart';
import 'package:flutter/material.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/models/chat.dart';

class ChatScreen extends StatefulWidget {
  // This will be replaced with user for backend in order to fetch the proper picture and info for a chat screen
  final User chatUser;

  // constructor for ChatScreen to initialize the User
  ChatScreen({this.chatUser});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // determines whether the user is blocked or not
  bool isBlocked;

  Widget _chatBubble(String chatUserProfileUrl, Message chatScreenMessages, bool isCurrentUser) {
    if (chatScreenMessages.timestamp == null) {
      return null;
    }

    return Column(
      children: <Widget>[
        // other user's chat box
        isCurrentUser == false ? Column(
          children: [
            Column(
              children: <Widget>[
                // wrapped in row so that image and text can be on same line
                Row(
                  children: <Widget>[
                    // USER IMAGE
                     Container(
                      padding: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(chatUserProfileUrl),
                      ),
                    ),

                    // CHAT BOX
                    Column(
                      children: [
                        Container(
                          //so that constraints can be placed so the text box won't take up
                          // the width of the screen
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .70,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 2),
                          child: Text(chatScreenMessages.content),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 40),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                  (chatScreenMessages.timestamp ?? DateTime.now()).toString(), //todo: display relative time (like 3 hours ago)
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
        ) :

        // YOUR CHAT BOX (NOT THE OTHER USER'S)
        Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              // wrapped in row so that image and text can be on same line
              child: Container(
                //so that constraints can be placed so the text box won't take up
                // the width of the screen
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .70,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.fromLTRB(10, 5, 10, 2),
                child: Text(chatScreenMessages.content,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightBlueAccent[400],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(right: 30),
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
              (chatScreenMessages.timestamp ?? DateTime.now()).toString(), //todo: display relative time (like 3 hours ago)
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // pop up notification to confirm blocking a user
  confirmBlock(BuildContext context) {
    final matching = ServicesProvider.of(context).services.matching;

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Are you really sure you want to block this user?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          MaterialButton(
              onPressed: () async {
                isBlocked = true;

                await matching.blockUser(widget.chatUser.uid);

                Navigator.pop(context);
              },
              child: Text("Yes",
              style: TextStyle(color: Colors.blue,
              fontSize: 18.0)),
          ),
          MaterialButton(
            onPressed: () {
              isBlocked = false;
              Navigator.pop(context);
            },
            child: Text("No",
            style: TextStyle(color: Colors.blue,
            fontSize: 18.0)),
          ),
        ]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ServicesProvider.of(context).services.profiles;
    final chat = ChatServiceProvider.of(context).chatService;
    final currentUser = AuthState.of(context).currentUser;

    // textController and ScrollController for when a message is sent
    TextEditingController _textController = TextEditingController();
    ScrollController _scrollController = ScrollController();

    // for the listbuilder to be able to detect consecutive messages from the same user
    //int consecutiveUserMessages = 0;
   // int consecutiveOtherMessages = 0;
    // to tap out of the chat box
    return FutureBuilder<List<dynamic>>(
        future: Future.wait([
          profiles.fetchPictureUrl(widget.chatUser),
          chat.fetchChatUidBetween(currentUser, widget.chatUser),
        ]),
        builder: (context, initialSnapshot) {
          if (!initialSnapshot.hasData) {
            return Center(child: CircularProgressIndicator()); //todo different on loading?
          }

          final chatUserProfileUrl = initialSnapshot.data[0] as String;
          //final chatUserProfileUrl = "https://firebasestorage.googleapis.com/v0/b/acm-fluent.appspot.com/o/uploads%2FHtFumEzDq1O5Z37x58xZ2bak9uE3?alt=media&token=e7671430-eca8-4de4-999c-e1920aa18883";
          final chatUid = initialSnapshot.data[1] as String;

          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if(!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 60,
                backgroundColor: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                elevation: 1,

                // centered user image
                centerTitle: true,
                title: GestureDetector(
                  onTap: () {
                    print("tapping the top user widget");
                    // OTHER USER'S PROFILE PAGE SHOULD GO HERE
                    // IT PROBABLY WON'T BE EDIT PROFILE
                    //Navigator.pushNamed(context, '/editProfile');
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(chatUserProfileUrl),
                  ),
                ),

                flexibleSpace: SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.lightBlueAccent[400],
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                          SizedBox(width: 180),
                          // button to block user
                          IconButton(
                            icon: Icon(
                              Icons.block,
                              size: 30,
                              color: Colors.lightBlueAccent[400],
                            ),
                            onPressed: () {
                              confirmBlock(context);
                              print(isBlocked);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              body: Column(
                children: <Widget>[
                  // have the chats expand to the entirety of the page (minus the bottom)
                  Expanded(
                      child: StreamBuilder<List<Message>>(
                          stream: chat.messages(chatUid),
                          builder: (context, messagesSnapshot) {
                            if (messagesSnapshot.hasError) {
                              print(messagesSnapshot.error);
                              return Center(child: Text(messagesSnapshot.error.toString()));
                            }

                            if (messagesSnapshot.hasData) {
                              final messages = messagesSnapshot.data;

                              return ListView.builder(
                                // so that the list will scroll down when new input is added
                                  controller: _scrollController,

                                  itemCount: messages.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    // get the info for one chat message
                                    final Message chatMessage = messages[index];
                                    bool isCurrentUser;
                                    // if else to figure out whether the currentUser or the other user is talking
                                    if (chatMessage.author.uid == currentUser.uid) {
                                      isCurrentUser = true;
                                    }
                                    else {
                                      isCurrentUser = false;
                                    }

                                    return _chatBubble(chatUserProfileUrl, chatMessage, isCurrentUser);
                                  }
                              );
                            }

                          return Center(child: CircularProgressIndicator()); //todo different loading?
                        }
                      )
                    ),
                    // TEXT AREA
                   Container(
                     height: 60,
                     padding: EdgeInsets.fromLTRB(5,2,5,5),
                     child: Row(
                       children: <Widget>[
                         Expanded(
                           child: TextField(
                             decoration: InputDecoration(
                               hintText: "Write a message!",
                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                             ),

                             // to determine if the text is empty when trying to send
                             controller: _textController,
                           ),
                         ),
                         IconButton(
                           padding: EdgeInsets.only(left: 7),
                           icon: Icon(Icons.send, color: Colors.indigo),
                           onPressed: () {
                             if(_textController.text.isNotEmpty) {
                               print("Sends the text to the chat");

                               // do some sending around here
                               chat.sendMessage(chatUid, _textController.text);

                               // clear out the text area
                               _textController.text = '';

                              // scroll down to see the new message
                             Timer(Duration(seconds: 1),
                             () =>
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.ease)
                             );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}