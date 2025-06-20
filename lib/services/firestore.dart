import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/errors/auth.dart';
import 'package:spendsmart/errors/network.dart';
import 'package:spendsmart/models/receipt.dart';

import '../utils/network.dart';

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
      if (receiptId == null || receiptId.trim().isEmpty) {
        final docRef = receiptsRef.doc();

        final receiptWithId = Receipt(
          id: docRef.id,
          businessName: receipt.businessName,
          category: receipt.category,
          items: receipt.items,
          date: receipt.date,
          totalPrice: receipt.totalPrice,
          imageUrl: receipt.imageUrl,
        );

        await docRef.set(Receipt.toMap(receiptWithId));
        return docRef.id;
      } else {
        final docRef = receiptsRef.doc(receiptId);

        final receiptWithId = Receipt(
          id: receiptId,
          businessName: receipt.businessName,
          category: receipt.category,
          items: receipt.items,
          date: receipt.date,
          totalPrice: receipt.totalPrice,
          imageUrl: receipt.imageUrl,
        );

        await docRef.set(Receipt.toMap(receiptWithId));
        return receiptId;
      }
    } catch (e) {
      log('Error saving receipt: $e');
      rethrow;
    }
  }

  static Future<void> saveMonthlyBudget(int budget) async {
    final hasConnection = await hasNetwork();

    if (!hasConnection) {
      throw NoNetwork();
    }

    final user = AppState().currentUser.value;

    if (user.isEmpty) {
      throw NoUser();
    }

    final userDocRef = db.collection("users").doc(user['uid']);

    await userDocRef.update({"monthlyBudget": budget});
  }
}
