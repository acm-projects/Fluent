import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/core.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:meta/meta.dart';

/// Represents a chat.
class Chat implements HasUid {
  /// This chat's unique ID.
  String uid;

  Chat(this.uid);
}

/// Represents a snapshot of a chat.
class ChatSnap extends Chat {
  /// This chat's members.
  List<User> members;

  /// The most recent message in this chat's content.
  String mostRecentMessage;

  ChatSnap({@required String uid, @required this.members, @required this.mostRecentMessage}) : super(uid);
}

/// Represents a message.
class Message implements HasUid {
  /// This message's unique ID.
  String uid;

  /// Timestamp of when the server received this message.
  Timestamp timestamp;

  /// This message's content.
  String content;

  /// This message's author.
  User author;

  Message({
    @required this.uid,
    @required this.timestamp,
    @required this.content,
    @required this.author,
  });
}
