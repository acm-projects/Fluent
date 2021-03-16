//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  // text for the header
  final String headerText;
  // keyboard type for the text field
  final TextInputType keyboardType;
  // is the text typed in obscured from the user or not
  final bool isObscured;
  // constructor
  MyTextField({this.headerText, this.keyboardType, this.isObscured});

  @override
  _MyTextFieldState createState() => _MyTextFieldState(this.headerText, this.keyboardType, this.isObscured);
}

class _MyTextFieldState extends State<MyTextField> {

  // constructor
  _MyTextFieldState(this.headerText, this.keyboardType, this.isObscured)
  {
    this.headerText = headerText;
    this.keyboardType = keyboardType;
    this.isObscured = isObscured;
  }

  String headerText;
  TextInputType keyboardType;
  bool isObscured;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            headerText,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
            ),
          ),
          TextFormField(
            keyboardType: keyboardType,
            obscureText: isObscured,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0,
            ),
          ),
        ]
      ),
      ),
    );
  }
}

