import 'dart:io';

import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerService>(context);
    final authProvider = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        body: SizedBox(
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
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      "Setting Up Your Profile",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Lottie.asset("assets/images/new-loader2.json",
                                      height: 50, width: 60),
                                ])
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
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
                                      width: 170, // Set the size of the avatar
                                      height: 170,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white, // Border color
                                          width: 4.0, // Border width
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundImage: selectedImage != null
                                            ? FileImage(selectedImage!)
                                            : const AssetImage(
                                                'assets/images/placeholder.png'),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.085,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 219, 217, 217)),
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white),
                                    child: TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                          border: InputBorder
                                              .none, // Removes the bottom line
                                          hintText: 'Enter your name',
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.080,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (selectedImage != null) {
                                          await imageProvider
                                              .uploadGalleryImage(
                                                  selectedImage!,
                                                  nameController.text,
                                                  context);
                                        } else {
                                          await imageProvider.uploadAssetImage(
                                              'assets/images/placeholder.png',
                                              nameController.text,
                                              context);
                                        }
                                        nameController.clear();
      
                                       await authProvider. getCurrentUserProfile();
                                        authProvider. onUserLogin();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              30),
                                        ),
                                      ),
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ]
                              )
                            )
                ]
              )
            )
          );
  }
}
