import 'package:flutter/material.dart';
import 'package:social_media/data/models/social_model.dart';
import 'package:social_media/data/models/social_model_impl.dart';

class AddNewPostBloc extends ChangeNotifier {
  /// states
  bool isDispose = false;
  bool isAddNewPostError = false;
  String description = "";

  /// models
  final SocialModel _mSocialModel = SocialModelImpl();

  void onNewPostTextChanged(String postDescription) {
    description = postDescription;
  }

  Future onCreateNewPost() {
    if (description.isEmpty) {
      isAddNewPostError = true;
      if (!isDispose) notifyListeners();
      return Future.error("Error");
    } else {
      isAddNewPostError = false;
      return _mSocialModel.createNewPost(description);
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDispose = true;
  }
}
