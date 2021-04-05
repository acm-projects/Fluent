import 'package:fluent/src/frontend/frontendmodels/UITestUserModel.dart';

class Message {
  final User sender;
  final String time; // would be something different for Firebase
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

// Messages that appear on the inbox
List<Message> chats = [
Message(
sender: user1,
time: ' 5 min ago',
text: 'Hey, do you want to go to IHOP tomorrow morning?',
unread: true,
),
Message(
sender: user2,
time: ' 20 min ago',
text: 'Hola, me gusta queso.',
unread: false,
),
Message(
sender: user3,
time: ' 1 hour ago',
text: 'oh oops, thanks for correcting my sentence!',
unread: false,
),
Message(
sender: user4,
time: ' 2 days ago',
text: 'I think you meant to say los muchachos, not las muchachos',
unread: true,
),
  Message(
    sender: user5,
    time: ' 3 days ago',
    text: 'I think you meant to say los muchachos, not las muchachos',
    unread: true,
  ),
  Message(
    sender: user6,
    time: ' 3 days ago',
    text: 'I think you meant to say los muchachos, not las muchachos',
    unread: true,
  ),
];