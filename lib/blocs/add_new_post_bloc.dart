import 'package:flutter/material.dart';
import 'package:social_media/data/models/social_model.dart';
import 'package:social_media/data/models/social_model_impl.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/resources/images.dart';

class AddNewPostBloc extends ChangeNotifier {
  /// states
  bool isDispose = false;
  bool isAddNewPostError = false;
  String description = "";

  /// edit mode
  bool isEditMode = false;
  String userName = "";
  String profilePicture = "";
  NewsFeedVO? mNewsFeed;

  /// models
  final SocialModel _mSocialModel = SocialModelImpl();

  AddNewPostBloc(int? postId) {
    if (postId != null) {
      isEditMode = true;
      _prePopulateDataForEditMode(postId);
    } else {
      isEditMode = false;
      _prePopulateDataForAddNewPost();
    }
  }

  void _prePopulateDataForEditMode(int postId) {
    _mSocialModel.getNewFeedById(postId).listen((newFeed) {
      userName = newFeed.userName ?? "";
      profilePicture = newFeed.profilePicture ?? "";
      description = newFeed.description ?? "";
      mNewsFeed = newFeed;
      _notifySafety();
    });
  }

  void _prePopulateDataForAddNewPost() {
    userName = "Naing Win Htun";
    profilePicture = MY_PROFILE_IMAGE;
    _notifySafety();
  }

  void onNewPostTextChanged(String postDescription) {
    description = postDescription;
  }

  Future onCreateNewPost() {
    if (description.isEmpty) {
      isAddNewPostError = true;
      _notifySafety();
      return Future.error("Error");
    } else {
      isAddNewPostError = false;
      return isEditMode ? _editPost() : _createNewPost();
    }
  }

  Future<void> _editPost() {
    mNewsFeed?.description = description;
    if (mNewsFeed != null) {
      return _mSocialModel.editPost(mNewsFeed!);
    } else {
      return Future.error("New Feed Null Error");
    }
  }

  Future<void> _createNewPost() => _mSocialModel.createNewPost(description);

  void _notifySafety() {
    if (!isDispose) notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose = true;
  }
}
