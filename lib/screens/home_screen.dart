import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';

class HomeScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
              kNavigate(context, 'login');
            },
            icon: const Icon(Icons.exit_to_app,
              color: Colors.white,),
          ),
          IconButton(
            onPressed: () async {
              kNavigate(context, 'chat');
            },
            icon: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
