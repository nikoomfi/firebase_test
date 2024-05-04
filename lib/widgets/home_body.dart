import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../constants.dart';
import '../screens/screens.dart';
import 'widgets.dart';

class HomeBody extends StatefulWidget {
  Size size;

  HomeBody({Key? key, required this.size}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  List<MultiSelectItem> categories = [];

  String selectedCategory = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = kCategories;
    categories.insert(0,  MultiSelectItem('All', 'All'));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text('Categories'),
          const SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories
                  .map(
                    (MultiSelectItem category) => InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = category.label;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade100,
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        child: Text(category.label),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder(
              stream: loadData(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  QuerySnapshot<Object?>? query = snapshot.data;
                  if (query!.docs.length == 0) {
                    return const Center(
                        child: Text('No item found in this category'));
                  }
                  return GridView.count(
                    crossAxisCount:
                        widget.size.width < widget.size.height ? 2 : 4,
                    children: snapshot.data!.docs.map(
                      (QueryDocumentSnapshot doc) {
                        String id = doc.id;
                        Map data = doc.data() as Map;
                        bool isMe = data['uploader'] == auth.currentUser!.uid;
                        return CustomItem(
                          onAddTapped: () {
                            onAddPressed(id, data['price']);
                          },
                          onTapped: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return InfoScreen(id: id);
                                },
                              ),
                            );
                          },
                          size: widget.size,
                          imageUrl: data['image'],
                          name: data['name'],
                          price: data['price'],
                          count: data['count'],
                        );
                      },
                    ).toList(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> loadData() {
    print(selectedCategory);
    if (selectedCategory == 'All') {
      return fireStore.collection('Items').snapshots();
    } else {
      return fireStore.collection('Items').where('categories',
          arrayContains: selectedCategory).snapshots();
    }
  }

  onAddPressed(String id, int price) async {
    String userId = auth.currentUser!.uid;
    CollectionReference bucketRef = fireStore.collection('Bucket');
    DocumentReference doc = bucketRef.doc(userId);
    DocumentSnapshot docSnapshot = await doc.get();
    // nothing available in bucket
    if (docSnapshot.data() == null) {
      // set vs update -> set completely changes the data, update looks for previous data and if found sth changes them
      doc.set({
        id: 1,
        'total': 1 * price,
      });
    } // we have something in our bucket
    else {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      // we previously had selected this item so just add another number
      if (data[id] != null) {
        data[id] = data[id] + 1;
        data['total'] = data['total'] + price;
      } // this item was not in our bucket so just add it
      else {
        data[id] = 1;
        data['total'] = data['total'] + price;
      }
      doc.update(data);
    }
  }
}
