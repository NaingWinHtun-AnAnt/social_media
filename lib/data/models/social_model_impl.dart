import 'package:social_media/data/models/social_model.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/network/agents/cloud_fire_store_data_agent_impl.dart';
import 'package:social_media/network/agents/social_data_agent.dart';
import 'package:social_media/resources/images.dart';

class SocialModelImpl extends SocialModel {
  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  factory SocialModelImpl() {
    return _singleton;
  }

  SocialModelImpl._internal();

  /// data agent
  // final SocialDataAgent mRealTimeDataAgent = RealtimeDatabaseDataAgentImpl();
  final SocialDataAgent mFireStoreDataAgent = CloudFireStoreDataAgentImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return mFireStoreDataAgent.getNewsFeed();
  }

  @override
  Future<void> createNewPost(String description) {
    var currentMilliSecond = DateTime.now().millisecondsSinceEpoch;
    NewsFeedVO newPost = NewsFeedVO(
      id: currentMilliSecond,
      postImage: "",
      description: description,
      profilePicture: MY_PROFILE_IMAGE,
      userName: "Naing Win Htun",
    );
    return mFireStoreDataAgent.createNewPost(newPost);
  }

  @override
  Future<void> editPost(NewsFeedVO newFeed) {
    return mFireStoreDataAgent.createNewPost(newFeed);
  }

  @override
  Future<void> deletePost(int postId) {
    return mFireStoreDataAgent.deletePost(postId);
  }

  @override
  Stream<NewsFeedVO> getNewFeedById(int postId) {
    return mFireStoreDataAgent.getNewFeedById(postId);
  }
}
