import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      log('Firebase initialization error: $e');
    }
  }
}
