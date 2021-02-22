import 'package:flutter/material.dart';

// TODO: Better loading screen?
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loading')),
      body: Center(child: Text('Loading...')),
    );
  }
}
