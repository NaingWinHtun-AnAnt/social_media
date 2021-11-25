import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/news_feed_bloc.dart';
import 'package:social_media/pages/add_new_post_page.dart';
import 'package:social_media/pages/login_page.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/strings.dart';
import 'package:social_media/utils/extensions.dart';
import 'package:social_media/viewitems/news_feed_item_view.dart';

class NewFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsFeedBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.only(
              left: MARGIN_MEDIUM,
            ),
            child: Text(
              SOCIAL,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: TEXT_HEADING_1X,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(
                  right: MARGIN_LARGE,
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            ),
            Consumer(
              builder:
                  (BuildContext context, NewsFeedBloc bloc, Widget? child) =>
                      GestureDetector(
                onTap: () => bloc.onTapLogout().then(
                      (value) => navigateToScreen(
                        context,
                        LoginPage(),
                      ),
                    ),
                child: Container(
                  margin: EdgeInsets.only(
                    right: MARGIN_LARGE,
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: MARGIN_LARGE,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Consumer<NewsFeedBloc>(
            builder: (context, bloc, child) => ListView.separated(
              padding: EdgeInsets.symmetric(
                vertical: MARGIN_LARGE,
                horizontal: MARGIN_LARGE,
              ),
              itemBuilder: (context, index) {
                return NewsFeedItemView(
                  mNewsFeed: bloc.newsFeed?[index],
                  onTapEditPost: (postId) {
                    Future.delayed(Duration(seconds: 1)).then(
                      (value) => _navigateToEditPostPage(context, postId),
                    );
                  },
                  onTapDeletePost: (postId) {
                    bloc.onTapDelete(postId);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: MARGIN_XLARGE,
                );
              },
              itemCount: bloc.newsFeed?.length ?? 0,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          onPressed: () => _navigateToAddNewPostPage(context),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToAddNewPostPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewPostPage(),
      ),
    );
  }

  void _navigateToEditPostPage(BuildContext context, int postId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewPostPage(
          postId: postId,
        ),
      ),
    );
  }
}
