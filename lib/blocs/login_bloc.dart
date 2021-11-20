import 'package:flutter/material.dart';

class LoginBloc extends ChangeNotifier {
  bool isDispose = false;
  bool isLoading = false;
  String email = "";
  String password = "";

  void onTapLogin() {
    _showLoading();
    Future.delayed(
      Duration(
        seconds: 2,
      ),
    ).then(
      (value) => _hideLoading(),
    );
  }

  void onEmailChanged(String email) {
    this.email = email;
  }

  void onPasswordChanged(String password) {
    this.password = password;
  }

  void _showLoading() {
    isLoading = true;
    _notifySafety();
  }

  void _hideLoading() {
    isLoading = false;
    _notifySafety();
  }

  void _notifySafety() {
    if (!isDispose) notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose = true;
  }
}
