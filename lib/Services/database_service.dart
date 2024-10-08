// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DatabaseServiceProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final authProvider = getIt<FirebaseAuthService>();

  // Get all user's prfile
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserProfiles() {
    final String currentUserUid = authProvider.credential.currentUser!.uid;
    return firestore
        .collection('users')
        .where('uid',
            isNotEqualTo: currentUserUid) // Exclude the current user's profile
        .snapshots();
  }
// check if chat already exist
  Future<bool> checkChatExist(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final result = await firestore.collection("chats").doc(chatId).get();
    return result.exists;
  }
//create new chat
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

//get current time from api
  Future<String?> getCurrentTimeFromInternet() async {
    try {
      final url = Uri.parse("http://worldtimeapi.org/api/ip");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String dateTimeStr = data['datetime'];
        DateTime.parse(dateTimeStr);

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
//get all old chats b/w the users
  Stream<DocumentSnapshot<Map>> getChat(String uid1, String uid2) {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    return firestore.collection("chats").doc(chatId).snapshots()
        as Stream<DocumentSnapshot<Map>>;
  }

// generate unique if for two users chat
  String generateChatId({required String uid1, required String uid2}) {
    List uids = [uid1, uid2];
    uids.sort();
    String chatId = uids.fold("", (id, uid) => "$id$uid");
    return chatId;
  }
}
