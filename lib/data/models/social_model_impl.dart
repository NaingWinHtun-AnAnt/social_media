import 'dart:io';

import 'package:social_media/data/models/auth_model.dart';
import 'package:social_media/data/models/auth_model_impl.dart';
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
  final SocialDataAgent _mFireStoreDataAgent = CloudFireStoreDataAgentImpl();
  final AuthModel _mAuthModel = AuthModelImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return _mFireStoreDataAgent.getNewsFeed();
  }

  @override
  Future<void> createNewPost(String description, File? file) {
    if (file != null) {
      return _mFireStoreDataAgent.uploadFileToFirebaseStorage(file).then(
            (imageUrl) => craftNewFeedVO(description, imageUrl).then(
              (value) => _mFireStoreDataAgent.createNewPost(value),
            ),
          );
    } else {
      return craftNewFeedVO(description, "").then(
        (value) => _mFireStoreDataAgent.createNewPost(value),
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
      userName: _mAuthModel.getLoginUser().userName,
    );
    return Future.value(newPost);
  }

  @override
  Future<void> editPost(NewsFeedVO newFeed, File? file) {
    if (file != null) {
      return _mFireStoreDataAgent.uploadFileToFirebaseStorage(file).then(
        (imageUrl) {
          newFeed.postImage = imageUrl;
          _mFireStoreDataAgent.createNewPost(newFeed);
        },
      );
    } else {
      return _mFireStoreDataAgent.createNewPost(newFeed);
    }
  }

  @override
  Future<void> deletePost(int postId) {
    return _mFireStoreDataAgent.deletePost(postId);
  }

  @override
  Stream<NewsFeedVO> getNewFeedById(int postId) {
    return _mFireStoreDataAgent.getNewFeedById(postId);
  }
}
