import 'package:flutter/foundation.dart';
import 'package:social_media/data/models/auth_model.dart';
import 'package:social_media/data/models/auth_model_impl.dart';
import 'package:social_media/data/models/social_model.dart';
import 'package:social_media/data/models/social_model_impl.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';

class NewsFeedBloc extends ChangeNotifier {
  /// states
  List<NewsFeedVO>? newsFeed;

  /// models
  final SocialModel _mSocialModel = SocialModelImpl();
  final AuthModel _mAuthModel = AuthModelImpl();

  bool isDisposed = false;

  NewsFeedBloc() {
    _mSocialModel.getNewsFeed().listen((newsFeedList) {
      newsFeed = newsFeedList;
      if (!isDisposed) {
        notifyListeners();
      }
    });
  }

  void onTapDelete(int postId) async {
    await _mSocialModel.deletePost(postId);
  }

  Future onTapLogout() => _mAuthModel.logOut();

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
