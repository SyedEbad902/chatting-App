// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Screens/chat_screen.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  // Map newUser = {};
  Map<String, dynamic>? userProfileMap = {};
  bool loadData = false;
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    setState(() {
      loadData = true;
    });
    final credential = FirebaseAuth.instance;

    // Get the current user's UID from Firebase Authentication
    final String currentUserUid = credential.currentUser!.uid;

    // Fetch the current user's profile document from Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(
            currentUserUid) // Retrieve the document where the UID matches the current user's UID
        .get();

    // Check if the document exists and return the profile data
    if (snapshot.exists) {
      userProfileMap = snapshot.data();
      setState(() {
        loadData = false;
      });
      return userProfileMap; // This returns the document data as a Map<String, dynamic>
    } else {
      return null; // Return null if the document doesn't exist
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfileMap?.clear();
    getCurrentUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseServiceProvider>(context);
    final authProvider = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 36, 36, 36),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loadData
                            ? "Welcome..."
                            : "Welcome ${userProfileMap!["imageName"]}",
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      GestureDetector(
                          onTap: () {
                            authProvider.signOut(context);
                          },
                          child: const Icon(
                            Icons.logout_outlined,
                            size: 25,
                            color: Colors.white,
                          )),
                    ],
                  ),
                )
              ])),
          DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.8,
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
                      padding: const EdgeInsets.all(5.0),
                      child: loadData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : StreamBuilder(
                              stream: databaseProvider.getUserProfiles(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text('No profiles found.'));
                                }

                                // Get the list of profiles excluding the current user
                                List<
                                        QueryDocumentSnapshot<
                                            Map<String, dynamic>>>
                                    userProfiles = snapshot.data!.docs;
                                print(userProfiles);
                                return ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: Color.fromARGB(255, 224, 223, 223),
                                      indent: 10,
                                      endIndent: 10,
                                    );
                                  },
                                  controller: scrollController,
                                  itemCount: userProfiles.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        final chatExist = await databaseProvider
                                            .checkChatExist(
                                                authProvider.credential
                                                    .currentUser!.uid,
                                                userProfiles[index]["uid"]);
                                        if (!chatExist) {
                                          await databaseProvider.createNewChat(
                                              uid1: authProvider
                                                  .credential.currentUser!.uid,
                                              uid2: userProfiles[index]["uid"]);
                                        }
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                      chatUser:
                                                          userProfiles[index],
                                                    )));
                                        print(chatExist);
                                      },
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 28,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            userProfiles[index]["imageUrl"]!,
                                          ),
                                        ),
                                        title: Text(
                                          userProfiles[index]["imageName"],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: const Text(
                                          "oky sure",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        trailing: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "12:55",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.done_all,
                                              size: 17,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                    ));
              })
        ]));
  }
}
