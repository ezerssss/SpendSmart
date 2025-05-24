import 'package:flutter/material.dart';

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  ValueNotifier<Map<String, dynamic>> currentUser = ValueNotifier({});
}
