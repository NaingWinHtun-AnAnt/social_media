import 'package:social_media/data/vos/user_vo.dart';

abstract class AuthModel {
  Future<void> registerNewUser(String userName, String email, String password);

  Future login(String email, String password);

  bool isLogin();

  UserVO getLoginUser();

  Future<void> logOut();
}
