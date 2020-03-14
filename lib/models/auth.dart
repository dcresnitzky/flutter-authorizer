import 'package:flutter/material.dart';
import 'package:twofactorauthorizer/auth/auth.dart';

class AuthModel extends ChangeNotifier {
  final Auth auth = Auth();
  bool isLoading = false;

  void toggleLoading() {
    this.isLoading = !this.isLoading;

    notifyListeners();
  }

}