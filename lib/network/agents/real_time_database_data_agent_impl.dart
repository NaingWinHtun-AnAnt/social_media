import 'package:firebase_database/firebase_database.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/network/agents/social_data_agent.dart';
import 'package:social_media/network/firebase_constants.dart';

class RealtimeDatabaseDataAgentImpl extends SocialDataAgent {
  static final RealtimeDatabaseDataAgentImpl _singleton =
      RealtimeDatabaseDataAgentImpl._internal();

  factory RealtimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealtimeDatabaseDataAgentImpl._internal();

  /// Database
  var databaseRef = FirebaseDatabase.instance.reference();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return databaseRef.child(NEW_FEED).onValue.map((event) {
      return event.snapshot.value.values.map<NewsFeedVO>((element) {
        return NewsFeedVO.fromJson(Map<String, dynamic>.from(element));
      }).toList();
    });
  }

  @override
  Future<void> createNewPost(NewsFeedVO newsFeed) {
    return databaseRef
        .child(NEW_FEED)
        .child("${newsFeed.id}")
        .set(newsFeed.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return databaseRef.child(NEW_FEED).child("$postId").remove();
  }

  @override
  Stream<NewsFeedVO> getNewFeedById(int postId) {
    return databaseRef.child(NEW_FEED).child("$postId").once().asStream().map(
          (snapShop) => NewsFeedVO.fromJson(
            Map<String, dynamic>.from(snapShop.value),
          ),
        );
  }
}
