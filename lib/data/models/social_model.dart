import 'dart:io';

import 'package:social_media/data/vos/news_feed_vo.dart';

abstract class SocialModel {
  Stream<List<NewsFeedVO>> getNewsFeed();

  Future<void> createNewPost(String description, File? imageFile);

  Future<void> editPost(NewsFeedVO newFeed, File? imageFile);

  Future<void> deletePost(int String);

  Stream<NewsFeedVO> getNewFeedById(int postId);
}
