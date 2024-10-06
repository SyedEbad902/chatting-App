import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallingService extends ChangeNotifier {
  List<Map<String, dynamic>> allCalls = [];
  Future<List<Map<String, dynamic>>> getAllCalls() async {
    allCalls.clear();

    final authService = getIt<FirebaseAuthService>();
    String userId = authService.credential.currentUser!.uid;
    final dataBaseService = getIt<DatabaseServiceProvider>();

    // Step 1: Fetch calls where the user is the caller (outgoing calls from their own doc)
    DocumentSnapshot userDoc = await dataBaseService.firestore
        .collection('call_invitations')
        .doc(userId)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      List<dynamic> userCalls = userDoc['calls'];
      allCalls.addAll(userCalls.cast<Map<String, dynamic>>());
    }

    // Step 2: Fetch calls where the user is the callee (incoming calls from other users)
    QuerySnapshot otherUsersCalls =
        await dataBaseService.firestore.collection('call_invitations').get();

    for (var doc in otherUsersCalls.docs) {
      if (doc.id != userId) {
        List<dynamic> calls = doc['calls'];
        for (var call in calls) {
          if (call['inviteeID'] == userId) {
            allCalls.add(call as Map<String, dynamic>);
          }
        }
      }
    }
    print("This is all callss of $allCalls");
    allCalls.sort((a, b) => DateTime.parse(b["timestamp"])
        .compareTo(DateTime.parse(a["timestamp"])));

    return allCalls;
  }

  formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    dateTime = dateTime.toLocal();

    // Formatting to a more readable format
    String formattedDate = DateFormat('MMM d, yyyy – kk:mm').format(dateTime);
    return formattedDate;
  }
}
