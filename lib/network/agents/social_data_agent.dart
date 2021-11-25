import 'dart:io';

import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/data/vos/user_vo.dart';

abstract class SocialDataAgent {
  Stream<List<NewsFeedVO>> getNewsFeed();

  Future<void> createNewPost(NewsFeedVO newsFeed);

  Future<void> deletePost(int postId);

  Stream<NewsFeedVO> getNewFeedById(int postId);

  Future<String> uploadFileToFirebaseStorage(File file);

  Future registerNewUser(UserVO user);

  Future login(String email, String password);

  bool isLogin();

  UserVO getLoginUser();

  Future<void> logOut();
}
