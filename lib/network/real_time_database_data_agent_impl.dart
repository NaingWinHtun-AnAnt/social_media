import 'package:firebase_database/firebase_database.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/network/social_data_agent.dart';

/// Database Paths
const newsFeedPath = "newsfeed";

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
    return databaseRef.child(newsFeedPath).onValue.map((event) {
      return event.snapshot.value.map<NewsFeedVO>((element) {
        return NewsFeedVO.fromJson(Map<String, dynamic>.from(element));
      }).toList();
    });
  }
}
