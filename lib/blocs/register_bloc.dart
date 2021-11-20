import 'package:flutter/foundation.dart';
import 'package:social_media/data/models/auth_model.dart';
import 'package:social_media/data/models/auth_model_impl.dart';

class RegisterBloc extends ChangeNotifier {
  bool isDispose = false;
  bool isLoading = false;
  String email = "";
  String password = "";
  String userName = "";

  /// models
  final AuthModel _authModel = AuthModelImpl();

  Future onTapRegister() {
    _showLoading();
    return _authModel.registerNewUser(userName, email, password).whenComplete(
          () => _hideLoading(),
        );
  }

  void onEmailChanged(String email) {
    this.email = email;
  }

  void onPasswordChanged(String password) {
    this.password = password;
  }

  void onUserNameChanged(String userName) {
    this.userName = userName;
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
