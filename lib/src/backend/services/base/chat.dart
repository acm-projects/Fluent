import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/chat.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:flutter/cupertino.dart';

class ChatService {
  CurrentUser _currentUser;

  CollectionReference chatsRef;

  CollectionReference messagesRef(String chatUid) => chatsRef.doc(chatUid).collection('messages');

  ChatService(this._currentUser, FirebaseFirestore database) : chatsRef = database.collection('chats');

  Future<ChatSnap> createChatWith(User other) async {
    var members = [_currentUser, other];

    var chatRef = chatsRef.doc();

    await chatRef.set({
      'memberUids': members.map((user) => user.uid).toList(),
    });

    return ChatSnap(chatRef.id, members);
  }

  Future<ChatSnap> fetchChat(String uid) async {
    var snap = await chatsRef.doc(uid).get();
    return ChatSnap(uid, [for (var uid in snap.get('memberUids')) User(uid)]);
  }

  Future<List<Message>> fetchMessages(String chatUid, int count, [Message after]) async {
    var query = messagesRef(chatUid).orderBy('timestamp').limit(count);

    if (after != null) {
      query = query.startAfter([after.timestamp]);
    }

    var querySnap = await query.get();

    return querySnap.docs
        .map((snap) => Message(
              uid: snap.id,
              author: User(snap.get('authorUid')),
              content: snap.get('content'),
              timestamp: snap.get('timestamp').toDate(),
            ))
        .toList(growable: false);
  }

  Future<void> sendMessage(String chatUid, String content) {
    return messagesRef(chatUid).doc().set({
      'timestamp': FieldValue.serverTimestamp(),
      'content': content,
      'author': _currentUser.uid,
    });
  }
}

class ChatServiceProvider extends InheritedWidget {
  final ChatService chatService;

  ChatServiceProvider({
    Key key,
    @required this.chatService,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ChatServiceProvider old) {
    return chatService._currentUser.uid != old.chatService._currentUser.uid;
  }
}
