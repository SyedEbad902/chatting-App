// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ChatScreen extends StatefulWidget {
  final chatUser;
  const ChatScreen({super.key, required this.chatUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GetIt _getIt = GetIt.instance;
  late FirebaseAuthService authservice;
  late DatabaseServiceProvider databaseservice;

  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    authservice = _getIt.get<FirebaseAuthService>();
    databaseservice = _getIt.get<DatabaseServiceProvider>();
    currentUser = ChatUser(
        id: authservice.credential.currentUser!.uid,
        firstName: authservice.credential.currentUser!.displayName);
    otherUser = ChatUser(
        id: widget.chatUser["uid"],
        firstName: widget.chatUser["imageName"],
        profileImage: widget.chatUser["imageUrl"]);
    authservice.getCurrentUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        body: Stack(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              width: double.infinity,
              child: Stack(fit: StackFit.expand, children: [
                Image.asset(
                  'assets/images/login-background.png', 
                  fit: BoxFit
                      .cover,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.chatUser["imageUrl"]),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 8, bottom: 8),
                        child: Text(
                          "${widget.chatUser["imageName"]}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      callingButton(false),
                      callingButton(true)
                    ],
                  ),
                )
              ])),
          DraggableScrollableSheet(
              initialChildSize: 0.83, 
              minChildSize:
                  0.83, 
              maxChildSize:
                  0.83,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 5,
                            right: 5,
                            left: 5 // This handles the keyboard
                            ),
                        child: StreamBuilder(
                          stream: databaseservice.getChat(
                              currentUser!.id, otherUser!.id),
                          builder: (BuildContext context, snapshot) {
                            final chat = snapshot.data;
                            List<ChatMessage> messages = [];
                            if (chat != null && chat["messages"] != null) {
                              messages =
                                  generateChatMessageList(chat["messages"]);
                            }
                            return DashChat(
                                messageListOptions: const MessageListOptions(
                                    separatorFrequency:
                                        SeparatorFrequency.hours),
                                messageOptions: MessageOptions(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                    messagePadding: const EdgeInsets.all(10),
                                    containerColor: const Color(0xffFFC700)
                                        .withOpacity(0.25),
                                    currentUserTextColor: Colors.black,
                                    currentUserContainerColor:
                                        const Color(0xffFF8933)
                                            .withOpacity(0.25),
                                    showOtherUsersAvatar: true,
                                    timePadding: const EdgeInsets.all(2),
                                    timeFontSize: 10,
                                    showTime: true),
                                inputOptions: InputOptions(
                                    alwaysShowSend: true,
                                    sendOnEnter: true,
                                    inputDecoration: const InputDecoration(),
                                    cursorStyle: CursorStyle(
                                        color: const Color(0xffFFC700)
                                            .withOpacity(0.25))),
                                currentUser: currentUser!,
                                onSend: sendMessage,
                                messages: messages);
                          },
                        )
                      )
                    );
              }
            ),
        ]
      )
    );
  }

  ZegoSendCallInvitationButton callingButton(bool isVideo) {
    return ZegoSendCallInvitationButton(
      isVideoCall: isVideo,
      onWillPressed: () async {
        try {
          String? getTime = await databaseservice.getCurrentTimeFromInternet();
          // ignore: unused_local_variable
          String chatId = databaseservice.generateChatId(
              uid1: currentUser!.id, uid2: otherUser!.id);
          await FirebaseFirestore.instance
              .collection('call_invitations')
              .doc(authservice.userProfileMap!["uid"])
              .set({
            'calls': FieldValue.arrayUnion([
              {
                'callerName': authservice.userProfileMap!["imageName"],
                'callerID': authservice.userProfileMap!["uid"],
                'inviteeID': otherUser!.id,
                'inviteeName': otherUser!.firstName,
                'isVideoCall': isVideo,
                'timestamp': getTime,
              }
            ]),
          }, SetOptions(merge: true));
          print('Call data added to Firestore successfully');

          return true;
        } catch (e) {
          print('Error adding call data to Firestore: $e');
          return false;
        }
      },
      resourceID: "zegouikit_call",
      iconSize: const Size(40, 40),
      buttonSize: const Size(50, 50),
      invitees: [
        ZegoUIKitUser(
          id: otherUser!.id,
          name: otherUser!.firstName!,
        ),
      ],
    );
  }

  

  Future<void> sendMessage(ChatMessage chatMessage) async {
    String? currentTime = await databaseservice.getCurrentTimeFromInternet();
    DateTime parsedTime = DateTime.parse(currentTime!);

    Timestamp timeStamp = Timestamp.fromDate(parsedTime);

    Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: timeStamp);
    await databaseservice.sendChatMessage(
        currentUser!.id, otherUser!.id, message);
  }

  List<ChatMessage> generateChatMessageList(List messages) {
    List<ChatMessage> chatMessage = messages.map((m) {
      return ChatMessage(
          user: m["senderID"] == currentUser!.id ? currentUser! : otherUser!,
          text: m["content"],
          createdAt: m["sentAt"]!.toDate());
    }).toList();
    
    chatMessage.sort((a, b) {
      DateTime dateA = parseDateTime(a.createdAt.toString());
      DateTime dateB = parseDateTime(b.createdAt.toString());

      return dateB.compareTo(dateA); 
    });
    return chatMessage;
  }

  DateTime parseDateTime(String dateString) {
    dateString = dateString.replaceFirst(' at ', ' UTC+');

    return DateTime.parse(dateString);
  }
}
