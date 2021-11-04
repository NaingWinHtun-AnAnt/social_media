import 'package:flutter/material.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/images.dart';

class NewsFeedItemView extends StatelessWidget {
  final NewsFeedVO? mNewsFeed;
  final Function(int) onTapDeletePost;

  const NewsFeedItemView({
    required this.mNewsFeed,
    required this.onTapDeletePost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileImageView(
              profileImage: mNewsFeed?.profilePicture ?? "",
            ),
            const SizedBox(
              width: MARGIN_MEDIUM_2,
            ),
            NameLocationAndTimeAgoView(
              userName: mNewsFeed?.userName ?? "",
            ),
            Spacer(),
            MoreButtonView(
              onTapDelete: () => onTapDeletePost(mNewsFeed?.id ?? 0),
            ),
          ],
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        PostImageView(
          postImage: mNewsFeed?.postImage ?? "",
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        PostDescriptionView(
          description: mNewsFeed?.description ?? "",
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Row(
          children: const [
            Text(
              "See Comments",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Icon(
              Icons.mode_comment_outlined,
              color: Colors.grey,
            ),
            SizedBox(
              width: MARGIN_MEDIUM,
            ),
            Icon(
              Icons.favorite_border,
              color: Colors.grey,
            )
          ],
        )
      ],
    );
  }
}

class PostDescriptionView extends StatelessWidget {
  final String description;

  const PostDescriptionView({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: const TextStyle(
        fontSize: TEXT_REGULAR,
        color: Colors.black,
      ),
    );
  }
}

class PostImageView extends StatelessWidget {
  final String postImage;

  PostImageView({
    required this.postImage,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: postImage != "",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          MARGIN_CARD_MEDIUM_2,
        ),
        child: FadeInImage(
          height: POST_IMAGE_HEIGHT,
          width: double.infinity,
          placeholder: NetworkImage(
            NETWORK_IMAGE_POST_PLACEHOLDER,
          ),
          image: NetworkImage(
            postImage,
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class MoreButtonView extends StatelessWidget {
  final Function onTapDelete;

  MoreButtonView({
    required this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: Text("Edit"),
        ),
        PopupMenuItem(
          onTap: () => onTapDelete(),
          child: Text("Delete"),
        ),
      ],
    );
  }
}

class ProfileImageView extends StatelessWidget {
  final String profileImage;

  const ProfileImageView({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(
        profileImage,
      ),
      radius: MARGIN_LARGE,
    );
  }
}

class NameLocationAndTimeAgoView extends StatelessWidget {
  final String userName;

  const NameLocationAndTimeAgoView({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontSize: TEXT_REGULAR_2X,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: MARGIN_SMALL,
            ),
            const Text(
              "- 2 hours ago",
              style: TextStyle(
                fontSize: TEXT_SMALL,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: MARGIN_MEDIUM,
        ),
        const Text(
          "Paris",
          style: TextStyle(
            fontSize: TEXT_SMALL,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
