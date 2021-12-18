import 'package:firebase_analytics/firebase_analytics.dart';

/// analytics constants
/// names
const homeScreenReached = "home_screen_reached";
const addNewPostScreenReached = "add_new_post_screen_reached";
const addNewPostAction = "add_new_post_action";
const editPostAction = "edit_post_action";

/// params
const postId = "post_id";

class FirebaseAnalyticsTracker {
  static final FirebaseAnalyticsTracker _singleton =
      FirebaseAnalyticsTracker.internal();

  factory FirebaseAnalyticsTracker() => _singleton;

  FirebaseAnalyticsTracker.internal();

  /// analytic object
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  Future logEvent(String name, {Map<String, dynamic>? parameters}) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }
}
