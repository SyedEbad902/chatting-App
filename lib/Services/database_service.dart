import 'dart:async';

import 'package:chatapp/Models/message_model.dart';
import 'package:chatapp/Services/auth_service.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseServiceProvider extends ChangeNotifier {
  // Map<String, dynamic>? userProfileMap = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authProvider = getIt<FirebaseAuthService>();

  // Get the current user's UID
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserProfiles() {
    final String currentUserUid = authProvider.credential.currentUser!.uid;
    return _firestore
        .collection('users')
        .where('uid',
            isNotEqualTo: currentUserUid) // Exclude the current user's profile
        .snapshots();
  }

  Future<bool> checkChatExist(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final result = await _firestore.collection("chats").doc(chatId).get();
    if (result != null) {
      return result.exists;
    } else {
      return false;
    }
  }

  Future<void> createNewChat(
      {required String uid1, required String uid2}) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = await _firestore.collection("chats").doc(chatId);
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
    final docRef = await _firestore.collection("chats").doc(chatId);
    await docRef.update({
      "messages": FieldValue.arrayUnion([message.toJson()])
    });
  }

  Stream<DocumentSnapshot<Map>> getChat(String uid1, String uid2) {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    return _firestore.collection("chats").doc(chatId).snapshots() as Stream<DocumentSnapshot<Map>>;
  }

  String generateChatId({required String uid1, required String uid2}) {
    List uids = [uid1, uid2];
    uids.sort();
    String chatId = uids.fold("", (id, uid) => "$id$uid");
    return chatId;
  }
}
