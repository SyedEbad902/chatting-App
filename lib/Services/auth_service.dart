import 'package:chatapp/Screens/login_screen.dart';
import 'package:chatapp/Screens/navbar.dart';
import 'package:chatapp/Screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService extends ChangeNotifier {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final credential = FirebaseAuth.instance;
  Map<String, dynamic>? userProfileMap = {};

  Future<bool> checkIfUserExists(String currentUserUid) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    return userDoc.exists;
  }

  signinUser(String emailAddress, String password, BuildContext context) async {
    try {
      await credential.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      final String currentUserUid = credential.currentUser!.uid;
      bool userExists = await checkIfUserExists(currentUserUid);

      if (userExists) {
        userProfileMap?.clear();
        await getCurrentUserProfile();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MyNavBar()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

//logout
  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login or welcome screen after signing out (optional)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      print('Error signing out: $e');
      // You can also show a dialog or a snackbar with the error message
    }
  }

  //Signup

  createUser(String email, String password, BuildContext context) async {
    try {
      // final credential =
      await credential.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Successful')),
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  //get current user profile
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
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
      return userProfileMap; // This returns the document data as a Map<String, dynamic>
    } else {
      return null; // Return null if the document doesn't exist
    }
  }

  // Stream of all users except the currently logged-in user
  // Stream<QuerySnapshot<Map<String, dynamic>>> getUserProfiles() {
  //          final String currentUserUid = credential.currentUser!.uid;

  //   return _firestore
  //       .collection('users')
  //       .where('uid',
  //           isNotEqualTo: currentUserUid) // Exclude the current user's profile
  //       .snapshots();
  // }
}
