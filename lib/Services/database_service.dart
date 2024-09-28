// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class DatabaseServiceProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Get the current user's UID
//   final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

//   // Stream of all users except the currently logged-in user
//   Stream<QuerySnapshot<Map<String, dynamic>>> getUserProfiles() {
//     return _firestore
//         .collection('users')
//         .where('uid',
//             isNotEqualTo: currentUserUid) // Exclude the current user's profile
//         .snapshots();
//   }
// }

// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

// //    Stream<QuerySnapshot<Map<String, dynamic>>> getUserProfile() {
// //     return _firestore
// //         .collection('users')
// //         .where('uid', isNotEqualTo: currentUserUid)
// //         .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
// //   }
// // }
