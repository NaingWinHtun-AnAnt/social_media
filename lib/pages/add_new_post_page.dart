import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/add_new_post_bloc.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/strings.dart';
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
      child: Scaffold(
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
                PostButtonView()
              ],
            ),
          ),
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

class PostButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (BuildContext context, AddNewPostBloc bloc, Widget? child) =>
          GestureDetector(
        onTap: () {
          bloc.onCreateNewPost().then((value) {
            Navigator.of(context).pop();
          });
        },
        child: Container(
          width: double.infinity,
          height: MARGIN_XXLARGE,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(
              MARGIN_LARGE,
            ),
          ),
          child: Center(
            child: Text(
              ACTION_POST,
              style: TextStyle(
                color: Colors.white,
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.bold,
              ),
            ),
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
