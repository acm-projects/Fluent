import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/core.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:meta/meta.dart';

/// Represents a chat.
class Chat implements HasUid {
  String uid;

  Chat(this.uid);
}

/// Represents a snapshot of a chat.
class ChatSnap extends Chat {
  /// This chat's members.
  List<User> members;

  ChatSnap(String uid, this.members) : super(uid);
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
