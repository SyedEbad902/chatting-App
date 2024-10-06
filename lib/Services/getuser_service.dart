// import 'package:chatapp/Services/auth_service.dart';
// import 'package:chatapp/main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class GetuserService extends ChangeNotifier {


//   Map<String, dynamic>? userProfileMap = {};


//    Future<Map<String, dynamic>?> getCurrentUserProfile() async {
//       final authProvider = getIt<FirebaseAuthService>();

//     // Get the current user's UID from Firebase Authentication
//     final String currentUserUid =authProvider.credential.currentUser!.uid;

//     // Fetch the current user's profile document from Firestore
//     DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//         .instance
//         .collection('users')
//         .doc(
//             currentUserUid) // Retrieve the document where the UID matches the current user's UID
//         .get();

//     // Check if the document exists and return the profile data
//     if (snapshot.exists) {
//       userProfileMap = snapshot.data();
//       return userProfileMap; // This returns the document data as a Map<String, dynamic>
//     } else {
//       return null; // Return null if the document doesn't exist
//     }
//   }

// }

