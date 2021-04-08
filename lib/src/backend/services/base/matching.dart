import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent/src/backend/models/match.dart';
import 'package:fluent/src/backend/models/chat.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/base/chat.dart';
import 'package:fluent/src/backend/services/base/profiles.dart';
import 'package:fluent/src/backend/services/firebase/auth.dart';

class MatchingService {
  CollectionReference collection;
  var potentialMatches = [];
  MatchingService(FirebaseFirestore database) : collection = database.collection('profiles');


  Future<List>chooseUser(String matchUID) async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    MatchProfile currentUser = await getUserData(uid);

    //store users you've liked
    await collection
        .doc(uid)
        .collection("liked")
        .doc(matchUID)
        .set({});

    //store users who've liked you
    await collection
        .doc(matchUID)
        .collection('selected')
        .doc(uid)
        .set({
      'name': currentUser.name,
      'pfp': currentUser.pfp,
      'time': DateTime.now(),
    });

    return getUsers(uid);
  }

  Future<List> skipUser(uid, matchUID) async{
    //store users you've passed
    await collection
        .doc(matchUID)
        .collection('not selected')
        .doc(uid)
        .set({});

    //store uses who passed on you
    await collection
        .doc(uid)
        .collection("not liked")
        .doc(matchUID)
        .set({});

    return getUsers(uid);
  }

  Future getUserData(uid) async{
    MatchProfile currentUser = MatchProfile();
    await collection
        .doc(uid)
        .get()
        .then((user){
          currentUser.pfp = user['pfp'];
          currentUser.name = user['name'];
          currentUser.language = user['language'];
          currentUser.fluency = user['fluency'];
    });
    return currentUser;
  }

  Future getChosenList(uid) async{
    //shows everyone who you have liked
    //to enforce the notion that you cannot see the same potential matches numerous times
    List<String> chosenList = [];
    await collection
        .doc(uid)
        .collection('liked')
        .get()
        .then((docs){
      for(var doc in docs.docs){
        if(docs.docs != null){
          chosenList.add(doc.id);
        }
      }
    }
    );
    return chosenList;
  }

  Future getNotChosenList(uid) async{
    //shows everyone who you have passed
    //to enforce the notion that you cannot see the same potential matches numerous times
    List<String> notChosenList = [];
    await collection
        .doc(uid)
        .collection('not liked')
        .get()
        .then((docs){
      for(var doc in docs.docs){
        if(docs.docs != null){
          notChosenList.add(doc.id);
        }
      }
    }
    );
    return notChosenList;
  }

  Future getMatchesList(uid) async{
    //shows everyone who you have matched with
    //to enforce the notion that you cannot see the same potential matches numerous times
    List<String> matchesList = [];
    await collection
        .doc(uid)
        .collection('matches')
        .get()
        .then((docs){
      for(var doc in docs.docs){
        if(docs.docs != null){
          matchesList.add(doc.id);
        }
      }
    }
    );
    return matchesList;
  }

  Future<List>getUsers(uid) async{
    List<String> chosenList = await getChosenList(uid);
    List<String> notChosenList = await getNotChosenList(uid);
    List<String> matchesList = await getMatchesList(uid);
    MatchProfile currentUser = await getUserData(uid);
    potentialMatches.clear();

    await collection
        .where('language', isEqualTo: currentUser.language)
        .get()
        .then((users){
      for (var user in users.docs){
        if(!chosenList.contains(user.id)
            && !notChosenList.contains(user.id)
            && !matchesList.contains(user.id)
            && user.id != uid
        ){potentialMatches.add(MatchProfile(
          pfp: user['pfp'],
          uid: user['UID'],
          name: user['name'],
          bio: user['bio'],
          gender: user['gender'],
          fluencyDifference: (currentUser.fluency - user['fluency']).abs(),
        ));
        }
      }
    });
    potentialMatches.sort((a,b) => a.fluencyDifference - b.fluencyDifference);
    return potentialMatches;
  }

  Future<List> searchUser(matchUsername) async{
    await collection.where('username', isEqualTo: matchUsername)
        .get()
        .then((users){
      for(var user in users.docs){
        potentialMatches.insert(0, MatchProfile(
          uid: user['UID'],
          name: user['name'],
          bio: user['bio'],
          gender: user['gender'],
        ));
      }
    });
    return potentialMatches;
  }

  Future getMatches(MatchProfile user) async{
    var uid = FirebaseAuth.instance.currentUser.uid;
    MatchProfile currentUser = await getUserData(uid);
    List<String> chosenList = await getChosenList(uid);
    await collection
        .doc(uid)
        .collection('selected')
        .get()
        .then((docs){
      for(var doc in docs.docs){
        if(chosenList.contains(doc.id)){
          //create chat between users

          //create new match for both users
          collection.doc(uid)
              .collection('matches')
              .doc(doc.id)
              .set({
            'name': user.name,
            'pfp': user.pfp,
            'time': DateTime.now(),
            //add chat uid
          });
          collection.doc(doc.id)
              .collection('matches')
              .doc(uid)
              .set({
            'name': user.name,
            'pfp': currentUser.pfp,
            'time': DateTime.now(),
            //add chat uid
          });
          //delete matched user from liked and selected data collection
          collection.doc(uid)
              .collection('liked')
              .doc(doc.id)
              .delete();
          collection.doc(uid)
              .collection('selected')
              .doc(doc.id)
              .delete();
          collection.doc(doc.id)
              .collection('liked')
              .doc(uid)
              .delete();
          collection.doc(doc.id)
              .collection('selected')
              .doc(uid)
              .delete();
        }
      }
    }
    );
  }
}
