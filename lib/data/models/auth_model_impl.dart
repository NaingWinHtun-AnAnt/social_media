import 'package:social_media/data/models/auth_model.dart';
import 'package:social_media/data/vos/user_vo.dart';
import 'package:social_media/network/agents/cloud_fire_store_data_agent_impl.dart';
import 'package:social_media/network/agents/social_data_agent.dart';

class AuthModelImpl extends AuthModel {
  static final AuthModelImpl _singleton = AuthModelImpl._internal();

  factory AuthModelImpl() {
    return _singleton;
  }

  AuthModelImpl._internal();

  /// data agent
  final SocialDataAgent _mDataAgent = CloudFireStoreDataAgentImpl();

  @override
  Future<void> registerNewUser(String userName, String email, String password) {
    return _craftUserVO(userName, email, password).then(
      (user) => _mDataAgent.registerNewUser(user),
    );
  }

  Future<UserVO> _craftUserVO(String userName, String email, String password) {
    final newUser = UserVO(
      id: "",
      userName: userName,
      email: email,
      password: password,
    );
    return Future.value(newUser);
  }

  @override
  Future login(String email, String password) {
    return _mDataAgent.login(email, password);
  }

  @override
  bool isLogin() {
    return _mDataAgent.isLogin();
  }

  @override
  UserVO getLoginUser() {
    return _mDataAgent.getLoginUser();
  }

  @override
  Future<void> logOut() {
    return _mDataAgent.logOut();
  }
}
