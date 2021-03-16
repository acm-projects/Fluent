import 'package:fluent/src/frontend/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
//import 'package:fluent/src/frontend/widgets/SignUpPage.dart';

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
          // singleChildScrollView allows for you to scroll when the keyboard is visible
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/src/frontend/assets/water.jpg'),
                  fit: BoxFit.cover,),
        ),

              child: Center(
                // general padding for the screen
                child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 130.0, 20.0, 102.0),
                // note: stuff from Card to the end of padding is new stuff to add the card in
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                        //MyTextField(headerText: 'Email', keyboardType: TextInputType.emailAddress, isObscured: false),
                        Text(
                          'Email',
                          style: TextStyle(
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
                          child: Text('Log in',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue[400],
                              minimumSize: Size(330,40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        ),
                        SizedBox(height: 10.0),
                        // button for the sign up page
                        Row(
                          children: [
                            Text('New user?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signUp');
                              },
                              child: Text('Sign up now!'),
                              style: TextButton.styleFrom(
                                primary: Colors.lightBlue[400],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ),
               ),
              ),
            ),
         ),
      ),
    );

  }

  }

