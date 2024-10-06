// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/Screens/login_screen.dart';
import 'package:chatapp/Screens/navbar.dart';
import 'package:chatapp/Screens/profile_screen.dart';
import 'package:chatapp/Services/toast_service.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final credential = FirebaseAuth.instance;
  final toastProvider = getIt<ToastService>();
  String? _errorMessage;

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
        toastProvider.DelightToast(
                text: "Loggedin Successfully",
                icon: Icons.done,
                circleColor: Colors.lightGreen,
                iconColor: Colors.white,
                context: context)
            .show(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MyNavBar()));
        onUserLogin();
      } else {
        onUserLogin();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      toastProvider.DelightToast(
              text: _errorMessage!,
              icon: Icons.cancel,
              circleColor: Colors.white,
              iconColor: Colors.red,
              context: context)
          .show(context);
    }
  }

//logout
  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login or welcome screen after signing out (optional)
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      ZegoUIKitPrebuiltCallInvitationService().uninit();
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
      toastProvider.DelightToast(
              text: "Signup Successful",
              icon: Icons.done,
              circleColor: Colors.lightGreen,
              iconColor: Colors.white,
              context: context)
          .show(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Signup Successful')),
      // );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        toastProvider.DelightToast(
                text: 'This email is already in use',
                icon: Icons.cancel,
                circleColor: Colors.white,
                iconColor: Colors.red,
                context: context)
            .show(context);
        // print('The account already exists for that email.');
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
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserProfiles() {
           final String currentUserUid = credential.currentUser!.uid;

    return _firestore
        .collection('users')
        .where('uid',
            isNotEqualTo: currentUserUid) // Exclude the current user's profile
        .snapshots();
  }

  void onUserLogin() {
    /// 1.2.1. initialized ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged in or re-logged in
    /// We recommend calling this method as soon as the user logs in to your app.
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 2087105392 /*input your AppID*/,
      appSign:
          "96e4ea6eb8c59732dddaa6b832a30920fa30f3688c6976674b60cbbbe1bdf7a4" /*input your AppSign*/,
      userID: credential.currentUser!.uid,
      userName:
       userProfileMap!["imageName"],
      plugins: [ZegoUIKitSignalingPlugin()],
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoCallAndroidNotificationConfig(
          showFullScreen: true,
          fullScreenBackgroundAssetURL: 'assets/image/call.png',
          callChannel: ZegoCallAndroidNotificationChannelConfig(
            channelID: "ZegoUIKit",
            channelName: "Call Notifications",
            sound: "call",
            icon: "call",
          ),
          missedCallChannel: ZegoCallAndroidNotificationChannelConfig(
            channelID: "MissedCall",
            channelName: "Missed Call",
            sound: "missed_call",
            icon: "missed_call",
            vibrate: false,
          ),
        ),
        iOSNotificationConfig: ZegoCallIOSNotificationConfig(
          systemCallingIconName: 'CallKitIcon',
        ),
      ),
      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.invitees.length > 1)
            ? ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        // config.avatarBuilder = customAvatarBuilder;

        /// support minimizing, show minimizing button
        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons
            .insert(0, ZegoCallMenuBarButtonName.minimizingButton);

        return config;
      },
    );
  }
}
