import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent/src/backend/models/chat.dart';
import 'package:fluent/src/backend/models/user.dart';
import 'package:flutter/cupertino.dart';

class ChatService {
  CurrentUser _currentUser;

  CollectionReference _profilesRef;
  CollectionReference _chatsRef;

  DocumentReference chatRef([String chatUid]) => _chatsRef.doc(chatUid);

  CollectionReference messagesRef({String uid, DocumentReference ref}) => (ref ?? chatRef(uid)).collection('messages');

  DocumentReference messageRef({@required String message, String chat, DocumentReference ref}) =>
      messagesRef(uid: chat, ref: ref).doc(message);

  DocumentReference readRef({String uid, DocumentReference ref}) =>
      (ref ?? chatRef(uid)).collection('readReceipts').doc(_currentUser.uid);

  ChatService(this._currentUser, FirebaseFirestore database)
      : _profilesRef = database.collection('profiles'),
        _chatsRef = database.collection('chats');

  static Message _makeMessage(DocumentSnapshot snap) => Message(
    uid: snap.id,
    author: User(snap.get('authorUid')),
    content: snap.get('content'),
    timestamp: snap.get('timestamp')?.toDate(),
  );

  Future<ChatSnap> createChatWith(User other) async {
    var members = [_currentUser, other];
    var ref = chatRef();

    await ref.set({
      'memberUids': members.map((user) => user.uid).toList(),
    });

    return ChatSnap(
      uid: ref.id,
      members: members,
      mostRecentMessage: "",
    );
  }

  Future<String> fetchChatUidBetween(User a, User b) async {
    final matchRef = await _profilesRef.doc(a.uid).collection('matches').doc(b.uid).get();
    return matchRef.get('chat');
  }

  Future<ChatSnap> fetchChat(String uid) async {
    var snap = await chatRef(uid).get();
    return ChatSnap(
      uid: uid,
      members: [for (var uid in snap.get('memberUids')) User(uid)],
      mostRecentMessage: snap.get('mostRecentMessage'),
    );
  }

  Future<Message> fetchMessage(String chatUid, String messageUid) async {
    return _makeMessage(await messageRef(message: messageUid, chat: chatUid).get());
  }

  Future<List<Message>> fetchMessages(String chatUid, int count, [Message after]) async {
    var query = messagesRef(uid: chatUid).orderBy('timestamp').orderBy('authorId');
    if (after != null) {
      query = query.startAfter([after.timestamp]);
    }
    query = query.limit(count);

    var querySnap = await query.get();
    return querySnap.docs.map(_makeMessage).toList(growable: false);
  }

  Future<void> sendMessage(String chatUid, String content) {
    var ref = chatRef(chatUid);
    return Future.wait([
      ref.update({
        'mostRecentMessage': content,
      }),
      messagesRef(ref: ref).doc().set({
        'timestamp': FieldValue.serverTimestamp(),
        'content': content,
        'authorUid': _currentUser.uid,
      }),
    ]);
  }

  Future<void> markRead(Chat chat, String messageUid) {
    return readRef(uid: chat.uid).set({
      'latestRead': messageUid,
    });
  }

  Future<bool> isRead(Chat chat, String messageUid) async {
    var message = await fetchMessage(chat.uid, messageUid);
    var latestRead = await fetchMessage(chat.uid, (await readRef(uid: chat.uid).get()).get('latestRead'));

    return message.timestamp.isAfter(latestRead.timestamp);
  }

  Stream<List<Message>> messages(String chatUid) {
    return messagesRef(uid: chatUid)
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs.map(_makeMessage).toList(growable: false));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChatService && runtimeType == other.runtimeType && _currentUser == other._currentUser;

  @override
  int get hashCode => _currentUser.hashCode;
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
    return chatService != old.chatService;
  }

  static ChatServiceProvider of(BuildContext context) {
    final ChatServiceProvider result = context.dependOnInheritedWidgetOfExactType<ChatServiceProvider>();
    assert(result != null, 'No ChatServiceProvider found in context');
    return result;
  }
}