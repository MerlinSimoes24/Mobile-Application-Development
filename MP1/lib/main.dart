import 'package:flutter/material.dart';
import 'Pages/UserInfoPage.dart';
import 'Model/UserInfo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user creation or retrieval
    final userInfo = UserInfo.getUserInfo().first; // Assuming this returns a list of users

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserInfoPage(userInfo: userInfo),
    );
  }
}
