import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/data/vos/news_feed_vo.dart';
import 'package:social_media/data/vos/user_vo.dart';
import 'package:social_media/network/agents/social_data_agent.dart';
import 'package:social_media/network/firebase_constants.dart';

class CloudFireStoreDataAgentImpl extends SocialDataAgent {
  static final CloudFireStoreDataAgentImpl _singleton =
      CloudFireStoreDataAgentImpl._internal();

  factory CloudFireStoreDataAgentImpl() => _singleton;

  CloudFireStoreDataAgentImpl._internal();

  /// fire store
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  /// Firebase Storage
  var _firebaseStorage = FirebaseStorage.instance;

  /// authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
  Future registerNewUser(UserVO newUser) {
    return _firebaseAuth
        .createUserWithEmailAndPassword(
          email: newUser.email ?? "",
          password: newUser.password ?? "",
        )
        .then((userCredential) =>
            userCredential.user?..updateDisplayName(newUser.userName))
        .then((user) {
      newUser.id = user?.uid;
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO registerUser) {
    return _fireStore
        .collection(USERS)
        .doc(registerUser.id ?? "")
        .set(registerUser.toJson());
  }

  @override
  Future login(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  bool isLogin() {
    return _firebaseAuth.currentUser != null;
  }

  @override
  UserVO getLoginUser() {
    return UserVO(
      id: _firebaseAuth.currentUser?.uid,
      email: _firebaseAuth.currentUser?.email,
      userName: _firebaseAuth.currentUser?.displayName,
    );
  }

  @override
  Future<void> logOut() {
    return _firebaseAuth.signOut();
  }
}
