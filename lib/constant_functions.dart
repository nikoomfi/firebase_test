import 'package:flutter/material.dart';

import 'screens/screens.dart';

kNavigate(BuildContext context, String path) {
  if (path == 'chat' || path == 'sell') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (path == 'chat') {
            return const ChatScreen();
          } else if (path == 'sell') {
            return const SellScreen();
          } else {
            return HomeScreen();
          }
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
