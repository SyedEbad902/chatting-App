// ignore_for_file: use_build_context_synchronously, avoid_print

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

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final databaseProvider = getIt<DatabaseServiceProvider>();
  final toastProvider = getIt<ToastService>();

  //to upload file image  to firebase
  Future<void> uploadGalleryImage(
      File imageFile, String userName, BuildContext context) async {
    try {
      final user = authProvider.credential.currentUser;
      final uid = user?.uid;

      final ref = _storage
          .ref('users/profiles')
          .child('$uid${p.extension(imageFile.path)}');
      isloading = true;
      notifyListeners();
      await ref.putFile(imageFile);

      final imageUrl = await ref.getDownloadURL();

      await _firestore.collection('users').doc('$uid').set({
        'uid': uid,
        'imageUrl': imageUrl,
        'imageName': userName,
      });

      // ignore: avoid_print
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
  //to upload asset image to firebase

  Future<void> uploadAssetImage(
      String assetPath, String userName, BuildContext context) async {
    try {
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List imageData = byteData.buffer.asUint8List();

      final user = authProvider.credential.currentUser;
      final uid = user?.uid;

      final imageName = '$uid${p.extension(assetPath)}';

      final ref = _storage.ref('users/profiles').child(imageName);
      isloading = true;
      notifyListeners();
      await ref.putData(imageData);

      final imageUrl = await ref.getDownloadURL();

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
      final user = authProvider.credential.currentUser;
      final uid = user?.uid;

      final ref = _storage
          .ref('users/profiles')
          .child('$uid${p.extension(newImageFile.path)}');
      isloading = true;
      notifyListeners();
      await ref.putFile(newImageFile);

      final newImageUrl = await ref.getDownloadURL();

      await _firestore.collection('users').doc(uid).update({
        'imageUrl': newImageUrl, 
        'imageName': newUserName, 
      });
      
      print('Profile image and name updated in Firestore');
      isloading = false;
      notifyListeners();

   
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

  // update Username 
 Future<void> updateUsername(String newUserName, BuildContext context) async {
    try {
      final user = authProvider.credential.currentUser;
      final uid = user?.uid;

      await _firestore.collection('users').doc(uid).update({
        'imageName': newUserName, 
      });

      print('Username updated successfully in Firestore');

      isloading = false;
      notifyListeners();

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
    final String currentUserUid = authProvider.credential.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(
            currentUserUid)
        .get();
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
    } else {
      return null; 
    }
  }



//upload stories

  bool isUploading = false;
  Future<void> pickAndUploadStory(String userId, String userName,
      String profilePictureUrl, BuildContext context) async {
    try {
      
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        isUploading = true;
        notifyListeners();
        File imageFile = File(pickedFile.path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageRef = storage.ref().child("stories/$userId/$fileName");
        UploadTask uploadTask = storageRef.putFile(imageFile);

        TaskSnapshot storageSnapshot = await uploadTask;
        String mediaUrl = await storageSnapshot.ref.getDownloadURL();

        CollectionReference stories =
            FirebaseFirestore.instance.collection('stories');

        await stories.doc(userId).set({
          "userId": userId,
          "userName": userName,
          "profilePicture": profilePictureUrl,
          "timestamp": DateTime.now(),
          "stories": FieldValue.arrayUnion([
            mediaUrl,
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
    DateTime dateTime = timestamp.toDate();

    String formattedDate = DateFormat('d-MMM, HH:mm').format(dateTime);
    return formattedDate;
  }
}
