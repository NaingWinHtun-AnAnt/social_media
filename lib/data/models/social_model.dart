import 'package:social_media/data/vos/news_feed_vo.dart';

abstract class SocialModel {
  Stream<List<NewsFeedVO>> getNewsFeed();

  Future<void> createNewPost(String description);
}
