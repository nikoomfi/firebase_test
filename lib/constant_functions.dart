import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

kNavigate(BuildContext context, String path) {
  if (path == 'chat') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ChatScreen();
        },
      ),
    );
  } //
  else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (path == 'home') {
            return HomeScreen();
          } else if (path == 'login') {
            return LoginScreen();
          } else {
            return HomeScreen();
          }
        },
      ),
    );
  }
}
