import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBar() : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home Screen'),
      actions: [
        StreamBuilder(
          stream: fireStore
              .collection('Bucket')
              .doc(auth.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.data() == null) {
                return const BucketIcon();
              }
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List keys = data.keys.toList();
              return Stack(
                children: [
                  const BucketIcon(),
                  Positioned(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Text('${keys.length - 1}'),
                    ),
                  ),
                ],
              );
            } //
            else {
              return const BucketIcon();
            }
          },
        ),
      ],
    );
  }
}
