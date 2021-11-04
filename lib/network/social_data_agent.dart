import 'package:social_media/data/vos/news_feed_vo.dart';

abstract class SocialDataAgent {
  Stream<List<NewsFeedVO>> getNewsFeed();

  Future<void> createNewPost(NewsFeedVO newsFeed);

  Future<void> deletePost(int postId);

  Stream<NewsFeedVO> getNewFeedById(int postId);
}
