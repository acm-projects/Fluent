import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // so that for the text boxes, tapping any non-widget will cause you to exit
      // out of them
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if(!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          // general padding for the screen
          body: Center(
            child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Fluent logo
               Center(
                 child: Text(
                    'Fluent',
                     style: TextStyle(
                         fontFamily: 'Pacifico',
                       fontSize: 68.0,
                       letterSpacing: 2.0,
                     ),
                    ),
               ),
                SizedBox(height: 6.0),
                //Email textField and heading
                Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                  ),
                ),
                // sign in button
                SizedBox(height: 24.0),
                ElevatedButton(
                    onPressed: () {},
                  child: Text(
                    'Log In'

                  ),
                    style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[400],
                      minimumSize: Size(330,40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                ),
              ],
            ),
            ),
           ),
        ),
      ),
    );

  }
}
