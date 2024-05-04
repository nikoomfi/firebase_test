import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constant_functions.dart';
import '../screens/screens.dart';

class CustomDrawer extends StatelessWidget {

  FirebaseAuth auth;

  CustomDrawer({required this.auth});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DrawerHeader(
                  decoration: const BoxDecoration(),
                  child:
                  Text(auth.currentUser!.phoneNumber ?? 'Not signed in'),
                ),
              ),
            ],
          ),
          ListTile(
            title: const Text(
              'Global Chat',
            ),
            trailing: const Icon(Icons.message),
            onTap: () {
              kNavigate(context, 'chat');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Sign Out',
            ),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () {
              auth.signOut();
              kNavigate(context, 'login');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Sell',
            ),
            trailing: const Icon(Icons.sell),
            onTap: () {
              kNavigate(context, 'sell');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Bucket',
            ),
            trailing: const Icon(Icons.shopping_basket),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const BucketScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
