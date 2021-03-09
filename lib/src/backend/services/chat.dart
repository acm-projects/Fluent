import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/chat.dart';
import 'package:fluent/src/backend/models/user.dart';

Future<ChatSnap> createChatWith([List<User> others = const []]) async {
  if (CurrentUser.instance.user == null) {
    throw "Only logged in users can create chats.";
  }
  var chatsRef = FirebaseFirestore.instance.collection('chats');

  var members = [CurrentUser.instance.uid, ...others.map((u) => u.uid)];
  var chatRef = await chatsRef.add({
    'members': members,
  });

  return ChatSnap(
    chatRef.id,
    members.map((uid) => User(uid)).toList(growable: false),
  );
}

Future<ChatSnap> fetchChat(String uid) async {
  var ref = FirebaseFirestore.instance.collection('chats').doc(uid);
  var snap = await ref.get();
  print('hi');
  return ChatSnap(
    uid,
    [for (var uid in snap.get('members')) User(uid)],
  );
}

/// Fetches the latest [count] messages in the chat with uid [chatUid], optionally starting after [after].
Future<List<Message>> fetchMessages(String chatUid, int count,
    [Message after]) async {
  var query = FirebaseFirestore.instance
      .collection('chats')
      .doc(chatUid)
      .collection('messages')
      .orderBy('timestamp')
      .limit(count);

  if (after != null) {
    query = query.startAfter([after.timestamp]);
  }

  var querySnap = await query.get();

  return querySnap.docs
      .map(
        (snap) => Message(
          uid: snap.id,
          author: User(snap.get('author')),
          content: snap.get('content'),
          timestamp: snap.get('timestamp'),
        ),
      )
      .toList(growable: false);
}

Future<void> sendMessage(String chatUid, String content) async {
  var ref = FirebaseFirestore.instance
      .collection('chats')
      .doc(chatUid)
      .collection('messages')
      .doc();

  await ref.set({
    'timestamp': FieldValue.serverTimestamp(),
    'content': content,
    'author': CurrentUser.instance.uid,
  });
}
