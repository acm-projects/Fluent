import 'package:flutter/material.dart';
// later the actual user model should be imported in order to fetch the right info
//import 'package:fluent/src/frontend/frontendmodels/UITestUserModel.dart';

class ChatScreen extends StatefulWidget {
  // This will be replaced with user for backend in order to fetch the proper picture and info for a chat screen
  //final User chatUser;

  // constructor for ChatScreen to initialize the User
  //ChatScreen({this.chatUser});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        //backgroundColor: Colors.lightBlueAccent[400],
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        elevation: 1,

        // centered user image
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            print("tapping the top user widget");
          },
          child: CircleAvatar(
            radius: 25,
            //backgroundImage: AssetImage(widget.chatUser.imageUrl),
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
                /*SizedBox(width: 105),
                    GestureDetector(
                      onTap: () {
                        print("tapping the top user widget");
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(widget.chatUser.imageUrl),
                      ),
                    ),*/
                SizedBox(width: 180),
                IconButton(
                  icon: Icon(
                    Icons.record_voice_over,
                    size: 30,
                    color: Colors.lightBlueAccent[400],
                  ),
                  onPressed: () {
                    print("Button to take you to voice chat");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Text("You navigated to this page!"),
      ),
    );
  }
}