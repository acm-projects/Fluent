import 'package:fluent/src/frontend/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
//import 'package:fluent/src/frontend/widgets/SignUpPage.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // String that will hold a valid email address
  String _email;

  // objects that will hold the password and confirm password
  TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                child: Form(
                  key: _formKey,
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
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                            ),
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
                          SizedBox(height: 16.0),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _password,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                            ),
                            validator: (String text){
                              if(text.isEmpty)
                              {
                                return "Password is a required field";
                              }

                              // got through without sending an error message
                              return null;
                            },
                          ),
                          // sign in button
                          SizedBox(height: 24.0),
                          ElevatedButton(
                              onPressed: () {
                                if(_formKey.currentState.validate())
                                {
                                  // I think validating data with database should happen here
                                  // snackBar probably won't show up in final product
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logging in')));

                                  _formKey.currentState.save();
                                }
                              },
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
      ),
    );

  }

  }

