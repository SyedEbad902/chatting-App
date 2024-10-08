import 'package:chatapp/Screens/view_story.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/image_picker_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:status_view/status_view.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  Map<String, dynamic> userStories = {};

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
                userId, userName, userProfilePic, context);
          },
          backgroundColor: const Color.fromARGB(255, 36, 36, 36),
          child: SvgPicture.asset(
            "assets/images/add-icon.svg",
            color: Colors.white,
            height: 55,
          ),
        ),
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
              initialChildSize: 0.8, 
              minChildSize:
                  0.8, 
              maxChildSize:
                  0.8,
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
                      child: imageProvider.isUploading
                          ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Uploading your story",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  Lottie.asset("assets/images/new-loader1.json",
                                      height: 50, width: 60),

                                  // CircularProgressIndicator(),
                                ],
                              ),
                            )
                          : StreamBuilder(
                              stream: imageProvider.getStories(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;
                                for (var doc in documents) {
                                  var storyData =
                                      doc.data() as Map<String, dynamic>;
                                  if (storyData['userId'] ==
                                      authProvider.userProfileMap!['uid']) {
                                    userStories =
                                        storyData; 
                                  }
                                  print(userStories);
                                }
                                return ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      endIndent: 7,
                                      indent: 7,
                                      thickness: 1,
                                    );
                                  },
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    var storyData = documents[index];
                                    Timestamp timestamp =
                                        storyData["timestamp"];

                                    String time =
                                        imageProvider.formatDate(timestamp);
                                    print(time);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => StoryPage(
                                                      userName:
                                                          storyData["userName"],
                                                      imageUrls:
                                                          storyData["stories"],
                                                      userProfileImage:
                                                          storyData[
                                                              "profilePicture"],
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
                                          subtitle: Text("$time"),
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
