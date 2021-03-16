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
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                ),
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
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  // Confirm button
                  ElevatedButton(
                    onPressed: () {
                      // code to determine whether the user inputted values successfully
                      if(_formKey.currentState.validate())
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Creating Your Account')));
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




