import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media/data/models/auth_model.dart';
import 'package:social_media/data/models/auth_model_impl.dart';
import 'package:social_media/pages/login_page.dart';
import 'package:social_media/pages/new_feed_page.dart';
import 'package:social_media/resources/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// if not firebase services will not work
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthModel _authModel = AuthModelImpl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // fontFamily: GoogleFonts.ubuntu().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: _authModel.isLogin() ? NewFeedPage() : LoginPage(),
    );
  }
}
