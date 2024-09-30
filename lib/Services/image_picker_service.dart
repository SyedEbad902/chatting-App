import 'dart:io';

import 'package:chatapp/Screens/home_screen.dart';
import 'package:chatapp/Screens/navbar.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ImagePickerService extends ChangeNotifier {
  bool isloading = false;

  final authProvider = getIt<FirebaseAuthService>();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final databaseProvider = getIt<DatabaseServiceProvider>();

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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MessageScreen()));
      DelightToast(
              text: "Your profile hs been setup successfully",
              icon: Icons.done,
              circleColor: Colors.lightGreen,
              iconColor: Colors.white)
          .show(context);
    } catch (e) {
      DelightToast(
              text: "Something went wrong!",
              icon: Icons.cancel_outlined,
              circleColor: Colors.white,
              iconColor: Colors.red)
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

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyNavBar()));
    } catch (e) {
      print('Error uploading image: $e');
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

//get current user profile
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
      authProvider.userProfileMap = snapshot.data();
      return authProvider
          .userProfileMap; // This returns the document data as a Map<String, dynamic>
    } else {
      return null; // Return null if the document doesn't exist
    }
  }

//for toasts

  DelightToastBar DelightToast(
      {required String text,
      required IconData icon,
      required Color circleColor,
      required Color iconColor}) {
    return DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      builder: (context) => ToastCard(
        color: Colors.white,
        leading: CircleAvatar(
          backgroundColor: circleColor,
          radius: 20,
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
