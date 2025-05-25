import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';

class ScannerUtils {
  static String extractFileUri(String data) {
    final splitRes = data.split("file://");

    if (splitRes.length < 2) {
      return "";
    }

    return splitRes[1].replaceAll("}]", "");
  }

  static Future<String> scanReceipt() async {
    dynamic scannerResult;

    try {
      scannerResult =
          await FlutterDocScanner().getScanDocumentsUri(page: 1) ?? '';
    } on PlatformException {
      scannerResult = '';
    }

    if (scannerResult is Map) {
      if (!scannerResult.containsKey("Uri")) {
        return "";
      }

      return extractFileUri(scannerResult["Uri"].toString());
    }

    return "";
  }
}
