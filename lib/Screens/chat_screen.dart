import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    // final databaseProvider = Provider.of<DatabaseServiceProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff414A4C),
        body: Stack(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              // decoration: BoxDecoration(border: Border(bottom: Bo)),
              width: double.infinity,
              child: Stack(fit: StackFit.expand, children: [
                Image.asset(
                  'assets/images/login-background.png', // Replace with your image path
                  fit: BoxFit
                      .cover, // This makes the image fill the screen while maintaining its aspect ratio
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
                    ],
                  ),
                )
              ])),
          DraggableScrollableSheet(
              initialChildSize: 0.83, // 30% of the screen height
              minChildSize:
                  0.83, // Minimum size (fixed at 30% of the screen height)
              maxChildSize:
                  0.83, // Maximum size (fixed at 30% of the screen height)
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
                            // print(chat!["messages"]);
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
                        )));
              }),
        ]));
  }

  Future<void> sendMessage(ChatMessage chatMessage) async {
    String? currentTime = await databaseservice.getCurrentTimeFromInternet();
    DateTime parsedTime = DateTime.parse(currentTime!);

    // Convert the `DateTime` to Firestore Timestamp
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
    // chatMessage.sort((a, b) {
    //   return b.createdAt.compareTo(a.createdAt);
    // });
    chatMessage.sort((a, b) {
      DateTime dateA = parseDateTime(a.createdAt.toString());
      DateTime dateB = parseDateTime(b.createdAt.toString());

      return dateB.compareTo(dateA); // Sorting in descending order
    });
    return chatMessage;
  }

// Function to parse date from string
  DateTime parseDateTime(String dateString) {
    dateString = dateString.replaceFirst(' at ', ' UTC+');

    // Try parsing the string as an ISO 8601 date with microseconds
    return DateTime.parse(dateString);
  }
}
