import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';


class InfoScreen extends StatefulWidget {
  String id;

  InfoScreen({
    required this.id,
  });

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: fireStore.collection('Items').doc(widget.id).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot? doc = snapshot.data;
                Map data = doc!.data() as Map;
                // print(data);
                String imageUrl = data['image'];
                String name = data['name'];
                String description = data['description'];
                int count = data['count'];
                int price = data['price'];
                List<dynamic> categories = data['categories'];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/default.png'),
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                        width: size.width,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Item Name:  ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Item Description:  ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(description),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.price_change,
                                  color: Colors.blueGrey.shade800,
                                  size: 30,
                                ),
                                Text(
                                  '$price \$',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.confirmation_num,
                                  color: Colors.blueGrey.shade800,
                                  size: 30,
                                ),
                                Text(
                                  '$count remaining',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Categories'),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: categories.map(
                                (text) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(text),
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } //
              else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: 300,
                        color: Colors.blueGrey.shade200,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Colors.blueGrey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const CustomBackButton(),
        ],
      ),
    );
  }
}
