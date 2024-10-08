import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/image_picker_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({
    super.key,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  Map<String, dynamic>? userProfileMap = {};
  bool loadData = false;
  File? selectedImage;
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

  TextEditingController nameController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerService>(context);
    Provider.of<FirebaseAuthService>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        body: loadData
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                    fit: StackFit
                        .expand, 
                    children: [
                      Image.asset(
                        'assets/images/login-background.png', 
                        fit: BoxFit
                            .cover,
                      ),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ]))
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                    fit: StackFit
                        .expand,
                    children: [
                      Image.asset(
                        'assets/images/login-background.png',
                        fit: BoxFit
                            .cover, 
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 15, right: 15, bottom: 20),
                          child: imageProvider.isloading
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          "Updating Your Profile",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const CircularProgressIndicator()
                                    ])
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          // left: 20,
                                          bottom: 30,
                                        ),
                                        child: const Text(
                                          "Setup Your Profile",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          File? file =
                                              await imageProvider.getImage();
                                          if (file != null) {
                                            setState(() {
                                              selectedImage = file;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          width:
                                              170, // Set the size of the avatar
                                          height: 170,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  Colors.white, // Border color
                                              width: 4.0, // Border width
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 70,
                                            backgroundImage: selectedImage !=
                                                    null
                                                ? FileImage(selectedImage!)
                                                : CachedNetworkImageProvider(
                                                    // authProvider
                                                    userProfileMap![
                                                        "imageUrl"]),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 20, top: 20),
                                          child: const Text(
                                            "Name",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 18, top: 8, bottom: 8),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.085,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 219, 217, 217)),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.white),
                                        child: TextField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                              border: InputBorder
                                                  .none, // Removes the bottom line
                                              hintText:
                                                  "${userProfileMap!["imageName"]}",
                                              hintStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.080,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (selectedImage != null) {
                                              await imageProvider
                                                  .updateProfileImage(
                                                      selectedImage!,
                                                      nameController.text,
                                                      context);
                                            } else {
                                              await imageProvider
                                                  .updateUsername(
                                                      nameController.text,
                                                      context);
                                            }
                                            nameController.clear();
                                            getCurrentUserProfile();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  30), // Adjust radius as needed
                                            ),
                                          ),
                                          child: const Text(
                                            "Update",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ]))
                    ])));
  }
}
