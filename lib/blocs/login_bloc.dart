import 'package:flutter/material.dart';
import 'package:social_media/data/models/auth_model.dart';
import 'package:social_media/data/models/auth_model_impl.dart';

class LoginBloc extends ChangeNotifier {
  /// states
  bool isDispose = false;
  bool isLoading = false;
  String email = "";
  String password = "";

  /// models
  final AuthModel _authModel = AuthModelImpl();

  Future onTapLogin() {
    _showLoading();
    return _authModel.login(email, password).whenComplete(
          () => _hideLoading(),
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
