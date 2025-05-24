import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendsmart/services/firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final dbService = FirestoreService();
      final user = await dbService.addUser(userCredential.user!);

      return user;
    } on Exception catch (e) {
      log('exception->$e');
      rethrow;
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
