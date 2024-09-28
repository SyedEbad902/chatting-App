import 'dart:io';

import 'package:chatapp/Services/image_picker_service.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(20, 20, 20, 1),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
                fit: StackFit
                    .expand, // This makes the image cover the entire screen
                children: [
                  Image.asset(
                    'assets/images/login-background.png', // Replace with your image path
                    fit: BoxFit
                        .cover, // This makes the image fill the screen while maintaining its aspect ratio
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 30, left: 15, right: 15, bottom: 20),
                      child: imageProvider.isloading
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                    child: Text(
                                      "Setting Up Your Profile",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                ])
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    child: Text(
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
                                    child: CircleAvatar(
                                      radius: 65,
                                      backgroundImage: selectedImage != null
                                          ? FileImage(selectedImage!)
                                          : AssetImage(
                                              'assets/images/placeholder.png'),
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
                                      decoration: InputDecoration(
                                          border: InputBorder
                                              .none, // Removes the bottom line
                                          hintText: 'Enter your name',
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ),
                                  ),
                                  SizedBox(
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
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              30), // Adjust radius as needed
                                        ),
                                      ),
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ]))
                ])));
  }
}
