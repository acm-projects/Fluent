import 'package:fluent/src/backend/models/language.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/users.dart' as Users;
import 'package:flutter/material.dart';

class FirestoreTestWidget extends StatefulWidget {
  @override
  State createState() => _FirestoreTestState();
}

class InitData {
  Profile profile;
  String pfpUrl;

  InitData({this.profile, this.pfpUrl});
}

class _FirestoreTestState extends State<FirestoreTestWidget> {
  Future<InitData> init() async {
    var profile = await Users.fetchProfile('7mwrm7bJ65aFrGnOSCUHEFIb9Aj1');
    return InitData(profile: profile, pfpUrl: await profile.fetchPfpUrl());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InitData>(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error;
        }

        if (snapshot.hasData) {
          var profile = snapshot.data.profile;
          var pfpUrl = snapshot.data.pfpUrl;
          return Column(children: [
            Text('${profile.name} (${profile.username}), ${profile.age}'),
            Text(profile.bio),
            Text('${profile.language.iso639}, ${profile.fluency.displayNumber}'),
            Image.network(pfpUrl),
          ]);
        }

        return CircularProgressIndicator();
      },
    );
  }
}
