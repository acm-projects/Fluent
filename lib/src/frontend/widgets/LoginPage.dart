import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // general padding for the screen
          body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 0.0),
            child: Column(

              children: <Widget>[
                // Fluent logo
                Text(
                  'Fluent',
                   style: TextStyle(

                   )
                )
              ],
            )

        ),
    ),

    );
  }
}
