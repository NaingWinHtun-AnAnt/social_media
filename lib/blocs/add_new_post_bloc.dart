import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media/analytics/firebase_analytics_tracker.dart';
import 'package:social_media/data/models/auth_model.dart';
import 'package:social_media/data/models/auth_model_impl.dart';
import 'package:social_media/data/models/social_model.dart';
import 'package:social_media/data/models/social_model_impl.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/data/vos/user_vo.dart';
import 'package:social_media/resources/images.dart';

class AddNewPostBloc extends ChangeNotifier {
  /// states
  bool isDispose = false;
  bool isAddNewPostError = false;
  bool isLoading = false;
  String description = "";
  File? chosenImageFile;

  /// edit mode
  bool isEditMode = false;
  String userName = "";
  String profilePicture = "";
  String? postImage;
  NewsFeedVO? newsFeed;
  UserVO? user;

  /// models
  final SocialModel _mSocialModel = SocialModelImpl();
  final AuthModel _mAuthModel = AuthModelImpl();

  AddNewPostBloc(int? postId) {
    user = _mAuthModel.getLoginUser();
    if (postId != null) {
      isEditMode = true;
      _prePopulateDataForEditMode(postId);
    } else {
      isEditMode = false;
      _prePopulateDataForAddNewPost();
    }

    /// log add new screen reach on firebase analytics
    _sendAnalyticsData(addNewPostScreenReached);
  }

  void _prePopulateDataForEditMode(int postId) {
    _mSocialModel.getNewFeedById(postId).listen((newFeed) {
      userName = newFeed.userName ?? "";
      profilePicture = newFeed.profilePicture ?? "";
      description = newFeed.description ?? "";
      postImage = newFeed.postImage == "" ? null : newFeed.postImage;
      newsFeed = newFeed;
      _notifySafety();
    });
  }

  void _prePopulateDataForAddNewPost() {
    userName = user?.userName ?? "";
    profilePicture = MY_PROFILE_IMAGE;
    _notifySafety();
  }

  void onNewPostTextChanged(String postDescription) {
    description = postDescription;
  }

  void onImageChosen(File imageFile) {
    chosenImageFile = imageFile;
    _notifySafety();
  }

  void onTapDeleteImage() {
    postImage = null;
    _notifySafety();
    chosenImageFile = null;
    _notifySafety();
  }

  Future onCreateNewPost() {
    if (description.isEmpty) {
      isAddNewPostError = true;
      _notifySafety();
      return Future.error("Error");
    } else {
      isLoading = true;
      _notifySafety();
      isAddNewPostError = false;
      if (isEditMode) {
        return _editPost().then((value) {
          isLoading = false;
          _notifySafety();

          /// log edit post action on firebase analytics
          _sendAnalyticsData(
            editPostAction,
            parameters: {postId: newsFeed?.id ?? ""},
          );
        });
      } else {
        return _createNewPost().then((value) {
          isLoading = false;
          _notifySafety();

          /// log add new post action on firebase analytics
          _sendAnalyticsData(addNewPostAction);
        });
      }
    }
  }

  Future<void> _editPost() {
    newsFeed?.description = description;
    newsFeed?.postImage = postImage;
    if (newsFeed != null) {
      return _mSocialModel.editPost(newsFeed!, chosenImageFile);
    } else {
      return Future.error("New Feed Null Error");
    }
  }

  Future<void> _createNewPost() => _mSocialModel.createNewPost(
        description,
        chosenImageFile,
      );

  void _sendAnalyticsData(String name, {Map<String, dynamic>? parameters}) {
    FirebaseAnalyticsTracker().logEvent(name, parameters: parameters);
  }

  void _notifySafety() {
    if (!isDispose) notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose = true;
  }
}
