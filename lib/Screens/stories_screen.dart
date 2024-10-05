import 'package:chatapp/Screens/view_story.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/image_picker_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:status_view/status_view.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerService>(context);
    final authProvider = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var userProfile = authProvider.userProfileMap;
            String userId = userProfile!["uid"];
            String userName = userProfile["imageName"];
            String userProfilePic = userProfile["imageUrl"];
            print(userProfile);
            await imageProvider.pickAndUploadStory(
                userId, userName, userProfilePic);
            imageProvider.DelightToast(
                text: "Story Uploaded",
                icon: Icons.done,
                circleColor: Colors.lightGreen,
                iconColor: Colors.white);
          },
          child: const Icon(Icons.add),
        ),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stories",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )
              ])),
          DraggableScrollableSheet(
              initialChildSize: 0.8, // 30% of the screen height
              minChildSize:
                  0.8, // Minimum size (fixed at 30% of the screen height)
              maxChildSize:
                  0.8, // Maximum size (fixed at 30% of the screen height)
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
                      child: StreamBuilder(
                        stream: imageProvider.getStories(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: const CircularProgressIndicator());
                          }

                          List<DocumentSnapshot> documents =
                              snapshot.data!.docs;
                          return ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                endIndent: 7,
                                indent: 7,
                                thickness: 1,
                              );
                            },
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              var storyData = documents[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StoryPage(
                                                userName: storyData["userName"],
                                                imageUrls: storyData["stories"],
                                                userProfileImage:
                                                    storyData["profilePicture"],
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: StatusView(
                                      radius: 28,
                                      spacing: 15,
                                      strokeWidth: 2,
                                      indexOfSeenStatus: 0,
                                      numberOfStatus:
                                          storyData["stories"].length,
                                      padding: 4,
                                      centerImageUrl:
                                          storyData["profilePicture"],
                                      seenColor: Colors.grey,
                                      unSeenColor: Colors.red,
                                    ),
                                    title: Text(
                                      storyData["userId"] ==
                                              authProvider
                                                  .userProfileMap!['uid']
                                          ? "You"
                                          : storyData["userName"],
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ); // Custom widget to display stories
                            },
                          );
                        },
                      ),
                    ));
              })
        ]));
  }
}
