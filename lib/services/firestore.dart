import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> addUser(User user) async {
    try {
      final docRef = db.collection("users").doc(user.uid);
      final userDoc = await docRef.get();

      if (!userDoc.exists) {
        final userData = {
          "uid": user.uid,
          "displayName": user.displayName,
          "email": user.email,
          "isOnboarded": false,
        };

        await docRef.set(userData);
        return userData;
      }

      return userDoc.data()!;
    } on Exception catch (e) {
      log('exception->$e');
      rethrow;
    }
  }

  static Future<void> completeOnboarding(String userId) async {
    try {
      final docRef = db.collection("users").doc(userId);

      await docRef.update({"isOnboarded": true});
    } on Exception catch (e) {
      log('exception->$e');
      rethrow;
    }
  }
}
