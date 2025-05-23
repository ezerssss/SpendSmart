import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    try {
      final docRef = _db.collection("users").doc(user.uid);
      final getDocRef = await docRef.get();

      if (!getDocRef.exists) {
        final userData = {
          "uid": user.uid,
          "displayName": user.displayName,
          "email": user.email,
        };

        await docRef.set(userData);
      }
    } on Exception catch (e) {
      log('exception->$e');
    }
  }
}
