import 'package:flutter/material.dart';

// TODO: Better error screen?
class ErrorPage extends StatelessWidget {
  final String message;

  ErrorPage(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loading')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 3),
            Text('An error occured:'),
            Spacer(flex: 1),
            Text(message),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
