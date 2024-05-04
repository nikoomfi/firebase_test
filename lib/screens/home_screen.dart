import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: CustomDrawer(auth: auth),
      appBar: HomeAppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const CustomSlider(),
          Expanded(
            child: HomeBody(size: size),
          ),
        ],
      ),
    );
  }
}
