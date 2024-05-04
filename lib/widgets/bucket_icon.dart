import 'package:flutter/material.dart';
import '../screens/screens.dart';

class BucketIcon extends StatelessWidget {
  const BucketIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_basket),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const BucketScreen();
            },
          ),
        );
      },
    );
  }
}
