import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/screens.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({Key? key}) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireStore.collection('Items').limit(1).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot<Object?>? query = snapshot.data;
          if (query!.docs.length == 0) {
            return const Center(child: Text('No Promotion Item Found'));
          }
          List<QueryDocumentSnapshot> list = snapshot.data!.docs;
          List<Map<String, dynamic>> mapList = [];
          for (QueryDocumentSnapshot each in list) {
            Map<String, dynamic> data = each.data() as Map<String, dynamic>;
            mapList.add(data);
          }
          return CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              viewportFraction: 0.8,
              enableInfiniteScroll: true,
              disableCenter: true,
              autoPlay: true,
              enlargeCenterPage: true,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items: [
              for (int i = 0; i < list.length; i++) ...[
                Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return InfoScreen(id: list[i].id);
                            },
                          ),
                        );
                      },
                      child: FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/default.png'),
                        image: NetworkImage(
                          mapList[i]['image'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        } //
        else {
          return CarouselSlider(
            options: CarouselOptions(height: 200.0),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}
