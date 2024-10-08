// ignore_for_file: use_build_context_synchronously, avoid_print

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

// check if user exist in database
  Future<bool> checkIfUserExists(String currentUserUid) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUserUid)
        .get();

    return userDoc.exists;
  }

// login user with credentials
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      ZegoUIKitPrebuiltCallInvitationService().uninit();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  //Signup with email password

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
      }
    } catch (e) {
      print(e);
    }
  }

  //get current user profile
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final String currentUserUid = credential.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(
            currentUserUid)
        .get();

    if (snapshot.exists) {
      userProfileMap = snapshot.data();
      return userProfileMap; // This returns the document data as a Map<String, dynamic>
    } else {
      return null; 
    }
  }

 // Stream of all users except the currently logged-in user
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserProfiles() {
           final String currentUserUid = credential.currentUser!.uid;

    return _firestore
        .collection('users')
        .where('uid',
            isNotEqualTo: currentUserUid) 
        .snapshots();
  }

  void onUserLogin() {
    
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID:       , //*input your AppID*//
      appSign: " ", //*input your AppSign*//
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


        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons
            .insert(0, ZegoCallMenuBarButtonName.minimizingButton);

        return config;
      },
    );
  }
}
