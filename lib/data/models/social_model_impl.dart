import 'dart:io';

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
  Future<void> createNewPost(String description, File? file) {
    if (file != null) {
      return mFireStoreDataAgent.uploadFileToFirebaseStorage(file).then(
            (imageUrl) => craftNewFeedVO(description, imageUrl).then(
              (value) => mFireStoreDataAgent.createNewPost(value),
            ),
          );
    } else {
      return craftNewFeedVO(description, "").then(
        (value) => mFireStoreDataAgent.createNewPost(value),
      );
    }
  }

  Future<NewsFeedVO> craftNewFeedVO(String description, String imageUrl) {
    var currentMilliSecond = DateTime.now().millisecondsSinceEpoch;
    NewsFeedVO newPost = NewsFeedVO(
      id: currentMilliSecond,
      postImage: imageUrl,
      description: description,
      profilePicture: MY_PROFILE_IMAGE,
      userName: "Naing Win Htun",
    );
    return Future.value(newPost);
  }

  @override
  Future<void> editPost(NewsFeedVO newFeed, File? file) {
    if (file != null) {
      return mFireStoreDataAgent.uploadFileToFirebaseStorage(file).then(
        (imageUrl) {
          newFeed.postImage = imageUrl;
          mFireStoreDataAgent.createNewPost(newFeed);
        },
      );
    } else {
      return mFireStoreDataAgent.createNewPost(newFeed);
    }
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
