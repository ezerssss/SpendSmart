import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/errors/auth.dart';
import 'package:spendsmart/errors/network.dart';
import 'package:spendsmart/utils/network.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadImage(String uri) async {
    final hasConnection = await hasNetwork();

    if (!hasConnection) {
      throw NoNetwork();
    }

    final user = AppState().currentUser.value;

    if (user.isEmpty) {
      throw NoUser();
    }

    final file = File(uri);
    final uuid = Uuid();
    final receiptFileRef = _storage.ref("receipts/${user["uid"]}/${uuid.v4()}");

    await receiptFileRef.putFile(file);
    final url = await receiptFileRef.getDownloadURL();
    return url;
  }
}
