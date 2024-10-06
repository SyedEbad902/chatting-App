// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chatapp/Screens/navbar.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/toast_service.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class ImagePickerService extends ChangeNotifier {
  bool isloading = false;

  final authProvider = getIt<FirebaseAuthService>();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final databaseProvider = getIt<DatabaseServiceProvider>();
  final toastProvider = getIt<ToastService>();

  //to upload file image  to firebase

  Future<void> uploadGalleryImage(
      File imageFile, String userName, BuildContext context) async {
    try {
      // Get current user UID
      final user = authProvider.credential.currentUser;
      final uid = user?.uid;

      // Upload the image to Firebase Storage with a unique name
      final ref = _storage
          .ref('users/profiles')
          .child('$uid${p.extension(imageFile.path)}');
      isloading = true;
      notifyListeners();
      await ref.putFile(imageFile);

      // Get the download URL of the uploaded image
      final imageUrl = await ref.getDownloadURL();

      // Save the download URL, image name, and user UID to Firestore
      await _firestore.collection('users').doc('$uid').set({
        'uid': uid,
        'imageUrl': imageUrl,
        'imageName': userName,
      });

      print('Image uploaded and data stored in Firestore');
      isloading = false;
      notifyListeners();
      authProvider.userProfileMap?.clear();
      await getCurrentUserProfile();
      notifyListeners();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyNavBar()));
      toastProvider.DelightToast(
              text: "Your profile hs been setup successfully",
              icon: Icons.done,
              circleColor: Colors.lightGreen,
              iconColor: Colors.white,
              context: context)
          .show(context);
    } catch (e) {
      toastProvider.DelightToast(
              text: "Something went wrong!",
              icon: Icons.cancel_outlined,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
      print('Error uploading image: $e');
    }
  }
  //to upload asset  to firebase

  Future<void> uploadAssetImage(
      String assetPath, String userName, BuildContext context) async {
    try {
      // Load the image from assets as byte data
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List imageData = byteData.buffer.asUint8List();

      // Get current user UID
      final user = authProvider.credential.currentUser;
      final uid = user?.uid;

      // Create a unique name for the image based on UID
      final imageName = '$uid${p.extension(assetPath)}';

      // Upload the image to Firebase Storage with a unique name
      final ref = _storage.ref('users/profiles').child(imageName);
      isloading = true;
      notifyListeners();
      await ref.putData(imageData);

      // Get the download URL of the uploaded image
      final imageUrl = await ref.getDownloadURL();

      // Save the download URL, image name, and user UID to Firestore
      await _firestore.collection('users').doc('$uid').set({
        'uid': uid,
        'imageUrl': imageUrl,
        'imageName': userName,
      });

      print('Image uploaded and data stored in Firestore');
      isloading = false;
      notifyListeners();
      authProvider.userProfileMap?.clear();
      await getCurrentUserProfile();
      notifyListeners();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyNavBar()));
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  //update Image
  Future<void> updateProfileImage(
      File newImageFile, String newUserName, BuildContext context) async {
    try {
      // Get current user UID
      final user = authProvider.credential.currentUser;
      final uid = user?.uid;

      // Upload the new image to Firebase Storage with a unique name
      final ref = _storage
          .ref('users/profiles')
          .child('$uid${p.extension(newImageFile.path)}');
      isloading = true;
      notifyListeners();
      await ref.putFile(newImageFile);

      // Get the download URL of the newly uploaded image
      final newImageUrl = await ref.getDownloadURL();

      // Update the user's profile data in Firestore
      await _firestore.collection('users').doc(uid).update({
        'imageUrl': newImageUrl, // Update image URL
        'imageName': newUserName, // Update image name
      });
      // authProvider.userProfileMap!.clear();
      // getCurrentUserProfile();
      print('Profile image and name updated in Firestore');
      isloading = false;
      notifyListeners();

      // Optionally, navigate to a new page or show success toast
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => const MyNavBar()));
      toastProvider.DelightToast(
              text: "Your profile has been updated successfully",
              icon: Icons.done,
              circleColor: Colors.lightGreen,
              iconColor: Colors.white,
              context: context)
          .show(context);
    } catch (e) {
      toastProvider.DelightToast(
              text: "Something went wrong!",
              icon: Icons.cancel_outlined,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
      print('Error updating profile image: $e');
    }
  }

  // upload Username image
 Future<void> updateUsername(String newUserName, BuildContext context) async {
    try {
      // Get current user UID
      final user = authProvider.credential.currentUser;
      final uid = user?.uid;

      // Update only the user's username in Firestore
      await _firestore.collection('users').doc(uid).update({
        'imageName': newUserName, // Update image name (username)
      });

      print('Username updated successfully in Firestore');

      isloading = false;
      notifyListeners();

      // Optionally, navigate to a new page or show success toast
      toastProvider.DelightToast(
              text: "Your username has been updated successfully",
              icon: Icons.done,
              circleColor: Colors.lightGreen,
              iconColor: Colors.white,
              context: context)
          .show(context);
    } catch (e) {
      toastProvider.DelightToast(
              text: "Something went wrong!",
              icon: Icons.cancel_outlined,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);

      print('Error updating username: $e');
    }
  }


//for pick image from gallery
  final ImagePicker picker = ImagePicker();

  Future<File?> getImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    }
    return null;
  }

// //get current user profile
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    // Get the current user's UID from Firebase Authentication
    final String currentUserUid = authProvider.credential.currentUser!.uid;

    // Fetch the current user's profile document from Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(
            currentUserUid) // Retrieve the document where the UID matches the current user's UID
        .get();
    // Check if the document exists and return the profile data
    if (snapshot.exists) {
      if (authProvider.userProfileMap!.isEmpty) {
        authProvider.userProfileMap = snapshot.data();
        print(
            "This is usermap **&&^^%%**^^&****&^%(((^${authProvider.userProfileMap}");
        return authProvider.userProfileMap;
      } else {
        authProvider.userProfileMap!.clear();
        authProvider.userProfileMap = snapshot.data();
        print(
            "This is usermap **&&^^%%**^^&****&^%(((^${authProvider.userProfileMap}");

        return authProvider.userProfileMap;
      }
      // This returns the document data as a Map<String, dynamic>
    } else {
      return null; // Return null if the document doesn't exist
    }
  }

//for toasts

//upload stories

  bool isUploading = false;
  Future<void> pickAndUploadStory(String userId, String userName,
      String profilePictureUrl, BuildContext context) async {
    try {
      // Step 1: Pick an image using image_picker
      // final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      // Check if the user selected a file
      if (pickedFile != null) {
        isUploading = true;
        notifyListeners();
        File imageFile = File(pickedFile.path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Step 2: Upload the image to Firebase Storage
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageRef = storage.ref().child("stories/$userId/$fileName");
        UploadTask uploadTask = storageRef.putFile(imageFile);

        // Wait until the upload is complete
        TaskSnapshot storageSnapshot = await uploadTask;
        String mediaUrl = await storageSnapshot.ref.getDownloadURL();

        // Step 3: Store the story data in Firestore
        CollectionReference stories =
            FirebaseFirestore.instance.collection('stories');

        await stories.doc(userId).set({
          "userId": userId,
          "userName": userName,
          "profilePicture": profilePictureUrl,
          "timestamp": DateTime.now(),
          "stories": FieldValue.arrayUnion([
            // "mediaUrl":
            mediaUrl,
            // "mediaType": "image", // Could be dynamic if you support video
            // "timestamp": DateTime.now(),
            // "viewedBy": []
          ])
        }, SetOptions(merge: true));
        isUploading = false;
        notifyListeners();
        toastProvider.DelightToast(
                text: "Story Uploaded",
                icon: Icons.done,
                circleColor: Colors.lightGreen,
                iconColor: Colors.white,
                context: context)
            .show(context);

        print("Story uploaded successfully");
      } else {
        // If no image is selected, print a message
        toastProvider.DelightToast(
                text: "No image selected",
                icon: Icons.done,
                circleColor: Colors.lightGreen,
                iconColor: Colors.white,
                context: context)
            .show(context);
        print("No image selected");
      }
    } catch (e) {
      toastProvider.DelightToast(
              text: "Failed to Upload story",
              icon: Icons.done,
              circleColor: Colors.lightGreen,
              iconColor: Colors.white,
              context: context)
          .show(context);
      print("Failed to upload story: $e");
    }
  }

//get stories
  Stream<QuerySnapshot> getStories() {
    return FirebaseFirestore.instance.collection('stories').snapshots();
  }

  formatDate(Timestamp timestamp) {
    // DateTime dateTime = DateTime.parse(timestamp);
    DateTime dateTime = timestamp.toDate();

    // Format the date as '5-Oct, 07:05'
    String formattedDate = DateFormat('d-MMM, HH:mm').format(dateTime);
    return formattedDate;
    // print(formattedDate); // Example: 2024-10-04 – 03:10
  }
}
