import 'package:fluent/src/backend/services/base/services.dart';
import 'package:flutter/material.dart';
import 'package:fluent/src/frontend/widgets/SignUpHeader.dart';
import 'package:fluent/src/frontend/widgets/MyTextField.dart';

class SignUpPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignUpPage> {

  // String that will hold a valid email address
  String _email;

  // objects that will hold the password and confirm password
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  // Global key for our form. It will keep track of what is being inputted in the fields
  // and will be used to give error messages to the user
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if(!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
            children: <Widget>[
            // sign up header widget
            SignUpHeader(),
            SizedBox(height: 80),
            // Form widget. This is done so that all the fields are filled in before letting you go to the next page
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Email text field
                    Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                      ),
                      // validator. This is used to validate the text you input in the field
                      validator: (String text){
                        if(text.isEmpty)
                          {
                            return "Email is a required field";
                          }

                        // if the user inputs something that doesn't match the regExp rules for a valid email,
                        // tell them they must enter something else
                        if(!RegExp(r"^([a-zA-Z0-9.!#$%&*+/=?^_`~-]+)@([A-Za-z0-9.-]+)\.([a-zA-Z0-9-]+)$").hasMatch(text))
                          {
                            return "Please enter a valid email address";
                          }
                        // got through without sending an error message
                        return null;
                      },
                      // got through validation, save the value
                      onSaved: (String email)
                        {
                          _email = email;
                        }
                    ),
                SizedBox(height: 30.0),
                // Password field
                Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                  ),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,

                  ),
                    validator: (String text){
                      if(text.isEmpty)
                      {
                        return "Password is a required field";
                      }

                      if(text.length < 6)
                        {
                          return "Password must be at least 6 characters long";
                        }

                      // got through without sending an error message
                      return null;
                    },

                  // controller takes care of the onSaved on its own

                ),
                    SizedBox(height: 30.0),
                    // Confirm Password field
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _confirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                      ),
                        validator: (String text){
                          if(text.isEmpty)
                          {
                            return "You must confirm your password";
                          }

                          if(_password.text != _confirmPassword.text)
                          {
                            return "Confirm Password must match Password";
                          }

                          // got through without sending an error message
                          return null;
                        },
                    ),
                    SizedBox(height: 24.0),
                    // Confirm button
                    ElevatedButton(
                      onPressed: () async {
                        // code to determine whether the user inputted values successfully
                        if(_formKey.currentState.validate())
                          {
                            // sending data to database happens here

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Creating Your Account')));

                            _formKey.currentState.save();

                            try {
                              final auth = ServicesProvider.of(context).services.auth;
                              await auth.register(email: _email, password: _password.text);
                            } catch (e) {
                              print(e.toString());
                            }
                          }
                      },
                      child: Text('Create Account',
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
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
    ),
      ),
    );
  }
}




