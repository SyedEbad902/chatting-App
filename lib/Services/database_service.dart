import 'dart:async';
import 'dart:convert';

import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DatabaseServiceProvider extends ChangeNotifier {
  // Map<String, dynamic>? userProfileMap = {};
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final authProvider = getIt<FirebaseAuthService>();

  // Get the current user's UID
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserProfiles() {
    final String currentUserUid = authProvider.credential.currentUser!.uid;
    return firestore
        .collection('users')
        .where('uid',
            isNotEqualTo: currentUserUid) // Exclude the current user's profile
        .snapshots();
  }

  Future<bool> checkChatExist(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final result = await firestore.collection("chats").doc(chatId).get();
    return result.exists;
  }

  Future<void> createNewChat(
      {required String uid1, required String uid2}) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = firestore.collection("chats").doc(chatId);
    final chat = {
      "id": chatId,
      "participants": [uid1, uid2],
      "messages": []
    };
    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = firestore.collection("chats").doc(chatId);
    await docRef.update({
      "messages": FieldValue.arrayUnion([message.toJson()])
    });
  }

  Future<String?> getCurrentTimeFromInternet() async {
    try {
      // World Time API URL (you can change the timezone)
      final url = Uri.parse("http://worldtimeapi.org/api/ip");

      // Send HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = jsonDecode(response.body);

        // Get the datetime string
        String dateTimeStr = data['datetime'];
        // print(dateTimeStr);
        // Parse the string to DateTime
        DateTime currentTime = DateTime.parse(dateTimeStr);

        return dateTimeStr;
      } else {
        print('Failed to fetch time. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching time: $e');
      return null;
    }
  }

  Stream<DocumentSnapshot<Map>> getChat(String uid1, String uid2) {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    return firestore.collection("chats").doc(chatId).snapshots()
        as Stream<DocumentSnapshot<Map>>;
  }

  String generateChatId({required String uid1, required String uid2}) {
    List uids = [uid1, uid2];
    uids.sort();
    String chatId = uids.fold("", (id, uid) => "$id$uid");
    return chatId;
  }
}
