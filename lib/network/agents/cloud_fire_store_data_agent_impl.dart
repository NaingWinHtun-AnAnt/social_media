import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/data/vos/user_vo.dart';
import 'package:social_media/network/agents/social_data_agent.dart';
import 'package:social_media/network/firebase_constants.dart';

class CloudFireStoreDataAgentImpl extends SocialDataAgent {
  /// fire store
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  /// Firebase Storage
  var _firebaseStorage = FirebaseStorage.instance;

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

  @override
  Future<String> uploadFileToFirebaseStorage(File file) {
    return _firebaseStorage
        .ref(FILE_UPLOAD_FOLDER)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(file)
        .then(
          (taskSnapShot) => taskSnapShot.ref.getDownloadURL(),
        );
  }

  @override
  Future registerNewUser(UserVO user) {
    // TODO: implement registerNewUser
    throw UnimplementedError();
  }
}
