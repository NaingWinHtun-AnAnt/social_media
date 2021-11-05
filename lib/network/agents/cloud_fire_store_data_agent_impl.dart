import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/network/agents/social_data_agent.dart';
import 'package:social_media/network/firebase_constants.dart';

class CloudFireStoreDataAgentImpl extends SocialDataAgent {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  static final CloudFireStoreDataAgentImpl _singleton =
      CloudFireStoreDataAgentImpl._internal();

  factory CloudFireStoreDataAgentImpl() => _singleton;

  CloudFireStoreDataAgentImpl._internal();

  @override
  Future<void> createNewPost(NewsFeedVO newsFeed) {
    return _fireStore
        .collection(NEW_FEED)
        .doc("${newsFeed.id}")
        .set(newsFeed.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return _fireStore.collection(NEW_FEED).doc("$postId").delete();
  }

  @override
  Stream<NewsFeedVO> getNewFeedById(int postId) {
    return _fireStore
        .collection(NEW_FEED)
        .doc("$postId")
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map(
          (event) => NewsFeedVO.fromJson(event.data()!),
        );
  }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return _fireStore.collection(NEW_FEED).snapshots().map((querySnapShot) {
      return querySnapShot.docs
          .map(
            (document) => NewsFeedVO.fromJson(
              document.data(),
            ),
          )
          .toList();
    });
  }
}
