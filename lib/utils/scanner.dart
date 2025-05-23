class ScannerUtils {
  static String extractFileUri(String data) {
    return data.split("file://")[1].replaceAll("}]", "");
  }
}
