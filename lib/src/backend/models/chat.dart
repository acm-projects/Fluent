import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/core.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:fluent/src/backend/services/chat.dart' as ChatService;
import 'package:fluent/src/backend/services/chat.dart';
import 'package:meta/meta.dart';

/// Represents a chat which may or may not be fetched.
abstract class Chat implements HasUid {
  /// This chat's unique ID.
  String uid;

  Chat(this.uid);

  /// Fetches a snapshot of this chat.
  Future<ChatSnap> fetch();

  /// A non-fetched reference to this chat.
  ChatRef get ref;

  /// Sends a message to this chat.
  Future<void> sendMessage(String content) =>
      ChatService.sendMessage(this.uid, content);

  /// Fetches the latest [count] messages, optionally starting after [after].
  Future<List<Message>> fetchMessages(int count, [Message after]) =>
      ChatService.fetchMessages(this.uid, count, after);
}

/// Represents a non-fetched reference to a chat.
/// Useful when access to messages and not chat metadata is needed.
class ChatRef extends Chat {
  ChatRef(String uid) : super(uid);

  @override
  Future<ChatSnap> fetch() => fetchChat(this.uid);
  ChatRef get ref => this;
}

/// Represents a fetched snapshot of a chat.
class ChatSnap extends Chat {
  /// This chat's members.
  List<User> members;

  ChatSnap(String uid, this.members) : super(uid);

  @override
  Future<ChatSnap> fetch() async => this;

  @override
  ChatRef get ref => ChatRef(this.uid);
}

/// Represents a fetched message.
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
