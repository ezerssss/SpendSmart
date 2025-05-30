import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendsmart/models/receipt.dart';

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
          "monthlyBudget": 10000,
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

  static Future<List<Receipt>> getReceipts(
    String userId, {
    int? maxLimit,
  }) async {
    final receiptsCollectionRef = db
        .collection("users")
        .doc(userId)
        .collection("receipts");

    var query = receiptsCollectionRef.orderBy("date");

    if (maxLimit != null) {
      query.limit(maxLimit);
    }

    final res = await query.get();

    List<Receipt> receipts =
        res.docs.map((doc) => Receipt.fromMap(doc.data())).toList();
    return receipts;
  }

  static Future<String> saveReceipt({
    required String userId,
    required Receipt receipt,
    String? receiptId,
  }) async {
    final receiptsRef = db
        .collection("users")
        .doc(userId)
        .collection("receipts");

    try {
      if (receiptId?.trim().isEmpty ?? true) {
        final docRef = await receiptsRef.add(Receipt.toMap(receipt));
        return docRef.id;
      } else {
        final docRef = receiptsRef.doc(receiptId);
        await docRef.set(Receipt.toMap(receipt));
        return docRef.id;
      }
    } catch (e) {
      log('Error saving receipt: $e');
      rethrow;
    }
  }
}
