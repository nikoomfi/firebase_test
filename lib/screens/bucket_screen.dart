import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class BucketScreen extends StatefulWidget {
  const BucketScreen({Key? key}) : super(key: key);

  @override
  _BucketScreenState createState() => _BucketScreenState();
}

class _BucketScreenState extends State<BucketScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late Size size;
  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Bucket Screen'),
      ),
      body: StreamBuilder(
        stream: fireStore
            .collection('Bucket')
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.data() == null) {
              return const Center(
                child: Text('No items in your bucket'),
              );
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            List keys = data.keys.toList();
            totalPrice = data['total'];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      // don't show anything for total :)
                      if (keys[index] == 'total') {
                        return Container();
                      }
                      print(keys[index]);
                      int itemCount = data[keys[index]];
                      // use a future builder for any other item in your bucket's key
                      return FutureBuilder(
                        future: loadEachDocument(keys[index]),
                        builder: (context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            Map<String, dynamic> itemData = snapshot.data ?? {};
                            return Card(
                              child: ListTile(
                                leading: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/images/default.png'),
                                  image: NetworkImage(
                                    itemData['image'],
                                  ),
                                ),
                                title: Text(itemData['name']),
                                subtitle: Text('${itemData['price']}\$'),
                                trailing: SizedBox(
                                  width: 110,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          updateCount(0, keys[index], data,
                                              itemData['price']);
                                        },
                                      ),
                                      Text('$itemCount'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          updateCount(1, keys[index], data,
                                              itemData['price']);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } //
                          else {
                            return const Card(
                              child: SizedBox(
                                height: 80,
                                width: 80,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                    itemCount: keys.length,
                  ),
                ),
                BasketBottom(
                  size: size,
                  totalPrice: totalPrice,
                  onBuyPressed: () {
                    onBuyPressed(auth.currentUser!.uid);
                  },
                ),
              ],
            );
          } //
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> loadEachDocument(String id) async {
    DocumentSnapshot doc = await fireStore.collection('Items').doc(id).get();
    return doc.data() as Map<String, dynamic>;
  }

  void onBuyPressed(String bucketId) async {
    fireStore.collection('Bucket').doc(auth.currentUser!.uid).delete();
  }

  updateCount(
      int status, String itemId, Map<String, dynamic> data, int price) {
    String userId = auth.currentUser!.uid;
    CollectionReference bucketRef = fireStore.collection('Bucket');
    DocumentReference doc = bucketRef.doc(userId);

    if (status == 0) {
      if (data[itemId] != 0) {
        data[itemId] = data[itemId] - 1;
        data['total'] = data['total'] - price;
        doc.update(data);
      }
    } //
    else {
      data[itemId] = data[itemId] + 1;
      data['total'] = data['total'] + price;
      doc.update(data);
    }
  }
}
