import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendsmart/services/firestore.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);

      final user = await FirestoreService.addUser(userCredential.user!);
      return user;
    } on Exception catch (e) {
      log('exception->$e');
      rethrow;
    }
  }

  static Future<bool> signOutFromGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await auth.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
