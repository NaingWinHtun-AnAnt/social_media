import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const channelId = "social_media_channel";
const channelName = "Social Media Channel";
const channelDescription = "Social Media Channel";

class FCMService {
  static final FCMService _singleton = FCMService.internal();

  factory FCMService() => _singleton;

  FCMService.internal();

  /// firebase message instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// android notification channel
  final AndroidNotificationChannel _notificationChannel =
      AndroidNotificationChannel(
    "social_media_channel",
    "social_media_channel",
    description: "social_media_channel",
    importance: Importance.max,
  );

  /// local notification plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// foreground notification set up for ANDROID(flutter local notification)
  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('app_icon');

  void listenForMessage() async {
    /// foreground notification set up for ios
    await requestNotificationPermissionIOS();
    await turnOnIOSForegroundNotification();

    /// initialize flutter local notification setting(for ANDROID)
    await initFlutterLocalNotification();
    await registerChannel();

    /// get device token for notification
    _firebaseMessaging.getToken().then((value) => print("TOKEN ===>>> $value"));

    /// user tap notification
    /// app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("USER PRESS ON NOTIFICATION ===>>> ${event.data['post_id']}");
    });

    /// app is killed
    _firebaseMessaging.getInitialMessage().then(
        (value) => debugPrint("APP IS KILL ===>>> ${value?.data['post_id']}"));

    /// firebase in active
    /// foreground
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? androidNotification =
          remoteMessage.notification?.android;

      if (notification != null && androidNotification != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _notificationChannel.id,
              _notificationChannel.name,
              channelDescription: _notificationChannel.description,
              icon: androidNotification.smallIcon,
            ),
          ),
          payload: remoteMessage.data['post_id'].toString(),
        );
      }
    });
  }

  Future requestNotificationPermissionIOS() {
    return _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// no need flutter local notification package
  /// just use firebase messaging instance
  Future turnOnIOSForegroundNotification() {
    return _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// initialize flutter local notification setting
  Future initFlutterLocalNotification() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: null,
      macOS: null,
    );
    return _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payLoad) {
        print("Local Notification ===>>> $payLoad");
      },
    );
  }

  /// register notification channel
  Future? registerChannel() {
    return _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_notificationChannel);
  }
}
