import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constant_functions.dart';

class HomeScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
              kNavigate(context, 'login');
            },
            icon: const Icon(Icons.exit_to_app),
          ),
          IconButton(
            onPressed: () async {
              await auth.signOut();
              kNavigate(context, 'chat');
            },
            icon: const Icon(
              Icons.message,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
