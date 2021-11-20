import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/add_new_post_bloc.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/strings.dart';
import 'package:social_media/widgets/button_view.dart';
import 'package:social_media/widgets/loading_view.dart';
import 'package:social_media/widgets/profile_image_view.dart';

class AddNewPostPage extends StatelessWidget {
  final int? postId;

  AddNewPostPage({
    this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewPostBloc(postId),
      child: Selector(
        selector: (
          BuildContext context,
          AddNewPostBloc bloc,
        ) =>
            bloc.isLoading,
        builder: (
          BuildContext context,
          bool isLoading,
          Widget? child,
        ) =>
            Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: false,
                title: Container(
                  margin: EdgeInsets.only(
                    left: MARGIN_MEDIUM,
                  ),
                  child: Text(
                    ADD_NEW_POST,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: TEXT_HEADING_1X,
                      color: Colors.black,
                    ),
                  ),
                ),
                elevation: 0.0,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: MARGIN_XLARGE,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    top: MARGIN_XLARGE,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileImageAndNameView(),
                      SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      AddNewPostTextFieldView(),
                      SizedBox(
                        height: MARGIN_MEDIUM,
                      ),
                      PostDescriptionErrorView(),
                      SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      PostImageView(),
                      SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      Consumer<AddNewPostBloc>(
                        builder: (BuildContext context, AddNewPostBloc bloc,
                                Widget? child) =>
                            ButtonView(
                          text: ACTION_POST,
                          onTap: () => bloc.onCreateNewPost().then((value) {
                            Navigator.of(context).pop();
                          }),
                        ),
                      ),
                      SizedBox(
                        height: MARGIN_LARGE,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: LoadingView(),
            ),
          ],
        ),
      ),
    );
  }
}

class PostImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => Container(
        padding: EdgeInsets.all(MARGIN_MEDIUM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          children: [
            Container(
              child: (bloc.chosenImageFile == null)
                  ? GestureDetector(
                      child: Image.network(
                        bloc.postImage != null
                            ? bloc.postImage ?? ""
                            : "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg",
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          bloc.onImageChosen(File(image.path));
                        }
                      },
                    )
                  : SizedBox(
                      height: 300,
                      child: Image.file(
                        bloc.chosenImageFile ?? File(""),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: bloc.chosenImageFile != null || bloc.postImage != null,
                child: GestureDetector(
                  onTap: () {
                    bloc.onTapDeleteImage();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      MARGIN_MEDIUM,
                    ),
                    child: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostDescriptionErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (BuildContext context, AddNewPostBloc bloc, Widget? child) =>
          Visibility(
        visible: bloc.isAddNewPostError,
        child: Text(
          POST_DESCRIPTION_EMPTY_ERROR,
          style: TextStyle(
            color: Colors.red,
            fontSize: TEXT_REGULAR,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ProfileImageAndNameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (BuildContext context, AddNewPostBloc bloc, Widget? child) =>
          Row(
        children: [
          ProfileImageView(
            profileImage: bloc.profilePicture,
          ),
          SizedBox(
            width: MARGIN_MEDIUM_2,
          ),
          Text(
            bloc.userName,
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AddNewPostTextFieldView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (BuildContext context, AddNewPostBloc bloc, Widget? child) =>
          SizedBox(
        height: ADD_NEW_POST_TEXT_FIELD_HEIGHT,
        child: TextField(
          maxLines: 24,
          onChanged: (text) => bloc.onNewPostTextChanged(text),
          controller: TextEditingController(text: bloc.description),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                MARGIN_MEDIUM,
              ),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
            hintText: POST_DESCRIPTION_HINT,
          ),
        ),
      ),
    );
  }
}
