import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media/pages/new_feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// if not firebase services will not work
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // fontFamily: GoogleFonts.ubuntu().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: NewFeedPage(),
    );
  }
}
