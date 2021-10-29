import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/news_feed_bloc.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/viewitems/news_feed_item_view.dart';

class HomePage extends StatelessWidget {
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
            margin: const EdgeInsets.only(
              left: MARGIN_MEDIUM,
            ),
            child: const Text(
              "Social",
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
                margin: const EdgeInsets.only(
                  right: MARGIN_LARGE,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Consumer<NewsFeedBloc>(
            builder: (context, bloc, child) => ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: MARGIN_LARGE,
                horizontal: MARGIN_LARGE,
              ),
              itemBuilder: (context, index) {
                return NewsFeedItemView(
                  mNewsFeed: bloc.newsFeed?[index],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: MARGIN_XLARGE,
                );
              },
              itemCount: bloc.newsFeed?.length ?? 0,
            ),
          ),
        ),
      ),
    );
  }
}
