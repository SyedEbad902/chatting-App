import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { Text, Image }

class Message {
  String senderID;
  String content;
  MessageType messageType;
  Timestamp? sentAt;

  // Constructor for creating new Message objects
  Message({
    required this.senderID,
    required this.content,
    required this.messageType,
    this.sentAt, // can be null if using server timestamp
  });

  // Factory constructor to create Message object from Firestore JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderID: json['senderID'],
      content: json['content'],
      messageType: MessageType.values.byName(json['messageType']),
      sentAt: json['sentAt'], // Firestore stores it as Timestamp
    );
  }

  // Convert Message object to JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      'senderID': senderID,
      'content': content,
      'sentAt': sentAt , // Use server timestamp if null
      'messageType': messageType.name,
    };
  }
}














// import 'package:cloud_firestore/cloud_firestore.dart';

// enum MessageType { Text, Image }

// class Message {
//   String? senderID;
//   String? content;
//   MessageType? messageType;
//   Timestamp? sentAt;

//   Message({
//     required this.senderID,
//     required this.content,
//     required this.messageType,
//     required this.sentAt,
//   });

//   Message.fromJson(Map<String, dynamic> json) {
//     senderID = json['senderID'];
//     content = json['content'];
//     sentAt = json['sentAt'];
//     messageType = MessageType.values.byName(json['messageType']);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['senderID'] = senderID;
//     data['content'] = content;
//     data['sentAt'] = sentAt;
//     data['messageType'] = messageType!.name;
//     return data;
//   }
// }
