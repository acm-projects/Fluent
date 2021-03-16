import 'package:flutter/material.dart';
import 'package:fluent/src/frontend/widgets/SignUpHeader.dart';
import 'package:fluent/src/frontend/widgets/MyTextField.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // sign up header widget
          SignUpHeader(),
          SizedBox(height: 80),
          // email text field widget
          MyTextField(headerText: 'Email', keyboardType: TextInputType.emailAddress, isObscured: false),
          MyTextField(headerText: 'Password', keyboardType: TextInputType.text, isObscured: true),
          MyTextField(headerText: 'Confirm Password', keyboardType: TextInputType.text, isObscured: true),
        ],
      ),
    ),
      ),
    );
  }
}

/*class SignUpHeader extends StatelessWidget {
  const SignUpHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
    children: <Widget>[
      // Sign up text
      Expanded(
        flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                "Sign Up",
            style: TextStyle(
              fontSize: 36.0,
             // experimentation on getting a border around the text, may delete later
             /* foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.grey[700],*/
              ),
            ),
          ),
        ),
      // Fluent logo text
      Expanded(
        flex: 2,
        child: Text(
            'Fluent',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 28.0,
              letterSpacing: 2.0,
            ),
        ),
      ),
    ],
    );
  }
}*/



